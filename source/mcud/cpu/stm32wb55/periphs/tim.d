module mcud.cpu.stm32wb55.periphs.tim;

import mcud.mem.volatile;

private struct TIM2
{
	enum base = 0x4000_0000;

	Volatile!(ushort, base + 0x00) cr1;
	Volatile!(ushort, base + 0x04) cr2;
	Volatile!(uint, base + 0x2C) arr;
}