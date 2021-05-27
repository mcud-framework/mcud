module mcud.core.flux;

import mcud.core.result;

import std.traits;

enum FutureState
{
	pending,
	running,
	complete
}

template PublisherType(alias publisher)
{
	alias PublisherType = ReturnType!publisher.type;
}

private struct Future(alias publisher, alias poller)
{
	alias T = ReturnType!publisher.type;

	static if (!is(T == void))
	{
		auto subscribe(alias success)()
		{
			struct Subscribe
			{
				FutureResult poll()
				{
					return FutureResult.complete;
				}
				//alias poll = poller!success;
			}
			return Subscribe();
		}
	}
	else static if (is(T == void))
	{
		auto subscribe(void function() success)()
		{
			struct Subscribe
			{
				alias poll = poller!success;
			}
			return Subscribe();
		}
	}
	else
		static assert(0, "Unsupported return type " ~ T);
}

/**
Creates a future which will call the publisher once in the future.
*/
auto once(alias publisher)()
{
	static FutureResult poller(alias success)()
	{
		auto result = publisher();
		if (result.isSuccess())
		{
			static if (is(PublisherType!publisher == void))
				success();
			else
				success(result.get());
			return FutureResult.complete;
		}
		else
			return FutureResult.complete;
	}

	return Future!(publisher, poller)();
}

unittest
{
	static int result = 0;
	static Result!int getInt()
	{
		return ok(5);
	}

	static void on(int v)
	{
		result = v;
	}

	auto flux = once!(getInt).subscribe!(v => on(v));
	assert(result == 0);
	assert(flux.poll() == FutureResult.complete);
	assert(result == 5);
}

/**
Creates a future which will keep calling the publisher repeatedly.
*/
auto poll(alias publisher)()
{
	static FutureResult poller(alias success)()
	{
		auto result = publisher();
		if (result.isSuccess())
			success(result.get());
		return FutureResult.running;
	}
	return Future!(publisher, poller)();
}

unittest
{
	static int result = 0;
	static Result!int getInt()
	{
		return ok(result + 1);
	}

	static void on(int v)
	{
		result = v;
	}

	auto flux = poll!(getInt).subscribe!(v => on(v));
	assert(result == 0);
	assert(flux.poll() == FutureResult.running);
	assert(result == 1);
	assert(flux.poll() == FutureResult.running);
	assert(result == 2);
}

auto combine(alias fluxA, alias fluxB)()
{
	struct Combine
	{
		bool fluxAFinished = false;
		bool fluxBFinished = false;
		
		FutureResult poll()
		{
			if (!fluxAFinished)
			{
				if (fluxA.poll() == FutureResult.complete)
					fluxAFinished = true;
			}

			if (!fluxBFinished)
			{
				if (fluxB.poll() == FutureResult.complete)
					fluxBFinished = true;
			}

			if (fluxAFinished && fluxBFinished)
				return FutureResult.complete;
			else
				return FutureResult.running;
		}
	}
	return Combine();
}

unittest
{
	static int resultA = 0;
	static int resultB = 0;

	static Result!int getIntA()
	{
		return ok(resultA + 1);
	}
	static Result!int getIntB()
	{
		return ok(resultB - 1);
	}

	static void onA(int v)
	{
		resultA = v;
	}
	static void onB(int v)
	{
		resultB = v;
	}

	auto fluxA = forever!(getIntA).subscribe!(v => onA(v));
	auto fluxB = once!(getIntB).subscribe!(v => onB(v));
	auto flux = combine!(fluxA, fluxB);

	assert(resultA == 0);
	assert(resultB == 0);
	assert(flux.poll() == FutureResult.running);
	assert(resultA == 1);
	assert(resultB == -1);
	assert(flux.poll() == FutureResult.running);
	assert(resultA == 2);
	assert(resultB == -1);
}

auto after(alias fluxA, alias fluxB)()
{
	struct After
	{
		bool fluxAFinished = false;
		bool fluxBFinished = false;

		FutureResult poll()
		{
			if (!fluxAFinished)
			{
				if (fluxA.poll() == FutureResult.complete)
					fluxAFinished = true;
			}

			if (fluxAFinished && !fluxBFinished)
			{
				if (fluxB.poll() == FutureResult.complete)
					fluxBFinished = true;
			}

			if (fluxAFinished && fluxBFinished)
				return FutureResult.complete;
			else
				return FutureResult.running;
		}
	}
	return After();
}