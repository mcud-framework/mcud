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

	// The following alternate functions have been added for all pins:
	// - 3, 7
	// The following alternate functions are still missing one or more definitions:
	// - 0, 1, 2, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15
	caps.alternateFunctions = AFBuilder()
		// Port A
		.pin(GPIOPort.a, 0)
			.af(1, AlternateFunction.TIM2_CH1)
			.af(2, AlternateFunction.TIM5_CH1)
			.af(3, AlternateFunction.TIM8_ETR)
			.af(7, AlternateFunction.USART2_CTS)
		.pin(GPIOPort.a, 1)
			.af(7, AlternateFunction.USART2_RTS_DE)
		.pin(GPIOPort.a, 2)
			.af(7, AlternateFunction.USART2_TX)
		.pin(GPIOPort.a, 3)
			.af(7, AlternateFunction.USART2_RX)
		.pin(GPIOPort.a, 4)
			.af(7, AlternateFunction.USART3_CK)
		.pin(GPIOPort.a, 5)
			.af(3, AlternateFunction.TIM8_CH1N)
		.pin(GPIOPort.a, 6)
			.af(3, AlternateFunction.TIM8_BKIN)
			.af(7, AlternateFunction.USART3_CTS)
		.pin(GPIOPort.a, 7)
			.af(3, AlternateFunction.TIM8_CH1N)
		.pin(GPIOPort.a, 8)
			.af(7, AlternateFunction.USART1_CK)
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
		.pin(GPIOPort.a, 11)
			.af(7, AlternateFunction.USART1_CTS)
		.pin(GPIOPort.a, 12)
			.af(7, AlternateFunction.USART1_RTS_DE)
		.pin(GPIOPort.a, 15)
			.af(3, AlternateFunction.USART2_RX)
			.af(7, AlternateFunction.USART3_RTS_DE)

		// Port B
		.pin(GPIOPort.b, 0)
			.af(3, AlternateFunction.TIM8_CH2N)
			.af(7, AlternateFunction.USART3_CK)
		.pin(GPIOPort.b, 1)
			.af(3, AlternateFunction.TIM8_CH3N)
			.af(7, AlternateFunction.USART3_RTS_DE)
		.pin(GPIOPort.b, 3)
			.af(7, AlternateFunction.USART1_RTS_DE)
		.pin(GPIOPort.b, 4)
			.af(7, AlternateFunction.USART1_CTS)
		.pin(GPIOPort.b, 5)
			.af(3, AlternateFunction.CAN2_RX)
			.af(7, AlternateFunction.USART1_CK)
		.pin(GPIOPort.b, 6)
			.af(3, AlternateFunction.TIM8_BKIN2)
			.af(7, AlternateFunction.USART1_TX)
		.pin(GPIOPort.b, 7)
			.af(3, AlternateFunction.TIM8_BKIN)
			.af(7, AlternateFunction.USART1_RX)
		.pin(GPIOPort.b, 10)
			.af(3, AlternateFunction.I2C4_SCL)
			.af(7, AlternateFunction.USART3_TX)
		.pin(GPIOPort.b, 11)
			.af(3, AlternateFunction.I2C4_SDA)
			.af(7, AlternateFunction.USART3_RX)
		.pin(GPIOPort.b, 12)
			.af(3, AlternateFunction.TIM1_BKIN_COMP2)
			.af(7, AlternateFunction.USART3_CK)
		.pin(GPIOPort.b, 13)
			.af(7, AlternateFunction.USART3_CTS)
		.pin(GPIOPort.b, 14)
			.af(3, AlternateFunction.TIM8_CH2N)
			.af(7, AlternateFunction.USART3_RTS_DE)
		.pin(GPIOPort.b, 15)
			.af(3, AlternateFunction.TIM8_CH3N)

		// Port C
		.pin(GPIOPort.c, 1)
			.af(3, AlternateFunction.SPI2_MOSI)
		.pin(GPIOPort.c, 4)
			.af(7, AlternateFunction.USART3_TX)
		.pin(GPIOPort.c, 5)
			.af(7, AlternateFunction.USART3_RX)
		.pin(GPIOPort.c, 6)
			.af(7, AlternateFunction.TIM8_CH1)
		.pin(GPIOPort.c, 7)
			.af(7, AlternateFunction.TIM8_CH2)
		.pin(GPIOPort.c, 8)
			.af(7, AlternateFunction.TIM8_CH3)
		.pin(GPIOPort.c, 9)
			.af(7, AlternateFunction.TIM8_CH4)
		.pin(GPIOPort.c, 10)
			.af(7, AlternateFunction.USART3_TX)
		.pin(GPIOPort.c, 11)
			.af(7, AlternateFunction.USART3_RX)
		.pin(GPIOPort.c, 12)
			.af(7, AlternateFunction.USART3_CK)

		// Port D
		.pin(GPIOPort.d, 2)
			.af(7, AlternateFunction.USART3_RTS_DE)
		.pin(GPIOPort.d, 3)
			.af(3, AlternateFunction.SPI2_SCK)
			.af(7, AlternateFunction.USART2_CTS)
		.pin(GPIOPort.d, 4)
			.af(7, AlternateFunction.USART2_RTS_DE)
		.pin(GPIOPort.d, 5)
			.af(7, AlternateFunction.USART2_TX)
		.pin(GPIOPort.d, 6)
			.af(7, AlternateFunction.USART2_RX)
		.pin(GPIOPort.d, 7)
			.af(7, AlternateFunction.USART2_CK)
		.pin(GPIOPort.d, 8)
			.af(7, AlternateFunction.USART3_TX)
		.pin(GPIOPort.d, 9)
			.af(7, AlternateFunction.USART3_RX)
		.pin(GPIOPort.d, 10)
			.af(7, AlternateFunction.USART3_CK)
		.pin(GPIOPort.d, 11)
			.af(7, AlternateFunction.USART3_CTS)
		.pin(GPIOPort.d, 12)
			.af(7, AlternateFunction.USART3_RTS_DE)

		// Port G
		.pin(GPIOPort.g, 9)
			.af(7, AlternateFunction.USART1_TX)
		.pin(GPIOPort.g, 10)
			.af(7, AlternateFunction.USART1_RX)
		.pin(GPIOPort.g, 11)
			.af(7, AlternateFunction.USART1_CTS)
		.pin(GPIOPort.g, 12)
			.af(7, AlternateFunction.USART1_RTS_DE)
		.pin(GPIOPort.g, 13)
			.af(7, AlternateFunction.USART1_CK)

		// Port E
		.pin(GPIOPort.e, 14)
			.af(3, AlternateFunction.TIM1_BKIN2_COMP2)
		.pin(GPIOPort.e, 15)
			.af(3, AlternateFunction.TIM1_BKIN_COMP1)

		// Port F
		.pin(GPIOPort.f, 10)
			.af(3, AlternateFunction.QUADSPI_CLK)

		// Port H
		.pin(GPIOPort.h, 2)
			.af(3, AlternateFunction.QUADSPI_BK2_IO0)
		.pin(GPIOPort.h, 13)
			.af(3, AlternateFunction.TIM8_CH1N)
		.pin(GPIOPort.h, 14)
			.af(3, AlternateFunction.TIM8_CH2N)
		.pin(GPIOPort.h, 15)
			.af(3, AlternateFunction.TIM8_CH3N)

		// Port I
		.pin(GPIOPort.i, 2)
			.af(3, AlternateFunction.TIM8_CH4)
		.pin(GPIOPort.i, 3)
			.af(3, AlternateFunction.TIM8_ETR)
		.pin(GPIOPort.i, 4)
			.af(3, AlternateFunction.TIM8_BKIN)
		.pin(GPIOPort.i, 5)
			.af(3, AlternateFunction.TIM8_CH1)
		.pin(GPIOPort.i, 6)
			.af(3, AlternateFunction.TIM8_CH2)
		.pin(GPIOPort.i, 7)
			.af(3, AlternateFunction.TIM8_CH3)
		.build();

	return caps;
}