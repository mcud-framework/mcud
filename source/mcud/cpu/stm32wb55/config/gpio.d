module mcud.cpu.stm32wb55.config.gpio;

import mcud.core.attributes;
import mcud.core.result;
import mcud.cpu.stm32wb55.cpu;

struct PinConfig
{
	enum Port
	{
		unset, a, b, c, d, e, h
	}

	enum Mode : uint
	{
		unset = -1,
		input = 0b00,
		output = 0b01,
		alternate = 0b10,
		analog = 0b11,
	}

	Port _port = Port.unset;
	Mode _mode = Mode.unset;
	uint _pin = -1;

	PinConfig port(Port port)
	{
		_port = port;
		return this;
	}

	PinConfig pin(uint pin)
	{
		_pin = pin;
		return this;
	}

	PinConfig mode(Mode mode)
	{
		assert(_mode == Mode.unset, "Mode is already set");
		_mode = mode;
		return this;
	}

	PinConfig asOutput()
	{
		return mode(Mode.output);
	}

	PinConfig asInput()
	{
		return mode(Mode.input);
	}

	PinConfig asAnalog()
	{
		return mode(Mode.analog);
	}

	PinConfig asAlternateFunction()
	{
		return mode(Mode.alternate);
	}
}

template Pin(PinConfig config)
{
	import mcud.cpu.stm32wb55.periphs.rcc;

	static assert(config._port != PinConfig.Port.unset, "Port not set");
	static assert(config._pin != -1, "Pin not set");
	static assert(config._pin < 16, "Pin out of range");
	static assert(config._mode != PinConfig.Mode.unset, "Mode not set");

	static if (config._port == PinConfig.Port.a)
	{
		enum periph = cpu.gpioA;
		alias rcc = RCCPeriph!(RCCDevice.GPIOA);
	}
	else static if (config._port == PinConfig.Port.b)
	{
		enum periph = cpu.gpioB;
		alias rcc = RCCPeriph!(RCCDevice.GPIOB);
	}
	else
		static assert(false, "Invalid port");
	
	@forceinline
	Result!void start()
	{
		return rcc.start()
			.flatMap!({
				auto value = periph.moder.load();
				value &= ~((0b11) << (config._pin * 2)); 
				value |= (cast(uint) config._mode) << (config._pin * 2);
				periph.moder.store(value);
				return ok!void;
			});
	}

	@forceinline
	Result!void stop()
	{
		return rcc.stop();
	}

	static if (config._mode == PinConfig.Mode.output)
	{
		@forceinline
		Result!void on() nothrow
		{
			periph.bsrr.store(1 << config._pin);
			return ok!void();
		}

		@forceinline
		Result!void off() nothrow
		{
			periph.bsrr.store(0x0001_0000 << config._pin);
			return ok!void();
		}
	}
}