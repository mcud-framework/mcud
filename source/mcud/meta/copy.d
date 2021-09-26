module mcud.meta.copy;

import std.traits;

/**
Copies all values from the input to the output.
This is useful for copying values between two templated structs.
*/
void copyTo(In, Out)(ref In input, ref Out output)
{
	static foreach (member; FieldNameTuple!In)
	{
		__traits(getMember, output, member) = __traits(getMember, input, member);
	}
}