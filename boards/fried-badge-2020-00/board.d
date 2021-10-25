module board;

import cpu.esp32;

template Board()
{
	alias cpu = ESP32!();
}

alias board = Board!();