/**
Contains many platform-independent memory helper classes.
*/
module mcud.mem.volatile;

import mcud.core.attributes;
import mcud.cpu.stm32wb55.mem;

/**
Wraps volatile memory at a specific memory address.
*/
struct Volatile(T, size_t addr)
{
	alias type = T;
	enum address = addr;

	enum T* t = cast(T*) (addr);

	@forceinline
	T load() nothrow
	{
		return volatileLoad(*t);
	}

	@forceinline
	void store(T value) nothrow
	{
		volatileStore(*t, value);
	}

	@forceinline
	auto opOpAssign(string op, T)(T value) nothrow
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

unittest
{
	struct S {}

	assert( isVolatile!(Volatile!(int, 5)));
	assert(!isVolatile!int);
	assert(!isVolatile!S);

	Volatile!(int, 1) value;
	assert( isVolatile!value);
}