module cpu.mem;

import mcud.core.attributes;

/**
Performs a volatile load.
*/
@forceinline
T volatileLoad(T)(ref T v) nothrow
{
	asm nothrow { "" : "+m" (v); }
	T res = v;
	asm nothrow { "" : "+g" (res); }
	return res;
}

/**
Performs a volatile store.
*/
@forceinline
T volatileStore(T)(ref T v, const T a) nothrow
{
	asm nothrow { "" : : "m" (v); }
	v = a;
	asm nothrow { "" : "+m" (v); }
	return a;
}
