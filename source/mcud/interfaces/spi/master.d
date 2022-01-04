// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.interfaces.spi.master;

import mcud.interfaces.startable;

/**
An SPI controller operating as a master.
*/
interface SpiMaster : Startable
{
	/**
	Indicates a transfer completed.
	*/
	struct TransferEvent
	{
		/// The the data that received.
		ubyte[] received;
	}

	/**
	Sends data over the SPI bus.
	At the end of the transfer, a TransferEvent will be fired containing the
	data that was received.
	Params:
		data = The data to send. Should stay in memory until the TransferEvent
		has been fired.
	*/
	void write(const(ubyte[]) data);
}

/**
An SPI master which can transmits up to 16 bits per word.
*/
interface SpiLongMaster : Startable
{
	/**
	Indicates a multi byte transfer completed.
	*/
	struct TransferEvent
	{
		ushort[] data;
	}

	/**
	Sends data over the SPI bus.
	At the end of the transfer, a TransferEvent will be fired containing the
	data that was received.
	Params:
		data = The data to send. Should stay in memory until the TransferEvent
		has been fired.
	*/
	void write(const(ushort[]) data);
}