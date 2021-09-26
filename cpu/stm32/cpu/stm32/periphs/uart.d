module cpu.stm32.periphs.uart;

import mcud.mem.volatile;

/**
The raw UART peripheral.
Params:
	base = The base address.
*/
struct PeriphUART(uint base)
{
	/// Control Register 1
	Volatile!(uint, base + 0x00) CR1;
	/// Control Register 2
	Volatile!(uint, base + 0x04) CR2;
	/// Control Register 3
	Volatile!(uint, base + 0x08) CR3;
	/// Baud Rate Register
	Volatile!(uint, base + 0x0C) BRR;
	/// Guard Time and Prescaler Register
	Volatile!(uint, base + 0x10) GPTR;
	/// Receiver Timeout Register
	Volatile!(uint, base + 0x14) RTOR;
	/// Request Register
	Volatile!(uint, base + 0x18) RQR;
	/// Interrupt and Status Register
	Volatile!(uint, base + 0x1C) ISR;
	/// Interrupt flag Clear Register
	Volatile!(uint, base + 0x20) ICR;
	/// Receive Data Register
	Volatile!(uint, base + 0x24) RDR;
	/// Transmit Data Register
	Volatile!(uint, base + 0x28) TDR;
}

struct UARTConfig(
	alias tx = void,
	alias rx = void
)
{
	alias _tx = tx;
	alias _rx = rx;

	auto txPin(alias pin)()
	{
		return UARTConfig!(pin, rx);
	}

	auto rxPin(alias pin)()
	{
		return UARTConfig!(tx, pin);
	}
}

template UART(UARTConfig config)
{
	static assert(!is(config._tx == void), "TX must be set");
}