module mcud.periphs.output;

import mcud.core.result;
import mcud.meta.like;

/**
Describes a general purpose output.
*/
interface GPO
{
	/**
	Turns the GPO on.
	*/
	Result!void on() nothrow;

	/**
	Turns the GPO off.
	*/
	Result!void off() nothrow;
}

alias isGPO = isLike!GPO;