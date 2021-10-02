// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module board;

import cpu.nrf5340;
import mcud.periphs.gpio.noop;

/**
An example definition for a u-blox Nora B1 evaluation kit.
*/
template Board()
{
	static NRF5340 cpu;

	static NoOpGPIO led;
}

/// The board.
alias board = Board!();