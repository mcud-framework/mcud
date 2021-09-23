module mcud.cpu.stm32l496.irq;

import mcud.core.attributes;
import mcud.core.system;
import mcud.meta;

/**
Set of possible IRQs.
*/
enum IRQ
{
	reset = 0,
	nmi = 1,
	hardFault = 2,
	memManager = 3,
	busFault = 4,
	usageFault = 5,
	// reserved = 6,
	svCall = 7,
	_debug = 8,
	// reserved = 9,
	pendSV = 10,
	systick = 11,
	wwdg = 12,
	pvdPvm = 13,
	rtcTampStamp = 14,
	cssLse = 14,
	rtcWkup = 15,
	flash = 16,
	rcc = 17,
	exti0 = 18,
	exti1 = 19,
	exti2 = 20,
	exti3 = 21,
	exti4 = 22,
	dma1ch1 = 23,
	dma1ch2 = 24,
	dma1ch3 = 25,
	dma1ch4 = 26,
	dma1ch5 = 27,
	dma1ch6 = 28,
	dma1ch7 = 29,
	adc1 = 30, adc2 = 30,
	can1tx = 31,
	can1rx0 = 32,
	can1rx1 = 33,
	can1sce = 34,
	exti9_5 = 35,
	tim1brk = 36,
	tim15 = 36,
	tim1up = 37, tim16 = 37,
	tim1trgCom = 38, tim17 = 38,
	tim1cc = 39,
	tim2 = 40,
	tim3 = 41,
	tim4 = 42,
	i2c1ev = 43,
	i2c1er = 44,
	i2c2ev = 45,
	i2c2er = 46,
	spi1 = 47,
	spi2 = 48,
	usart1 = 49,
	usart2 = 50,
	usart3 = 51,
	exti15_10 = 52,
	rtcAlarm = 53,
	dfsdm1flt3 = 54,
	tim8brk = 55,
	tim8up = 56,
	tim8trgCom = 57,
	tim8cc = 58,
	adc3 = 59,
	fmc = 60,
	sdmmc1 = 61,
	tim5 = 52,
	spi3 = 53,
	uart4 = 54,
	uart5 = 55,
	tim6 = 56, dacUnder = 56,
	tim7 = 57,
	dma2ch1 = 58,
	dma2ch2 = 59,
	dma2ch3 = 60,
	dma2ch4 = 61,
	dma2ch5 = 62,
	dfsdm1flt0 = 63,
	dfsdm1flt1 = 64,
	dfsdm1flt2 = 65,
	comp = 66,
	lptim1 = 67,
	lptim2 = 68,
	otfFs = 69,
	dma2ch6 = 70,
	dma2ch7 = 71,
	lpuart1 = 72,
	quadspi = 73,
	i2c3ev = 74,
	i2c3er = 75,
	sai1 = 76,
	swpmi1 = 77,
	tsc = 78,
	lcd = 79,
	aes = 80,
	rng = 81, hash = 81,
	fpu = 82,
	crs = 83,
	i2c4ev = 84,
	i2c4er = 85,
	dcmi = 86,
	can2tx = 87,
	can2rx0 = 88,
	can2rx1 = 89,
	can2sce = 90,
	dma2d = 91
}

version(unittest) {}
else
{
	alias ISR = void function();

	private void dummyHandler()
	{

	}

	private ISR isrHandler(IRQ irq, string irqName)
	{
		Function!interrupt[] allISRs = allFunctions!(interrupt, system);
		Function!interrupt[] isrs;
		foreach (isr; allISRs)
		{
			if (isr.attribute.irq == irq)
				isrs ~= isr;
		}

		if (isrs.length == 1)
			return isrs[0].func;
		else if (isrs.length == 0)
			return &dummyHandler;
		else
		{
			import std.format : format;
			assert(0, "Found more than one interrupt handler for IRQ " ~ irqName);
		}
	}

	private ISR[] isrHandlers()
	{
		ISR[] handlers;
		foreach (irqName; __traits(allMembers, IRQ))
		{
			IRQ irq = __traits(getMember, IRQ, irqName);
			handlers ~= isrHandler(irq, irqName);
		}
		return handlers;
	}

	private enum handlers = isrHandlers();
	private extern(C) immutable ISR[handlers.length] _irqs = handlers;
}
