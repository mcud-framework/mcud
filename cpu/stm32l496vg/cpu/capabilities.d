// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module cpu.capabilities;

import cpu.stm32l496.capabilities;
public import cpu.stm32.periphs.gpio : AlternateFunction, GPIOPort;

/**
Gets the capabilities of the STM32L496VG.
*/
Capabilities capabilities()
{
	Capabilities caps = baseCapabilities();
	caps.mask.gpioA = 0b1111_1111_1111_1111;
	caps.mask.gpioB = 0b1111_1111_1111_1111;
	caps.mask.gpioC = 0b1111_1111_1111_1111;
	caps.mask.gpioD = 0b1111_1111_1111_1111;
	caps.mask.gpioE = 0b1111_1111_1111_1111;
	caps.mask.gpioH = 0b0000_0000_0000_1011;

	caps.alternateFunctions = AFBuilder()
		.pin(GPIOPort.a, 0)
			.af(1, AlternateFunction.TIM2_CH1)
			.af(2, AlternateFunction.TIM5_CH1)
			.af(3, AlternateFunction.TIM8_ETR)
			.af(7, AlternateFunction.USART2_CTS)
		.pin(GPIOPort.a, 1)
			.af(7, AlternateFunction.USART2_RTS_DE)
		.pin(GPIOPort.a, 9)
			.af(1, AlternateFunction.TIM1_CH2)
			.af(3, AlternateFunction.SPI2_SCK)
			.af(5, AlternateFunction.DCMI_D0)
			.af(7, AlternateFunction.USART1_TX)
			.af(11, AlternateFunction.LCD_COM1)
			.af(13, AlternateFunction.SAI1_FS_A)
			.af(14, AlternateFunction.TIM15_BKIN)
			.af(15, AlternateFunction.EVENTOUT)
		.pin(GPIOPort.a, 10)
			.af(1, AlternateFunction.TIM1_CH2)
			.af(5, AlternateFunction.DCMI_D1)
			.af(7, AlternateFunction.USART1_RX)
			.af(10, AlternateFunction.OTG_FS_ID)
			.af(11, AlternateFunction.LCD_COM2)
			.af(13, AlternateFunction.SAI1_SD_A)
			.af(14, AlternateFunction.TIM17_BKIN)
			.af(15, AlternateFunction.EVENTOUT)
		.build();

	return caps;
}