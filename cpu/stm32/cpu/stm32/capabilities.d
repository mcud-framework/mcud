// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module cpu.stm32.capabilities;

public import cpu.stm32.periphs.gpio : AlternateFunction, GPIOPort;

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
Describes the capabilities of an STM32 microcontroller.
*/
struct Capabilities
{
	/// Bitmask of available pins.
	PortMask mask;

	/// A set of alternative functions
	uint[AlternateFunction] alternateFunctions;

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
			case 'a': return gpioAMask;
			case 'b': return gpioBMask;
			case 'c': return gpioCMask;
			case 'd': return gpioDMask;
			case 'e': return gpioEMask;
			case 'f': return gpioFMask;
			case 'g': return gpioGMask;
			case 'h': return gpioHMask;
			case 'i': return gpioIMask;
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

	bool pinSupport(char port, int pin, AlternateFunction af)
	{

	}
}
