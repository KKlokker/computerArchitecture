.global findNumbers
	
#Find the x until '/t' and y ending at '\n' and converting it into an integer
#Starts searching at r12 for coordinate until null pointer is reached
#Returns the y coordinate integer in rax, x in rbx and end address of y coordinate including linebreak in rdi
findNumbers:
	push %r12
	push %rsi
	push %rcx
	cmpq $10, (%r12)
	je EOF #Check if the given pointer is null pointer, which starts with a newline	
	convert:
	call convertNumber 
	movq %rax, %rbx
	call convertNumber
	jmp returnT
	EOF:
	movq $35000, %rax #Move out of range into number
	returnT:
	pop %rcx
	pop %rsi
	pop %r12
	ret

convertNumber:
	mov (%r12d), %esi
	sub $9, %sil
	cmp $1, %sil
	jg dontJump
	addq $1, %r12 #Jump over \t or \n
	dontJump:
	add $9, %sil
	movq $0, %rax
	convertLoop:
		mov (%r12d), %esi #Move value of address into rsi
		sub $9, %sil
		cmp $1, %sil #Exit if the next number is \n
		jle return
		add $9, %sil
		sub $48, %sil #Subtract 48 to convert from ascii to numerical
		imulq $10, %rax #Multiply the current sum with 10
		movq $0, %rcx
		add %sil, %cl #Move value into empty 64 bit register to coutner overflow errors
		addq %rcx, %rax #Add the next digit to the sum
		addq $1, %r12 #Move the r12 pointer 1 digit up
		jmp convertLoop
return:
	movq %r12, %rdi
	ret
 
