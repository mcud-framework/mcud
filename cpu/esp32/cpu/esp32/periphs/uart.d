// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module cpu.esp32.periphs.uart;

/**
Configures a UART.
*/
struct UartConfig
{
	/// The baud rate of a UART.
	uint m_baudrate;

	/**
	Sets the baud rate of the UART.
	Params:
		baudrate = The baud rate to use.
	Returns: This object.
	*/
	UartConfig baudrate(uint baudrate)
	{
		m_baudrate = baudrate;
		return this;
	}
}