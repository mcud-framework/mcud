# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

ENTRY(_irqs)

MEMORY
{
    flash (rx)  : ORIGIN = 0x08000000, LENGTH = 4M
    sram1 (rxw) : ORIGIN = 0x20000000, LENGTH = 192K
    sram2 (rxw) : ORIGIN = 0x10000000, LENGTH = 64K
}

_stackStart = ORIGIN(sram2) + LENGTH(sram2);

SECTIONS
{
    .text :
    {
        _text = .;
        LONG(_stackStart);
        *(.data._irqs)
        *(.text)
        *(.text*)
        
        . = ALIGN(4);

        *(.rodata)
        *(.rodata*)
        _etext = .;
    } > flash

    .data : AT(ADDR(.text) + SIZEOF(.text))
    {
        _data = .;
        *(.data*)
        _edata = .;
    } > sram1

    .bss : AT(ADDR(.data) + SIZEOF(.data))
    {
        _bss = .;
        *(.bss*)
        _ebss = .;
    } > sram1
}