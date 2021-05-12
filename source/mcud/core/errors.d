module mcud.core.errors;

/**
A set of errors one can encounter.
*/
enum Error
{
	/// Everything's okay!
	ok,

	timeout
}

alias Errors = Error;