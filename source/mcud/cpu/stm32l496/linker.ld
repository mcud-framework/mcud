ENTRY(_irqs)

MEMORY
{
    flash (rx)  : ORIGIN = 0x08000000, LENGTH = 1M
    sram (rxw) : ORIGIN = 0x20000000, LENGTH = 320K
}

_stackStart = ORIGIN(sram) + LENGTH(sram);

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
    } > sram

    .bss : AT(ADDR(.data) + SIZEOF(.data))
    {
        _bss = .;
        *(.bss*)
        _ebss = .;
    } > sram
}