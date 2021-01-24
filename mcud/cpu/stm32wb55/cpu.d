module mcud.cpu.stm32wb55.cpu;

import mcud.cpu.stm32wb55.mem;
import mcud.cpu.stm32wb55.periphs;

//@attribute("section", "start")
private void onReset()
{
	//startup();
	//uint* ahb2enr = cast(uint*) (0x5800_0000 + 0x4C);
	//volatileStore(*ahb2enr, volatileLoad(*ahb2enr) | 1);

	rcc.ahb2enr |= 1;

	//uint* 
	uint* mode = cast(uint*) 0x4800_0000;
	volatileStore(*mode, 0x5555_5555);
	//*cast(uint*)(0x4800_0000 + 0x00) = 0xFFFF_FFFF;
	//*GPIOA_MODER |= 0b01_00_00_00_00u;
	//*GPIOA_MODER = 0xFFFF_FFFF;
	//*GPIOA_ODR = 0xFFFF_FFFF;
	//*GPIOA_ODR = 0;
	uint* output = cast(uint*)(0x4800_0000 + 0x14);
	while (1)
	//for (;;)
	{
		volatileStore(*output, ~volatileLoad(*output));
		//*output = ~*output;
		//volatileStore(output, ~volatileLoad(output));
	}
}


alias ISR = void function();

extern(C) immutable ISR _start = &onReset;
