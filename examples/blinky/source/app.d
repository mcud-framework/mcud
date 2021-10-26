// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module app;

import mcud.core;

struct App
{
static:
	@task
	void loop()
	{
		system.board.led.on();
		system.board.led.off();
	}
}
