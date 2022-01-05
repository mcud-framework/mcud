module idf.soc.soc;

import idf.common.esp_bit_defs;

enum APB_CLK_FREQ_ROM = 26 * 1000000;
enum CPU_CLK_FREQ_ROM = APB_CLK_FREQ_ROM;
/// This may be incorrect, please refer to ESP32_DEFAULT_CPU_FREQ_MHZ
enum CPU_CLK_FREQ = APB_CLK_FREQ;
/// Unit: Hz
enum APB_CLK_FREQ = 80 * 1000000;
enum REF_CLK_FREQ = 1000000;
enum UART_CLK_FREQ = APB_CLK_FREQ;
enum WDT_CLK_FREQ = APB_CLK_FREQ;
/// 80MHz divided by 16
enum TIMER_CLK_FREQ = 80000000 >> 4;
enum SPI_CLK_DIV = 4;
/// CPU is 80MHz
enum TICKS_PER_US_ROM = 26;
enum GPIO_MATRIX_DELAY_NS = 25;
