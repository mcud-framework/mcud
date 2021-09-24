module app;

import board : board;
import mcud.core;

template App()
{
	@task
	void loop()
	{
		board.led.on();
		board.led.off();
	}
}