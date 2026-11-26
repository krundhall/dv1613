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

counter:
    .word 0

.text
.global _start

_start:
    BL draw
read:
    BL read_uart
    CMP r0, #'w'
    BLEQ counter_up
    CMP r0, #'s'
    BLEQ counter_down
    BL draw
    B read

draw:
    LDR r0, =SEV_DISP_BASE
    LDR r1, =counter
    LDR r2, =SEG_TABLE

    LDR r3, [r1]
    AND r1, r3, #15

    LDRB r1, [r2, r1]
    STR r1, [r0]
    BX lr

read_uart:
    LDR r1, =UART_CON
poll_loop:
    LDR r2, [r1]
    TST r2, #0x8000 //is bit 15 set?
    BEQ poll_loop

    AND r0, r2, #0xFF
    BX lr

counter_up:
    LDR r0, =counter
    LDR r1, [r0]
    ADD r1, r1, #1
    STR r1, [r0]
    BX lr
counter_down:
    LDR r0, =counter
    LDR r1, [r0]
    SUB r1, r1, #1
    STR r1, [r0]
    BX lr
    
    
 _halt:
     B _halt 