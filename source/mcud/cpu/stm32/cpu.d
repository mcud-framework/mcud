module mcud.cpu.stm32.cpu;

version (MCU_STM32WB55)
{
	public import mcud.cpu.stm32wb55.cpu : cpu;
}
else version (unittest)
{
}
else
{
	static assert(0, "No MCU version set");
}