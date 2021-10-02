// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.meta.functions;

import std.traits;
import std.meta;

/**
Describes a function.
*/
struct Function(T)
{
	/**
	The attribute the function was annotated with.
	*/
	T attribute;

	/**
	The function.
	*/
	void function() func;

	/**
	The mangled name of the function.
	*/
	string mangled;
}

/**
Checks if the given type can have child functions.
*/
private template canContainFunctions(alias T)
{
	enum canContainFunctions = __traits(compiles, __traits(allMembers, T));
}

/**
Finds all attributed functions of a program.
Param:
	attribute = The attribute that functions should be annotated with.
	T = The type to search for functions.
Returns:
	An array of all attributed functions.
*/
Function!attribute[] allFunctions(alias attribute, alias T = system)()
{
	Function!attribute[] filters = [];
	allFunctionsFiltered!(attribute, T)(filters);
	return filters;
}

private void allFunctionsFiltered(alias attribute, alias T)(ref Function!attribute[] found)
{
	static if (hasUDA!(T, attribute))
	{
		alias udas = getUDAs!(T, attribute);
		assert(udas.length == 1, "A function should not have duplicate annotations");
		attribute uda;
		static if (!isType!(udas[0]))
			uda = udas[0];
		foreach (filter; found)
		{
			if (filter.func == &T)
				return;
		}
		found ~= [Function!attribute(uda, &T, T.mangleof)];
	}
	else static if (canContainFunctions!T)
	{
		static foreach (child; __traits(allMembers, T))
		{
			allFunctionsFiltered!(attribute, __traits(getMember, T, child))(found);
		}
	}
}
