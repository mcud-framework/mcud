module mcud.cpu.stm32wb55.periphs;

import mcud.core.mem;

private struct RCC
{
	enum base = 0x5800_0000;

	Volatile!(uint, base + 0x4C) ahb2enr;
}

private struct GPIO
{
	enum base = 0x4800_0000;

	Volatile!(uint, base + 0) moder;
}

enum rcc = RCC();
enum gpio = GPIO();