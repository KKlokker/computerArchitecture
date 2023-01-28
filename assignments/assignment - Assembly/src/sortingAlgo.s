.global insertSort, quickSort, heapSort

heapSort:
	movq $0, %rbp
	movq %r14, %r13
	subq %r15, %r13
	subq $4, %r13 #Get lower half so heap is not called on leafs
	shrq %r13 #divide by 2
	movq %r13, %rax
	xorq %rdx, %rdx
	movq $4, %rbx
	divq %rbx #Check if divisible by four, if not add 2 such it lines up with coordinates
	cmpq $0, %rdx
	je initBuildHeap
	addq $2, %r13
	initBuildHeap:
	addq %r15, %r13 #Convert to address
	buildHeap: #Go from leaves to root and call maxHeapify
		call maxHeapify
		subq $4, %r13
		cmpq %r15, %r13
		jge buildHeap
	heapLoop: #Take out largest element, switch with end and limit array by 1
	mov (%r15d), %ecx
	mov -4(%r14d), %edx
	mov %ecx, -4(%r14d)
	mov %edx, (%r15d)
	subq $4, %r14
	movq %r15, %r13
	call maxHeapify #Call maxHeapify on array but one shorter
	cmpq %r14, %r15 #Check if end is reached
	jne heapLoop
	pop %r14
	ret

maxHeapify:
	push %r13
	movq %r13, %r9
	subq %r15, %r9 #amount into array
	movq %r9, %r12 
	addq %r12, %r12 
	addq %r15, %r12 #back to address
	addq $4, %r12 #Left node
	movq %r12, %r11
	addq $4, %r11 #RightNode 
	cmpq %r14, %r12
	jge rootLargest
	movq 2(%r13), %rax
	movq 2(%r12), %rbx
	cmp %ax, %bx
	jle rootLargest
	movq %r12, %r10 #Left node is larger than root
	jmp testRight
	rootLargest:
	movq %r13, %r10
		
	testRight:
	cmpq %r14, %r11
	jge noChangeLargest
	movq 2(%r10), %rax
	movq 2(%r11), %rbx
	cmp %ax, %bx
	jle noChangeLargest
	movq %r11, %r10 #Right node is larger than root and left
	noChangeLargest:
	cmpq %r10, %r13
	je heapEnd
	mov (%r13d), %ecx
	mov (%r10d), %edx
	mov %ecx, (%r10d)
	mov %edx, (%r13d)
	movq %r10, %r13
	call maxHeapify
	heapEnd:
	pop %r13
	ret

quickSort:
	#End r14
	#Start r15
	push %r15
	push %r14
	push %r13
	push %r12
	movq %r15, %r12 #Move copy into r12 for later reference
	movq %r14, %rax
	subq %r15, %rax #Find the difference between start and end of array
	cmpq $4, %rax #Check if the given array is larger than 1 element
	jle quickSortRet #If not return
	movq 2(%r15), %rax #choosen y number 
	movq $0, %r13 #Large basket counter
	quickArray:
		addq $4, %r15 #Move up
		cmpq %r15, %r14 #Check if end is reached
		je endSort
		movq 2(%r15), %rbx #move y in bx
		cmp %ax, %bx #is the choosen y smaller or equal than current y
		jg quickArray #If so skip to next number in array
		addq $4, %r13 #Move up large basket counter
		mov (%r15d), %ecx #hold current coordinate
		add %r13d, %r12d #Get large basket pointer
		mov (%r12d), %edx #Get first element of larger basket
		mov %ecx, (%r12d) #Switch current element with first element outside basket pointer
		mov %edx, (%r15d)
		sub %r13d, %r12d #Restore original array start pointer
		jmp quickArray 
	endSort:	
		addq %r12, %r13 #Large basket pointer
		cmp %r13d, %r12d #check if equal to not switch
		je noSwitch
		mov (%r13d), %ecx #hold coordinate
		mov (%r12d), %edx #Get first element outside larger basket
		mov %ecx, (%r12d) #switch such the choosen y is between smaller and larger basket
		mov %edx, (%r13d)
		noSwitch:
		movq %r13, %r15 
		addq $4, %r15
		call quickSort #Call quick sort on larger basket
		movq %r13, %r14
		movq %r12, %r15
		call quickSort	 #Call quick sort on lower baskeeeet
		quickSortRet:
		pop %r12
		pop %r13
		pop %r14
		pop %r15
		ret	
	
insertSort:
	movq %r15, %r13 #Start
	sortArray:
		movq %r13, %r11 #Save progress
		moveInArray: #Move elem down until until the elem below is lower or equal
			movq 2(%r13), %rax #y in ax
 			cmpq %r13, %r15
 			je next
			movq -2(%r13), %rbx #prev y in bx
        	cmp %ax, %bx #Check if the current y value is higher or equal to lower y value
         jle next #If true then go to next value in array
         mov (%r13d), %ecx #hold current coordinate
         mov -4(%r13d), %edx #hold previuos coordinate
         mov %ecx, -4(%r13d)
         mov %edx, (%r13d)
	      subq $4, %r13 #Move one down
         jmp moveInArray
		next:
	     	addq $4, %r11 #move one up
	      movq %r11, %r13
	      cmpq %r13, %r14 #check if end is reached
	      je ret #Return if at end
		   jmp moveInArray
 		ret:
			ret
