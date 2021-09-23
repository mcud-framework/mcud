module mcud.cpu.atmega328p.periphs.gpio;

import mcud.core.system;
import mcud.cpu.atmega328p.io;

/**
Controls a single pin of a GPIO device.
*/
template GPIOPin(GPIOConfig config)
{
	static assert(config._pin != -1, "No pin was selected");
	static assert(config._port != Port.none, "No port was selected");
	static assert(config._mode != GPIOConfig.Mode.none,
		"No mode was GPIO mode configured");

	static if (config._port == Port.b)
		alias gpio = system.cpu.gpioB;
	else static if (config._port == Port.c)
		alias gpio = system.cpu.gpioC;
	else static if (config._port == Port.d)
		alias gpio = system.cpu.gpioD;

	enum pin = config._pin;
	enum mask = 1 << pin;

	void start()
	{
		gpio.ddr.setBit(pin);
	}

	void on()
	{
		gpio.ddr.setBit(pin);
	}

	void off()
	{
		gpio.port.set(gpio.port.get() & ~mask);
	}
}

/**
Configures a GPIO device.
*/
struct GPIOConfig
{
	/**
	Sets the mode of the GPIO.
	*/
	enum Mode
	{
		none,
		input,
		output
	}

	/// The port to control.
	Port _port = Port.none;

	/// The pin to control;
	uint _pin = -1;

	/// The mode to configure the pin as.
	Mode _mode = Mode.none;

	/**
	Sets the port to control.
	Params:
		port = The port to control.
	*/
	GPIOConfig port(Port port)
	{
		assert(_port == Port.none, "A port was already selected");
		_port = port;
		return this;
	}

	/**
	Sets the pin to control.
	Params:
		pin = The pin to control.
	*/
	GPIOConfig pin(uint pin)
	{
		assert(_port != Port.none, "No port was selected. Make sure to select"
			~ " a port before configuring a pin.");
		if (_port == Port.b)
			assert(pin <= 7, "Selected pin does not exist.");
		if (_port == Port.c)
			assert(pin <= 6, "Selected pin does not exist.");
		if (_port == Port.d)
			assert(pin <= 7, "Selected pin does not exist.");
		_pin = pin;
		return this;
	}

	/**
	Configures the pin as an input.
	*/
	GPIOConfig asInput()
	{
		assert(_mode == Mode.none, "The pin as already configured");
		_mode = Mode.input;
		return this;
	}

	/**
	Configures the pin as an output;
	*/
	GPIOConfig asOutput()
	{
		assert(_mode == Mode.none, "The pin as already configured");
		_mode = Mode.output;
		return this;
	}
}

/**
A set of GPIO ports.
*/
enum Port
{
	none, b, c, d
}

/**
Allows access to a GPIO periph.
*/
template GPIOPeriph(ubyte base)
{
	alias pin = IO!(base + 0x00);
	alias ddr = IO!(base + 0x01);
	alias port = IO!(base + 0x02);
}