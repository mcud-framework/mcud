// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module test;

import core.runtime;
import std.meta;
import std.stdio;
import std.string;
import std.traits;

static import mcud;
static import test_modules;

enum green = "\x1B[92m";
enum red = "\x1B[91m";
enum blue = "\x1B[94m";
enum reset = "\x1B[0m";

struct TestResults
{
	uint total = 0;
	uint passed = 0;

	TestResults opBinary(string op)(const TestResults rhs) const
	if (op == "+")
	{
		TestResults results;
		results.total += rhs.total;
		results.passed += rhs.passed;
		return this;
	}

	void opOpAssign(string op)(TestResults value)
	if (op == "+")
	{
		total += value.total;
		passed += value.passed;
	}

	bool allPassed()
	{
		return total == passed;
	}
}

shared static this()
{
	Runtime.moduleUnitTester = &mcudUnitTester;
}

bool mcudUnitTester()
{
	TestResults results;

	writeln();
	static import mcud.mem.volatile;
	alias a = mcud.mem.volatile;
	static foreach (mod; test_modules.allModules)
		results += runTestsInModule!(mod);
	writeln();

	const percentage = 100f * results.passed / results.total;
	writefln!"%d of %d tests passed! (%.0f%%)"(results.passed, results.total, percentage);
	return results.allPassed;
}

TestResults runTestsInModule(alias symbol)()
{
	TestResults results;
	static foreach (unitTest; __traits(getUnitTests, symbol))
	{
		results += runTest!(unitTest);
	}
	return results;
}

TestResults runTest(alias symbol)()
{
	TestResults results;
	const name = TestName!symbol;
	results.total = 1;
	try
	{
		symbol();
		writefln!(" [%s OK %s]  %s")(green, reset, name);
		results.passed++;
	}
	catch (Throwable e)
	{
		writeln();
		writefln!(" [%sFAIL%s]  %s")(red, reset, name);
		writeln(e.toString());
		writeln();
	}
	return results;
}


template TestName(alias symbol)
{
	static if (hasUDA!(symbol, string))
		enum TestName = getUDAs!(symbol, string)[0];
	else
		enum TestName = format!("(unittest at %s:%d)")(__traits(getLocation, symbol)[0], __traits(getLocation, symbol)[1]);
}