module mcud.cpu.stm32wb55.cpu;

import mcud.core.system;
import mcud.cpu.stm32wb55.config;
import mcud.mem.volatile;

private struct CPU
{
	import mcud.cpu.stm32wb55.periphs;

	PeriphGPIO!0x4800_0000 gpioA;
	PeriphGPIO!0x4800_0400 gpioB;
	PeriphGPIO!0x4800_0800 gpioC;
	PeriphGPIO!0x4800_0C00 gpioD;
	PeriphGPIO!0x4800_1000 gpioE;
	PeriphGPIO!0x4800_1C00 gpioH;

	RCC!0x5800_0000 rcc;
}

/**
The global CPU instances. This gives access to all CPU registers.
*/
enum cpu = CPU();

version(unittest) {}
else
{
	private void onReset()
	{
		start();
	}


	alias ISR = void function();

	private extern(C) immutable ISR _start = &onReset;
}
