module mcud.interfaces.gpio.output;

import mcud.meta.like;

/**
A digital output.
*/
interface DigitalOutput
{
	/**
	An event which gets fired when the output has been turned on or off.
	*/
	interface ReadyEvent
	{
	}

	/**
	Turns the output on.
	*/
	void on();

	/**
	Turns the output off.
	*/
	void off();
}

/**
Tests whether a type is a digital output or not.
*/
alias isDigitalOutput = isLike!DigitalOutput;