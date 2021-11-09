// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module app;

import board : board;
import mcud.core;

template App()
{
	@setup
	void onSetup()
	{
		board.led.start();
	}

	@task
	void loop()
	{
		board.led.on();
		board.led.off();
	}
}
