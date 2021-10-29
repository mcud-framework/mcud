// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.events.test;

import mcud.core.system;
import mcud.events.standard : standardFire = fire;
import std.traits;

public import mcud.events.standard : event, handler;

private template EventHandlers(Event)
{
	void delegate()[] voidHandlers;
	void delegate(Event)[] argHandlers;

	void add(void delegate() handler)
	{
		voidHandlers ~= handler;
	}

	void add(void delegate(Event) handler)
	{
		argHandlers ~= handler;
	}
}

struct Events
{
	@disable this();

	static void addHandler(Event)(void delegate() handler)
	{
		EventHandlers!(Event).add(handler);
	}

	static void addHandler(Event)(void function() handler)
	{
		addHandler(() => handler());
	}

	static void addHandler(Event)(void delegate(Event) handler)
	{
		EventHandlers!(Event).add(handler);
	}

	static void addHandler(Event)(void function(Event) handler)
	{
		addHandler!Event(event => handler(event));
	}

	static void addHandlers(Source)()
	{
		static foreach (member; __traits(allMembers, Source))
		{
			static foreach (overload; __traits(getOverloads, Source, member))
			{
				static if (hasUDA!(overload, handler))
				{
					addHandler(&overload);
				}
			}
		}
	}

	static void addHandlers(alias source)()
	{
		addHandlers!(typeof(source))();
	}

	static void clearHandlers(Event)()
	{
		EventHandlers!(Event).voidHandlers = [];
		EventHandlers!(Event).argHandlers = [];
	}

	static void setHandler(Event)(void delegate() handler)
	{
		clearHandlers!(Event);
		addHandler!(Event)(handler);
	}

	static void setHandler(Event)(void delegate(Event) handler)
	{
		clearHandlers!Event;
		addHandler!(Event)(handler);
	}
}

void fire(T, alias target = system)(T t)
{
	import std.stdio : writeln;
	foreach (handler; EventHandlers!(T).voidHandlers)
	{
		handler();
	}
	foreach (handler; EventHandlers!(T).argHandlers)
	{
		handler(t);
	}
	standardFire!(T, target)(t);
}

void fire(T, alias target = system)()
{
	assert(EventHandlers!(T).argHandlers.length == 0,
		"Cannot fire argless event when there are arged handlers registered");
	foreach (handler; EventHandlers!(T).voidHandlers)
		handler();
	standardFire!(T, target)();
}