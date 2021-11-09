// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module board;

import cpu.esp32;
import cpu.esp32;

struct Board()
{
	alias cpu = ESP32!();

	alias led = Pin!(PinConfig()
		.pin(13)
		.asOutput()
	);
}

alias board = Board!();