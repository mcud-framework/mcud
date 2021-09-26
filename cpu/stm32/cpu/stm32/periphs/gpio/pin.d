module cpu.stm32.periphs.gpio.pin;

import mcud.core.attributes;
import mcud.core.result;
import mcud.core.system;
import mcud.mem.volatile;
import mcud.meta.like;
import mcud.periphs.input;

/**
Configures a pin.
*/
struct PinConfig
{
	/**
	Set of valid modes.
	*/
	enum Mode : uint
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
	enum Pull : uint
	{
		none = 0b00,
		up = 0b01,
		down = 0b10,
	}

	/// The selected mode.
	Mode _mode = Mode.unset;
	/// The state of the pull-up/pull-down resistor.
	Pull _pull = Pull.none;
	/// The selected pin.
	uint _pin = -1;

	/**
	Sets the pin.
	Params:
		pin = The pin to configure.
	*/
	PinConfig pin(uint pin)
	{
		_pin = pin;
		return this;
	}

	/**
	Sets the mode of the pin.
	Params:
		mode = The mode of the pin.
	*/
	PinConfig mode(Mode mode)
	{
		assert(_mode == Mode.unset, "Mode is already set");
		_mode = mode;
		return this;
	}

	/**
	Configures the pin as an output.
	*/
	PinConfig asOutput()
	{
		return mode(Mode.output);
	}

	/**
	Configures the pin as an input.
	*/
	PinConfig asInput()
	{
		return mode(Mode.input);
	}

	/**
	Configures the pin as an analog input.
	*/
	PinConfig asAnalog()
	{
		return mode(Mode.analog);
	}

	/**
	Configures the pin as an alternative function.
	*/
	PinConfig asAlternateFunction()
	{
		return mode(Mode.alternate);
	}

	/**
	Configures the pull-up/pull-down resistor.
	*/
	PinConfig pull(Pull pull)
	{
		assert(_pull == Pull.none, "Pull-up/down is already set");
		_pull = pull;
		return this;
	}

	/**
	Enables the pull-up resistor.
	*/
	PinConfig enablePullUp()
	{
		return pull(Pull.up);
	}

	/**
	Enables the bull-down resistor.
	*/
	PinConfig enablePullDown()
	{
		return pull(Pull.down);
	}
}

/**
Manages a pin with a certain configuration.
Params:
	config = The pin configuration.
*/
template Pin(alias periph, PinConfig config)
{
	import board : board;
	import cpu.capabilities;
	import cpu.stm32.periphs.rcc;

	static assert(config._pin != -1, "Pin not set");
	static assert(config._pin < 16, "Pin out of range");
	static assert(config._mode != PinConfig.Mode.unset, "Mode not set");
	static assert(capabilities.gpioHasPin(periph._port, config._pin), "Invalid port");

	/**
	Sets the mode of the pin.
	Params:
		mode = The mode of the pin.
	*/
	void setMode(PinConfig.Mode mode)
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
	void setPull(PinConfig.Pull pull)
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
		setMode(PinConfig.Mode.analog);
	}

	static if (config._mode == PinConfig.Mode.output)
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
	else static if (config._mode == PinConfig.Mode.input)
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