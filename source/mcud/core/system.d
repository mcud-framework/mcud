module mcud.core.system;

import mcud.core.task;

version(unittest) {}
else
{
	import app;
	import board;

	private extern(C) __gshared
	{
		ubyte _bss;
		ubyte _ebss;
	}

	private alias a_board = Board!();
	private alias a_app = App!a_board;
	private enum tasks = allTasks!a_app;

	/**
	Starts the main scheduling loop.
	*/
	void start()
	{
		for (ubyte* bss = &_bss; bss < &_ebss; bss++)
			*bss = 0;
		
		a_board.init();
		//e_board.normal.configure();
		//static __gshared app = App!e_board.start();
		a_app.start();
		for (;;)
		{
			static foreach (task; tasks)
				task.loop();
		}
	}
}