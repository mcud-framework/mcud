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

	PeriphGPIO!0x4800_0000 gpioA;
	PeriphGPIO!0x4800_0400 gpioB;
	PeriphGPIO!0x4800_0800 gpioC;
	PeriphGPIO!0x4800_0C00 gpioD;
	PeriphGPIO!0x4800_1000 gpioE;
	PeriphGPIO!0x4800_1400 gpioF;
	PeriphGPIO!0x4800_1800 gpioG;
	PeriphGPIO!0x4800_1C00 gpioH;
	PeriphGPIO!0x4800_2000 gpioI;
}