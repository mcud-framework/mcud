module mcud.cpu.stm32.cpu;

import mcud.cpu.stm32.capabilities;

/**
Base template for STM32 microcontrollers.
*/
template STM32(alias irqs)
{
	alias IRQ = irqs;

	import mcud.cpu.stm32.mem : vload = volatileLoad;
	import mcud.cpu.stm32.mem : vstore = volatileStore;
	alias volatileLoad = vload;
	alias volatileStore = vstore;

	import mcud.core.attributes : interrupt;
	@interrupt(IRQ.reset)
	void onReset()
	{
		import mcud.core.system : start;
		start();
	}
}
