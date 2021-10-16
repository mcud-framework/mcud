// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.meta.device;

import std.format;
import std.meta;

/**
Keeps a reference to a device.
Use the `get(Device device)` template to access the original device.
*/
struct Device
{
	/// The mangled name of the device.
	string _mangle;

	@disable this();

	private this(string mangle)
	{
		_mangle = mangle;
	}

	this(Device device)
	{
		this(device._mangle);
	}

	/**
	Creates a reference to a device.
	Params:
		T = The device to refer to.
	*/
	static Device of(T)()
	if (!is(T == void))
	{
		return Device(T.mangleof);
	}

	/**
	Gets whether the device is bound to something or not.
	Returns: `true` if the device is not bound, `false` if the device is bound.
	*/
	bool isEmpty()
	{
		return _mangle == "";
	}

	/**
	Gets the empty device reference.
	*/
	enum empty = Device("");
}

/**
Gets the actual object a Device instance refers to.
*/
template getDevice(Device device)
{
	static assert(device != Device.empty, "Device does not refer to anything");
	alias getDevice = __traits(toType, device._mangle);
}

unittest
{
	struct Test
	{
		static int value = 0;
		static void increase()
		{
			value++;
		}
	}

	enum io = Device.of!Test;
	getDevice!io.increase();
	assert(Test.value == 1);
}
