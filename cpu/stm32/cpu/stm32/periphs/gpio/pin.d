module cpu.stm32.periphs.gpio.pin;

import board : board;
import cpu.capabilities;
import cpu.stm32.periphs.rcc;
import mcud.core.attributes;
import mcud.core.result;
import mcud.core.system;
import mcud.mem.volatile;
import mcud.meta.like;
import mcud.periphs.input;


/**
Set of valid modes.
*/
enum PinMode : uint
{
	unset = -1,
	input = 0b00,
	output = 0b01,
	alternate = 0b10,
	analog = 0b11,
}

/**
State of pull-up/pull-down resistor.
*/
enum PinPull : uint
{
	none = 0b00,
	up = 0b01,
	down = 0b10,
}

/**
A set of all alternative functions.
*/
enum AlternateFunction
{
	can1,
	can2,
	comp1,
	comp2,
	dcmi,
	dfsdm,
	evenout,
	fmc,
	i2c1,
	i2c2,
	i2c3,
	i2c4,
	lcd,
	lptim2,
	lpuart1,
	otg_fs,
	quadspi,
	sai1,
	sai2,
	sdmmc,
	spi1,
	spi2,
	spi3,
	swpmi1,
	sysAf,
	tim1,
	tim15,
	tim16,
	tim17,
	tim2,
	tim3,
	tim4,
	tim5,
	tim8,
	tsc,
	uart4,
	uart5,
	unset,
	usart1,
	usart2,
	usart3,
}

/**
Configures a pin.
*/
struct PinConfigT(Port)
{
	/// The port the pin is on.
	alias _port = Port;
	/// The selected mode.
	PinMode _mode = PinMode.unset;
	/// The state of the pull-up/pull-down resistor.
	PinPull _pull = PinPull.none;
	/// The selected pin.
	uint _pin = -1;

	/**
	Sets the port the GPIO pin uses.
	*/
	PinConfigT!Port port(Port)(Port port)
	{
		import mcud.meta.copy : copyTo;
		PinConfigT!Port config;
		this.copyTo(config);
		return config;
	}

	/**
	Sets the pin.
	Params:
		pin = The pin to configure.
	*/
	PinConfigT!Port pin(uint pin)
	{
		_pin = pin;
		return this;
	}

	/**
	Sets the mode of the pin.
	Params:
		mode = The mode of the pin.
	*/
	PinConfigT!Port mode(PinMode mode)
	{
		assert(_mode == PinMode.unset, "Mode is already set");
		_mode = mode;
		return this;
	}

	/**
	Configures the pin as an output.
	*/
	PinConfigT!Port asOutput()
	{
		return mode(PinMode.output);
	}

	/**
	Configures the pin as an input.
	*/
	PinConfigT!Port asInput()
	{
		return mode(PinMode.input);
	}

	/**
	Configures the pin as an analog input.
	*/
	PinConfigT!Port asAnalog()
	{
		return mode(PinMode.analog);
	}

	/**
	Configures the pin as an alternative function.
	*/
	PinConfigT!Port asAlternateFunction()
	{
		return mode(PinMode.alternate);
	}

	/**
	Configures the pull-up/pull-down resistor.
	*/
	PinConfigT!Port pull(PinPull pull)
	{
		assert(_pull == PinPull.none, "Pull-up/down is already set");
		_pull = pull;
		return this;
	}

	/**
	Enables the pull-up resistor.
	*/
	PinConfigT!Port enablePullUp()
	{
		return pull(PinPull.up);
	}

	/**
	Enables the bull-down resistor.
	*/
	PinConfigT!Port enablePullDown()
	{
		return pull(PinPull.down);
	}
}
alias PinConfig = PinConfigT!(void);

/**
Manages a pin with a certain configuration.
Params:
	config = The pin configuration.
*/
struct Pin(alias config)
{
	alias periph = config._port.periph;
	static assert(config._pin != -1, "Pin not set");
	static assert(config._pin < 16, "Pin out of range");
	static assert(config._mode != PinMode.unset, "Mode not set");
	static assert(!is(config._port == void), "No port was selected");
	static assert(capabilities.gpioHasPin(config._port._port, config._pin), "Invalid port");

static:
	/**
	Sets the mode of the pin.
	Params:
		mode = The mode of the pin.
	*/
	void setMode(PinMode mode)
	{
		auto value = periph.moder.load();
		value &= ~(0b11 << (config._pin * 2));
		value |= (cast(uint) config._mode) << (config._pin * 2);
		periph.moder.store(value);
	}

	/**
	Sets the pull-up/pull-down resistor.
	Params:
		pull = The state of the pull-upp/pull-down resistor.
	*/
	void setPull(PinPull pull)
	{
		auto value = periph.pupdr.load();
		value &= ~(0b11 << (config._pull * 2));
		value |= (cast(uint) config._pull) << (config._pin * 2);
		periph.pupdr.store(value);
	}

	/**
	Enables the pin.
	*/
	@forceinline
	void start()
	{
		setMode(config._mode);
		setPull(config._pull);
	}

	/**
	Disables the pin.
	*/
	@forceinline
	void stop()
	{
		setMode(PinMode.analog);
	}

	static if (config._mode == PinMode.output)
	{
		@forceinline
		Result!void on() nothrow
		{
			periph.bsrr.store(1 << config._pin);
			return ok!void();
		}

		@forceinline
		Result!void off() nothrow
		{
			periph.bsrr.store(0x0001_0000 << config._pin);
			return ok!void();
		}
	}
	else static if (config._mode == PinMode.input)
	{
		@forceinline
		Result!bool isOn()
		{
			const idr = periph.idr.load();
			enum mask = 1 << config._pin;
			return ok!bool((idr & mask) != 0);
		}
	}
	else
	{
		static assert(false, "Unsupported IO mode");
	}
}