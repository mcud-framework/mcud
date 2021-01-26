module mcud.cpu.stm32wb55.configurer;

import mcud.cpu.stm32wb55.periphs;

/**
A set of all supported GPIOs.
*/
enum GPIO
{
	a = 0
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
	Enables GPIO port A.
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
		GPIOConfigurer configurer = GPIOConfigurer(_cpu, gpio);
		return configurer;
	}
}

/**
Configures a GPIO port.
*/
struct GPIOConfigurer
{
	private ConfiguredCPU* _cpu;
	private GPIO _port;

	/**
	Creates a new GPIO configurer.
	*/
	this(ConfiguredCPU* cpu, GPIO port)
	{
		_cpu = cpu;
		_port = port;
	}

	/**
	Configures a pin.
	*/
	PinConfigurer pin(int pin)
	{
		assert(pin >= 0 && pin < 16, "Invalid pin number");
		return PinConfigurer(_cpu, _port, pin);
	}
}

/**
Configures a GPIO pin.
*/
struct PinConfigurer
{
	private ConfiguredCPU* _cpu;
	private GPIO _port;
	private int _pin;

	/**
	Creates a new pin configurer.
	*/
	this(ConfiguredCPU* cpu, GPIO port, int pin)
	{
		_cpu = cpu;
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
	uint rcc_ahb2enr_masks = 0;
	uint rcc_ahb2enr_value = 0;
	uint[7] gpio_moder_masks = 0;
	uint[7] gpio_moder_value = 0;
}

/**
Uses conditional compilation to bring the CPU into the configured state.
*/
private struct FinalConfiguredCPU(ConfiguredCPU c)
{
	void configure() pure const
	{
		static if (c.rcc_ahb2enr_masks != 0)
		{
			rcc.ahb2enr.store((rcc.ahb2enr.load() & ~c.rcc_ahb2enr_masks) | c.rcc_ahb2enr_value);
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
	
	assert(configured.gpio_moder_value[0] == 0x0000_0000);
	assert(configured.rcc_ahb2enr_enable == 1);
}