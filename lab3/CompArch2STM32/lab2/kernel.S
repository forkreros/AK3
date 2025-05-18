.syntax unified
.cpu cortex-m4
.thumb

.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
    .word __stack_start
    .word __kernel_reset__ + 1     // +1 = thumb mode
.size vtable_kernel, .-vtable_kernel

.section .rodata
data:       .asciz "kernel started!\n"
result_str: .asciz "Result: "

.section .text
__kernel_reset__:
    push {lr}

    ldr r0, =data
    bl dbgput_line

    // A = 10, B = 5, C = 2
    mov r0, #10        // A
    mov r1, #5         // B
    mov r2, #2         // C

    sub r3, r0, r1     // r3 = A - B
    mov r4, #3
    mul r3, r3, r4     // r3 = (A - B) * 3

    mov r4, #1
    lsl r4, r4, r2     // r4 = 2^C = 1 << C

    add r0, r3, r4     // r0 = final result

    ldr r1, =result_str
    mov r2, r0
    bl dbgput_result

infinite_loop:
    b infinite_loop

