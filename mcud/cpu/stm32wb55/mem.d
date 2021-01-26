module mcud.cpu.stm32wb55.mem;

version (unittest)
{
	T volatileLoad(T)(ref T v)
	{
		return v;
	}

	T volatileStore(T)(ref T v, const T a)
	{
		return v = a;
	}
}
else
{
	import gcc.attribute;
	
	/**
	Performs a volatile load.
	*/
	@attribute("forceinline")
	T volatileLoad(T)(ref T v)
	{
		asm { "" : "+m" v; }
		T res = v;
		asm { "" : "+g" res; }
		return res;
	}

	/**
	Performs a volatile store.
	*/
	@attribute("forceinline")
	T volatileStore(T)(ref T v, const T a)
	{
		asm { "" : : "m" v; }
		v = a;
		asm { "" : "+m" v; }
		return a;
	}
}

