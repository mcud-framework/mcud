// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

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