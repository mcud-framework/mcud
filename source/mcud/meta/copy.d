// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

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