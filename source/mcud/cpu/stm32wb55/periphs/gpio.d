module mcud.cpu.stm32wb55.periphs.gpio;

import mcud.mem.volatile;

struct GPIO(uint base)
{
	Volatile!(uint, base + 0x00) moder;
	Volatile!(uint, base + 0x04) otyper;
	Volatile!(uint, base + 0x08) ospeedr;
	Volatile!(uint, base + 0x0C) pupdr;
	Volatile!(uint, base + 0x10) idr;
	Volatile!(uint, base + 0x14) odr;
	Volatile!(uint, base + 0x18) bsrr;
	Volatile!(uint, base + 0x1C) lckr;
	Volatile!(uint, base + 0x20) afrl;
	Volatile!(uint, base + 0x24) afrh;
	Volatile!(uint, base + 0x28) brr;
}