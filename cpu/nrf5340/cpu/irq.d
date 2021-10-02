module cpu.irq;

/**
Set of IRQs supported by the NRF5340.
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
	systick = 14
}