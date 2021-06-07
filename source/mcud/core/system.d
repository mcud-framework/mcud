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

	private template System()
	{
		public:
		/// The board support layer.
		alias board = Board!();
		/// The CPU used by the board.
		alias cpu = board.cpu;
		/// The user application.
		alias app = App!board;
	}

	/// Describes the program and board definition.
	alias system = System!();

	/**
	Starts the main scheduling loop.
	*/
	void start()
	{
		for (ubyte* bss = &_bss; bss < &_ebss; bss++)
			*bss = 0;
		
		system.board.init();
		//e_board.normal.configure();
		//static __gshared app = App!e_board.start();
		system.app.start();
		static foreach (setup; allSetup!system)
			setup.func();
		for (;;)
		{
			static foreach (task; allTasks!system)
				task.func();
		}
	}
}