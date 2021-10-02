#!/bin/rdmd
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module tools.generate_dub;

import std.file;
import std.path;
import std.process;
import std.stdio;
import std.string;

/**
Describes a board configuration.
*/
struct Description
{
	/// The name of the board.
	string board;
	/// The path to the board support package.
	string boardPath;
	/// A set of directories to build.
	string[] dirs;
}

void main(string[] args)
{
	const mcud = args[1];
	const boards = args[2 .. $];

	writeln(`name "mcud"`);
	writefln(`sourcePaths "source" "%s/source" "%s/libd" "%s/libphobos"`, mcud, mcud, mcud);
	writefln(`importPaths "source" "%s/source" "%s/libd" "%s/libphobos"`, mcud, mcud, mcud);

	Description[] descriptions;
	foreach (const board; boards)
	{
		Description description;
		description.board = board;
		const process = execute(["make", "describe", "BOARD=" ~ board]);
		string output = process.output;
		foreach (line; splitLines(output))
		{
			if (line.indexOf('=') != -1)
			{
				const parts = line.split('=');
				const key = parts[0];
				string[] values = parts[1].split(' ');
				if (key == "DIRS")
					description.dirs = values;
			}
		}
		descriptions ~= description;
	}

	foreach (const description; descriptions)
	{
		writefln!(`configuration "%s" {`)(description.board);
		writefln!(`    sourcePaths "%s"`)(description.dirs.join(`" "`));
		writefln!(`    importPaths "%s"`)(description.dirs.join(`" "`));
		writefln!(`}`);
	}
}