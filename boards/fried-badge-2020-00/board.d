module board;

import cpu.esp32;
import cpu.esp32;

struct Board()
{
	alias cpu = ESP32!();

	alias led = Pin!(PinConfig()
		.pin(13)
		.asOutput()
	);
}

alias board = Board!();