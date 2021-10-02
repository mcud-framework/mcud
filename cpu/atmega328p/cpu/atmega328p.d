// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module cpu.atmega328p;

import cpu.periphs.gpio;
import mcud.core.attributes;
import mcud.core.interrupts;
import mcud.core.system;

/**
An interface to the Atmega328P.
*/
template Atmega328P()
{
	@interrupt(IRQ.RESET)
	void reset()
	{
		start();
	}

	alias gpioB = GPIOPeriph!0x03;
	alias gpioC = GPIOPeriph!0x06;
	alias gpioD = GPIOPeriph!0x09;
}