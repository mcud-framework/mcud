module mcud.cpu.atmega328p.cpu;

import mcud.core.attributes;
import mcud.cpu.atmega328p.irq;

/**
An interface to the Atmega328P.
*/
template Atmega328P()
{
	@interrupt(IRQ.RESET)
	void reset()
	{

	}
}