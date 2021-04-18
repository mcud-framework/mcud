module mcud.core.system;

import app;
import board;

private enum Board e_board = Board();
private enum App!board e_app = App!board();

void start()
{
	e_app.main();
}