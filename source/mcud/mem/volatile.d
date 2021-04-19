/**
Contains many platform-independent memory helper classes.
*/
module mcud.mem.volatile;

import mcud.cpu.stm32wb55.mem;

version (GCC)
{
	import gcc.attribute;
}
else
{
	struct attribute
	{
		string attr;
	}
}

/**
Wraps volatile memory at a specific memory address.
*/
struct Volatile(T, size_t addr)
{
	alias type = T;
	enum address = addr;

	enum T* t = cast(T*) (addr);

	@attribute("forceinline")
	T load()
	{
		return volatileLoad(*t);
	}

	@attribute("forceinline")
	void store(T value)
	{
		volatileStore(*t, value);
	}

	@attribute("forceinline")
	auto opOpAssign(string op, T)(T value)
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