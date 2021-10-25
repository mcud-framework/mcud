// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/**
Contains many platform-independent memory helper classes.
*/
module mcud.mem.volatile;

version(unittest) {} else import cpu.mem;
import mcud.core.attributes;
import mcud.core.system;

/**
Wraps volatile memory at a specific memory address.
*/
struct Volatile(T, size_t addr)
{
static:
	alias type = T;
	enum address = addr;

	enum T* t = cast(T*) (addr);

	@forceinline
	static T load() nothrow
	{
		version(unittest) assert(0, "Not supported during unit tests");
		else return volatileLoad(*t);
	}

	@forceinline
	static void store(T value) nothrow
	{
		version(unittest) assert(0, "Not supported during unit tests");
		else volatileStore(*t, value);
	}

	@forceinline
	static auto opOpAssign(string op, T)(T value) nothrow
	{
		T result = mixin("load() " ~ op ~ " value");
		store(result);
		return result;
	}
}

/**
Tests if the type is a Volatile or not.
*/
enum isVolatile(T) = is(T == Volatile!(V, A), V, size_t A);
enum isVolatile(alias t) = isVolatile!(typeof(t));

@("isVolatile can detect whether variable is volatile")
unittest
{
	struct S {}

	assert( isVolatile!(Volatile!(int, 5)));
	assert(!isVolatile!int);
	assert(!isVolatile!S);

	Volatile!(int, 1) value;
	assert( isVolatile!value);
}
