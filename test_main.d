import std.stdio;

void main()
{
	foreach (ModuleInfo* m; ModuleInfo)
	{
		writefln!"Module: %s"(m.name);
		/*foreach (test; m.unitTest)
		{
			writefln("Found test");
		}*/
	}

	/*
	foreach (test; __traits(getUnitTests, mcud.meta.like))
	{
		writeln("Running test");
		test();
	}
	*/
}