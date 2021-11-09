// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module cpu.esp32.periphs.gpio;

import idf.driver.gpio;
import mcud.events;
import mcud.interfaces.gpio;
import mcud.meta;

enum Direction
{
	unset,
	input,
	output,
}

/**
Configures a pin.
*/
struct PinConfig
{
	/// The selected pin.
	int m_pin = -1;
	/// The direction of the pin.
	Direction m_direction = Direction.unset;

	/**
	Selects the pin to configure.
	Params:
		pin = The pin to configure.
	*/
	PinConfig pin(int pin)
	{
		m_pin = pin;
		return this;
	}

	/**
	Sets the direction of the pin.
	Params:
		direction = The direction of the pin.
	*/
	PinConfig direction(Direction direction)
	{
		assert(m_direction == Direction.unset, "Direction was already set");
		m_direction = direction;
		return this;
	}

	/**
	Marks the pin as an output.
	*/
	PinConfig asOutput()
	{
		return direction(Direction.output);
	}

	/**
	Marks the pin as an input.
	*/
	PinConfig asInput()
	{
		return direction(Direction.input);
	}
}

/**
Manages a pin.
*/
struct Pin(PinConfig config)
{
static:
	static assert(config.m_pin >= 0 && config.m_pin < gpio_num_t.GPIO_NUM_MAX, "Invalid pin selected");
	static assert(config.m_direction != Direction.unset, "No pin direction was set");

	enum gpio_num_t m_pinNum = {return cast(gpio_num_t) config.m_pin;} ();

	static if (config.m_direction == Direction.input)
	{
		static assert(assertLike!(DigitalInput, typeof(this)));
	}
	else static if (config.m_direction == Direction.output)
	{
		struct ReadyEvent {}
		struct StartedEvent {}
		struct StoppedEvent {}

		void on()
		{
			gpio_set_level(m_pinNum, 1);
			fire!ReadyEvent();
		}

		void off()
		{
			gpio_set_level(m_pinNum, 0);
			fire!ReadyEvent();
		}

		void start()
		{
			gpio_reset_pin(m_pinNum);
			gpio_set_direction(m_pinNum, gpio_mode_t.GPIO_MODE_OUTPUT);
			fire!StartedEvent();
		}

		void stop()
		{
			gpio_reset_pin(m_pinNum);
			fire!StoppedEvent();
		}

		static assert(assertLike!(DigitalOutput, typeof(this)));
	}
	else
		static assert(false, "Unsupported pin direction");
}
