/* This Source Code Form is subject to the terms of the Mozilla Public *
 * License, v. 2.0. If a copy of the MPL was not distributed with this *
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.           */

ENTRY(_irqs)

MEMORY
{
    flash (rx) : ORIGIN = 0x08000000, LENGTH = 1M
    sram (rxw) : ORIGIN = 0x20000000, LENGTH = 320K
}

_stackStart = ORIGIN(sram) + LENGTH(sram);

SECTIONS
{
    .text :
    {
        PROVIDE(__start_text = .);
        LONG(_stackStart);
        *(.irq*)
        *(.text)
        *(.text*)

        . = ALIGN(4);

        *(.rodata)
        *(.rodata*)
        PROVIDE(__stop_text = .);
    } > flash

    .data : AT(ADDR(.text) + SIZEOF(.text))
    {
        PROVIDE(__start_data = .);
        *(.data*)
        PROVIDE(__stop_data = .);
    } > sram

    .bss : AT(ADDR(.data) + SIZEOF(.data))
    {
        PROVIDE(__start_bss = .);
        *(.bss*)
        PROVIDE(__stop_bss = .);
    } > sram
}