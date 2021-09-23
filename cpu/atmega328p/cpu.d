module mcud.cpu.atmega328p.cpu;

import mcud.core.attributes;
import mcud.core.system;
import mcud.cpu.atmega328p.irq : IRQName = IRQ;
import mcud.cpu.atmega328p.periphs.gpio;

/**
An interface to the Atmega328P.
*/
template Atmega328P()
{
	alias IRQ = IRQName;

	@interrupt(IRQ.RESET)
	void reset()
	{
		start();
	}

	alias gpioB = GPIOPeriph!0x03;
	alias gpioC = GPIOPeriph!0x06;
	alias gpioD = GPIOPeriph!0x09;
}