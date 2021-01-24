module mcud.cpu.stm32wb55.periphs;

import mcud.core.mem;

private struct RCC
{
	enum base = 0x5800_004C;

	//Volatile!(uint, base + 0x4C) ahb2enr;
	Volatile!(uint, base) ahb2enr;
}

enum rcc = RCC();
pragma(msg, rcc.sizeof);