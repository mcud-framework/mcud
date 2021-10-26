module mcud.drivers.gpio.mock;

import mcud.events;
import mcud.interfaces.gpio.input;
import mcud.interfaces.gpio.output;
import mcud.meta.like;
import mcud.test;
import mcud.core.system;

/**
A mock digital input.
*/
struct DigitalIOMock
{
	private bool m_isOn = false;

	struct IsOnEvent
	{
		bool isOn;
	}

	struct ReadyEvent
	{
	}

	void isOn()
	{
		IsOnEvent event;
		event.isOn = m_isOn;
		fire!IsOnEvent(event);
	}

	bool isOnBlock()
	{
		return m_isOn;
	}

	void on()
	{
		m_isOn = true;
	}

	void off()
	{
		m_isOn = false;
	}
}

static assert(assertLike!(DigitalInput, DigitalIOMock));
static assert(assertLike!(DigitalOutput, DigitalIOMock));

@("DigitalIOMock#isOn fires events")
unittest
{
	DigitalIOMock mock;

	bool called = false;
	Events.addHandlers!(mock);
	Events.addHandler((DigitalIOMock.IsOnEvent event)
	{
		called = true;
		expect(event.isOn).toEqual(false);
	});
	mock.isOn();
	expect(called).toEqual(true);
}