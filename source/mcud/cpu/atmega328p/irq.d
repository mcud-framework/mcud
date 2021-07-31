module mcud.cpu.atmega328p.irq;

import mcud.core.attributes;
import mcud.meta.functions;

/**
A list of all supported IRQs.
*/
enum IRQ
{
	/// External pin, power-on reset, brown-out reset
	/// and watchdog system reset.
	RESET,

	/// External interrupt request 0
	INT0,

	/// External interrupt request 1
	INT1,

	/// Pin change interrupt request 0
	PCINT0,

	/// Pin change interrupt request 1
	PCINT1,

	/// Pin change interrupt request 2
	PCINT2,

	/// Watchdog time-out interrupt
	WDT,

	/// Timer/Counter2 compare match A
	TIMER2_COMPA,

	/// Timer/Counter2 compare match B
	TIMER2_COMPB,

	/// Timer/Counter2 overflow
	TIMER2_OVF,

	/// Timer/Counter1 capture event
	TIMER1_CAPT,

	/// Timer/Counter1 compare match A
	TIMER1_COMPA,

	/// Timer/Counter1 compare match B
	TIMER1_COMPB,

	/// Timer/Counter1 overflow
	TIMER1_OVF,

	/// Timer/Counter0 compare match A
	TIMER0_COMPA,

	/// Timer/Counter0 compare match B
	TIMER0_COMPB,

	/// Timer/Counter0 overflow
	TIMER0_OVF,

	/// USART Rx complete
	USART_RX,

	/// USART data register empty
	USART_UDRE,

	/// USART Tx complete
	USART_TX,

	/// ADC conversion complete
	ADC,

	/// EEPROM ready
	EE_READY,

	/// Analog comparator
	ANALOG_COMP,

	/// 2-wire serial interface
	TWI,

	/// Store program memory ready
	SPM_READY,
}

version (unittest) {}
else
{
	void isr_handler(IRQ irq)
	{
		allFunctions!(irq, system);
	}
}