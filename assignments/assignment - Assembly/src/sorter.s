.data
	printBuffer: .zero 5 #5 byte print buffer for a maximum of 5 character print
	stat: .space 144 #size of fstat
.text
	.globl _start

_start:
	pop %r14 #Number of args 
	pop %r13 #pop command 
	sub $1, %r14
	cmpq $0x0, %r14
	je end #Jump to the end of file if it had read all files given
	pop %r12 #Filename argument in r12

	#Open file
	movq $1, %rdx #Reading flag
	movq $2, %rax #Open system call
	movq %r12, %rdi #Filename 
	movq $0, %rsi #Readonly opening
	syscall
	movq %rax, %rbx #Saving file descriptor in rbx

	#Find file size
	movq %rbx, %rdi #File descriptor
	movq $5, %rax #Fstat system call
	movq $stat, %rsi #Stat buffer
	syscall
	movq $stat, %rax #Stat block full of file info
	movq 48(%rax), %rax #Getting 48byte of the buffer which is the size		
	movq %rax, %r14 #Saving size in r14 register
	addq $1, %r14 #Make space for null at both ends of array in case of min. file	

	#Creating space by setting new end of data segment
	movq $12, %rax #Brk system call
	xorq %rdi, %rdi #Zero to get the current starting address
	syscall
	movq %rax, %r15 #Saving data segment start of file and later array
	addq %r14, %rax #Current data segment end address plus filesize
	movq %rax, %rdi #New data segment end address 
	movq $12, %rax #Brk system call
	syscall

	#Read file into buffer
	movq $0, %rax #Read system call
	movq %rbx, %rdi #File descripter
	movq %r15, %rsi #Filecontent
	movq %r14, %rdx #Filesize
	syscall

	#Close file
	movq $3, %rax
	movq %rbx, %rdi
	syscall		

	#Convert from coordinate to format [x,y] in integer form where x and y is 16 bit each
	movq %r15, %r14
	movq %r15, %rdi
	changeFormat:
		cmpq $0, (%rdi)
		je stopFormatChange
		movq %rdi, %r12
		call findNumbers #x in rbx and y in rax, end of coordinate in rdi
		cmpq $35000, %rax #change
		je stopFormatChange
		shlq $16, %rax
		addq %rbx, %rax
		mov %eax, (%r14d)
		addq $4, %r14
		jmp changeFormat
		
	stopFormatChange:
	#Sorting
	call heapSort #r14 end of array, r15 start of array
	#call quickSort
	#call insertSort
	writeLine:
		cmpq %r14, %r15
		je end	
		movq $printBuffer, %r8

		call print16
		movq $1, %rdx
		movq $9, (%r8) #Write \t
		call writeBuffer

		call print16
		movq $1, %rdx
		movq $10, (%r8) #Write \n
		call writeBuffer
		
		jmp writeLine
		
	#Prints the next 16bits from decimal to ascii
	print16:
		movq $printBuffer, %r13
		movq $0, (%r13)
		movq $0, %r11 #Print counter
		xorq %r10, %r10 #Register used to save if the start of the  number is reached such zeroes before are not printed
		movq $10000, %r12	#Max value was 32,767 therefore we start by dividing by 10,000 to get the first digit
		bitLoop:
			cmpq $0, %r12
			je ret #Return if we have found every digit and before dividing by 0

			#Get digit
			mov (%r15d), %ax #move first 16 bits into ax
			mov %r12w, %bx #move divisor into bx
			xor %edx, %edx #move 0 into edx due to it representing upper 16 bits in division
			div %bx 
		
			mov %dx, (%r15d) #move remainder into writing number
			cmp $0, %ax #Check if ax is 0 and therefore not update digit start register
			je zeroFound
			mov $1, %r10 #We are after first zeroes

			zeroFound:
			movq %r10, %rsi
			add %r12w, %si #Add divisor and boolen for if the first zero is found
			cmp $1, %si #In the case the number only consist of a zero then the last zero should be printed
			je printDigit
			movq %r10, %rsi
			add %ax, %si
			cmp $0, %si
			je skipPrint #Check if the digit should be printet by if the sum between r10 register and the digit is not 0

			printDigit:
			add $48, %al #Convert to ascii 
			mov %al, (%r13d) #Insert ascii to print buffer
			addq $1, %r13 #Move up in buffer
			addq $1, %r11 #Add 1 to amount of printet digits
			skipPrint:
			#Divide divisor with 10
			mov %r12w, %ax
			mov $10, %bx
			xor %edx, %edx
			div %bx
			mov %ax, %r12w
			jmp bitLoop
			
			ret:
			movq %r11, %rdx #Amount to write
			call writeBuffer
			addq $2, %r15 #Move up to next 16 bits
			ret

	writeBuffer:
		movq $printBuffer, %r13
		movq $1, %rax #write sys call
		movq %r13, %rsi #Filecontent address
		movq $1, %rdi #reading flag
		syscall
		ret
		
	end:
		# Syscall exit
		movq $60, %rax            # rax: int syscall number
		movq $0, %rdi             # rdi: int error code
		syscall
