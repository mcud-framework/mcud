module mcud.core.system;

import mcud.core.flux;

import app;
import board;

private Board e_board;
//private App!e_board e_app;

void start()
{
	e_board.normal.configure();
	static __gshared app = App!e_board.start();
	FutureResult result;
	do
	{
		result = app.poll();
	}
	while (result != FutureResult.complete);
}