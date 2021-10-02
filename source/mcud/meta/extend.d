// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.meta.extend;

/**
Lets a template extend another template.

It will define an alias called `base` which refers to the parent template.
Alias to all the child members are automatically generated.

Params:
	parent = The parent to alias to.
*/
mixin template Extend(alias parent)
{
	alias base = parent;
	mixin AliasThis!base;
}

/**
Generates alias to each member of the given parent.

This allows for a construction similar to `alias xyz this`, but also allows
non-aggregates such as template to be aliased.

Params:
	parent = The parent to alias to.
*/
mixin template AliasThis(alias parent)
{
	static foreach (member; __traits(allMembers, parent))
	{
		mixin("alias "~member~" = parent."~member~";");
	}
}