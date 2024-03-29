// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.meta.functions;

import mcud.core.system;
import std.meta;
import std.traits;

/**
Describes a function.
*/
struct Function(T, Arg = void)
{
	/**
	The attribute the function was annotated with.
	*/
	T attribute;

	/**
	The function.
	*/
	static if (is(Arg == void))
		void function() func;
	else
		void function(Arg) func;

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
Function!(attribute, Arg)[] allFunctions(alias attribute, alias T = system, Arg = void)()
{
	Function!(attribute, Arg)[] found = [];
	allFunctionsFiltered!(attribute, Arg, T)(found);
	return found;
}

/**
Finds all attributed functions in a 'thing'. The 'thing' will be searched
recursively.
Params:
	attribute = The attribute a function has to be annoted with.
	Arg = The type of parameter any found function should be able to accept.
	T = The symbol to search for.
	found = An array which functions will be appeneded to if they have the
	attribute.
*/
private void allFunctionsFiltered(alias attribute, Arg, alias T)(ref Function!(attribute, Arg)[] found)
{
	static if (isPublic!T && hasUDA!(T, attribute))
	{
		alias udas = getUDAs!(T, attribute);
		assert(udas.length == 1, "A function should not have duplicate annotations");
		attribute uda;
		static if (!isType!(udas[0]))
			uda = udas[0];

		alias expectedParams = Parameters!(Function!(attribute, Arg).func);
		static if (is(Parameters!T == expectedParams))
		{
			foreach (filter; found)
			{
				if (filter.func == &T)
					return;
			}
			found ~= [Function!(attribute, Arg)(uda, &T, T.mangleof)];
		}
	}
	else static if (isPublic!T && canContainFunctions!T)
	{
		static foreach (child; __traits(allMembers, T))
		{{
			alias symbol = __traits(getMember, T, child);
			static if (!__traits(isScalar, symbol))
				allFunctionsFiltered!(attribute, Arg, symbol)(found);
		}}
	}
}

/**
Tests if a symbol is public or not.
Params:
	t = The symbol to test.
Returns: `true` if the symbol is public or cannot have any visibility,
otherwise `false`
*/
private template isPublic(alias t)
{
	static if (__traits(compiles, __trait(getVisibility, t)))
		enum isPublic = __traits(getVisibilty, t) == "public";
	else
		enum isPublic = true;
}

/**
Tests if a symbol is a template or not.
Params:
	t = The symbol to test.
Returns: `true` if the symbol is a template, `false` if it is not a template.
*/
private template isTemplate(alias t)
{
	enum isTemplate = !is(TemplateOf!t == void);
}

/**
Ditto.
*/
private template isTemplate(T...)
{
	enum isTemplate = true;
}

/**
Executes `allFunctionsFiltered` for all members of `T`. This allows searching
through tuples.
*/
private void allFunctionsFiltered(alias attribute, Arg, T...)(ref Function!(attribute, Arg)[] found)
{
	static foreach (value; T)
	{
		allFunctionsFiltered!(attribute, Arg, value)(found);
	}
}
