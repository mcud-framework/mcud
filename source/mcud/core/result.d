module mcud.core.result;

import mcud.core.errors;

/**
Holds a value and a success code.
*/
struct Result(T)
if (!is(T == void))
{
	private T m_value;
	private Errors m_code;

	@disable this();

	package this(in T value, Errors code)
	{
		m_value = value;
		m_code = code;
	}
}

/**
Holds a success code.
*/
struct Result(T)
if (is(T == void))
{
	private Errors m_code;

	@disable this();

	package this(Errors code)
	{
		m_code = code;
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