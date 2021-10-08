// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.core.event;

import mcud.core.system;
import mcud.meta.functions;

/**
A UDA for marking a function as an event handler.
This particular version is used when the function itself takes no arguments.
Params:
	T = The type of event to listen for.
*/
struct event(T = void) {}

/**
A UDA for marking a function as an event handler.
This particular version is used when the function takes the event as an
argument. There is no need to manually specify the event type here.
*/
alias handler = event!void;

/**
Fires an event.

This template resolves to different things depending on the event handlers found.
	- If no event handlers are found, it resolves to two empty functions. One
	  function can take an argument, one does not.
	- If only event handlers are found which do not take any arguments, two
	  functions are generated. One function takes the argument and drops it
	  before calling the event handlers, the other simply calls all event
	  handlers immediately.
	- If event handlers are found which take argument, only one function is
	  generated. This function must take the event as an argument.

Params:
	T = The event to fire.
	target = The target to fire it in. By default it will fire the event on the
	entire user application.
*/
template fire(T, alias target = system)
{
	enum argHandlers = allFunctions!(handler, target, T);
	enum voidHandlers = allFunctions!(event!T, target, void);

	static if (argHandlers.length == 1 && voidHandlers.length == 0)
	{
		void fire(T t)
		{
			argHandlers[0].func(t);
		}
	}
	else static if (argHandlers.length == 0 && voidHandlers.length == 1)
	{
		void fire(T t)
		{
			voidHandlers[0].func();
		}

		void fire()
		{
			voidHandlers[0].func();
		}
	}
	else static if (argHandlers.length == 0 && voidHandlers.length > 1)
	{
		void fire(T t)
		{
			fire();
		}

		void fire()
		{
			static foreach (handler; voidHandlers)
				handler.func();
		}
	}
	else static if (argHandlers.length >= 1 || voidHandlers.length >= 1)
	{
		void fire(T t)
		{
			static foreach (handler; argHandlers)
				handler.func(t);
			static foreach (handler; voidHandlers)
				handler.func();
		}
	}
	else
	{
		void fire(T t) {}
		void fire() {}
	}
}
