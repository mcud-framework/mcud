module mcud.test.expect;

version(unittest) import core.exception;
import std.format;

/**
Starts an expection.
Expections are a way to write more clear asserts that produce better error
messages.
Params:
	T = The type of the expected value.
	value = The expected value.
Returns: An expector which can be used to test the given value.
*/
Expector!T expect(T)(T actual)
{
	Expector!T expector;
	expector.actual = actual;
	return expector;
}

/**
An expection.
Params:
	T = The type of the expectation.
*/
struct Expector(T)
{
	/// The actual value.
	T actual;

	/**
	Tests if the actual value equals the expected value.
	Params:
		expected = The expected value.
	*/
	void toEqual(T expected)
	{
		if (actual != expected)
			assert(0, format!("Expected to equal '%s', but was '%s'")(expected, actual));
	}

	/**
	Tests that the actual value is different from the expeted value.
	Params:
		expected = The expected value the actual value should differ from.
	*/
	void toDiffer(T expected)
	{
		if (actual == expected)
			assert(0, format!("Expected to differ from '%s'")(expected));
	}
}

@("expect(true).toEqual(true) succeeds")
unittest
{
	expect(true).toEqual(true);
}

@("expect(false).toEqual(true) fails")
unittest
{
	bool failed = false;
	try
	{
		expect(false).toEqual(true);
	}
	catch (AssertError e)
	{
		assert(e.msg == "Expected to equal 'true', but was 'false'", "Invalid message");
		failed = true;
	}
	assert(failed, "Expect never asserted");
}

@("expect(true).toDiffer(false) succeeds")
unittest
{
	expect(true).toDiffer(false);
	expect(false).toDiffer(true);
}

@("expect(true).toDiffer(true) fails")
unittest
{
	bool failed = false;
	try
	{
		expect(true).toDiffer(true);
	}
	catch (AssertError e)
	{
		assert(e.msg == "Expected to differ from 'true'", "Invalid message");
		failed = true;
	}
	assert(failed, "Expect never asserted");
}