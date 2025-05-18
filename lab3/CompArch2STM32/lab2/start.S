.syntax unified
.cpu cortex-m4
.thumb

.global vtable
.global __hard_reset__

/*
 * Vector table
 */
.type vtable, %object
.section .interrupt_vector
vtable:
    .word __stack_start           // Initial stack pointer
    .word __hard_reset__ + 1      // Reset handler (thumb bit set)
    .size vtable, .-vtable

/*
 * Bootloader Reset Handler
 */
.type __hard_reset__, %function
.section .text
__hard_reset__:
    // Copy initialized data from flash (_sidata) to RAM (_sdata to _edata)
    ldr r0, =_sidata     // source in flash
    ldr r1, =_sdata      // destination start
    ldr r2, =_edata      // destination end
1:
    cmp r1, r2
    ittt lt
    ldrlt r3, [r0], #4
    strlt r3, [r1], #4
    blt 1b

    // Zero initialize .bss section (_sbss to _ebss)
    ldr r0, =_sbss
    ldr r1, =_ebss
2:
    cmp r0, r1
    itt lt
    movlt r2, #0
    strlt r2, [r0], #4
    blt 2b

    ldr r0, =d
    bl dbgput_line

    // Call bootloader code
    bl bootload

_loop:
    b _loop

    .size __hard_reset__, .-__hard_reset__

.data
d: .asciz "starting \n"
