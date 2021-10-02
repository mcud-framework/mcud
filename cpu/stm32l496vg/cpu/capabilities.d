// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module cpu.capabilities;

import cpu.stm32l496.capabilities;

/**
Gets the capabilities of the STM32L496VG.
*/
Capabilities capabilities()
{
	Capabilities caps = baseCapabilities();
	caps.gpioAMask = 0b1111_1111_1111_1111;
	caps.gpioBMask = 0b1111_1111_1111_1111;
	caps.gpioCMask = 0b1111_1111_1111_1111;
	caps.gpioDMask = 0b1111_1111_1111_1111;
	caps.gpioEMask = 0b1111_1111_1111_1111;
	caps.gpioHMask = 0b0000_0000_0000_1011;
	return caps;
}