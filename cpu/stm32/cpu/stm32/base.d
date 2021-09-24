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
		import mcud.core.system : start;
		start();
	}
}
