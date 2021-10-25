// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.util.frequency;

/**
Describes the frequency of a thing.
*/
struct Frequency
{
	private ulong freq;

	/**
	Gets the frequency in hertz.
	*/
	ulong inHz() const
	{
		return freq;
	}

	/**
	Gets the frequency in kilohertz.
	*/
	ulong inKhz() const
	{
		return inHz / 1000;
	}

	/**
	Gets the frequency in megahertz.
	*/
	ulong inMhz() const
	{
		return inKhz / 1000;
	}

	Frequency opBinary(string op)(const ulong rhs) const
	if (op == "*" || op == "/")
	{
		static if (op == "/")
			return Frequency(freq / rhs);
		else static if (op == "*")
			return Frequency(freq * rhs);
	}

	ulong opBinary(string op)(const Frequency rhs) const
	if (op == "/" || op == "%")
	{
		static if (op == "/")
			return freq / rhs.freq;
		else static if (op == "%")
			return freq % rhs.freq;
	}

	Frequency opBinary(string op)(const Frequency rhs) const
	if (op == "+" || op == "-")
	{
		static if (op == "+")
			return Frequency(freq + rhs.freq);
		else static if (op == "-")
			return Frequency(freq - rhs.freq);
	}

	/**
	A frequency of zero hertz.
	*/
	static immutable Frequency zero = Frequency(0);
}

/**
Gets a specific frequency.
Params:
	n = The frequency to get in hertz.
Returns: The frequency specified.
*/
Frequency hz(ulong n)
{
	return Frequency(n);
}

/**
Gets a specific frequency.
Params:
	n = The frequency to get in kilohertz.
Returns: The frequency specified.
*/
Frequency khz(ulong n)
{
	return hz(n * 1000);
}

/**
Gets a specific frequency.
Params:
	n = The frequency to get in megahertz.
Returns: The frequency specified.
*/
Frequency mhz(ulong n)
{
	return khz(n * 1000);
}