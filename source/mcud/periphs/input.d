module mcud.periphs.input;

import mcud.core.result;
import mcud.meta.like;

/**
A general purpose input.
*/
interface GPI
{
	/**
	Tests if the GPI is currently on.
	*/
	Result!bool isOn();
}

alias isLikeGPI = isLike!GPI;