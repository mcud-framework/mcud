// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.util.sequence.sequencer;

import mcud.core.event;
import mcud.util.sequence.awaitall;
import std.format;
import std.meta;
import std.traits;

/**
A sequence of things that should be executed serially, with pauses in-between
to wait for events.
Each step can consist of either:
 - A function which gets executed.
 - An `await` step which waits on one or more events to occur.
*/
template Sequence(SimpleSteps...)
{
	private int state = 0;
	private alias steps = staticMap!(mapStep, SimpleSteps);

	/**
	Starts the sequence.
	If the sequence has already been started, this will do nothing.
	*/
	void start()
	{
		if (!isRunning())
		{
			state = 1;
			steps[0].callable();
			event_1.reset();
		}
	}

	/**
	Stops the sequence.
	Any function that is currently still running will complete.
	*/
	void stop()
	{
		state = 0;
	}

	/**
	Gets whether or not the sequence is running.
	Returns: `true` if the sequence is running, `false` if it is not running.
	*/
	bool isRunning()
	{
		return state != 0;
	}

	static foreach (i, step; steps)
	{
		static if (step.type == StepType.awaitAll)
		{
			mixin(format!
				`
					alias event_%d = AwaitAll!(
						{
							if (state == %d)
							{
								enum nextState = %d;
								state = nextState;
								steps[%d].callable();
								static if (nextState != 0)
								{
									event_%d.reset();
								}
							}
						},
						step.events
					);
				`
			(i, i, nextState(i), i+1, nextState(i)));
		}
	}

	private size_t nextState(size_t state)
	{
		return (state + 2) % steps.length;
	}
}

auto awaitAll(Events...)()
{
	struct Description
	{
		StepType type = StepType.awaitAll;
		alias events = Events;
	}
	return Description();
}

auto await(Event)()
{
	return awaitAll!Event;
}

/**
The types of steps a sequence can wait on.
*/
private enum StepType
{
	callable,
	awaitAll
}

/**
Maps a step to a more homogeneous structure.
*/
private template mapStep(alias step)
{
	static if (!isFunction!step)
	{
		struct Step
		{
			alias callable = step;
			StepType type = StepType.callable;
		}
		enum mapStep = Step();
	}
	else
	{
		alias mapStep = step;
	}
}

unittest
{
	struct SomeEvent {}

	static int count = 0;
	alias sequence = Sequence!(
		{
			count = 1;
		},
		await!SomeEvent,
		{
			count = 2;
		}
	);

	assert(count == 0, "Expected initial state");
	assert(sequence.isRunning() == false, "Expected to not yet have been started");

	sequence.start();
	assert(count == 1, "Expected first state");
	assert(sequence.isRunning() == true, "Expected to have started");
	
	fire!(SomeEvent, sequence)();
	assert(count == 2, "Expected second state");
	assert(sequence.isRunning() == false, "Expected to have stopped");

	fire!(SomeEvent, sequence);
	assert(count == 2, "Expected second state");
	assert(count == 2, "Count did not increase after event");
}