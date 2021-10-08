// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.periphs.gpio.inverse;

import mcud.periphs.gpio.input;

/**
Inverse an input.
Params:
	input = The input to inverse.
*/
struct Inverse(alias input)
{
static:
	alias InputHigh = input.InputLow;
	alias InputLow = input.InputHigh;

	/**
	Checks if the input is on.
	Returns: `true` if the input is on, `false` if the input is off.
	*/
	bool isOnSync()
	{
		return !input.isOnSync();
	}

	/**
	Checks if the input is on.
	*/
	void isOn()
	{
		input.isOn();
	}

	auto opDispatch(string member, T...)(T args)
	{
		return __traits(getMember, input, member)(args);
	}
}