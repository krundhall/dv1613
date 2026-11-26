.equ LEDS_BASE, 0xff200000
.equ SWITCH_BASE, 0xff200040
.equ SEV_DISP_BASE, 0xff200020
.equ SEV_DISP_BASE2, 0xff200030

.equ UART_CON, 0xff201000

.data
SEG_TABLE:
    .byte 0b0111111 //0
    .byte 0b0000110 //1
    .byte 0b1011011 //2
    .byte 0b1001111 //3
    .byte 0b1100110 //4
    .byte 0b1101101 //5
    .byte 0b1111101 //6
    .byte 0b0000111 //7
    .byte 0b1111111 //8
    .byte 0b1100111 //9

    .byte 0b1110111 //a
    .byte 0b1111100 //b
    .byte 0b0111001 //c
    .byte 0b1011110 //d
    .byte 0b1111001 //e
    .byte 0b1110001 //f


.text
.global _start

_start:
    // BL reset
    LDR r4, =SEG_TABLE // ARRAY
    MOV r5, #0           // COUNTER
read:
    LDR r0, =UART_CON

wait:
    LDR r1, [r0]
    TST r1, #0x8000 // is bit 15 set?
    BEQ wait // if not, check again //77 Counter go up // 73 counter go down

    AND r2, r1, #0xFF
    CMP r2, #'w'
    BEQ UP
    CMP r2, #'s'
    BEQ DOWN
    B read

UP:
    ADD r5, #1
    B draw

DOWN:
    SUB r5, #1
    B draw

draw:
    LDR r0, =SEV_DISP_BASE

    AND r5, r5, #15

    LDRB r3, [r4, r5]
    STR r3, [r0]
    B read



/*
reset:
    LDR r0, =0x3F3F3F3F
    LDR r1, =SEV_DISP_BASE
    STR r0, [r1]

    LDR r0, =0x00003F3F
    LDR r1, =SEV_DISP_BASE2
    STR r0, [r1]

    BX lr
*/

    
    
 _halt:
     B _halt 