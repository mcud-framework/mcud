module mcud.cpu.stm32wb55.configurer;

import mcud.core.attributes;
import mcud.cpu.stm32wb55.periphs;

/**
A set of all supported GPIOs.
*/
enum GPIO
{
	a = 0,
	// b,
	// c,
	// d,
	// e,
	// f,
	// h,
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
			_cpu.rcc_ahb2enr_masks |= 1;
			_cpu.rcc_ahb2enr_value |= 1;
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
		_cpu.gpio_moder_masks[_port] = 0b11 << (_pin * 2);
		_cpu.gpio_moder_value[_port] = 0b01 << (_pin * 2);
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

		cpu.rcc_apb1enr_masks |= 1;
		cpu.rcc_apb1enr_value |= 1;
		cpu.tim2_cr1_masks |= 1;
		cpu.tim2_cr1_value |= 1;
	}

	/**
	Sets the auto reload value of the timer.
	*/
	Timer2Configurer autoReload(uint value)
	{
		_cpu.tim2_arr_masks |= 0xFFFF_FFFF;
		_cpu.tim2_arr_value = value;
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
	static string register(string name)()
	{
		return "uint " ~ name ~ "_value; uint " ~ name ~ "_masks;";
	}

	mixin(register!"rcc_ahb2enr");
	mixin(register!"rcc_apb1enr");
	mixin(register!"tim2_cr1");
	mixin(register!"tim2_cr2");
	mixin(register!"tim2_arr");
	mixin(register!"tim2_ccr1");
	mixin(register!"tim2_ccr2");
	mixin(register!"tim2_ccr3");
	mixin(register!"tim2_ccr4");

	uint[7] gpio_moder_masks = 0;
	uint[7] gpio_moder_value = 0;
}

string[] split(string str, char delimiter)
{
	string[] parts;
	string part;
	foreach (chr; str)
	{
		if (chr == delimiter)
		{
			parts ~= part;
			part = "";
		}
		else
			part ~= chr;
	}
	return parts ~ part;
}

/**
Uses conditional compilation to bring the CPU into the configured state.
*/
private struct FinalConfiguredCPU(ConfiguredCPU c)
{
	private static string applyRegister(string peripheral, string register)()
	{
		enum p = peripheral;
		enum r = register;
		return "static if (c."~p~"_"~r~"_masks != 0)"
		     ~ "{"
		     ~ "    "~p~"."~r~".store(("~p~"."~r~".load() & ~c."~p~"_"~r~"_masks) | c."~p~"_"~r~"_value);"
			 ~ "}";
	}

	private static string autoApplyRegister(string member)()
	{
		static if (is(typeof(__traits(getMember, c, member)) == uint))
		{
			enum string[] parts = member.split('_');
			static if (parts.length == 3u)
				return applyRegister!(parts[0], parts[1]);
			else
				return "";
		}
		else
			return "";
	}

	@forceinline
	static void configure() pure
	{
		static foreach (member; __traits(allMembers, ConfiguredCPU))
		{
			import std.algorithm.searching : endsWith;
			static if (member.endsWith("_value"))
			{
				pragma(msg, "Configuring " ~ member);
				mixin(autoApplyRegister!(member));
			}
		}

		static foreach (i; 0 .. ConfiguredCPU.gpio_moder_value.length)
		{
			static if (c.gpio_moder_masks[i] != 0)
			{
				gpio.moder.store((gpio.moder.load() & ~c.gpio_moder_masks[i]) | c.gpio_moder_value[i]);
			}
		}
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
	
	assert(configured.gpio_moder_masks[0] == 0x0000_0300);
	assert(configured.gpio_moder_value[0] == 0x0000_0100);
	assert(configured.rcc_ahb2enr_masks == 1);
	assert(configured.rcc_ahb2enr_value == 1);
}