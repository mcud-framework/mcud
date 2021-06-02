module mcud.cpu.stm32wb55.periphs.rcc;

import mcud.core.attributes;
import mcud.core.result;
import mcud.cpu.stm32wb55.cpu;
import mcud.mem.volatile;

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

template RCCPeriph(RCCDevice device)
if (device == RCCDevice.GPIOA || device == RCCDevice.GPIOB)
{
	__gshared uint count = 0;

	@forceinline
	Result!void start()
	{
		//if (count == 0)
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

struct RCC(uint base)
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