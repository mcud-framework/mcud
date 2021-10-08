// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.periphs.gpio.output;

import mcud.core.result;
import mcud.meta.like;

/**
Describes a general purpose output.
*/
interface GPO
{
	/**
	Turns the GPO on.
	*/
	void on();

	/**
	Turns the GPO off.
	*/
	void off();
}

alias isGPO = isLike!GPO;