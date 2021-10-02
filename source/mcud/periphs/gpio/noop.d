// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// Contains a mock GPIO.
module mcud.periphs.gpio.noop;

/**
A GPIO which does nothing.
*/
struct NoOpGPIO
{
	static void doNothing() {}

	alias on = doNothing;
	alias off = doNothing;
	enum isOn = false;
}