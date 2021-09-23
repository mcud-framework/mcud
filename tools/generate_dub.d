#!/bin/rdmd
module tools.generate_dub;

import std.array;
import std.file;
import std.path;
import std.stdio;

void main(string[] args)
{
	auto mcud = args[1];
	auto boards = args[2 .. $-1];
	writeln(`name "mcud"`);
	writefln(`sourcePaths "%s/source" "%s/libd" "%s/libphobos"`, mcud, mcud, mcud);
	//writeln(`importPaths "source" "libd" "libphobos"`);

	foreach (string dir; dirEntries(buildPath(mcud, "boards"), SpanMode.shallow))
	{
		string board = dir.split("/")[$ - 1];
		writefln!(`configuration "%s" {`)(board);
		writefln!(`    sourcePaths "%s"`)(dir);
		writefln!(`}`);
	}
}