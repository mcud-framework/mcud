// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module board;

import cpu.atmega328p;
import cpu.periphs;

/**
An RGBDuino board.
*/
template Board()
{
	alias cpu = Atmega328P!();

	template Led()
	{
		void on() {}
		void off() {}
	}

	alias led = GPIOPin!(GPIOConfig()
		.asOutput()
		.port(Port.b)
		.pin(5)
	);
}

alias board = Board!();
