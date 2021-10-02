// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

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
