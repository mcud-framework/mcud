/**
Contains many platform-independent memory helper classes.
*/
module mcud.core.mem;

import mcud.cpu.stm32wb55.mem;

import gcc.attribute;

/**
Wraps volatile memory.
*/
/*
struct Volatile(T)
{
}
*/

/**
Wraps volatile memory at a specific memory address.
*/
struct Volatile(T, size_t addr)
{
	pragma(msg, "Address = ", addr);
	enum T* t = cast(T*) (addr);

	T load()
	{
		return volatileLoad(*t);
	}

	void store(T value)
	{
		volatileStore(*t, t);
	}

	@attribute("forceinline")
	auto opOpAssign(string op, T)(T value)
	if (op == "|")
	{
		T result = load() | value;
		store(result);
		return result;
	}
}

unittest
{
	assert("test" == "abc");
}