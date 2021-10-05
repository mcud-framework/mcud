module cpu.nrf5340.cpu;

import cpu.nrf5340.periphs;
import mcud.core.interrupts;

/**
The NRF5340 CPU.
*/
template NRF5340()
{
	version (CORE_application)
	{
		/// GPIO Port 0
		PeriphGPIO!0x50842500 p0;
		/// GPIO Port 1
		PeriphGPIO!0x50842800 p1;
	}
	else version (CORE_network)
	{
		/// GPIO Port 0
		PeriphGPIO!0x418C0500 p0;
		/// GPIO Port 1
		PeriphGPIO!0x418C0800 p1;
	}

	@interrupt(IRQ.reset)
	void onReset()
	{
		import mcud.core.system : startMCUd;
		startMCUd();
	}
}