module cpu.esp32;

template ESP32()
{

}

extern(C) void app_main()
{
	import mcud.core.system : startMCUd;
	startMCUd();
}