module mcud.meta.startable;

import mcud.core.result;
import mcud.meta.like;

interface Startable
{
	Result!void start();
	Result!void stop();
}

alias isStartable = isLike!Startable;