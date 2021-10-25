module mcud.interfaces.gpio.input;

import mcud.meta.like;

/**
A digital input.
*/
interface DigitalInput
{
	/**
	An event which detects whether an input is on or off.
	*/
	interface IsOnEvent
	{
		/**
		Returns: `true` if the input is on, `false` if the input is off.
		*/
		@property
		bool isOn();
	}

	/**
	Tests whether the input is on or off.
	The result is received in an `IsOnEvent` packet.
	*/
	void isOn();
}

/**
Tests whether a type is a digital input or not.
*/
alias isDigitalInput = isLike!DigitalInput;