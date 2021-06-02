module mcud.core.errors;

/**
A set of errors one can encounter.
*/
enum Error
{
	/// Everything's okay!
	ok,
	/// A timeout occured
	timeout,
	/// A buffer was full
	full,
}

alias Errors = Error;