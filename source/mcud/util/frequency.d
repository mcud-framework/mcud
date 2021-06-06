module mcud.util.frequency;

/**
Describes the frequency of a thing.
*/
struct Frequency
{
	private ulong freq;

	ulong inHz()
	{
		return freq;
	}

	ulong inKhz()
	{
		return inHz / 1000;
	}

	ulong inMhz()
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
}

Frequency hz(ulong n)
{
	return Frequency(n);
}

Frequency khz(ulong n)
{
	return hz(n * 1000);
}

Frequency mhz(ulong n)
{
	return khz(n * 1000);
}