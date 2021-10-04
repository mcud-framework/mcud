// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.core.interrupts;

import mcud.core.system;

public import mcud.core.attributes : interrupt;

version (unittest)
{
	enum IRQ
	{
		irq1, irq2, irq3
	}
}
else
{
	public import cpu.irq : IRQ;
}