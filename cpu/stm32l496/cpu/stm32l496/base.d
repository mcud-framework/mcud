// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module cpu.stm32l496.base;

import cpu.stm32.base;
import cpu.stm32.periphs;
import mcud.meta.extend;

/**
Base template for STM32L496 microcontrollers.
*/
template STM32L496()
{
	alias base = STM32!();
	mixin AliasThis!(base);

	PeriphRCC!0x4002_1000 rcc;

	PeriphGPIO!('a', 0x4800_0000) gpioA;
	PeriphGPIO!('b', 0x4800_0400) gpioB;
	PeriphGPIO!('c', 0x4800_0800) gpioC;
	PeriphGPIO!('d', 0x4800_0C00) gpioD;
	PeriphGPIO!('e', 0x4800_1000) gpioE;
	PeriphGPIO!('f', 0x4800_1400) gpioF;
	PeriphGPIO!('g', 0x4800_1800) gpioG;
	PeriphGPIO!('h', 0x4800_1C00) gpioH;
	PeriphGPIO!('i', 0x4800_2000) gpioI;
}