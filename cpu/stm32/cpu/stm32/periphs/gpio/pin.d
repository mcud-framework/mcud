// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module cpu.stm32.periphs.gpio.pin;

import board : board;
import cpu.capabilities;
import cpu.stm32.capabilities;
import cpu.stm32.periphs.rcc;
import mcud.core.attributes;
import mcud.core.result;
import mcud.core.system;
import mcud.events;
import mcud.interfaces.gpio;
import mcud.mem.volatile;
import mcud.meta.like;

public import cpu.stm32.capabilities : AlternateFunction;


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
	/// The selected alternate function.
	AlternateFunction _af;

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
	PinConfigT!Port asAlternateFunction(AlternateFunction af)
	{
		_af = af;
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

	static if (config._mode == PinMode.alternate)
	{
		/// The configured alternative function of the pin.
		enum alternateFunction = capabilities().getAlternateFunction(config._port._port, config._pin, config._af);
	}
	else
	{
		/// The configured alternative function of the pin.
		enum alternateFunction = AFCapability();
	}

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
		struct ReadyEvent {}

		void on()
		{
			periph.bsrr.store(1 << config._pin);
			fire!ReadyEvent();
		}

		void off()
		{
			periph.bsrr.store(0x0001_0000 << config._pin);
			fire!ReadyEvent();
		}
	}
	else static if (config._mode == PinMode.input)
	{
		struct IsOnEvent
		{
			bool isOn;
		}

		bool isOnBlock()
		{
			const idr = periph.idr.load();
			enum mask = 1 << config._pin;
			return (idr & mask) != 0;
		}

		void isOn()
		{
			IsOnEvent event;
			event.isOn = isOnBlock();
			fire!IsOnEvent(event);
		}
	}
}