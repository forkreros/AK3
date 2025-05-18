.syntax unified
.cpu cortex-m4
.thumb
.global bootload

.section .rodata
image: .incbin "kernel.bin"
end_of_image:
str_boot_start: .asciz "bootloader started"
str_boot_end: .asciz "bootloader end"

.section .text
bootload:
    push {lr}

    ldr r0, =str_boot_start
    bl dbgput_line

    ldr r1, =image         // Beginning of kernel.bin
    ldr r2, =_ram_start    // Beginning of RAM
    ldr r3, =end_of_image  // End of kernel.bin

copy_loop:
    cmp r1, r3
    bcs copy_done

    ldr r4, [r1]
    str r4, [r2]
    add r1, r1, #4
    add r2, r2, #4
    b copy_loop

copy_done:
    ldr r0, =str_boot_end
    bl dbgput_line

    // Jump to reset handler of the core
    ldr r0, =_ram_start
    ldr r1, [r0, #4]    // address __kernel_reset__
    bx r1              // to the core

    // is not going back

