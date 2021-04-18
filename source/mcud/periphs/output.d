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
	Result!void on();

	/**
	Turns the GPO off.
	*/
	Result!void off();
}

alias isLikeGPO = isLike!GPO;