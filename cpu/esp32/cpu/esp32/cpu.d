module cpu.esp32.cpu;

template ESP32()
{

}

extern(C) void app_main()
{
	import mcud.core.system : startMCUd;
	startMCUd();
}