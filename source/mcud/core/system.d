module mcud.core.system;

import mcud.core.task;
import std.traits;

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
		static assert(__traits(hasMember, board, "cpu"), "Board does not define a 'cpu'");
		/// The CPU used by the board.
		alias cpu = board.cpu;
		/// The user application.
		alias app = App!();
	}

	/// Describes the program and board definition.
	alias system = System!();

	/**
	Performs common MCUd initialisation functions and then enters the scheduler.
	This function should only ever be called by the reset handler.
	*/
	void start()
	{
		for (ubyte* bss = &_bss; bss < &_ebss; bss++)
			*bss = 0;

		static if (is(typeof(system.board.init)))
			system.board.init();
		static if (is(typeof(system.app.start)))
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
