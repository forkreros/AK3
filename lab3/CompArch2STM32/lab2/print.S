.syntax unified
.thumb
.cpu cortex-m4

// Constants of Semihosting
#define SEMIHOSTING_SYS_WRITE0 0x04
#define SEMIHOSTING             0xAB

// Data
.section .data
str_hex:        .asciz "0x00000000"    // Hex buffer
_newline_sym:   .asciz "\n\r"          // New line

// Text functions
.section .text
.global dbgput_line
.global dbgput
.global newline
.global dbgput_num
.global dbgput_result

// === dbgput_line ===
// Line output + new line
dbgput_line:
    push {lr}
    mov r1, r0                            // Argument:line
    mov r0, #SEMIHOSTING_SYS_WRITE0
    bkpt #SEMIHOSTING

    ldr r1, =_newline_sym
    mov r0, #SEMIHOSTING_SYS_WRITE0
    bkpt #SEMIHOSTING

    pop {pc}

// === dbgput ===
// Output a line without moving to a new line
dbgput:
    push {lr}
    mov r1, r0
    mov r0, #SEMIHOSTING_SYS_WRITE0
    bkpt #SEMIHOSTING
    pop {pc}

// === newline ===
// Output of a new line
newline:
    push {lr}
    ldr r1, =_newline_sym
    mov r0, #SEMIHOSTING_SYS_WRITE0
    bkpt #SEMIHOSTING
    pop {pc}

// === dbgput_num ===
// 32-bit number output
dbgput_num:
    push {r0-r4, lr}

    ldr r1, =str_hex      // Buffer "0x00000000"
    mov r2, #2            // Beginning point of recording
    mov r3, #0xF0000000   // Mask for older 4 bits

next_digit:
    and r4, r0, r3        // Selection of 4 bits
    lsr r4, r4, #28       // Shift to lower bits

    cmp r4, #10
    blo digit_0_9
    add r4, #7            // For 'A'..'F'

digit_0_9:
    add r4, #48           // ASCII-code
    strb r4, [r1, r2]     // Recording to buffer

    lsl r0, r0, #4        // Left shift
    add r2, r2, #1        // Next position
    cmp r2, #10
    blo next_digit

    ldr r1, =str_hex
    mov r0, #SEMIHOSTING_SYS_WRITE0
    bkpt #SEMIHOSTING

    bl newline

    pop {r0-r4, pc}

// === dbgput_result ===
// dbgput_result:
// Line output and a hex number after it
dbgput_result:
    push {r0-r2, lr}

    mov r0, r1        // Line
    bl dbgput

    mov r0, r2        // Number
    bl dbgput_num

    pop {r0-r2, pc}

