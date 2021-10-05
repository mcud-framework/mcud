// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.core.attributes;

import gcc.attributes;

/**
Forces a specific function to be inlined.
*/
enum forceinline = attribute("always_inline");

/**
Describes the states of a task.
*/
enum TaskState
{
	/// Marks the task as started.
	started,
	/// Marks the task as stopped.
	stopped,
	/// Marks the task as a task which cannot be stopped.
	unstoppable
}

/**
Declares a function to be a task.
*/
struct task
{
	/// The state of the task.
	TaskState state = TaskState.started;
}

/**
Declares a function to be run at the start of the program.
*/
struct setup {}

/**
Declares a function to be an interrupt handler.
*/
struct interrupt
{
	int irq;

	/**
	Declares a function to be an interrupt handler.
	Params:
		irq = The IRQ to listen for.
	*/
	this(int irq)
	{
		this.irq = irq;
	}
}