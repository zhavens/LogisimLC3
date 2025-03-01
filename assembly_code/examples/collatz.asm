; Implements step count for Collatz conjecture.
;
;	https://en.wikipedia.org/wiki/Collatz_conjecture
;
; Author: Zach Havens (2025)
;
; Errors if (storing -1):
;  - Starting value is negative
;  - Integer overflow
;  - The operation takes more than 150 steps
;
;	R0: Temp storage
;	R1: The current value
;	R2: Current step count
;	R3: -- unused --
;	R4: Working register for division
;	R5: -2, for dividing by 2
;	R6:	-maxsteps, for checking... max steps
;	R7: -1, for testing for exit condition

.orig x3000

	and R5 R5 #0	; place -2 in R5 for division by 2
	add R5 R5 #-2

	and R2 R2 #0
	ld R6 maxsteps ; place -maxsteps in R6 for checking infinite loops
	not R6 R6
	add R6 R6 #1

	and R7 R7 #0	; place -1 in R7 for checking end state
	add R7 R7 #-1

	ld R1 data
	brn error		; negative input = bad news

loop:
	add R0 R1 R7
	brz exit		; got to 1!
	
	add R2 R2 #1	; increment steps counter
	add R0 R2 R6
	brzp error		; Maximum number of steps!
	
	and R0 R1 #1	; test last bit of value
	brp odd

even:
	add R4 R1 #0	; copy value to R4
	and R1 R1 #0	; clear prev value for division result
evenDiv:
    add R1 R1 #1  ; increment quotient
    add R4 R4 R5  ; subtract divisor once
    brp evenDiv
	br  loop
	
odd:
	add R0 R1 #1    ; n+1
	add R1 R1 R1    ; 2n
	add R1 R1 R0    ; 3n+1
	brnz error		; Overflow!
	br loop

error:
	and R2 R2 #0
	add R2 R2 #-1

exit:
	st R2 steps
	halt

data .fill #447
maxsteps .fill #200
steps .blkw 1

.end