// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/**
This module auto-generates the interrupt vector table.
*/
module cpu.stm32.irq;

import cpu.irq;
import mcud.core.attributes;
import mcud.core.system;
import mcud.meta;

alias ISR = void function();

private void dummyHandler()
{

}

private ISR isrHandler(IRQ irq, string irqName)
{
	Function!interrupt[] allISRs = allFunctions!(interrupt, system);
	Function!interrupt[] isrs;
	foreach (isr; allISRs)
	{
		if (isr.attribute.irq == irq)
			isrs ~= isr;
	}

	if (isrs.length == 1)
		return isrs[0].func;
	else if (isrs.length == 0)
		return &dummyHandler;
	else
	{
		import std.format : format;
		assert(0, "Found more than one interrupt handler for IRQ " ~ irqName);
	}
}

private ISR[] isrHandlers()
{
	ISR[] handlers;
	foreach (irqName; __traits(allMembers, IRQ))
	{
		IRQ irq = __traits(getMember, IRQ, irqName);
		handlers ~= isrHandler(irq, irqName);
	}
	return handlers;
}

private enum handlers = isrHandlers();
private extern(C) immutable ISR[handlers.length] _irqs = handlers;
