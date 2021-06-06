module mcud.cpu.stm32wb55.periphs.rcc;

import mcud.core.attributes;
import mcud.core.result;
import mcud.cpu.stm32wb55.cpu;
import mcud.mem.volatile;
import mcud.util.frequency;

struct PeriphRCC(uint base)
{
	Volatile!(uint, base + 0x000) cr;
	Volatile!(uint, base + 0x004) icscr;
	Volatile!(uint, base + 0x008) cfgr;
	Volatile!(uint, base + 0x00C) pllcfgr;
	Volatile!(uint, base + 0x010) pllsai1cfgr;
	Volatile!(uint, base + 0x018) cier;
	Volatile!(uint, base + 0x01C) cifr;
	Volatile!(uint, base + 0x020) cicr;
	Volatile!(uint, base + 0x024) smpscr;

	Volatile!(uint, base + 0x028) ahb1rstr;
	Volatile!(uint, base + 0x02C) ahb2rstr;
	Volatile!(uint, base + 0x030) ahb3rstr;
	Volatile!(uint, base + 0x038) apb1rstr1;
	Volatile!(uint, base + 0x03C) apb1rstr2;
	Volatile!(uint, base + 0x040) apb2rstr;
	Volatile!(uint, base + 0x044) apb3rstr;

	Volatile!(uint, base + 0x048) ahb1enr;
	Volatile!(uint, base + 0x04C) ahb2enr;
	Volatile!(uint, base + 0x050) ahb3enr;
	Volatile!(uint, base + 0x058) apb1enr1;
	Volatile!(uint, base + 0x05C) apb1enr2;
	Volatile!(uint, base + 0x060) apb2enr;
	
	Volatile!(uint, base + 0x068) ahb1smenr;
	Volatile!(uint, base + 0x06C) ahb2smenr;
	Volatile!(uint, base + 0x070) ahb3smenr;
	Volatile!(uint, base + 0x078) apb1smenr1;
	Volatile!(uint, base + 0x07C) apb1smenr2;
	Volatile!(uint, base + 0x080) apb2smenr;

	Volatile!(uint, base + 0x088) ccipr;
	Volatile!(uint, base + 0x090) bdcr;
	Volatile!(uint, base + 0x094) csr;
	Volatile!(uint, base + 0x098) crrcr;
	Volatile!(uint, base + 0x09C) hsecr;
	Volatile!(uint, base + 0x108) extcfgr;

	Volatile!(uint, base + 0x148) c2ahb1enr;
	Volatile!(uint, base + 0x14C) c2ahb2enr;
	Volatile!(uint, base + 0x150) c2ahb3enr;
	Volatile!(uint, base + 0x158) c2apb1enr1;
	Volatile!(uint, base + 0x15C) c2apb1enr2;
	Volatile!(uint, base + 0x160) c2apb2enr;
	Volatile!(uint, base + 0x164) c2apb3enr;
	Volatile!(uint, base + 0x168) c2ahb1smenr;
	Volatile!(uint, base + 0x170) c2ahb2smenr;
	Volatile!(uint, base + 0x178) c2apb1smenr1;
	Volatile!(uint, base + 0x17C) c2apb1smenr2;
	Volatile!(uint, base + 0x180) c2apb2smenr;
	Volatile!(uint, base + 0x184) c2apb3smenr;
}

enum RCC_AHB2ENR
{
	GPIOAEN = 0x0_0001,
	GPIOBEN = 0x0_0002,
	GPIOCEN = 0x0_0004,
	GPIODEN = 0x0_0008,
	GPIOEEN = 0x0_0010,
	GPIOHEN = 0x0_0080,
	ADCEN   = 0x0_2000,
	AES1EN  = 0x1_0000,
}

enum RCCDevice
{
	// AHB2ENR
	GPIOA = RCC_AHB2ENR.GPIOAEN,
	GPIOB = RCC_AHB2ENR.GPIOBEN,
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
	import mcud.cpu.stm32wb55.cpu : cpu;

	private enum rcc = cpu.rcc;

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

template RCCPeriph(RCCDevice device)
if (device == RCCDevice.GPIOA || device == RCCDevice.GPIOB)
{
	__gshared uint count = 0;

	@forceinline
	Result!void start()
	{
		{
			auto value = cpu.rcc.ahb2enr.load();
			value |= device;
			cpu.rcc.ahb2enr.store(value);
		}
		count++;
		return ok!void;
	}

	@forceinline
	Result!void stop()
	{
		if (count == 1)
		{
			auto value = cpu.rcc.ahb2enr.load();
			value &= ~device;
			cpu.rcc.ahb2enr.store(value);
		}
		count--;
		return ok!void;
	}
}