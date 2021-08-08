module board;

import mcud.cpu.atmega328p;

template Board()
{
	alias cpu = Atmega328P!();

	template Led()
	{
		void on() {}
		void off() {}
	}

	alias led = GPIOPin!(GPIOConfig()
		.asOutput()
		.port(Port.b)
		.pin(5)
	);
}
