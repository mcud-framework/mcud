ENTRY(_start)

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
        LONG(_stackStart);
        *(.data._start)
        *(.text)
        *(.text*)
        
        . = ALIGN(4);

        *(.rodata)
        *(.rodata*)

    } > flash

    .data : AT(ADDR(.text) + SIZEOF(.text))
    {
        _data = .;
        *(.data)
        _edata = .;
    } > sram1
}