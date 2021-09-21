module mcud.cpu.stm32l496.cpu;

import mcud.core.attributes;
import mcud.cpu.stm32l496.periphs;
import mcud.cpu.stm32l496.irq : IRQName = IRQ;

template STM32L496()
{
	alias IRQ = IRQName;

	enum GPIO
	{
		unset,
		a,b,c,d,e,f,g,h,i
	};

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

	@interrupt(IRQ.reset)
	void onReset()
	{
		import mcud.core.system : start;
		start();
	}
}