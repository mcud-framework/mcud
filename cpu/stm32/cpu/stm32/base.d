// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module cpu.stm32.base;

import mcud.core.interrupts;

/**
The base template for any STM32 microcontroller.
*/
template STM32()
{
	@interrupt(IRQ.reset)
	void onReset()
	{
		import mcud.core.system : startMCUd;
		startMCUd();
	}
}
