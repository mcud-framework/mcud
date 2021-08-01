module mcud.cpu.atmega328p.periphs.gpio;

/**
Controls a GPIO device.
*/
template GPIO(GPIOConfig config)
{
	static assert(config._pin != -1, "No pin was selected");
	static assert(config._port != Port.none, "No port was selected");
	static assert(config._mode != GPIOConfig.Mode.none,
		"No mode was GPIO mode configured");

	void start()
	{

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
	void port(Port port)
	{
		assert(_port == Port.none, "A port was already selected");
		_port = port;
	}

	/**
	Sets the pin to control.
	Params:
		pin = The pin to control.
	*/
	void pin(uint pin)
	{
		assert(_port != Port.none, "No port was selected. Make sure to select"
			~ " a port before configuring a pin.");
		if (_port == Port.b)
			assert(pin <= 7, "Selected pin does not exist.");
		if (_port == Port.c)
			assert(pin <= 5, "Selected pin does not exist.");
		if (_port == Port.d)
			assert(pin <= 7, "Selected pin does not exist.");
		_pin = pin;
	}

	/**
	Configures the pin as an input.
	*/
	void asInput()
	{
		assert(_mode == Mode.none, "The pin as already configured");
		_mode = Mode.input;
	}

	/**
	Configures the pin as an output;
	*/
	void asOutput()
	{
		assert(_mode == Mode.none, "The pin as already configured");
		_mode = Mode.output;
	}
}

/**
A set of GPIO ports.
*/
enum Port
{
	none, b, c, d
}

template GPIOPeriph
{

}