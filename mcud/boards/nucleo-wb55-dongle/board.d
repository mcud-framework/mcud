module board;

__gshared uint* GPIOA_MODER = cast(uint*)(0x4800_0000 + 0x00);
__gshared uint* GPIOA_ODR = cast(uint*)(0x4800_0000 + 0x14);

void init()
{
	*cast(uint*)(0x4800_0000 + 0x00) = 0xFFFF_FFFF;
	//*GPIOA_MODER |= 0b01_00_00_00_00u;
	//*GPIOA_MODER = 0xFFFF_FFFF;
	//*GPIOA_ODR = 0xFFFF_FFFF;
	//*GPIOA_ODR = 0;
	//while (1) {}
	for (;;)
	{
		*cast(uint*)(0x4800_0000 + 0x14) = ~*cast(uint*)(0x4800_0000 + 0x14);
	}
}
