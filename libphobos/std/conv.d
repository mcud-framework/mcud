module std.conv;

/**
Converts an enum value to a string.
*/
Target to(Target, Input)(Input inp)
if (is(Target == string) && Input.mangleof[0] == 'E')
{
	static foreach (member; __traits(allMembers, Input))
	{
		if (__traits(getMember, Input, member) == inp)
			return member;
	}
	assert(0, "Invalid value");
}

/**
No-op converter.
*/
Target to(Target, Input)(ref Input inp)
if (is(Target == Input))
{
	return inp;
}