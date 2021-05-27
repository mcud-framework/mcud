module mcud.core.attributes;

import gcc.attribute;

/**
Forces a specific function to be inlined.
*/
enum forceinline = attribute("forceinline");

/**
Declares a function to be a task.
*/
enum task;