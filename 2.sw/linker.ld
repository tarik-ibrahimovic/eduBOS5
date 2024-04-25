MEMORY
{
    rom (rx)  : ORIGIN = 0x000000000, LENGTH = 0x800       /*2kB IMEM*/
    ram (xrw) : ORIGIN = 0x000000000, LENGTH = 0x800       /*2kB DMEM*/
}
SECTIONS
{
    .text ALIGN(4) : { *(.text) } > rom
    
    /* data LMA = ., data VMA - 0x000000000*/
    .data :{    
       /* __sdata=.;  for start code */
        . = ALIGN(4);
        *(.data)
    } > ram AT > rom

    .bss :{                                 
        . = ALIGN(4);
        __bss_start = .;
        *(.bss)
    } > ram

    _end = .;
}