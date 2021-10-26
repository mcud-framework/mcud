// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.interfaces.gpio.input;

import mcud.interfaces.startable;
import mcud.meta.like;

/**
A digital input.
*/
interface DigitalInput : Startable
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