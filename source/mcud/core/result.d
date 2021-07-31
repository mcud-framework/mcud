module mcud.core.result;

import mcud.core.errors;
import mcud.core.attributes;

/**
Holds a value and a success code.
*/
struct Result(T)
if (!is(T == void))
{
	private T m_value;
	private Errors m_code;

	public alias type = T;

	@disable this();

	package this(in T value, Errors code)
	{
		m_value = value;
		m_code = code;
	}

	Errors code() const
	{
		return m_code;
	}

	T get()
	{
		return m_value;
	}

	void on(alias callback)() const
	{
		callback(m_value);
	}

	Result!T map(T function(T) mapper)()
	{
		if (isSuccess())
			return ok(mapper(m_value));
		else
			return this;
	}

	Result!T flatMap(Result!T function(T) mapper)()
	{
		if (isSuccess())
			return mapper(m_value);
		else
			return this;
	}

	bool isSuccess() const
	{
		return m_code == Errors.ok;
	}

	bool isFail() const
	{
		return m_code != Errors.ok;
	}

	T or(T other) const
	{
		if (isSuccess())
			return m_value;
		else
			return other;
	}
}

/**
Holds a success code.
*/
struct Result(T)
if (is(T == void))
{
	private Errors m_code;

	public alias type = void;

	@disable this();

	@forceinline
	package this(Errors code)
	{
		m_code = code;
	}

	Errors code() const
	{
		return m_code;
	}

	@forceinline
	Result!T on(void function() callback)() const
	{
		if (isSuccess)
			callback();
		return this;
	}

	Result!T map(T function() mapper)()
	{
		if (isSuccess())
			return ok(mapper());
		else
			return this;
	}

	@forceinline
	Result!T flatMap(Result!T function() mapper)()
	{
		if (isSuccess)
			return mapper();
		else
			return this;
	}

	@forceinline
	bool isSuccess() const
	{
		return m_code == Errors.ok;
	}

	bool isFail() const
	{
		return m_code != Errors.ok;
	}
}

/**
Gets a success result with a value. 
*/
Result!T ok(T)(in T value)
if (!is(T == void))
{
	return Result!T(value, Errors.ok);
}

/**
Gets a success result without a value.
*/
Result!void ok(T)()
if (is(T == void))
{
	return Result!void(Errors.ok);
}

/**
Gets a failed result with a reason.
*/
Result!T fail(T)(Errors reason)
if (!is(T == void))
{
	return Result!T(T.init, reason);
}

/**
Gets a failure result with a value.
*/
Result!void fail(T)(Errors reason)
if (is(T == void))
{
	return Result!void(reason);
}

unittest
{
	ok!int(5);
	ok!void();
	fail!int(Errors.timeout);
	fail!void(Errors.timeout);
}