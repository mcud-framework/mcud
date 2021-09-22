module mcud.cpu.stm32l496.cpu;

import mcud.cpu.stm32.capabilities;
import mcud.cpu.stm32.cpu;
import mcud.cpu.stm32l496.irq;
import mcud.cpu.stm32l496.periphs;
import mcud.meta.extend;

/**
Base template for STM32L496 microcontrollers.
*/
template STM32L496()
{
	alias base = STM32!(IRQ);
	mixin AliasThis!(base);

	static Capabilities capabilities()
	{
		Capabilities caps;
		return caps;
	}

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