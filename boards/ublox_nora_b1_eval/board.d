// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module board;

import cpu.nrf5340;
import mcud.drivers.gpio.invert;

/**
An example definition for a u-blox Nora B1 evaluation kit.
*/
struct Board
{
static:
	enum cpu = NRF5340();

	static Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(28)
		.asOutput()
	) led1;
	alias led = led1;

	static Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(29)
		.asOutput()
	) led2;

	static Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(30)
		.asOutput()
	) led3;

	static Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(31)
		.asOutput()
	) led4;

	static Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(23)
		.asInput()
		.withPullUp()
	) button1_raw;

	static Invert!button1_raw button1;

	static Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(24)
		.asInput()
		.withPullUp()
	) button2_raw;

	static Invert!button2_raw button2;

	static Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(8)
		.asInput()
		.withPullUp()
	) button3_raw;

	static Invert!button3_raw button3;

	static Pin!(
		PinConfig()
		.port(Port.p0)
		.pin(9)
		.asInput()
		.withPullUp()
	) button4_raw;

	static Invert!button4_raw button4;

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
