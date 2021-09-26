module cpu.stm32.periphs.gpio.port;

import board : board;
import cpu.capabilities;
import cpu.stm32.periphs.gpio.pin;
import cpu.stm32.periphs.rcc;
import mcud.core.attributes;
import mcud.mem.volatile;

/**
The raw GPIO peripheral.

Params:
	port = A letter naming the port.
	base = The starting address of the peripheral.
*/
struct PeriphGPIO(char port, uint base)
{
	/// The identifier of the port.
	enum _port = port;

	/// Mode Register
	Volatile!(uint, base + 0x00) moder;
	/// Output Type Register
	Volatile!(uint, base + 0x04) otyper;
	/// Output Speed Register
	Volatile!(uint, base + 0x08) ospeedr;
	/// Pull-Up Pull-Down Register
	Volatile!(uint, base + 0x0C) pupdr;
	/// Input Data Register
	Volatile!(uint, base + 0x10) idr;
	/// Output Data Register
	Volatile!(uint, base + 0x14) odr;
	/// Bit Set/Reset Register
	Volatile!(uint, base + 0x18) bsrr;
	/// Configuration Lock Register
	Volatile!(uint, base + 0x1C) lckr;
	/// Alternate Function Low
	Volatile!(uint, base + 0x20) afrl;
	/// Alternate Function High
	Volatile!(uint, base + 0x24) afrh;
	/// Bit Reset Register
	Volatile!(uint, base + 0x28) brr;
}

/**
Configures a GPIO port.
*/
struct PortConfig
{
	/**
	Set of valid ports.
	*/
	enum Port
	{
		unset,
		a = 'a',
		b = 'b',
		c = 'c',
		d = 'd',
		e = 'e',
		f = 'f',
		g = 'g',
		h = 'h',
		i = 'i'
	}

	/// The configured port.
	Port _port = Port.unset;

	/**
	Sets the port to configure.
	*/
	PortConfig port(Port port)
	{
		assert(capabilities.hasGPIO(cast(char) port), "The MCU does not have a port '" ~ (cast(char) port) ~ "'");
		_port = port;
		return this;
	}
}

/**
Manages a GPIO port.
*/
template Port(PortConfig config)
{
	static assert(config._port != PortConfig.Port.unset, "No port was selected");

	static if (config._port == PortConfig.Port.a)
	{
		private alias periph = board.cpu.gpioA;
		private alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOAEN);
	}
	else static if (config._port == PortConfig.Port.b)
	{
		private alias periph = board.cpu.gpioB;
		private alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOBEN);
	}
	else static if (config._port == PortConfig.Port.c)
	{
		private alias periph = board.cpu.gpioC;
		private alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOCEN);
	}
	else static if (config._port == PortConfig.Port.d)
	{
		private alias periph = board.cpu.gpioD;
		private alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIODEN);
	}
	else static if (config._port == PortConfig.Port.e)
	{
		private alias periph = board.cpu.gpioE;
		private alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOEEN);
	}
	else static if (config._port == PortConfig.Port.f)
	{
		private alias periph = board.cpu.gpiof;
		private alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOFEN);
	}
	else static if (config._port == PortConfig.Port.g)
	{
		private alias periph = board.cpu.gpioG;
		private alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOGEN);
	}
	else static if (config._port == PortConfig.Port.h)
	{
		private alias periph = board.cpu.gpioH;
		private alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOHEN);
	}
	else static if (config._port == PortConfig.Port.i)
	{
		private alias periph = board.cpu.gpioI;
		private alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOIEN);
	}
	else
		static assert(false, "Invalid port");

	template configurePin(PinConfig config)
	{
		alias configurePin = Pin!(periph, config);
	}

	@forceinline
	void start()
	{
		rcc.start();
	}

	@forceinline
	void stop()
	{
		rcc.stop();
	}
}