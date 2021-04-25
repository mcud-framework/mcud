module mcud.cpu.stm32wb55.periphs.gpio;

import mcud.core.result;
import mcud.mem.volatile;
import mcud.meta.like;
import mcud.periphs.input;

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

struct InputPin(periph, uint pin)
{
	Result!bool isOn();
}

static assert(isGPI!(InputPin!(void, 0)));

struct OutputPin(alias periph, uint pin)
{
	Result!void on()
	{
		periph.bsrr.store(1 << pin);
		return ok!void();
	}

	Result!void off()
	{
		periph.bsrr.store(0x0001_0000 << pin);
		return ok!void();
	}
}

static assert(isGPI!(InputPin!(void, 0)));
