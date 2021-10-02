/* This Source Code Form is subject to the terms of the Mozilla Public *
 * License, v. 2.0. If a copy of the MPL was not distributed with this *
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.           */

ENTRY(_irqs)

_stackStart = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
    .text :
    {
        PROVIDE(_text = .);
        LONG(_stackStart);
        *(.data._irqs)
        *(.text)
        *(.text*)
        
        . = ALIGN(4);

        *(.rodata)
        *(.rodata*)
        PROVIDE(_etext = .);
    } > FLASH

    .data : AT(ADDR(.text) + SIZEOF(.text))
    {
        PROVIDE(_data = .);
        *(.data*)
        PROVIDE(_edata = .);
    } > RAM

    .bss : AT(ADDR(.data) + SIZEOF(.data))
    {
        PROVIDE(_bss = .);
        *(.bss*)
        PROVIDE(_ebss = .);
    } > RAM
}