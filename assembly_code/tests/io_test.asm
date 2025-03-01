; Code from OS implementation by Aidan Garvey, 2022

.orig x3000

TRAP_GETC:
GETC_WAIT:
    ; wait for keyboard to be ready
    LDI     r1, KBD_STATUS
    ; ready bit is MSB so we loop until result is negative
    BRzp    GETC_WAIT
    LDI     r0, KBD_DATA
    ; clear keyboard ready bit
    LD      r2, MSB_MASK
    AND     r1, r1, r2
    STI     r1, KBD_STATUS
    ; ensure R0[15:8] are clear
    LD      r1, BYTE_MASK
    AND     r0, r0, r1

TRAP_OUT:
    ; ensure we only write lower byte to console
    LD      r1, BYTE_MASK
    AND     r0, r0, r1
OUT_WAIT:
    ; wait for display to be ready
    LDI     r1, CON_STATUS
    ; ready bit is MSB so we loop until result is negative
    BRzp    OUT_WAIT
    ; write character
    STI     r0, CON_DATA
	
; Device register addresses:
KBD_STATUS: .FILL xFE00
KBD_DATA:   .FILL xFE02
CON_STATUS: .FILL xFE04
CON_DATA:   .FILL xFE06
MCR:        .FILL xFFFE

; Constants (see bottom of code for more strings):
BYTE_MASK:  .FILL x00FF ; to clear the upper byte of a word
MSB_MASK:   .FILL x7FFF ; to clear the MSB of a word
NOTRAP_MSG: .STRINGZ "Invalid TRAP excecuted\n"
BAD_EX_MSG: .STRINGZ "An invalid interrupt or exception has occured\n"

.end