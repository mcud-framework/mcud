module mcud.meta.traits;

/**
Tests if a thing has a given member.
Params:
	parent = The parent thing to test.
	member = The name of the member to test for.
Returns:
	`true` if the thing has the member, `false` if it does not have the member.
*/
enum hasMember(alias parent, string member) = __traits(hasMember, parent, member);