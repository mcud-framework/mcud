module mcud.cpu.stm32wb55.cpu;

import mcud.core.attributes;
import mcud.core.system;
import mcud.cpu.stm32.periphs;
import mcud.cpu.stm32wb55.irq : IRQName = IRQ;
import mcud.cpu.stm32wb55.periphs;

template STM32WB55_CPU()
{
	public enum GPIO
	{
		unset, a, b, c, d, e, h
	}

	alias IRQ = IRQName;

	PeriphGPIO!0x4800_0000 gpioA;
	PeriphGPIO!0x4800_0400 gpioB;
	PeriphGPIO!0x4800_0800 gpioC;
	PeriphGPIO!0x4800_0C00 gpioD;
	PeriphGPIO!0x4800_1000 gpioE;
	PeriphGPIO!0x4800_1C00 gpioH;

	PeriphRCC!0x5800_0000 rcc;

	@interrupt(IRQ.reset)
	void onReset()
	{
		start();
	}
}