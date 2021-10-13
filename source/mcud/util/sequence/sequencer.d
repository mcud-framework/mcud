module mcud.util.sequence.sequencer;

import mcud.core.event;
import std.meta;
import std.traits;

enum StepType
{
	callable,
	awaitAll
}

template mapStep(alias step)
{
	static if (isCallable!step)
	{
		struct Step
		{
			alias callable = step;
			StepType type = StepType.callable;
		}
		enum mapStep = Step();
	}
	else
	{
		alias mapStep = step;
	}
}

template Sequence(SimpleSteps...)
{
	int state = 0;
	alias Steps = staticMap!(mapStep, SimpleSteps);

	template isTypeCurry(StepType type)
	{
		alias isTypeCurry(alias thing) = isType!(type, thing);
	}
	template isType(StepType type, alias thing)
	{
		enum isType = thing.type == type; 
	}
	alias functionSteps = Filter!(isType!(StepType.callable), Steps);

	private void step()
	{
		static foreach (i, step; functionSteps)
		{
			if (state == i)
				step();
		}
		state++;
	}

	void exec()
	{
		state = 0;
		step();
	}

	/*
	static foreach (i, step; Steps)
	{
		static if (isType!(StepType.awaitAll, step))
		{
			@event!(step.event)
			void await_i()
			{
				step();
			}
		}
	}
	*/
}

auto awaitAll(Events...)()
{
	struct Description
	{
		StepType type = StepType.awaitAll;
		alias events = Events;
	}
	return Description();
}

auto await(Event)()
{
	return awaitAll!Event;
}

unittest
{
	struct SomeEvent {}

	int count = 0;
	alias sequence = Sequence!(
		{
			count++;
		},
		await!SomeEvent,
		{
			count++;
		}
	);

	sequence.exec();

	assert(count == 1, "Count did not increase");
	fire!(SomeEvent, sequence);
	assert(count == 2, "Count did not increase after event");
}
