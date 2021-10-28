// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.events.standard;

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

All event handlers which listen to the event will be executed. If there are
event handlers which take the event as an argument, the argless fire will cause
a build error.

Params:
	Event = The event to fire.
	target = The target to fire it in. By default it will fire the event on the
	entire user application.
*/
void fire(Event, alias target = system)()
{
	enum argHandlers = allFunctions!(handler, target, Event);
	enum voidHandlers = allFunctions!(event!Event, target, void);
	static assert (argHandlers.length == 0, "Can't fire argless event when there are arged event handlers");

	static foreach (handler; voidHandlers)
		handler.func();
}

/**
Fires an event.

All event handlers which listen to the event will be executed. If there are
event handlers which take the event as an argument, the argless fire will cause
a build error.

Params:
	Event = The event to fire.
	target = The target to fire it in. By default it will fire the event on the
	entire user application.
	e = The actual value of the event.
*/
void fire(Event, alias target = system)(ref Event e)
{
	enum argHandlers = allFunctions!(handler, target, Event);
	enum voidHandlers = allFunctions!(event!Event, target, void);

	static foreach (handler; argHandlers)
		handler.func(e);
	static foreach (handler; voidHandlers)
		handler.func();
}
