module mcud.cpu.stm32wb55.config.configurer;

import mcud.core.attributes;
import mcud.cpu.stm32wb55.cpu;
import mcud.cpu.stm32wb55.periphs.rcc;
import mcud.mem.volatile;

import std.traits;

/**
A set of all supported GPIOs.
*/
enum GPIO
{
	a, b, c,
	d, e, h
}

/**
A set of all supported timers.
*/
enum Timer
{
	// tim1,
	tim2,
	// tim16,
	// tim17,
	// lptim,
	// irtim,
}

private auto getGPIO(GPIO gpio)()
{
	static if (gpio == GPIO.a)
		return cpu.gpioA;
	else static if (gpio == GPIO.b)
		return cpu.gpioB;
	else static if (gpio == GPIO.c)
		return cpu.gpioC;
	else static if (gpio == GPIO.d)
		return cpu.gpioD;
	else static if (gpio == GPIO.e)
		return cpu.gpioE;
	else static if (gpio == GPIO.h)
		return cpu.gpioH;
}

/**
Configures a CPU.
*/
struct CPUConfigurer
{
	private ConfiguredCPU* _cpu;

	/**
	Creates a new CPU configurer.
	*/
	this(ConfiguredCPU* cpu)
	{
		_cpu = cpu;
	}

	/// Disabled.
	this() @disable;

	/**
	Enables a GPIO port.
	*/
	GPIOConfigurer enableGPIO(GPIO gpio)
	{
		final switch (gpio)
		{
		case GPIO.a:
			_cpu.rcc_ahb2enr.set(RCC_AHB2ENR.GPIOAEN, 1);
			break;
		case GPIO.b:
			_cpu.rcc_ahb2enr.set(RCC_AHB2ENR.GPIOBEN, 1);
			break;
		case GPIO.c:
			_cpu.rcc_ahb2enr.set(RCC_AHB2ENR.GPIOCEN, 1);
			break;
		case GPIO.d:
			_cpu.rcc_ahb2enr.set(RCC_AHB2ENR.GPIODEN, 1);
			break;
		case GPIO.e:
			_cpu.rcc_ahb2enr.set(RCC_AHB2ENR.GPIOEEN, 1);
			break;
		case GPIO.h:
			_cpu.rcc_ahb2enr.set(RCC_AHB2ENR.GPIOHEN, 1);
			break;
		}
		GPIOConfigurer configurer = GPIOConfigurer(_cpu, this, gpio);
		return configurer;
	}

	/**
	Enables a timer.
	*/
	Timer2Configurer enableTimer2()
	{
		Timer2Configurer configurer = Timer2Configurer(_cpu, this);
		return configurer;
	}
}

/**
Configures a GPIO port.
*/
struct GPIOConfigurer
{
	private ConfiguredCPU* _cpu;
	private CPUConfigurer _parent;
	private GPIO _port;

	/**
	Creates a new GPIO configurer.
	*/
	this(ConfiguredCPU* cpu, CPUConfigurer parent, GPIO port)
	{
		_cpu = cpu;
		_parent = parent;
		_port = port;
	}

	/**
	Configures a pin.
	*/
	PinConfigurer pin(int pin)
	{
		assert(pin >= 0 && pin < 16, "Invalid pin number");
		return PinConfigurer(_cpu, this, _port, pin);
	}

	/**
	Continue configurer the parent.
	*/
	CPUConfigurer and()
	{
		return _parent;
	}
}

/**
Configures a GPIO pin.
*/
struct PinConfigurer
{
	private ConfiguredCPU* _cpu;
	private GPIOConfigurer _parent;
	private GPIO _port;
	private int _pin;

	/**
	Creates a new pin configurer.
	*/
	this(ConfiguredCPU* cpu, GPIOConfigurer parent, GPIO port, int pin)
	{
		_cpu = cpu;
		_parent = parent;
		_port = port;
		_pin = pin;
	}

	/**
	Configures the pin as an output.
	*/
	PinConfigurer asOutput()
	{
		final switch (_port)
		{
		case GPIO.a:
			_cpu.gpioA_moder.set(0b11 << (_pin * 2), 0b01 << (_pin * 2));
			break;
		case GPIO.b:
			_cpu.gpioB_moder.set(0b11 << (_pin * 2), 0b01 << (_pin * 2));
			break;
		case GPIO.c:
			_cpu.gpioC_moder.set(0b11 << (_pin * 2), 0b01 << (_pin * 2));
			break;
		case GPIO.d:
			_cpu.gpioD_moder.set(0b11 << (_pin * 2), 0b01 << (_pin * 2));
			break;
		case GPIO.e:
			_cpu.gpioE_moder.set(0b11 << (_pin * 2), 0b01 << (_pin * 2));
			break;
		case GPIO.h:
			_cpu.gpioH_moder.set(0b11 << (_pin * 2), 0b01 << (_pin * 2));
			break;
		}
		_cpu.markPinAsOutput(_port, _pin);
		return this;
	}

	/**
	Continue configurer the parent.
	*/
	GPIOConfigurer and()
	{
		return _parent;
	}
}

/**
Configures timer 2.
*/
struct Timer2Configurer
{
	private ConfiguredCPU* _cpu;
	private CPUConfigurer _parent;

	/**
	Creates a new pin configurer.
	*/
	this(ConfiguredCPU* cpu, CPUConfigurer parent)
	{
		_cpu = cpu;
		_parent = parent;

		cpu.rcc_apb1enr1.set(1, 1);
		//cpu.tim2_cr1_masks |= 1;
		//cpu.tim2_cr1_value |= 1;
	}

	/**
	Sets the auto reload value of the timer.
	*/
	Timer2Configurer autoReload(uint value)
	{
		//_cpu.tim2_arr_masks |= 0xFFFF_FFFF;
		//_cpu.tim2_arr_value = value;
		return this;
	}
}

/**
Configures the required state of the microcontroller, at compile-time!
*/
auto configureCPU(void function(CPUConfigurer) options)()
{
	return FinalConfiguredCPU!(buildConfiguredCPU(options))();
}

/**
Creates a ConfiguredCPU struct.
*/
private ConfiguredCPU buildConfiguredCPU(void function(CPUConfigurer) options)
{
	ConfiguredCPU cpu;
	CPUConfigurer configurer = CPUConfigurer(&cpu);
	options(configurer);
	return cpu;
}

/**
Contains all settings of a fully configured CPU.
*/
private struct ConfiguredCPU
{
	bool[5][16] inputPins;
	bool[5][16] outputPins;

	void markPinAsInput(GPIO port, int pin)
	{
		inputPins[port][pin] = true;
	}

	void markPinAsOutput(GPIO port, int pin)
	{
		outputPins[port][pin] = true;
	}

	bool isPinInput(GPIO port, int pin)
	{
		return inputPins[port][pin];
	}

	bool isPinOutput(GPIO port, int pin)
	{
		return outputPins[port][pin];
	}

	struct Value
	{
		uint mask;
		uint value;

		void set(uint mask, uint value)
		{
			this.mask |= mask;
			this.value = (this.value & ~mask) | value;
		}
	}

	static string[] getRegisters(T)(string prefix = "")
	{
		string[] values = [];
		static foreach (member; FieldNameTuple!T)
		{
			static if (isVolatile!(__traits(getMember, T, member)))
			{
				values ~= prefix ~ member;
			}
			else
			{
				values ~= getRegisters!(typeof(__traits(getMember, T, member)))(prefix ~ member ~ "_");
			}
		}
		return values;
	}

	static string generateValues(T)()
	{
		string variables;
		static foreach (register; getRegisters!T)
		{
			variables ~= "Value " ~ register ~ ";";
		}
		return variables;
	}

	mixin(generateValues!CPU);
}

/**
Uses conditional compilation to bring the CPU into the configured state.
*/
private struct FinalConfiguredCPU(ConfiguredCPU c)
{
	private static string getPart(string reg, int index)
	{
		foreach (size_t i, char c; reg)
		{
			if (c == '_')
			{
				if (index == 0)
					return reg[0 .. i];
				else
					return reg[i + 1 .. $];
			}
		}
		assert(0, "No '_' found in string '" ~ reg ~ "'");
	}

	private static string applyRegister(string name)()
	{
		enum p = getPart(name, 0);
		enum r = getPart(name, 1);
		return "static if (c."~p~"_"~r~".mask != 0)"
		     ~ "{"
		     ~ "    cpu."~p~"."~r~".store((cpu."~p~"."~r~".load() & ~c."~p~"_"~r~".mask) | c."~p~"_"~r~".value);"
			 ~ "}";
		return "";
	}

	@forceinline
	static void configure() pure
	{
		static foreach (member; FieldNameTuple!ConfiguredCPU)
		{
			import std.algorithm.searching : endsWith;
			static if (isAggregateType!(typeof(__traits(getMember, ConfiguredCPU, member))))
			{
				mixin(applyRegister!(member));
			}
		}
	}

	static auto getInput(GPIO port, uint pin)()
	{
		assert(c.isPinInput(port, pin), "The desired pin is not configured as an input");
		auto gpio = getPort!port;
	}

	static auto getOutput(GPIO port, uint pin)()
	{
		import mcud.cpu.stm32wb55.periphs.gpio : OutputPin;
		assert(c.isPinOutput(port, pin), "The desired pin is not configured as an output");
		enum gpio = getGPIO!port;
		return OutputPin!(gpio, pin)();
	}
}

unittest
{
	auto configured = buildConfiguredCPU((options)
	{
		options
			.enableGPIO(GPIO.a)
			.pin(4)
				.asOutput();
	});
	
	assert(configured.gpioA_moder.mask == 0x0000_0300);
	assert(configured.gpioA_moder.value == 0x0000_0100);
	assert(configured.rcc_ahb2enr.mask == 1);
	assert(configured.rcc_ahb2enr.value == 1);
}