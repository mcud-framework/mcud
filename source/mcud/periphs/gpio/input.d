// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.periphs.gpio.input;

import mcud.core.result;
import mcud.meta.like;

/**
A general purpose input.
*/
interface GPI
{
	/**
	Tests if the GPI is currently on.
	*/
	bool isOnSync();

	/**
	Tests if the GPI is currently on.
	*/
	void isOn();
}

alias isGPI = isLike!GPI;