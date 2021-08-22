module board;

import mcud.cpu.esp8266.cpu;

template FakeGPIO()
{
	void on() {}
	void off() {}
}

/**
ESP8266mod doitam board.
*/
template Board()
{
	alias cpu = ESP8266!();

	alias led = FakeGPIO!();
}