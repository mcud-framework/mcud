# About MCUd
MCUd is a framework for running D on microcontrollers (or MCUs).
It provides a declarative style of programming allowing one to
create complex embedded firmwares in a higly maintable manner.

In addition, it aims to reduce flash memory usage as much as
possible and make the entire user application (and even MCUd
itself) fully unit-testable.

As very few vendors or distributions ship compilers with
support for D, all compile jobs run in Docker containers
containing the right tools needed to build MCUd for your target
CPU.
