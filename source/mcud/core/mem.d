/**
Contains many platform-independent memory helper classes.
*/
module mcud.core.mem;

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