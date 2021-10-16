// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module cpu.stm32.capabilities;

struct PortMask
{
	/// A bitmask of available pins on port A.
	uint gpioA = 0;
	/// A bitmask of available pins on port B.
	uint gpioB = 0;
	/// A bitmask of available pins on port C.
	uint gpioC = 0;
	/// A bitmask of available pins on port D.
	uint gpioD = 0;
	/// A bitmask of available pins on port E.
	uint gpioE = 0;
	/// A bitmask of available pins on port F.
	uint gpioF = 0;
	/// A bitmask of available pins on port G.
	uint gpioG = 0;
	/// A bitmask of available pins on port H.
	uint gpioH = 0;
	/// A bitmask of available pins on port I.
	uint gpioI = 0;
}

/**
Set of valid ports.
*/
enum GPIOPort
{
	unset,
	a = 'a',
	b = 'b',
	c = 'c',
	d = 'd',
	e = 'e',
	f = 'f',
	g = 'g',
	h = 'h',
	i = 'i'
}

/**
A set of all alternative functions.
*/
enum AlternateFunction
{
	/*
	can1,
	can2,
	comp1,
	comp2,
	dcmi,
	dfsdm,
	evenout,
	fmc,
	i2c1,
	i2c2,
	i2c3,
	i2c4,
	lcd,
	lptim2,
	lpuart1,
	otg_fs,
	quadspi,
	sai1,
	sai2,
	sdmmc,
	spi1,
	spi2,
	spi3,
	swpmi1,
	sysAf,
	tim1,
	tim15,
	tim16,
	tim17,
	tim2,
	tim3,
	tim4,
	tim5,
	tim8,
	tsc,
	uart4,
	uart5,
	unset,
	usart1,
	usart2,
	usart3,*/
	DCMI_D0,
	DCMI_D1,
	DCMI_PIXCLK,
	I2C1_SMBA,
	I2C3_SCL,
	I2C4_SMBA,
	IR_OUT,
	JTCK_SWCLK,
	JTDI,
	JTMS_SWDIO,
	LPTIM1_OUT,
	LPUART1_CTS,
	LPUART1_RTS_DE,
	LPUART1_RX,
	LPUART1_TX,
	MCO,
	SPI1_MISO,
	SPI1_MOSI,
	SPI1_NSS,
	SPI1_SCK,
	SPI2_SCK,
	SPI3_NSS,
	TIM1_BKIN,
	TIM1_BKIN2,
	TIM1_CH1,
	TIM1_CH1N,
	TIM1_CH2,
	TIM1_CH3,
	TIM1_CH4,
	TIM1_ETR,
	TIM2_CH1,
	TIM2_CH2,
	TIM2_CH3,
	TIM2_CH4,
	TIM2_ETR,
	TIM3_CH1,
	TIM3_CH2,
	TIM5_CH1,
	TIM5_CH2,
	TIM5_CH3,
	TIM5_CH4,
	TIM8_BKIN,
	TIM8_CH1N,
	TIM8_ETR,
	UART4_CTS,
	UART4_RTS_DE,
	UART4_RX,
	UART4_TX,
	UART5_CTS,
	UART5_RTS_DE,
	UART5_RX,
	UART5_TX,
	UDART2_RX,
	USART1_CK,
	USART1_CKN,
	USART1_CTS,
	USART1_RTS_DE,
	USART1_RX,
	USART1_TX,
	USART2_CK,
	USART2_CTS,
	USART2_RTS_DE,
	USART2_RX,
	USART2_TX,
	USART3_CK,
	USART3_CTS,
	USART3_RTS_DE,
	USART3_RX,
	USART3_TX,
	LCD_COM1,
	SAI1_FS_A,
	TIM15_BKIN,
	EVENTOUT,
	OTG_FS_ID,
	LCD_COM2,
	SAI1_SD_A,
	TIM17_BKIN,
}

/**
Describes a set of alternate functions.
*/
struct AFCapability
{
	/// The GPIO port.
	GPIOPort port;
	/// The pin.
	int pin;
	/// The support alternate function.
	AlternateFunction af;
	/// The alternate function id (a number from 0 to 15).
	ubyte afNum;

	/**
	Tests whether this capability is for a given port/pin combination.
	Params:
		port = The port to test for.
		pin = The pin to test for.
	Returns: `true` if the AF capability describes an alternate function of the
	given port/pin combination, `false` if it does not.²
	*/
	bool isForPin(GPIOPort port, int pin)
	{
		return this.port == port && this.pin == pin;
	}
}

/**
Describes the capabilities of an STM32 microcontroller.
*/
struct Capabilities
{
	/// Bitmask of available pins.
	PortMask mask;

	/// A set of alternative functions
	AFCapability[] alternateFunctions;

	/**
	Gets the GPIO mask for a given port.
	Params:
		port = The port to query.
	Returns: The mask for the port.
	*/
	uint gpioMask(char port)
	{
		switch (port)
		{
			case 'a': return mask.gpioA;
			case 'b': return mask.gpioB;
			case 'c': return mask.gpioC;
			case 'd': return mask.gpioD;
			case 'e': return mask.gpioE;
			case 'f': return mask.gpioF;
			case 'g': return mask.gpioF;
			case 'h': return mask.gpioH;
			case 'i': return mask.gpioI;
			default: assert(0, "Invalid port: " ~ port);
		}
	}

	/**
	Gets the number of IO pins on the port.
	Params:
		port = The port to query.
	Returns: The mask for the port.
	*/
	int gpioPins(char port)
	{
		import core.bitop : popcnt;
		return popcnt(gpioMask(port));
	}

	/**
	Tests whether a specific GPIO port is available or not.
	Params:
		port = The port to query.
	Returns: `true` if the port is available, `false` if the port is not present
		on the microcontroller.
	*/
	bool hasGPIO(char port)
	{
		return gpioMask(port) != 0;
	}

	/**
	Tests whether a specific GPIO port has a specific pin.
	Params:
		port = The port to query.
		pin = The pin to test for.
	Returns: `true` if the port has the pin, `false` if the port does not have
		the pin.
	*/
	bool gpioHasPin(char port, int pin)
	{
		if (pin < 0)
			return false;
		if (pin > 15)
			return false;
		const mask = gpioMask(port);
		return (mask & (1 << pin)) != 0;
	}

	AFCapability getAlternateFunction(GPIOPort port, int pin, AlternateFunction af)
	{
		foreach (altFunc; alternateFunctions)
		{
			if (altFunc.isForPin(port, pin) && altFunc.af == af)
				return altFunc;
		}
		assert(0, "Alternate function not found");
	}
}

/**
A helper which helps building an alternate function array quickily.
*/
struct AFBuilder
{
	AFCapability[] _functions;

	AFBuilderPin pin(GPIOPort port, int pin)
	{
		return AFBuilderPin(this, port, pin);
	}

	AFCapability[] build()
	{
		return _functions;
	}
}

/**
A helper which helps building an alternate function array quickily.
*/
struct AFBuilderPin
{
	AFBuilder _builder;
	GPIOPort _port;
	int _pin;

	AFBuilderPin af(ubyte num, AlternateFunction af)
	{
		_builder._functions ~= AFCapability(_port, _pin, af, num);
		return this;
	}

	AFBuilderPin pin(GPIOPort port, int pin)
	{
		return _builder.pin(port, pin);
	}

	AFCapability[] build()
	{
		return _builder.build();
	}
}