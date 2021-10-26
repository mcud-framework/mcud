// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.meta.like;

import std.algorithm;
import std.meta;
import std.traits;

private template TypeOf(alias func)
{
	alias TypeOf = AliasSeq!(ReturnType!func, Parameters!func);
}

private bool hasFunctionAttributes(alias func, string property)()
{
	bool hasAttribute = false;
	static foreach (attribute; __traits(getFunctionAttributes, func))
	{
		if (attribute == property)
			hasAttribute = true;
	}
	return hasAttribute;
}

private template isProperty(alias func)
{
	enum isProperty = hasFunctionAttributes!(func, "@property");
}

/**
Checks that the function `func` has the same signature as the function `candidate`.
*/
private template isLikeFunction(alias func)
{
	/// If `candidate` is callable
	template isLikeFunction(alias candidate)
	if (isCallable!candidate)
	{
		enum isLikeFunction = is(TypeOf!func == TypeOf!candidate);
	}

	/// If `candidate` is not callable and `func` has no parameters (a.k.a. a getter)
	template isLikeFunction(alias candidate)
	if (!isCallable!candidate && Parameters!func.length == 0)
	{
		enum isLikeFunction = isProperty!func && is(ReturnType!func == typeof(candidate));
	}

	/// If `candidate` is not callable and `func` has one parameter (a.k.a. a setter)
	template isLikeFunction(alias candidate)
	if (!isCallable!candidate && Parameters!func.length == 1)
	{
		enum isLikeFunction = isProperty!func && is(Parameters!func[0] == typeof(candidate));
	}

	/// Fallback if `candidate` is not callable and `func` is not a setter or getter.
	template isLikeFunction(alias candidate)
	if (!isCallable!candidate && Parameters!func.length >= 2)
	{
		enum isLikeFunction = false;
	}
}

@("isLikeFunction is true for similar functions")
unittest
{
	static bool functionA(int a);
	static bool functionB(int b);

	alias curried = isLikeFunction!functionA;
	assert(curried!functionB == true, "functionA and functionB should be alike");
}

@("isLikeFunction is false for functions with different parameters")
unittest
{
	static bool functionA(int a);
	static bool functionB(int a, float b);
	static bool functionC(long a);

	alias curried = isLikeFunction!functionA;
	assert(curried!functionB == false, "functionA and functionB are not alike");
	assert(curried!functionC == false, "functionA and functionC are not alike");
}

@("isLikeFunction is false for functions with different return types")
unittest
{
	static bool functionA(int a);
	static long functionB(int b);

	alias curried = isLikeFunction!functionA;
	assert(curried!functionB == false, "functionA and functionB are not alike");
}

/**
Is `true` if the aggregate `A` has a method that has the
same name as the function F and is like the function `F`.
Is `false` if it has no method with the same name or signature.
*/
private template isInAggregate(A)
{
	template isInAggregate(alias F)
	{
		enum functionName = __traits(identifier, F);
		static if (hasMember!(A, functionName))
		{
			enum isInAggregate = anySatisfy!(
				isLikeFunction!(F),
				__traits(getMember, A, functionName),
				__traits(getOverloads, A, functionName)
			);
		}
		else
		{
			enum isInAggregate = false;
		}
	}
}

@("isInAggregate is true when the interface has a similar function")
unittest
{
	interface Interface
	{
		bool someFunction(int test);
		bool someFunction();
	}

	struct StructA
	{
		bool someFunction(int test);
	}

	struct StructB
	{
		bool someFunction();
	}

	alias curried = isInAggregate!Interface;
	assert(curried!(StructA.someFunction) == true, "StructA.someFunction should be like the first function");
	assert(curried!(StructB.someFunction) == true, "StructB.someFunction should be like the second function");
}

@("isInAggregate is false when the interface has no similar function")
unittest
{
	interface Interface
	{
		bool someFunction(int test);
		bool someFunction();
	}

	struct StructA
	{
		bool someFunction(float test);
	}

	struct StructB
	{
		bool otherName();
	}

	alias curried = isInAggregate!Interface;
	assert(curried!(StructA.someFunction) == false, "StructA.someFunction has different parameters");
	assert(curried!(StructB.otherName) == false, "StructB.otherName has a different name");
}

private template GetType(alias value)
{
	static if (__traits(compiles, typeof(value)))
		alias GetType = typeof(value);
	else
		alias GetType = value;
}

/**
Is `true` if all members of `Interface` are like members in `Type`.
Is `false` if even one member is different.
*/
string[] describeLike(Interface, alias value, string interfacePrefix = "", string valuePrefix = "")()
{
	import std.format : format;
	alias GetMember(string m) = __traits(getMember, Interface, m);
	alias Type = GetType!value;
	alias isIn = isInAggregate!Type;

	string[] reasons;
	static foreach (member; Filter!(templateNot!isFinal, staticMap!(GetMember, __traits(allMembers, Interface))))
	{
		static if (is(member == interface))
		{
			reasons ~= describeLike!(
				member,
				__traits(getMember, value, __traits(identifier, member)),
				__traits(identifier, Interface) ~ ".",
				__traits(identifier, value) ~ ".",
			);
		}
		else
		{
			static if (!isIn!member)
				reasons ~= format!("No match found for '%s' from interface '%s' in '%s'")(
					__traits(identifier, member),
					interfacePrefix ~ Interface.stringof,
					valuePrefix ~ __traits(identifier, value)
				);
		}
	}
	return reasons;
}

/**
Is `true` if all members of `Interface` are like members in `Type`.
Is `false` if even one member is different.
*/
template isLike(Interface)
{
	alias GetMember(string m) = __traits(getMember, Interface, m);
	enum isLike(alias value) = describeLike!(Interface, value).length == 0;
}

@("isLike is true for a struct that is like an interface")
unittest
{
	interface Interface
	{
		void a();
		bool b();
		final float finalMember();
	}

	struct Struct
	{
		void a();
		bool b();
		long c();
	}

	alias curried = isLike!Interface;
	assert(curried!Struct == true, "Struct should have everything that Interface has");
}

@("isLike is false for a struct that is not like an interface")
unittest
{
	interface Interface
	{
		void a();
		bool b();
	}

	struct StructWithMissingMember
	{
		void a();
		long c();
	}

	struct StructWithWrongMember
	{
		void a();
		int b();
	}

	alias curried = isLike!Interface;
	assert(curried!StructWithMissingMember == false, "Struct has a missing member");
	assert(curried!StructWithWrongMember == false, "Struct has a wrong member");
}

@("isLike is true for a struct that has an alias similar to a function")
unittest
{
	interface Interface
	{
		@property
		long a();
	}

	struct Struct
	{
		long t();
		alias a = t;
	}

	alias curried = isLike!Interface;
	assert(curried!Struct == true, "Struct is not like Interface");
}

@("isLike is false for a struct that has an property but the interface has no @property")
unittest
{
	interface Interface
	{
		int a();
	}

	struct Struct
	{
		int a;
	}

	alias curried = describeLike!(Interface, Struct);
	assert(curried.length == 1);
	assert(curried[0] == "No match found for 'a' from interface 'Interface' in 'Struct'");
}

@("isLike can work recursively")
unittest
{
	interface Interface
	{
		interface Child
		{
			long funcChild();
		}
		int funcParent();
	}

	struct Struct
	{
		struct Child
		{
			long funcChild();
		}
		int funcParent();
	}

	alias curried = isLike!Interface;
	assert(curried!Struct == true, "Struct is not like Interface");
}

/**
Asserts that a type is like an interface.
Params:
	Interface = The interface the type should be like.
	value = The value to test.
*/
template assertLike(Interface, alias value)
{
	enum results = describeLike!(Interface, value);
	static if (results.length > 0)
		static assert(false, results[0]);
	enum assertLike = results.length == 0;
}
