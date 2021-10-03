module cpu.irq;

version (CORE_application)
{
	/**
	Set of IRQs supported by the NRF5340 application core.
	*/
	enum IRQ
	{
		reset = 0,
		nmi = 1,
		hardFault = 2,
		memManage = 3,
		busFault = 4,
		usageFault = 5,
		secureFault = 6,
		svcHandler = 10,
		debugMon = 11,
		pendSV = 13,
		systick = 14,
		fpu = 15,
		cache = 16,
		spu = 17,
		clockPower = 19,
		serial0 = 22,
		serial1 = 23,
		spim4 = 24,
		serial2 = 25,
		serial3 = 26,
		gpiote0 = 27,
		saadc = 28,
		timer0 = 29,
		timer1 = 30,
		timer2 = 31,
		rtc0 = 34,
		rtc1 = 35,
		wdt0 = 38,
		wdt1 = 39,
		comp = 40, lpcomp = 40,
		egu0 = 41,
		egu1 = 42,
		egu2 = 43,
		egu3 = 44,
		egu4 = 45,
		egu5 = 46,
		pwm0 = 47,
		pwm1 = 48,
		pwm2 = 49,
		pwm3 = 50,
		pdm0 = 52,
		i2s0 = 54,
		ipc = 55,
		qpsi = 56,
		nfct = 58,
		gpiote1 = 60,
		qdec0 = 64,
		qdec1 = 65,
		usbd = 67,
		usbregulator = 68,
		kmu = 70,
		cryptocell = 81
	}
}
else version (CORE_network)
{
	/**
	Set of IRQs support by the NRF5340 network core.
	*/
	enum IRQ
	{
		reset = -15,
		nmi = -14,
		hardFault = -13,
		memManage = -12,
		busFault = -11,
		usageFault = -10,
		secureFault = -9,
		svcHandler = -5,
		debugMonitor = -4,
		pendSV = -2,
		sysTick = -1,
		clockPower = 5,
		radio = 8,
		rng = 9,
		gpiote = 10,
		wdt = 11,
		timer0 = 12,
		ecb = 13,
		aar = 14, ccm = 14,
		temp = 16,
		rtc0 = 17,
		ipc = 18,
		serial0 = 19,
		egu0 = 20,
		rtc1 = 22,
		timer1 = 24,
		timer2 = 25,
		swi0 = 26,
		swi1 = 27,
		swi2 = 28,
		swi3 = 29,
	}
}
