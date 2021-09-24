module cpu.stm32wb55;

import mcud.core.attributes;
import mcud.core.system;
import cpu.stm32.periphs;
import cpu.stm32wb55.periphs;

template STM32WB55()
{
	PeriphGPIO!0x4800_0000 gpioA;
	PeriphGPIO!0x4800_0400 gpioB;
	PeriphGPIO!0x4800_0800 gpioC;
	PeriphGPIO!0x4800_0C00 gpioD;
	PeriphGPIO!0x4800_1000 gpioE;
	PeriphGPIO!0x4800_1C00 gpioH;

	PeriphRCC!0x5800_0000 rcc;
}