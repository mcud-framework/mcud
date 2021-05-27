module mcud.core.system;

import mcud.core.task;

import app;
import board;

private __gshared Board e_board;
private alias a_app = App!Board;
private enum tasks = allTasks!a_app;

void start()
{
	e_board.normal.configure();
	//static __gshared app = App!e_board.start();
	for (;;)
	{
		static foreach (task; tasks)
			task.loop();
	}
}