// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

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