// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.core.system;

import core.stdc.string;
import gcc.attributes;
import mcud.core.task;
import std.traits;

version(unittest) {}
else
{
	import app;
	import board;

	private extern extern(C) __gshared
	{
		@attribute("section", ".bss")
		ubyte __start_bss;
		@attribute("section", ".bss")
		ubyte __stop_bss;

		@attribute("section", ".data")
		ubyte __start_data;
		@attribute("section", ".data")
		ubyte __stop_data;

		@attribute("section", ".text")
		ubyte __start_text;
		@attribute("section", ".text")
		ubyte __stop_text;
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
		memset(&__start_bss, 0, &__stop_bss - &__start_bss);
		memcpy(&__start_data, &__stop_text, &__stop_data - &__start_data);

		static if (is(typeof(system.board.init)))
			system.board.init();
		static foreach (setup; allSetup!system)
			setup.func();
		for (;;)
		{
			static foreach (task; allTasks!system)
				task.func();
		}
	}
}
