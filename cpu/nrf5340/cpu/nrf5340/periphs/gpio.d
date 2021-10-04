module cpu.nrf5340.periphs.gpio;

import mcud.mem.volatile;

/**
Manages a GPIO port.
*/
struct PeriphGPIO(uint base)
{
	Volatile!(uint, base + 0x004) out_;
	Volatile!(uint, base + 0x008) outSet;
	Volatile!(uint, base + 0x00C) outClr;
	Volatile!(uint, base + 0x010) in_;
	Volatile!(uint, base + 0x014) dir;
	Volatile!(uint, base + 0x018) dirSet;
	Volatile!(uint, base + 0x01C) dirClr;
	Volatile!(uint, base + 0x020) latch;
	Volatile!(uint, base + 0x024) detectMode;
	Volatile!(uint, base + 0x028) detectModeSec;
	Volatile!(uint, base + 0x200) pinCnf;
}

struct GPIOConfig
{
	
}