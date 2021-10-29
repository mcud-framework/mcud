// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.drivers.gpio.invert;

import mcud.drivers.gpio.mock;
import mcud.events;
import mcud.interfaces.gpio.input;
import mcud.interfaces.gpio.output;
import mcud.meta.like;
import mcud.test;

struct Invert(alias base)
if (isDigitalInput!base || isDigitalOutput!base)
{
static:
	struct StartedEvent {}
	struct StoppedEvent {}

	void start()
	{
		base.start();
		fire!StartedEvent();
	}

	void stop()
	{
		base.stop();
		fire!StoppedEvent();
	}

	static if (isDigitalInput!base)
	{
		struct IsOnEvent
		{
			bool isOn;
		}

		void isOn()
		{
			base.isOn();
		}

		@handler
		void onIsOnEvent(base.IsOnEvent event)
		{
			IsOnEvent newEvent;
			newEvent.isOn = !event.isOn;
			fire!IsOnEvent(newEvent);
		}

		static assert(assertLike!(DigitalInput, typeof(this)));
	}
	static if (isDigitalOutput!base)
	{
		alias ReadyEvent = base.ReadyEvent;

		void on()
		{
			base.off();
		}

		void off()
		{
			base.on();
		}

		static assert(assertLike!(DigitalOutput, typeof(this)));
	}
}

@("Invert inverts digital inputs")
unittest
{
	static DigitalIOMock mock;
	Invert!mock input;

	bool called = false;
	Events.addHandlers!(mock);
	Events.addHandlers!(input);
	Events.setHandler((input.IsOnEvent event)
	{
		expect(event.isOn).toEqual(true);
		called = true;
	});
	input.isOn();
	expect(called).toEqual(true);
}

@("Invert inverts digital outputs")
unittest
{
	static DigitalIOMock mock;
	Invert!mock output;

	expect(mock.isOnBlock).toEqual(false);
	output.off();
	expect(mock.isOnBlock).toEqual(true);
	output.on();
	expect(mock.isOnBlock).toEqual(false);
}