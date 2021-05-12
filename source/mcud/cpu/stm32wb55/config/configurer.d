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
			_cpu.rcc_ahb2enr.set(RCC_AHB2ENR.GPIOAEN);
			break;
		case GPIO.b:
			_cpu.rcc_ahb2enr.set(RCC_AHB2ENR.GPIOBEN);
			break;
		case GPIO.c:
			_cpu.rcc_ahb2enr.set(RCC_AHB2ENR.GPIOCEN);
			break;
		case GPIO.d:
			_cpu.rcc_ahb2enr.set(RCC_AHB2ENR.GPIODEN);
			break;
		case GPIO.e:
			_cpu.rcc_ahb2enr.set(RCC_AHB2ENR.GPIOEEN);
			break;
		case GPIO.h:
			_cpu.rcc_ahb2enr.set(RCC_AHB2ENR.GPIOHEN);
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

	ref getRegister(string register)()
	{
		final switch (_port)
		{
		case GPIO.a:
			return mixin("_cpu.gpioA_" ~ register);
		case GPIO.b:
			return mixin("_cpu.gpioB_" ~ register);
		case GPIO.c:
			return mixin("_cpu.gpioC_" ~ register);
		case GPIO.d:
			return mixin("_cpu.gpioD_" ~ register);
		case GPIO.e:
			return mixin("_cpu.gpioE_" ~ register);
		case GPIO.h:
			return mixin("_cpu.gpioH_" ~ register);
		}
	}

	/**
	Sets the value of the MODER register for this pin.
	*/
	PinConfigurer setMode(uint mode)
	{
		assert(mode <= 0b11, "Invalid value for mode register");
		getRegister!"moder".set(0b11 << (_pin * 2), mode << (_pin * 2));
		return this;
	}

	/**
	Configures the pin as an output.
	*/
	PinConfigurer asOutput()
	{
		setMode(0b01);
		_cpu.markPinAsOutput(_port, _pin);
		return this;
	}

	/**
	Configures the pin as an input pin.
	*/
	PinConfigurer asInput()
	{
		setMode(0b00);
		_cpu.markPinAsInput(_port, _pin);
		return this;
	}

	/**
	Sets the value of the PUPDR register for this pin.
	*/
	PinConfigurer setPupdr(uint mode)
	{
		assert(mode <= 0b11, "Invalid value for mode register");
		getRegister!"pupdr".set(0b11 << (_pin * 2), mode << (_pin * 2));
		return this;
	}

	/**
	Enables pull-up resistors on the pin.
	*/
	PinConfigurer asPullUp()
	{
		setPupdr(0b01);
		return this;
	}

	/**
	Enables pull-down resistors on the pin.
	*/
	PinConfigurer asPullDown()
	{
		setPupdr(0b10);
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
	bool[16][5] inputPins;
	bool[16][5] outputPins;

	void markPinAsInput(GPIO port, int pin)
	{
		inputPins[port][pin] = true;
	}

	void markPinAsOutput(GPIO port, int pin)
	{
		outputPins[port][pin] = true;
	}

	bool isPinInput(GPIO port, int pin) nothrow
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

		void set(uint mask)
		{
			set(mask, mask);
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

	static auto getInput(GPIO port, uint pin)() nothrow
	{
		import mcud.cpu.stm32wb55.periphs.gpio : InputPin;
		assert(c.isPinInput(port, pin), "The desired pin is not configured as an input");
		enum gpio = getGPIO!port;
		return InputPin!(gpio, pin)();
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
	auto configured = buildConfiguredCPU((CPUConfigurer options)
	{
		options
			.enableGPIO(GPIO.a)
				.pin(4)
					.asOutput()
					.and();
	});
	
	assert(configured.gpioA_moder.mask == 0x0000_0300);
	assert(configured.gpioA_moder.value == 0x0000_0100);
	assert(configured.rcc_ahb2enr.mask == 1);
	assert(configured.rcc_ahb2enr.value == 1);
}