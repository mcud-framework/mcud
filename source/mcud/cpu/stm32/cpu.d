module mcud.cpu.stm32.cpu;

import mcud.cpu.stm32.capabilities;

static assert(hasCPUMember!"GPIO", "CPU has no GPIO definition");
static assert(hasGPIO!"unset", "GPIO enum has no 'unset' value");