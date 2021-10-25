// Copyright 2010-2016 Espressif Systems (Shanghai) PTE LTD
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
module idf.driver.gpio;

// #define GPIO_REG_READ(reg)              READ_PERI_REG(reg)
// #define GPIO_REG_WRITE(reg, val)        WRITE_PERI_REG(reg, val)
// #define GPIO_ID_PIN0                    0
// #define GPIO_ID_PIN(n)                  (GPIO_ID_PIN0+(n))
// #define GPIO_PIN_ADDR(i)                (GPIO_PIN0_REG + i*4)

// #define GPIO_FUNC_IN_HIGH               0x38
// #define GPIO_FUNC_IN_LOW                0x30

// #define GPIO_ID_IS_PIN_REGISTER(reg_id) \
//     ((reg_id >= GPIO_ID_PIN0) && (reg_id <= GPIO_ID_PIN(GPIO_PIN_COUNT-1)))

// #define GPIO_REGID_TO_PINIDX(reg_id) ((reg_id) - GPIO_ID_PIN0)

enum GPIO_INT_TYPE
{
    DISABLE = 0,
    POSEDGE = 1,
    NEGEDGE = 2,
    ANYEDGE = 3,
    LOLEVEL = 4,
    HILEVEL = 5
}

// #define GPIO_OUTPUT_SET(gpio_no, bit_value) \
//         ((gpio_no < 32) ? gpio_output_set(bit_value<<gpio_no, (bit_value ? 0 : 1)<<gpio_no, 1<<gpio_no,0) : \
//                          gpio_output_set_high(bit_value<<(gpio_no - 32), (bit_value ? 0 : 1)<<(gpio_no - 32), 1<<(gpio_no -32),0))
// #define GPIO_DIS_OUTPUT(gpio_no)    ((gpio_no < 32) ? gpio_output_set(0,0,0, 1<<gpio_no) : gpio_output_set_high(0,0,0, 1<<(gpio_no - 32)))

bool GPIO_INPUT_GET(ubyte gpio_no) @safe pure
{
	return ((gpio_no < 32) ? ((gpio_input_get() >> gpio_no) & BIT0) : ((gpio_input_get_high() >> (gpio_no - 32)) & BIT0));
}

/// GPIO interrupt handler, registered through gpio_intr_handler_register
alias gpio_intr_handler_fn_t = void function(uint intr_mask, bool high, void* arg);

/**
Initialize GPIO. This includes reading the GPIO Configuration DataSet
to initialize "output enables" and pin configurations for each gpio pin.
Please do not call this function in SDK.
*/
void gpio_init();

/**
Change GPIO(0-31) pin output by setting, clearing, or disabling pins, GPIO0<->BIT(0).
There is no particular ordering guaranteed; so if the order of writes is significant,
calling code should divide a single call into multiple calls.
Params:
	set_mask = the gpios that need high level.
	clear_mask = the gpios that need low level.
	enable_mask = the gpios that need be changed.
	disable_mask = the gpios that need diable output.
*/
void gpio_output_set(uint set_mask, uint clear_mask, uint enable_mask, uint disable_mask);

/**
Change GPIO(32-39) pin output by setting, clearing, or disabling pins, GPIO32<->BIT(0).
There is no particular ordering guaranteed; so if the order of writes is significant,
calling code should divide a single call into multiple calls.
Params:
	set_mask = the gpios that need high level.
	clear_mask = the gpios that need low level.
	enable_mask = the gpios that need be changed.
	disable_mask = the gpios that need diable output.
*/
void gpio_output_set_high(uint set_mask, uint clear_mask, uint enable_mask, uint disable_mask);

/**
Sample the value of GPIO input pins(0-31) and returns a bitmask.
Returns: bitmask for GPIO input pins, BIT(0) for GPIO0.
*/
uint gpio_input_get();

/**
Sample the value of GPIO input pins(32-39) and returns a bitmask.
Returns: bitmask for GPIO input pins, BIT(0) for GPIO32.
*/
uint gpio_input_get_high();

/**
Register an application-specific interrupt handler for GPIO pin interrupts.
Once the interrupt handler is called, it will not be called again until after a call to gpio_intr_ack.
Please do not call this function in SDK.
Params:
	fn = gpio application-specific interrupt handler
	arg = gpio application-specific interrupt handler argument.
*/
void gpio_intr_handler_register(gpio_intr_handler_fn_t fn, void* arg);

/**
Get gpio interrupts which happens but not processed.
Please do not call this function in SDK.
Returns: bitmask for GPIO pending interrupts, BIT(0) for GPIO0.
*/
uint gpio_intr_pending();

/**
Get gpio interrupts which happens but not processed.
Please do not call this function in SDK.
Returns: bitmask for GPIO pending interrupts, BIT(0) for GPIO32.
*/
uint gpio_intr_pending_high();

/**
Ack gpio interrupts to process pending interrupts.
Please do not call this function in SDK.
Params:
	ack_mask = bitmask for GPIO ack interrupts, BIT(0) for GPIO0.
*/
void gpio_intr_ack(uint ack_mask);

/**
Ack gpio interrupts to process pending interrupts.
Please do not call this function in SDK.
Params:
	ack_mask = bitmask for GPIO ack interrupts, BIT(0) for GPIO32.
*/
void gpio_intr_ack_high(uint ack_mask);

/**
Set GPIO to wakeup the ESP32.
Please do not call this function in SDK.
Params:
	i = gpio number.
	intr_state = only GPIO_PIN_INTR_LOLEVEL\GPIO_PIN_INTR_HILEVEL can be used
*/
void gpio_pin_wakeup_enable(uint i, GPIO_INT_TYPE intr_state);

/**
Disable GPIOs to wakeup the ESP32.
Please do not call this function in SDK.
*/
void gpio_pin_wakeup_disable();

/**
Set gpio input to a signal, one gpio can input to several signals.
Params:
	gpio = gpio number, 0~0x27
	       gpio == 0x30, input 0 to signal
	       gpio == 0x34, ???
	       gpio == 0x38, input 1 to signal
	signal_idx = signal index.
	inv = the signal is inv or not
*/
void gpio_matrix_in(uint gpio, uint signal_idx, bool inv);

/**
Set signal output to gpio, one signal can output to several gpios.
Params:
	gpio = gpio number, 0~0x27
	signal_idx = signal index. signal_idx == 0x100, cancel output put to the gpio
	out_inv = the signal output is inv or not
	oen_inv = the signal output enable is inv or not
*/
void gpio_matrix_out(uint gpio, uint signal_idx, bool out_inv, bool oen_inv);

/**
Select pad as a gpio function from IOMUX.
Params:
	gpio_num = gpio number, 0~0x27
*/
void gpio_pad_select_gpio(ubyte gpio_num);

/**
Set pad driver capability.
Params:
	gpio_num = gpio number, 0~0x27
 	drv = 0-3
*/
void gpio_pad_set_drv(ubyte gpio_num, ubyte drv);

/**
Pull up the pad from gpio number.
Params:
	gpio_num = gpio number, ~0x27
*/
void gpio_pad_pullup(ubyte gpio_num);

/**
Pull down the pad from gpio number.

Params:
	gpio_num = gpio number, 0~0x27
*/
void gpio_pad_pulldown(ubyte gpio_num);

/**
Unhold the pad from gpio number.
Params:
	gpio_num = gpio number, 0~0x27
*/
void gpio_pad_unhold(ubyte gpio_num);

/**
Hold the pad from gpio number.
Params:
	gpio_num = gpio number, 0~0x27
*/
void gpio_pad_hold(ubyte gpio_num);
