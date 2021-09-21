module mcud.cpu.stm32.capabilities;

import mcud.core.system;

private alias cpu = system.cpu;

private bool hasMember(alias parent, string member)()
{
	return __traits(hasMember, parent, member);
}

bool hasCPUMember(string member)()
{
	return hasMember!(cpu, member);
}

bool hasGPIO(string port)()
{
	return hasMember!(cpu.GPIO, port);
}

bool hasOTGFS()
{
	return false;
}

bool hasADC()
{
	return false;
}

bool hasDCMI()
{
	return false;
}

bool hasAES()
{
	return false;
}

bool hasHash()
{
	return false;
}

bool hasRng()
{
	return false;
}