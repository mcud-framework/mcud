module cpu.nrf5340.periphs.gpio;

import mcud.mem.volatile;
import std.format;

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

	static foreach (i; 0 .. 32)
		mixin(format!"Volatile!(uint, base + 0x%X) pinCnf%d;"(0x200 + i * 4, i));
}

/**
Pin configuration register.
*/
enum PIN_CNF : uint
{
	DIR = 0,
	INPUT = 1,
	PULL = 2,
	DRIVE = 8,
	SENSE = 16,
	MCUSEL = 28,
}


/**
A set of GPIO ports.
*/
enum Port
{
	unset,
	p0, p1
}

/**
The direction of the GPIO pin.
*/
enum Direction
{
	unset,
	input,
	output
}

/**
The direction of the pull-up/down resistor.
*/
enum PullMode
{
	none,
	pullDown,
	pullUp
}

/**
Configures a GPIO port.
*/
struct PinConfig
{
	/// The port to configure.
	Port _port;
	/// The pin to configure.
	uint _pin;
	/// The direction of the pin.
	Direction _direction;
	/// The state of the pull-up/down resistor.
	PullMode _pullMode;

	/**
	Sets the port to configure.
	Params:
		port = The port to configure.
	Returns: this struct.
	*/
	PinConfig port(Port port)
	{
		assert(port != Port.unset, "Invalid port");
		_port = port;
		return this;
	}
	
	/**
	Sets the pin to configure.
	Params:
		pin = The pin to configure.
	Returns: this struct.
	*/
	PinConfig pin(uint pin)
	{
		assert(pin < 32, "Invalid pin");
		_pin = pin;
		return this;
	}

	/**
	Configures the pin as an input.
	Returns: this struct.
	*/
	PinConfig asInput()
	{
		return direction(Direction.input);
	}

	/**
	Configures the pin as an output.
	Returns: this struct.
	*/
	PinConfig asOutput()
	{
		return direction(Direction.output);
	}

	/**
	Enables a pull-up resistor on the pin.
	Returns: this struct.
	*/
	PinConfig withPullUp()
	{
		return pullMode(PullMode.pullUp);
	}

	/**
	Enables a pull-down resistor on the pin.
	Returns: this struct.
	*/
	PinConfig withPullDown()
	{
		return pullMode(PullMode.pullDown);
	}

	/**
	The direction of the pin.
	Params:
		direction = The direction of the pin.
	Returns: this struct.
	*/
	private PinConfig direction(Direction direction)
	{
		assert(_direction == Direction.unset, "Direction already set");
		assert(direction != Direction.unset, "Invalid direction");
		_direction = direction;
		return this;
	}

	/**
	The direction of the pin.
	Params:
		direction = The direction of the pin.
	Returns: this struct.
	*/
	private PinConfig pullMode(PullMode pullMode)
	{
		assert(_pullMode == PullMode.none, "Direction already set");
		assert(pullMode != PullMode.none, "Invalid direction");
		_pullMode = pullMode;
		return this;
	}
}

/**
Configures a pin.
*/
struct Pin(PinConfig config)
{
static:
	import board : board;

	static if (config._port == Port.p0)
		alias periph = board.cpu.p0;
	else static if (config._port == Port.p1)
		alias periph = board.cpu.p1;
	else
		static assert(0, "No port to configure was selected");

	mixin(format!"alias cnf = periph.pinCnf%d;"(config._pin));
	enum mask = (1 << config._pin);
	enum pinConfig = {
		uint cnf = 0;

		if (config._direction == Direction.output)
			cnf |= 1 << PIN_CNF.DIR;

		if (config._pullMode == PullMode.pullUp)
			cnf |= 3 << PIN_CNF.PULL;
		else if (config._pullMode == PullMode.pullDown)
			cnf |= 1 << PIN_CNF.PULL;

		return cnf;
	}();

	/**
	Starts the pin.
	*/
	void start()
	{
		cnf.store(pinConfig);
	}

	static if (config._direction == Direction.output)
	{
		/**
		Turn the pin on.
		*/
		void on()
		{
			periph.outSet.store(mask);
		}

		/**
		Turn the pin off.
		*/
		void off()
		{
			periph.outClr.store(mask);
		}
	}
	else static if (config._direction == Direction.input)
	{
		/**
		Gets the state of the pin.
		Returns: `true` if the pin is high, `false` if the pin is low.
		*/
		bool isOn()
		{
			return (periph.in_.load() & mask) != 0;
		}
	}
}