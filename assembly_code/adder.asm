.orig x3000

	ld R1 neg0
	not R1 R1
	add R1 R1 #1

	; Get first num, add raw val
	lea R0 p1
	puts
	getc
    out
	add R2 R1 R0

	; Get second num, add ASCII val
	lea R0 p2
	puts
	getc
    out
	add R2 R2 R0

	; Print result
	lea R0 res
	puts
	add R0 R2 #0
	out
	ld R0 nl
	out

	halt

p1: .stringz "#1: "
p2: .stringz "\n#2: "
nl: .fill xD
res: .stringz "\nS: "

neg0: .fill x30


.end