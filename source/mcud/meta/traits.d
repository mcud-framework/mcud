// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.meta.traits;

/**
Tests if a thing has a given member.
Params:
	parent = The parent thing to test.
	member = The name of the member to test for.
Returns:
	`true` if the thing has the member, `false` if it does not have the member.
*/
enum hasMember(alias parent, string member) = __traits(hasMember, parent, member);