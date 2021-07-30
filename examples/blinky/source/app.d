module app;

import mcud.core;

template App(alias board)
{
	@task
	void loop()
	{
		board.led.on();
		board.led.off();
	}
}