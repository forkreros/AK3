.syntax unified
.cpu cortex-m4
.thumb
.global lab1

//Constants
.equ A, 10
.equ B, 5
.equ C, 2

//(a - b)*3 + 2^c [TO BE DONE]
lab1:
    push {lr}

    mov r0, #A  //A to r0
    mov r1, #B  //B to r1
    mov r2, #C  //C to r2

    //(a - b) [r3 = a - b]
    sub r3, r0, r1

    //(r3 * 3) [r3 = (a - b) * 3]
    mov r4, #3
    mul r3, r3, r4

    //2^c [1 << c] [r4 = 1 << c = 2^c]
    mov r4, #1
    lsl r4, r4, r2

    //Result [r0 = (a-b)*3 + 2^c]
    add r0, r3, r4

    pop {pc}
