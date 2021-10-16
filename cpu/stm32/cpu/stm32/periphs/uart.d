module cpu.stm32.periphs.uart;

import cpu.capabilities;
import mcud.container.queue;
import mcud.core.system;
import mcud.core.task;
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

/**
Bitmask for CR1.
*/
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
	Device m_tx = Device.empty;
	/// The pin to use as RX.
	Device m_rx = Device.empty;
	/// The UART port to configure.
	UARTPort m_port = UARTPort.unset;
	/// The size of the transmit buffer.
	size_t m_transmitBufferSize = 128;

	UARTConfig uart(UARTPort port)
	{
		assert(m_port == UARTPort.unset, "A UART port is already selected");
		m_port = port;
		return this;
	}

	/**
	Sets the TX pin.
	*/
	UARTConfig txPin(Pin)(Pin pin)
	{
		m_tx = Device.of!Pin;
		return this;
	}

	/**
	Sets the RX pin.
	*/
	UARTConfig rxPin(Pin)(Pin pin)
	{
		m_rx = Device.of!Pin;
		return this;
	}

	/**
	Sets the size of the transmit buffer in bytes.
	Params:
		size = The size of the transmit buffer, in bytes.
	*/
	UARTConfig transmitBufferSize(size_t size)
	{
		m_transmitBufferSize = size;
		return this;
	}

	auto opDispatch(string member)()
	{
		return mixin("m_"~member);
	}
}

/**
A UART.
*/
struct UART(UARTConfig config)
{
static:
	enum hasTX = !config.m_tx.isEmpty();
	enum hasRX = !config.m_rx.isEmpty();
	enum UARTConfig c = config;

	static if (hasTX)
		alias tx = getDevice!(config.tx());
	static if (hasRX)
		alias rx = getDevice!(config.rx());

	static assert(hasTX || hasRX, "A UART needs at least a TX or RX pin configured");

	static if (config.m_port == UARTPort.usart1)
	{
		alias periph = system.cpu.usart1;
		mixin assertAF!(AlternateFunction.USART1_TX, AlternateFunction.USART1_RX);
	}
	else static if (config.m_port == UARTPort.usart2)
	{
		alias periph = system.cpu.usart2;
		mixin assertAF!(AlternateFunction.USART2_TX, AlternateFunction.USART2_RX);
	}
	else static if (config.m_port == UARTPort.usart3)
	{
		alias periph = system.cpu.usart3;
		mixin assertAF!(AlternateFunction.USART3_TX, AlternateFunction.USART3_RX);
	}
	else static if (config.m_port == UARTPort.uart4)
	{
		alias periph = system.cpu.uart4;
		mixin assertAF!(AlternateFunction.UART4_TX, AlternateFunction.UART4_RX);
	}
	else static if (config.m_port == UARTPort.uart5)
	{
		alias periph = system.cpu.uart5;
		mixin assertAF!(AlternateFunction.UART5_TX, AlternateFunction.UART5_RX);
	}
	else static if (config.m_port == UARTPort.lpuart1)
	{
		alias periph = system.cpu.lpuart1;
		mixin assertAF!(AlternateFunction.LPUART1_TX, AlternateFunction.LPUART1_RX);
	}

	private enum m_cr1 = getDefaultCR1();
	private Queue!(ubyte, config.transmitBufferSize()) m_transmitBuf;

	void start()
	{
		periph.CR1 |= m_cr1;
	}

	void stop()
	{
		periph.CR1.store(0);
	}

	@task(TaskState.stopped)
	void transmitTask()
	{

	}

	void write(ubyte[] data)
	{

	}

	void write(string data)
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

	mixin template assertAF(AlternateFunction afTX, AlternateFunction afRX)
	{
		static if (hasTX)
		{
			static assert(tx.alternateFunction.isSet, "TX is not configured as an alternate function");
			static assert(tx.alternateFunction.af == afTX, "TX is configured for the incorrect alternate function");
		}
		static if (hasRX)
		{
			static assert(rx.alternateFunction.isSet, "RX is not configured as an alternate function");
			static assert(rx.alternateFunction.af == afRX, "RX is configured for the incorrect alternate function");
		}
	}
}