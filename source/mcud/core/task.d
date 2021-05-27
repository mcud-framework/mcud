module mcud.core.task;

import mcud.core.attributes;

import std.traits;

struct Task
{
	void function() loop;
}

Task[] allTasks(alias T)()
{
	Task[] tasks;
	static foreach (child; getSymbolsByUDA!(T, task))
	{
		assert(isFunction!child);
		Task task;
		task.loop = &child;
		tasks ~= task;
	}
	return tasks;
}