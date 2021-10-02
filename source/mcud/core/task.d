// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.core.task;

import mcud.core.attributes;
import mcud.meta;

alias Task = Function!task;
alias Setup = Function!setup;

Task[] allTasks(alias T)()
{
	return allFunctions!(task, T);
}

Setup[] allSetup(alias T)()
{
	return allFunctions!(setup, T);
}

unittest
{
	template A()
	{
		@task
		static void loop() {}
	}

	alias a = A!();
	const taskA = Task(task(), &a.loop);
	assert(allTasks!a == [taskA]);

	template B()
	{
		alias a = A!();
		@task
		static void loop() {}
	}

	alias b = B!();
	const taskA2 = Task(task(), &b.a.loop);
	const taskB = Task(task(), &b.loop);

	const tasks = allTasks!b;
	assert(tasks == [taskA2, taskB] || tasks == [taskB, taskA2]);
}
