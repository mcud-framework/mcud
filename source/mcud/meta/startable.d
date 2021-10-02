// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.meta.startable;

import mcud.core.result;
import mcud.meta.like;

interface Startable
{
	Result!void start();
	Result!void stop();
}

alias isStartable = isLike!Startable;