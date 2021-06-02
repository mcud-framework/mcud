module mcud.core.system;

import mcud.core.task;

private __gshared Board e_board;
private alias a_app = App!Board;
private enum tasks = allTasks!a_app;

version(unittest) {}
else
{
	import app;
	import board;

	private void sleep()
	{
		asm { "wfi"; }
	}

	private extern(C) __gshared
	{
		ubyte _bss;
		ubyte _ebss;
	}

	/**
	Starts the main scheduling loop.
	*/
	void start()
	{
		for (ubyte* bss = &_bss; bss < &_ebss; bss++)
			*bss = 0;
			
		//e_board.normal.configure();
		//static __gshared app = App!e_board.start();
		a_app.start();
		for (;;)
		{
			static foreach (task; tasks)
				task.loop();
			if (!testAndResetAwake())
				sleep();
		}
	}
}