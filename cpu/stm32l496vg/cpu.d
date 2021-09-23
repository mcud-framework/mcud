module mcud.cpu.stm32l496vg.cpu;

template STM32L496VG()
{
	import mcud.cpu.stm32.capabilities;
	import mcud.cpu.stm32l496.cpu;
	import mcud.meta.extend;

	mixin Extend!(STM32L496!());

	Capabilities capabilities()
	{
		Capabilities caps = base.capabilities();
		caps.gpioAMask = 0b1111_1111_1111_1111;
		caps.gpioBMask = 0b1111_1111_1111_1111;
		caps.gpioCMask = 0b1111_1111_1111_1111;
		caps.gpioDMask = 0b1111_1111_1111_1111;
		caps.gpioEMask = 0b1111_1111_1111_1111;
		caps.gpioHMask = 0b0000_0000_0000_1011;
		return caps;
	}
}