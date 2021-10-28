module mcud.interfaces.startable;

import mcud.meta.like;

/**
Describes a driver that can be started and stopped.
*/
interface Startable
{
	/**
	An event which gets fired if the driver has started.
	*/
	interface StartedEvent {}

	/**
	An event which gets fired if the driver has failed to start.
	*/
	interface StoppedEvent {}

	/**
	Starts the driver.
	*/
	void start();

	/**
	Stops the driver.
	*/
	void stop();
}

alias isStartable = isLike!Startable;