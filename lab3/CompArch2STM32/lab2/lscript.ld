/* STM32F407VG Linker Script */

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 1M
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}

/* Stack start at top of RAM */
__stack_start = ORIGIN(RAM) + LENGTH(RAM);
_ram_start = ORIGIN(RAM);
_ram_end   = ORIGIN(RAM) + LENGTH(RAM);

/* Sections */
SECTIONS
{
    /* Interrupt vector table and code */
    .text :
    {
        . = ALIGN(4);
        KEEP(*(.interrupt_vector))   /* vector table */
        *(.text)                     /* main code */
        *(.text*)                   /* other functions */
        *(.rodata)                  /* read-only data */
        *(.rodata*)                 
        . = ALIGN(4);
    } > FLASH

    /* Initialized data - copied from Flash to RAM at runtime */
    .data : AT (LOADADDR(.text) + SIZEOF(.text))
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data)
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > RAM

    _sidata = LOADADDR(.data); /* Source address in Flash for .data init */

    /* Uninitialized data - zeroed at startup */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > RAM

    /* Stack */
    .stack (COPY):
    {
        . = ALIGN(8);
        _sstack = .;
        . = . + 0x1000;  /* 4 KB stack */
        _estack = .;
    } > RAM

    /* Heap */
    .heap (COPY):
    {
        . = ALIGN(8);
        _sheap = .;
        . = . + 0x1000;  /* 4 KB heap */
        _eheap = .;
    } > RAM
}

