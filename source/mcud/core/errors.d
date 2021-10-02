// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.core.errors;

/**
A set of errors one can encounter.
*/
enum Err
{
	/// Everything's okay!
	ok,
	/// A timeout occured
	timeout,
	/// A buffer was full
	full,
	/// An invalid state was reached
	invalidState,
}
