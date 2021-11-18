.data
    ArrSize: .space 4
	TargetNumber: .space 4
    Arr:.space 400  
    ArrSizeMessage: .asciiz "\nEnter the array size (Max 100) : "
	TargetNumberMessage: .asciiz "\nEnter the target number :"
	QueueMessage: .asciiz ".number : \n"
	PossibleMessage: .asciiz "\nPossible !\n"
	NotPossibleMessage: .asciiz "\nNot Possible !\n"  
	ArrayFollowsMessage: .asciiz "The array is as follows : "
	Space: .asciiz " " 
	Newline: .asciiz "\n"
	TargetNumberPrintMessage: .asciiz "\n The target number is : "


.text    
.globl main
main:
	jal printArrSizeMsg			#Print message
	jal readArrSize				#Read array size
	jal printTargetMsg			#Print target num message
	jal readTarget 				#Read target number
	lw $t1,ArrSize				#Load Arr size to t1
	addi $t2,$zero,0				#Temporary values for condition (i == size etc.)
	addi $t3,$zero,0
	jal loopForReadNumbers		#go to loop

    
printArrSizeMsg: 
	li $v0, 4		#Print array size message
	la $a0, ArrSizeMessage
	syscall
	jr $ra
	
readArrSize:
	li $v0,5			#Read Integer for Array Size 
	syscall
	sw $v0,ArrSize	#Store integer to array size
	jr $ra
	
printTargetMsg:
	li $v0, 4		#Print target number message
	la $a0, TargetNumberMessage
	syscall
	jr $ra
	
readTarget:
	li $v0, 5 		#Read Integer for target number
	syscall 		 
	sw $v0, TargetNumber		#Store integer to target number
	jr $ra
	
printQueueMsg:		#Print "*.number" label
	add $s0,$s0,1		# Print increase index one by one 
	move $a0,$s0
	li $v0, 1		
	syscall
	la $a0,QueueMessage
	li $v0,4				#Print ".number" string
	syscall 
	jr $ra

loopForReadNumbers:        	#Take inputs from user
    beq $t2,$t1,assignValues		#If condition is not true, then go assign Values label
    jal printQueueMsg		
    li $v0,5
    syscall
    sw $v0,Arr($t0)			#Fill the array
    add $t0,$t0,4
    addi $t2,$t2,1
    j loopForReadNumbers

assignValues:				#For Loop exit label
	j printResult	

    
printResult:					#Send to the recursive
	lw $a0,TargetNumber
	la $a1,Arr
	lw $a2,ArrSize
	jal CheckSumPossibility		#Send to the recursive
	move $s6,$v0
	li $s5,1
	beq $s6,$s5,possibleMsg		#If the return is 1, then print possible
	beq $s6,$zero,notPossibleMsg		#If the return is 0, then print not possible

    
CheckSumPossibility:			#Recursive method
	addi $sp,$sp,-16		#Adjust stack for 4 items (Include array elements)
	sw  $ra,12($sp)
	sw  $a0,8($sp)
	sw  $a2,4($sp)
	sw  $a1,0($sp)
	lw $v0,8($sp)			
	bne $v0,$zero,otherBaseCase	#if(num != 0) go to otherBaseCase label
	li $v0,1
	lw $ra, 12($sp) 	
	addiu $sp, $sp, 16
	jr $ra


	
otherBaseCase:				
	lw $v0,	4($sp)
	bne $v0,$zero,thirdCondition 		#If(size != 0) go to third condition	
	move $v0,$zero	
	lw $ra, 12($sp)		
	addi $sp,$sp,16
	jr $ra						#return 0


thirdCondition:
	sw $ra,12($sp)					
	lw $v1, 8($sp)
	la $v0,Arr
	lw $a2,4($sp)
	add $s7,$a2,-1					#Find size-1. index and check if it is bigger than num
	mul $s7,$s7,4
	add $v0,$v0,$s7
	lw  $s1,($v0)
	slt $v0,$v1,$s1
	beq $v0,$zero,returnStatement     #if(arr[size-1] < num) go to return statement 

	lw $s2,4($sp)					
	addi $s2,$s2,-1
	lw  $a0,8($sp)
	move  $a2,$s2
	la  $a1,Arr 
	jal CheckSumPossibility			#This recursive, decrease the size by 1 and send to function
	li $s5,1
	beq $v0,$s5,possibleMsg
	lw $ra,12($sp)
	addi $sp,$sp,16
	jr $ra
	
	
returnStatement:
	sw $ra,12($sp)					
	addi $s2,$zero,0					#First return is decrease num by arr[size-1] and size by 1
	lw $v1, 8($sp)
	la $v0,Arr
	lw $a2,4($sp)
	add $s7,$a2,-1
	mul $s7,$s7,4
	add $v0,$v0,$s7
	lw  $s1,($v0)
	sub $s1,$v1,$s1

	lw $s2,4($sp)
	addi $s2,$s2,-1
	move  $a0,$s1
	move  $a2,$s2
	la  $a1,Arr 
	jal CheckSumPossibility

	li $s5, 1	
	beq $v0,$s5,possibleMsg

	lw $v0,4($sp)					#Second return is just decrease size by 1  
	addi $v0,$v0,-1
	move $a2,$v0						#Size-1 
	lw $a0,8($sp)
	la $a1,Arr
	jal CheckSumPossibility
	addi $s5,$zero,1
	beq $v0,$s5,possibleMsg			
	lw $ra,12($sp)
	addi $sp,$sp,16
	jr $ra
	
		
possibleMsg: 
	li $v0, 4		#Print array size message
	la $a0, PossibleMessage
	syscall
	lw $t1,ArrSize				#Load Arr size to t1
	li $t2,0						#Temporary values for condition (i == size etc.)
	li $t0,0						#Increase 4 by 4 (for array element byte)
	jal PrintArrayFollowsMessage
	j PrintArr
	
notPossibleMsg:
	li $v0, 4		#Print array size message
	la $a0, NotPossibleMessage
	syscall
	lw $t1,ArrSize				#Load Arr size to t1
	li $t2,0						#Temporary values for condition (i == size etc.)
	li $t0,0						#Increase 4 by 4 (for array element byte)
	jal PrintArrayFollowsMessage
	j PrintArr
	
PrintArr:
	beq $t2,$t1,PrintTarget		#If condition is not true, then go print target label
    li $v0,1
    lw $a0,Arr($t0)
    syscall
    jal PrintSpace
    add $t0,$t0,4
    addi $t2,$t2,1
    j PrintArr
    
PrintSpace:				#Print space character
	li $v0,4
	la $a0,Space
	syscall
	jr $ra
	
PrintNewLine:			#Print newline character
	li $v0,4
	la $a0,Newline
	syscall
	jr $ra
	
PrintArrayFollowsMessage:		#Print "The array is follows : " message
	li $v0,4
	la $a0,ArrayFollowsMessage
	syscall
	jr $ra
	
	
PrintTarget:						#Print "The target number is "  message
	li $v0,4
	la $a0,TargetNumberPrintMessage
	syscall
	li $v0,1
	lw $a0,TargetNumber
	syscall
	j exit

exit:				#Exit call
	li $v0,10
	syscall
    
    
    
    
    
    
