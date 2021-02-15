module mcud.cpu.stm32wb55.cpu;

import mcud.cpu.stm32wb55.mem;
import mcud.cpu.stm32wb55.periphs;
import mcud.cpu.stm32wb55.configurer;
import mcud.core.mem;

version(unittest) {}
else
{
	enum cpuConfigurer = configureCPU!((CPUConfigurer options)
	{
		options
			.enableGPIO(GPIO.a)
				.pin(4)
					.asOutput()
					.and()
				.and()
			//.enableTimer(Timer.tim2)
			//	.autoReload(100)
		;
	});

	private void onReset()
	{
		cpuConfigurer.configure();
		uint* output = cast(uint*)(0x4800_0000 + 0x14);
		while (1)
		{
			volatileStore(*output, ~volatileLoad(*output));
		}
	}


	alias ISR = void function();

	private extern(C) immutable ISR _start = &onReset;
}
