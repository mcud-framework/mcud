module cpu.capabilities;

import cpu.stm32l496.capabilities;

/**
Gets the capabilities of the STM32L496VG.
*/
Capabilities capabilities()
{
	Capabilities caps = baseCapabilities();
	caps.gpioAMask = 0b1111_1111_1111_1111;
	caps.gpioBMask = 0b1111_1111_1111_1111;
	caps.gpioCMask = 0b1111_1111_1111_1111;
	caps.gpioDMask = 0b1111_1111_1111_1111;
	caps.gpioEMask = 0b1111_1111_1111_1111;
	caps.gpioHMask = 0b0000_0000_0000_1011;
	return caps;
}