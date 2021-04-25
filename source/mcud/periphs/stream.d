module mcud.periphs.stream;

import mcud.core;

interface InputStream(T)
{
	Result!T read();
}

interface OutputStream(T)
{
	Result!void write(T value);
}

alias isLikeInputStream(T) = isLike!(InputStream!T);
alias isLikeOutputStream(T) = isLike!(OutputStream!T);
enum isLikeIOStream(T, S) = isLikeInputStream!T(S) && isLikeOutputStream!T(S);