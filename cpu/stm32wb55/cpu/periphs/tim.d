// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.cpu.stm32wb55.periphs.tim;

import mcud.mem.volatile;

private struct TIM2
{
	enum base = 0x4000_0000;

	Volatile!(ushort, base + 0x00) cr1;
	Volatile!(ushort, base + 0x04) cr2;
	Volatile!(uint, base + 0x2C) arr;
}