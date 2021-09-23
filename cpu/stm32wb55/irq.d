module mcud.cpu.stm32wb55.irq;

import mcud.core.attributes;
import mcud.core.system;
import mcud.meta;

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
	pvd = 13,
	pvm1 = 13,
	pvm3 = 13,
	tamp = 14,
	rtcStamp = 14,
	lseCss = 14,
	rtcWkup = 15,
	flash = 16,
	rcc = 17,
	exti0 = 18,
	exti1 = 19,
	exti2 = 20,
	exti3 = 21,
	exti4 = 22,
	dma1Channel1 = 23,
	dma1Channel2 = 24,
	dma1Channel3 = 25,
	dma1Channel4 = 26,
	dma1Channel5 = 27,
	dma1Channel6 = 28,
	dma1Channel7 = 29,
	adc1 = 30,
	usbHp = 31,
	usbLp = 32,
	c2sev = 33,
	pwrC2h = 34,
	comp = 35,
	exti5 = 36,
	exti6 = 37,
	exti7 = 38,
	exti8 = 39,
	exti9 = 40,
	tim1Brk = 41,
	tim1Up = 42,
	tim16 = 42,
	tim1TrgCom = 43,
	tim17 = 43,
	tim1Cc = 44,
	tim2 = 45,
	pka = 46,
	i2c1Event = 47,
	i2cError = 48,
	i2c3Event = 49,
	i2c3Error = 50,
	spi1 = 51,
	spi2 = 52,
	usart1 = 53,
	lpuart1 = 54,
	sai1 = 55,
	tsc = 56,
	exti10 = 57,
	exti11 = 58,
	exti12 = 59,
	exti13 = 60,
	exti14 = 61,
	exti15 = 62,
	rtcAlarm = 63,
	crsIt = 64,
	pwrSotf = 65,
	pwrBleAct = 65,
	pwr802Act = 65,
	pwrRfPhase = 65,
	ipccC1RxIt = 66,
	ipccC1TxIt = 67,
	hsem = 68,
	lptim1 = 69,
	lptim2 = 70,
	lcd = 71,
	quadSpi = 72,
	aes1 = 73,
	aes2 = 74,
	trueRng = 75,
	fpu = 76,
	dma2Channel1 = 77,
	dma2Channel2 = 78,
	dma2Channel3 = 79,
	dma2Channel4 = 80,
	dma2Channel5 = 81,
	dma2Channel6 = 82,
	dma2Channel7 = 83,
	dmaMux1Ovr = 84,
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

	private extern(C) immutable ISR[] _irqs = isrHandlers();
}
