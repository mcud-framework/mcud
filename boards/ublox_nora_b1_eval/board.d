// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module board;

import cpu.nrf5340;
import mcud.drivers.gpio.invert;

/**
An example definition for a u-blox Nora B1 evaluation kit.
*/
struct Board()
{
static:
	alias cpu = NRF5340!();

	alias led1 = Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(28)
		.asOutput()
	);
	alias led = led1;

	alias led2 = Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(29)
		.asOutput()
	);

	alias led3 = Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(30)
		.asOutput()
	);

	alias led4 = Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(31)
		.asOutput()
	);

	alias button1_raw = Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(23)
		.asInput()
		.withPullUp()
	);
	alias button1 = Invert!button1_raw;

	alias button2_raw = Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(24)
		.asInput()
		.withPullUp()
	);
	alias button2 = Invert!button2_raw;

	alias button3_raw = Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(8)
		.asInput()
		.withPullUp()
	);

	alias button3 = Invert!button3_raw;

	alias button4_raw = Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(9)
		.asInput()
		.withPullUp()
	);

	alias button4 = Invert!button4_raw;

	version(CORE_application) void init()
	{
		led1.start();
		led2.start();
		led3.start();
		led4.start();

		led1.on();
		led2.on();
		led3.on();
		led4.on();

		button1.start();
		button2.start();
		button3.start();
		button4.start();
	}
}

/// The board.
alias board = Board!();