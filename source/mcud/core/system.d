// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.core.system;

import core.stdc.string;
import gcc.attributes;
import mcud.core.attributes;
import mcud.core.task;
import std.traits;

//version(unittest) {}
//else
//{
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

	private auto filter(alias callback, T)(T[] values)
	{
		T[] result;
		foreach (value; values)
		{
			if (callback(value))
				result ~= value;
		}
		return result;
	}

	private bool[] getInitialTaskStates(T)(T tasks)
	{
		bool[] states;
		foreach (task; tasks)
		{
			if (task.attribute.state == TaskState.started)
				states ~= true;
			else
				states ~= false;
		}
		return states;
	}

	private enum tasks = allTasks!system;
	private enum stoppableTasks = tasks
		.filter!(task => task.attribute.state != TaskState.unstoppable);
	private enum unstoppableTasks = tasks
		.filter!(task => task.attribute.state == TaskState.unstoppable);

	/**
	Performs common MCUd initialisation functions and then enters the scheduler.
	This function should only ever be called by the reset handler.
	*/
	void startMCUd()
	{
		version(unittest)
		{
			assert(0, "startMCUd is not supported during unit tests");
		}
		else
		{
			memset(&__start_bss, 0, &__stop_bss - &__start_bss);
			memcpy(&__start_data, &__stop_text, &__stop_data - &__start_data);

			static if (is(typeof(system.board.init)))
				system.board.init();
			static foreach (setup; allSetup!system)
				setup.func();
			for (;;)
			{
				static foreach (task; unstoppableTasks)
				{
					task.func();
				}
				static foreach (task; stoppableTasks)
				{{
					enum mangled = task.mangled;
					if (TaskRuntime!(mangled).running == true)
						task.func();
				}}
			}
		}
	}

	private size_t findStoppableTask(alias task)()
	{
		size_t index = -1;
		foreach (i, stoppableTask; stoppableTasks)
		{
			if (stoppableTask.func == &task)
			{
				assert(index == -1, "Multiple tasks found");
				index = i;
			}
		}
		assert(index != -1, "No task found. Perhaps the function given was not " ~
			"marked with @task or was marked with @task(TaskState.unstoppable)?");
		return index;
	}

	/**
	Starts a task.
	Params:
		task = The task to start.
	*/
	void startTask(alias task)()
	{
		TaskRuntime!(task.mangleof).running = true;
	}

	/**
	Stops a task.
	Params:
		task = The task to stop.
	*/
	void stopTask(alias task)()
	{
		TaskRuntime!(task.mangleof).running = false;
	}
//}
