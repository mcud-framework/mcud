// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.util.format;

import std.conv;

private enum FormatType
{
	literal,
	integer,
	hex,
	upperHex,
	text,
}

private struct FormatSpec
{
	FormatType type;
	size_t index;
}

private FormatSpec[] parseFormatString(string fmt)
{
	FormatSpec[] specs;
	bool escape = false;
	int argIndex = 0;
	size_t escapeStart = 0;
	FormatSpec spec;
	for (size_t i = 0; i < fmt.length; i++)
	{
		const chr = fmt[i];
		if (escape)
		{
			if (chr == '%')
			{
				spec.type = FormatType.literal;
				spec.index = i;
				specs ~= spec;
				escape = false;
			}
			else if (chr == 'd')
			{
				spec.type = FormatType.integer;
				spec.index = argIndex++;
				specs ~= spec;
				escape = false;
			}
			else if (chr == 'x')
			{
				spec.type = FormatType.hex;
				spec.index = argIndex++;
				specs ~= spec;
				escape = false;
			}
			else if (chr == 'X')
			{
				spec.type = FormatType.upperHex;
				spec.index = argIndex++;
				specs ~= spec;
				escape = false;
			}
			else if (chr == 's')
			{
				spec.type = FormatType.text;
				spec.index = argIndex++;
				specs ~= spec;
				escape = false;
			}
			else
				assert(0, "Invalid format specifier '" ~ fmt[escapeStart .. cast(size_t)(i + 1)] ~ "'");
		}
		else if (chr == '%')
		{
			escape = true;
			escapeStart = i;
		}
		else
		{
			spec.type = FormatType.literal;
			spec.index = i;
			specs ~= spec;
		}
	}
	return specs;
}

void format(string fmt, void delegate(char) callback, Arg...)(Arg arg)
{
	enum specs = parseFormatString(fmt);
	static foreach (FormatSpec spec; specs)
	{{
		static if (spec.type == FormatType.literal)
			callback(fmt[spec.index]);
		else static if (spec.type == FormatType.integer)
		{
			int num = arg[spec.index];
			if (num == 0)
				callback('0');
			if (num < 0)
			{
				callback('-');
				num = -num;
			}
			char[12] chars;
			size_t length = 0;
			while (num != 0)
			{
				chars[length++] = (num % 10) + '0';
				num /= 10;
			}
			foreach_reverse (i; 0 .. length)
				callback(chars[i]);
		}
		else static if (spec.type == FormatType.hex)
		{
			uint num = arg[spec.index];
			if (num == 0)
				callback('0');
			char[8] chars;
			size_t length;
			while (num != 0)
			{
				if ((num & 0xF) < 10)
					chars[length++] = (num & 0xF) + '0';
				else
					chars[length++] = cast(char) ((num & 0xF) - 10 + 'a');
				num >>= 4;
			}
			foreach_reverse (i; 0 .. length)
				callback(chars[i]);
		}
		else static if (spec.type == FormatType.upperHex)
		{
			uint num = arg[spec.index];
			if (num == 0)
				callback('0');
			char[8] chars;
			size_t length;
			while (num != 0)
			{
				if ((num & 0xF) < 10)
					chars[length++] = (num & 0xF) + '0';
				else
					chars[length++] = cast(char) ((num & 0xF) - 10 + 'A');
				num >>= 4;
			}
			foreach_reverse (i; 0 .. length)
				callback(chars[i]);
		}
		else static if (spec.type == FormatType.text)
		{
			string str = arg[spec.index].to!string;
			foreach (chr; str)
				callback(chr);
		}
	}}
}

string format(string fmt, Arg...)(Arg arg)
{
	string output;
	format!(fmt, (chr) 
	{
		output ~= chr;
	}, Arg)(arg);
	return output;
}

@("format can generate formatted strings")
unittest
{
	assert(format!"abc" == "abc", "Simple string was incorrect");
	assert(format!"a%%b" == "a%b", "Escaped '%' was incorrect");
	assert(format!"a%db"(52) == "a52b", "Format '%d' was incorrect");
	assert(format!"a%db"(0) == "a0b", "Format '%d' with zero was incorrect");
	assert(format!"a%db"(-52) == "a-52b", "Format '%d' with negative was incorrect");
	assert(format!"?%x!"(0xdead1234) == "?dead1234!", "Format '%x' was incorrect");
	assert(format!"?%X!"(0xdead1234) == "?DEAD1234!", "Format '%x' was incorrect");
	assert(format!"?%s!"("test") == "?test!", "Format '%s' was incorrect");
}