ENTRY(boot);
OUTPUT_FORMAT(elf32-i386);
OUTPUT_ARCH(i386);
SECTIONS
{
    . = 0x7E00;

    .text : AT(0x7E00)
    {
        _start = .;
        BYTE(0xE9);
        LONG(boot - _start - 5);
        *(.text)
    }
    
    .data :
    {
        *(.bss);
        *(.bss*);
        *(.data);
        *(.rodata*);
        *(COMMON);
    }  
    /DISCARD/ :
    {
        *(.note*);
        *(.iplt*);
        *(.igot*);
        *(.rel*);
        *(.comment);  
    }
}