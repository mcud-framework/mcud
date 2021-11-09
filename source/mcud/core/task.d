// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.core.task;

import mcud.core.attributes;
import mcud.meta;
import mcud.test;

/**
Describes the states of a task.
*/
enum TaskState
{
	/// Marks the task as started.
	started,
	/// Marks the task as stopped.
	stopped,
	/// Marks the task as a task which cannot be stopped.
	unstoppable
}

/**
Declares a function to be a task.
*/
struct task
{
	/// The state of the task.
	TaskState state = TaskState.started;
}

alias Task = Function!task;
alias Setup = Function!setup;

/**
Gets all tasks.
*/
Task[] allTasks(alias T)()
{
	return allFunctions!(task, T);
}

/**
Gets all setups.
*/
Setup[] allSetup(alias T)()
{
	return allFunctions!(setup, T);
}

/**
Keeps track of some runtime information of a task.
*/
template TaskRuntime(string mangledName)
{
	/// Whether or not the task is running.
	static shared bool running = true;
}

@("allTasks finds task in template")
unittest
{
	template A()
	{
		@task
		static void loop() {}
	}

	alias a = A!();
	const tasks = allTasks!a;
	assert(tasks.length > 0);
	assert(tasks[0].attribute == task());
	assert(tasks[0].func == &a.loop);
}

@("allTask finds tasks recursively")
unittest
{
	template A()
	{
		@task static void loop() {}
	}

	template B()
	{
		alias a = A!();
		@task
		static void loop() {}
	}

	alias b = B!();
	const taskA2 = Task(task(), &b.a.loop);
	const taskB = Task(task(), &b.loop);

	const tasks2 = allTasks!b;
	assert(tasks2[0].attribute == task());
	assert(tasks2[1].attribute == task());
	assert(tasks2[0].func == &b.a.loop);
	assert(tasks2[1].func == &b.loop);
}

@("allSetup finds setup functions recursively")
unittest
{
	template A()
	{
		@setup static void onSetup() {}
	}

	alias a = A!();
	const setups = allSetup!a;
	expect(setups.length).toEqual(1);
	assert(setups[0].attribute == setup());
	assert(setups[0].func == &a.onSetup);
}
