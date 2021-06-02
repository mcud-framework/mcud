module mcud.core.attributes;

import gcc.attributes;

/**
Forces a specific function to be inlined.
*/
enum forceinline = attribute("always_inline");

/**
Declares a function to be a task.
*/
enum task;

/**
Deckares a function to be run at the start of the program.
*/
enum setup;