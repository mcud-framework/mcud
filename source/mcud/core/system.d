module mcud.core.system;

import app;
import board;

private enum Board e_board = Board();
private enum App!e_board e_app = App!e_board();

void start()
{
	e_board.normal.configure();
	e_app.main();
}