module mcud.core.attributes;

import gcc.attributes;

/**
Forces a specific function to be inlined.
*/
enum forceinline = attribute("always_inline");

/**
Declares a function to be a task.
*/
struct task {}

/**
Declares a function to be run at the start of the program.
*/
struct setup {}

/**
Declares a function to be an interrupt handler.
*/
struct interrupt
{
	int irq;

	/**
	Declares a function to be an interrupt handler.
	Params:
		irq = The IRQ to listen for.
	*/
	this(int irq)
	{
		this.irq = irq;
	}
}