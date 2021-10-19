// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module cpu.stm32.periphs.rcc;

import board : board;
import cpu.capabilities;
import mcud.core.attributes;
import mcud.core.result;
import mcud.core.system;
import mcud.mem.volatile;
import mcud.util.frequency;

struct PeriphRCC(uint base)
{
	Volatile!(uint, base + 0x00) cr;
	Volatile!(uint, base + 0x04) icscr;
	Volatile!(uint, base + 0x08) cfgr;
	Volatile!(uint, base + 0x0C) pllcfgr;
	Volatile!(uint, base + 0x10) pllsai1cfgr;
	Volatile!(uint, base + 0x14) pllsai2cfgr;
	Volatile!(uint, base + 0x18) cier;
	Volatile!(uint, base + 0x1C) cifr;
	Volatile!(uint, base + 0x20) cicr;

	Volatile!(uint, base + 0x28) ahb1rstr;
	Volatile!(uint, base + 0x2C) ahb2rstr;
	Volatile!(uint, base + 0x30) ahb3rstr;
	Volatile!(uint, base + 0x38) apb1rstr1;
	Volatile!(uint, base + 0x3C) apb1rstr2;
	Volatile!(uint, base + 0x40) apb2rstr;

	Volatile!(uint, base + 0x48) ahb1enr;
	Volatile!(uint, base + 0x4C) ahb2enr;
	Volatile!(uint, base + 0x50) ahb3enr;
	Volatile!(uint, base + 0x58) apb1enr1;
	Volatile!(uint, base + 0x5C) apb1enr2;
	Volatile!(uint, base + 0x60) apb2enr;

	Volatile!(uint, base + 0x68) ahb1smenr;
	Volatile!(uint, base + 0x6C) ahb2smenr;
	Volatile!(uint, base + 0x70) ahb3smenr;
	Volatile!(uint, base + 0x78) apb1smenr1;
	Volatile!(uint, base + 0x7C) apb1smenr2;
	Volatile!(uint, base + 0x80) apb2smenr;

	Volatile!(uint, base + 0x88) ccipr;
	Volatile!(uint, base + 0x90) bdcr;
	Volatile!(uint, base + 0x94) csr;
	Volatile!(uint, base + 0x98) crrcr;
	Volatile!(uint, base + 0x9C) ccipr2;
}

enum RCC_AHB2ENR
{
	GPIOAEN = 1 << 0,
	GPIOBEN = 1 << 1,
	GPIOCEN = 1 << 2,
	GPIODEN = 1 << 3,
	GPIOEEN = 1 << 4,
	GPIOFEN = 1 << 5,
	GPIOGEN = 1 << 6,
	GPIOHEN = 1 << 7,
	GPIOIEN = 1 << 8,
	OTGFSEN = 1 << 12,
	ADCEN   = 1 << 13,
	DCMIEN  = 1 << 14,
	AES1EN  = 1 << 16,
	HASHEN  = 1 << 17,
	RNGEN   = 1 << 18,
}

enum RCC_APB1ENR1
{
	TIM2EN   = 1 << 0,
	TIM3EN   = 1 << 1,
	TIM4EN   = 1 << 2,
	TIM5EN   = 1 << 3,
	TIM6EN   = 1 << 4,
	TIM8EN   = 1 << 5,
	LCDEN    = 1 << 9,
	RTCAPBEN = 1 << 10,
	WWDGEN   = 1 << 11,
	SPI2EN   = 1 << 14,
	SPI3EN   = 1 << 15,
	USART2EN = 1 << 17,
	USART3EN = 1 << 18,
	UART4EN  = 1 << 19,
	UART5EN  = 1 << 20,
	I2C1EN   = 1 << 21,
	I2C2EN   = 1 << 22,
	I2C3EN   = 1 << 23,
	CRSEN    = 1 << 24,
	CAN1EN   = 1 << 25,
	CAN2EN   = 1 << 26,
	PWREN    = 1 << 28,
	DAC1EN   = 1 << 29,
	OPAMPEN  = 1 << 30,
	LPTIM1EN = 1 << 31,
}

enum RCC_APB1ENR2
{
	LPUART1EN = 1 << 0,
	I2C4EN    = 1 << 1,
	SWPMI1EN  = 1 << 2,
	LPTIM2EN  = 1 << 5,
}

enum RCC_APB2ENR
{
	SYSCFGEN = 1 << 0,
	FWEN     = 1 << 7,
	SDMMC1EN = 1 << 10,
	TIM1EN   = 1 << 11,
	SPI1EN   = 1 << 12,
	TIM8EN   = 1 << 13,
	USART1EN = 1 << 14,
	TIM15EN  = 1 << 16,
	TIM16EN  = 1 << 17,
	TIM17EN  = 1 << 18,
	SAI1EN   = 1 << 21,
	SAI2EN   = 1 << 22,
	DFSDM1EN = 1 << 24,
}

/**
Configures the clock.
*/
struct ClockTree
{
	/**
	A source of a clock signal.
	*/
	enum Source
	{
		unknown,
		HSE,
		HSI16,
		MSI,
		PLL,
	}

	/// The source of the sysclk clock.
	Source _sysclkSource = Source.unknown;
	
	/// The divisor for the APB1 clock.
	uint _apb1Prescale = 1;
	/// The configuration value for the APB1 prescaler.
	uint _cfgr_ppre1 = 0b000;

	/// The divisor for the HCLK1 clock.
	uint _hclk1Prescale = 1;
	/// The configuration value for the HCLK1 prescaler.
	uint _cfgr_hpre1 = 0b0000;
	
	/// The frequency of the MSI frequency.
	Frequency _msiFrequency = 4.mhz;

	/**
	Sets the source of the sysclk clock.
	*/
	ClockTree sysclkSource(Source source)
	{
		switch (source)
		{
		case Source.HSE:
		case Source.HSI16:
		case Source.MSI:
		case Source.PLL:
			_sysclkSource = source;
			return this;
		default:
			assert(0, "Unsupported clock source");
		}
	}

	Frequency sysclkFrequency()
	{
		switch (_sysclkSource)
		{
		case Source.MSI:
			return msiFrequency();
		default:
			assert(0, "Incomplete clock tree support");
		}
	}

	Frequency msiFrequency()
	{
		return _msiFrequency;
	}

	Frequency hclk1Frequency()
	{
		assert(_hclk1Prescale != -1, "No value for HCLK1 prescaler chosen");
		return sysclkFrequency() / _hclk1Prescale;
	}

	Frequency apb1Frequency()
	{
		assert(_apb1Prescale != -1, "No value for APB1 prescaler chosen");
		return hclk1Frequency() / _apb1Prescale;
	}

	ClockTree apb1Prescaler(uint prescaler)
	{
		_apb1Prescale = prescaler;
		switch (prescaler)
		{
		case 1:
			_cfgr_ppre1 = 0b000;
			break;
		case 2:
			_cfgr_ppre1 = 0b100;
			break;
		case 4:
			_cfgr_ppre1 = 0b101;
			break;
		case 8:
			_cfgr_ppre1 = 0b110;
			break;
		case 16:
			_cfgr_ppre1 = 0b111;
			break;
		default:
			assert(0, "Invalid APB1 prescaler");
		}
		return this;
	}

	ClockTree apb1Frequency(Frequency target)
	{
		assert(hclk1Frequency % target == 0, "Target frequency is not possible");
		return apb1Prescaler(cast(uint) (hclk1Frequency / target));
	}
}

template RCC(ClockTree config)
{
	private alias rcc = system.cpu.rcc;

	ClockTree.Source sysclkSource()
	{
		const cfgr = rcc.cfgr.load();
		switch ((cfgr >> 2) & 0b11)
		{
		case 0b00:
			return ClockTree.Source.MSI;
		case 0b01:
			return ClockTree.Source.HSI16;
		case 0b10:
			return ClockTree.Source.HSE;
		case 0b11:
			return ClockTree.Source.PLL;
		default:
			return ClockTree.Source.unknown;
		}
	}

	void init()
	{
		auto cfgr = rcc.cfgr.load();
		/// Sysclk source
		static if (config._sysclkSource != ClockTree.Source.unknown)
		{
			cfgr &= ~0b11;
			switch (config._sysclkSource)
			{
			case ClockTree.Source.MSI:
				cfgr |= 0b00;
				break;
			case ClockTree.Source.HSI16:
				cfgr |= 0b01;
				break;
			case ClockTree.Source.HSE:
				cfgr |= 0b10;
				break;
			case ClockTree.Source.PLL:
				cfgr |= 0b11;
				break;
			default:
			}
		}

		/// APB1 prescaler (PPRE1)
		cfgr &= ~(0b111 << 8);
		cfgr |= config._cfgr_ppre1;

		/// HCLK1 Prescaler (HPRE1)
		cfgr &= ~(0b1111 << 4);
		cfgr |= config._cfgr_hpre1;

		rcc.cfgr.store(cfgr);
	}
}

template RCCPeriph_(alias register, uint mask)
{
	static void start()
	{
		register.store(register.load() | mask);
	}

	static void stop()
	{
		register.store(register.load() & ~mask);
	}
}

template RCCPeriph(RCC_AHB2ENR device)
{
	alias RCCPeriph = RCCPeriph_!(board.cpu.rcc.ahb2enr, device);
}

template RCCPeriph(RCC_APB2ENR device)
{
	alias RCCPeriph = RCCPeriph_!(board.cpu.rcc.apb2enr, device);
}