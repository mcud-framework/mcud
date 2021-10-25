// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module cpu.stm32.capabilities;

import mcud.test;
import std.format;

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
	CAN2_RX,
	DCMI_D0,
	DCMI_D1,
	DCMI_PIXCLK,
	EVENTOUT,
	I2C1_SMBA,
	I2C3_SCL,
	I2C4_SCL,
	I2C4_SDA,
	I2C4_SMBA,
	IR_OUT,
	JTCK_SWCLK,
	JTDI,
	JTMS_SWDIO,
	LCD_COM1,
	LCD_COM2,
	LPTIM1_OUT,
	LPUART1_CTS,
	LPUART1_RTS_DE,
	LPUART1_RX,
	LPUART1_TX,
	MCO,
	OTG_FS_ID,
	QUADSPI_BK2_IO0,
	QUADSPI_CLK,
	SAI1_FS_A,
	SAI1_SD_A,
	SPI1_MISO,
	SPI1_MOSI,
	SPI1_NSS,
	SPI1_SCK,
	SPI2_MOSI,
	SPI2_SCK,
	SPI3_NSS,
	TIM1_BKIN_COMP1,
	TIM1_BKIN_COMP2,
	TIM1_BKIN,
	TIM1_BKIN2_COMP2,
	TIM1_BKIN2,
	TIM1_CH1,
	TIM1_CH1N,
	TIM1_CH2,
	TIM1_CH3,
	TIM1_CH4,
	TIM1_ETR,
	TIM15_BKIN,
	TIM17_BKIN,
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
	TIM8_BKIN2,
	TIM8_CH1,
	TIM8_CH1N,
	TIM8_CH2,
	TIM8_CH2N,
	TIM8_CH3,
	TIM8_CH3N,
	TIM8_CH4,
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
}

/**
Describes a set of alternate functions.
*/
struct AFCapability
{
	/// The GPIO port.
	GPIOPort port;
	/// The pin.
	int pin = -1;
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

	/**
	Tests if the AF capability is set.
	Returns: `true` if the AF capability refers to an actual alternate function
	on a pin, `false` if it refers does not.
	*/
	bool isSet()
	{
		return pin != -1;
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
		string err = format!("Alternate function %s not found for pin (%s.%d)")(af, port, pin);
		assert(0, err.idup);
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

@("AFBuilder can configure alternate functions")
unittest
{
	AFBuilder builder;
	AFCapability[] caps = builder
		.pin(GPIOPort.a, 2)
			.af(1, AlternateFunction.JTDI)
			.af(4, AlternateFunction.LPTIM1_OUT)
		.pin(GPIOPort.b, 4)
			.af(2, AlternateFunction.LPUART1_CTS)
		.build();

	expect(caps[0]).toEqual(AFCapability(GPIOPort.a, 2, AlternateFunction.JTDI, 1));
	expect(caps[1]).toEqual(AFCapability(GPIOPort.a, 2, AlternateFunction.LPTIM1_OUT, 4));
	expect(caps[2]).toEqual(AFCapability(GPIOPort.b, 4, AlternateFunction.LPUART1_CTS, 2));
}

@("Capabilities.getAlternateFunction can find an alternative function")
unittest
{
	Capabilities caps;
	caps.alternateFunctions ~= AFCapability(GPIOPort.a, 2, AlternateFunction.JTDI, 1);

	AFCapability cap = caps.getAlternateFunction(GPIOPort.a, 2, AlternateFunction.JTDI);
	expect(cap).toEqual(AFCapability(GPIOPort.a, 2, AlternateFunction.JTDI, 1));
}