module mcud.core.task;

import mcud.core.attributes;

import std.traits;
import std.meta;

/**
Describes a task.
*/
struct Task
{
	/**
	The loop function of the task.
	*/
	void function() loop;
}

/**
Checks if the given type can have tasks.
*/
private template canContainTasks(alias T)
{
	enum canContainTasks = __traits(compiles, __traits(allMembers, T));
}

/**
Finds all tasks of a program.
Param:
	T = The type to find all tasks for.
Returns:
	An array of all tasks.
*/
Task[] allTasks(alias T)()
{
	static if (hasUDA!(T, task))
	{
		return [Task(&T)];
	}
	else static if (canContainTasks!T)
	{
		Task[] tasks;
		foreach (child; __traits(allMembers, T))
		{
			tasks ~= allTasks!(__traits(getMember, T, child));
		}
		return tasks;
	}
	else
	{
		return [];
	}
}

unittest
{
	template A()
	{
		@task
		static void loop() {}
	}

	alias a = A!();
	const taskA = Task(&a.loop);
	assert(allTasks!a == [taskA]);

	template B()
	{
		alias a = A!();
		@task
		static void loop() {}
	}

	alias b = B!();
	const taskA2 = Task(&b.a.loop);
	const taskB = Task(&b.loop);

	const tasks = allTasks!b;
	assert(tasks == [taskA2, taskB] || tasks == [taskB, taskA2]);
}

/**
Set to `true` if at least one tasks requested to be awake.
*/
private shared g_awake = false;

/**
Ensures tasks are awake.
*/
void wake()
{
	g_awake = true;
}

/**
Tests and clears the awake flag.
*/
bool testAndResetAwake()
{
	if (g_awake)
	{
		g_awake = false;
		return true;
	}
	else
		return false;
}