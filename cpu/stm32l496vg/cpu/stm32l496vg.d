module cpu.stm32l496vg;

import cpu.stm32l496.base;
import cpu.stm32l496.capabilities;
import mcud.meta.extend;

/**
The STM32L496VG is an 32-bit ST microcontroller with 1 megabyte of flash and
320 kilobytes of RAM.
*/
template STM32L496VG()
{
	mixin Extend!(STM32L496!());
}