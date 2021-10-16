module cpu.stm32.periphs.gpio.port;

import board : board;
import cpu.capabilities;
import cpu.stm32.periphs.gpio.pin;
import cpu.stm32.periphs.rcc;
import mcud.core.attributes;
import mcud.mem.volatile;

public import cpu.stm32.capabilities : GPIOPort;

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
	/// The configured port.
	GPIOPort _port = GPIOPort.unset;

	/**
	Sets the port to configure.
	*/
	PortConfig port(GPIOPort port)
	{
		assert(capabilities.hasGPIO(cast(char) port), "The MCU does not have a port '" ~ (cast(char) port) ~ "'");
		_port = port;
		return this;
	}
}

/**
Manages a GPIO port.
*/
struct Port(PortConfig config)
{
	/// The port the driver manages.
	enum _port = config._port;

	static assert(_port != GPIOPort.unset, "No port was selected");

	static if (config._port == GPIOPort.a)
	{
		alias periph = board.cpu.gpioA;
		alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOAEN);
	}
	else static if (config._port == GPIOPort.b)
	{
		alias periph = board.cpu.gpioB;
		alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOBEN);
	}
	else static if (config._port == GPIOPort.c)
	{
		alias periph = board.cpu.gpioC;
		alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOCEN);
	}
	else static if (config._port == GPIOPort.d)
	{
		alias periph = board.cpu.gpioD;
		alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIODEN);
	}
	else static if (config._port == GPIOPort.e)
	{
		alias periph = board.cpu.gpioE;
		alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOEEN);
	}
	else static if (config._port == GPIOPort.f)
	{
		alias periph = board.cpu.gpiof;
		alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOFEN);
	}
	else static if (config._port == GPIOPort.g)
	{
		alias periph = board.cpu.gpioG;
		alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOGEN);
	}
	else static if (config._port == GPIOPort.h)
	{
		alias periph = board.cpu.gpioH;
		alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOHEN);
	}
	else static if (config._port == GPIOPort.i)
	{
		alias periph = board.cpu.gpioI;
		alias rcc = RCCPeriph!(RCC_AHB2ENR.GPIOIEN);
	}
	else
		static assert(false, "Invalid port");

	/**
	Enables the port.
	*/
	@forceinline
	void start()
	{
		rcc.start();
	}

	/**
	Disables the port.
	*/
	@forceinline
	void stop()
	{
		rcc.stop();
	}
}