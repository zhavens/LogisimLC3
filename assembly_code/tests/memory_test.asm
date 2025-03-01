.orig x3000

	ld R1 value
	lea R2 array
	ldr R3 R2 #2
	ldi R4 array

	and R1 R1 #0
	st R1 value
	str R1 R2 #2
	sti R1 array 

	halt

value: .fill 42
array: .fill data
	   .fill 99
	   .fill 11
	   .fill -40
data:  .fill 101
.end