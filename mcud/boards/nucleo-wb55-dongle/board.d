module board;

__gshared uint* GPIOA_MODER = cast(uint*)(0x4800_0000 + 0x00);
__gshared uint* GPIOA_ODR = cast(uint*)(0x4800_0000 + 0x14);

void init()
{
	*cast(uint*)(0x4800_0000 + 0x00) = 0xFFFF_FFFF;
	for (;;)
	{
		*cast(uint*)(0x4800_0000 + 0x14) = ~*cast(uint*)(0x4800_0000 + 0x14);
	}
}
