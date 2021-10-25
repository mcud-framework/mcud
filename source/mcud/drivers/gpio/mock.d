module mcud.drivers.gpio.mock;

import mcud.core.event;
import mcud.interfaces.gpio.input;
import mcud.meta.like;

/**
A mock digital input.
*/
struct DigitalInputMock
{
	private bool m_isOn;

	struct IsOnEvent
	{
		bool isOn;
	}

	void isOn()
	{
		const event = IsOnEvent(m_isOn);
		fire!IsOnEvent(event);
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

static assert(assertLike!(DigitalInput, DigitalInputMock));
