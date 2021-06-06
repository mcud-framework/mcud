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
