module cpu.stm32.periphs.uart;

import cpu.capabilities;
import mcud.mem.volatile;
import mcud.meta.device;

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

enum USART_CR1
{
	UE = 1 << 0,
	UESM = 1 << 1,
	RE = 1 << 2,
	TE = 1 << 3,
	IDLEIE = 1 << 4,
	RXNEIE = 1 << 5,
	TCIE = 1 << 6,
	TXEIE = 1 << 7,
	PEIE = 1 << 8,
	PS = 1 << 9,
	PCE = 1 << 10,
	WAKE = 1 << 11,
	M0 = 1 << 12,
	MME = 1 << 13,
	CMIE = 1 << 14,
	OVER8 = 1 << 15,
	RTOIE = 1 << 26,
	EOBIE = 1 << 27,
	M1 = 1 << 18,
}

/**
Describes all supported UART ports.
*/
enum UARTPort
{
	unset,
	usart1,
	usart2,
	usart3,
	uart4,
	uart5,
	lpuart1
}

/**
Configures a UART.
*/
struct UARTConfig
{
	/// The pin to use as TX.
	Device _tx = Device.empty;
	/// The pin to use as RX.
	Device _rx = Device.empty;
	/// The UART port to configure.
	UARTPort _port = UARTPort.unset;

	UARTConfig uart(UARTPort port)
	{
		assert(_port == UARTPort.unset, "A UART port is already selected");
		_port = port;
		return this;
	}

	/**
	Sets the TX pin.
	*/
	UARTConfig txPin(Pin)(Pin pin)
	{
		_tx = Device.of!Pin;
		return this;
	}

	/**
	Sets the RX pin.
	*/
	UARTConfig rxPin(Pin)(Pin pin)
	{
		_rx = Device.of!Pin;
		return this;
	}
}

/**
A UART.
*/
struct UART(UARTConfig config)
{
static:
	enum hasTX = !config._tx.isEmpty();
	enum hasRX = !config._rx.isEmpty();

	static assert(hasTX || hasRX, "A UART needs at least a TX or RX pin configured");

	enum cr1 = getDefaultCR1();

	void start()
	{

	}

	void stop()
	{

	}

	private uint getDefaultCR1()
	{
		uint cr1 = 0;
		if (hasTX)
			cr1 |= USART_CR1.TE;
		if (hasRX)
			cr1 |= USART_CR1.RE;
		return cr1;
	}
}