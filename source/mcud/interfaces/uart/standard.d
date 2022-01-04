// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.interfaces.uart.standard;

import mcud.interfaces.startable;

/**
A simple UART interface.
*/
interface UART : Startable
{
	/**
	Indicates data was sent.
	*/
	struct WriteEvent {}

	/**
	Indicates data was received.
	*/
	struct ReadEvent
	{
		ubyte[] data;
	}

	/**
	Writes data to over a UART port.
	Params:
		data = The data to send. It should be kept in memory until the transfer
		has completed.
	*/
	void write(const(ubyte[]) data);
}