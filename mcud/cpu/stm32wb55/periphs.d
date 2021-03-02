module mcud.cpu.stm32wb55.periphs;

import mcud.core.mem;

private struct RCC
{
	enum base = 0x5800_0000;

	Volatile!(uint, base + 0x04C) ahb2enr;
	Volatile!(uint, base + 0x400) apb1enr;
}

private struct GPIO
{
	enum base = 0x4800_0000;

	Volatile!(uint, base + 0) moder;
}

private struct TIM2
{
	enum base = 0x4000_0000;

	Volatile!(ushort, base + 0x00) cr1;
	Volatile!(ushort, base + 0x04) cr2;
	Volatile!(uint, base + 0x2C) arr;
}

enum rcc = RCC();
enum gpio = GPIO();
enum tim2 = TIM2();