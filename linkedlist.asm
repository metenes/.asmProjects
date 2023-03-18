.data
	nextl: .asciiz "\n"
	arrow: .asciiz "->"
	arrowR: .asciiz "<-"
	.align 2
	headNode: .word 0,0
.text
	main:
	# s0 -> headNode
	# s1 -> find adress result
	# s2 -> find adress bool result
	la $s0, headNode
	
	addi $a0, $zero, 1
	jal insertNodeEnd
	addi $a0, $zero, 2
	jal insertNodeEnd
	addi $a0, $zero, 3
	jal insertNodeEnd
	addi $a0, $zero, 4
	jal insertNodeEnd
	addi $a0, $zero, 5
	jal insertNodeEnd
	addi $a0, $zero, 6
	jal insertNodeEnd
	
	li $a0, 10
	jal searchNode
	
	move $s1, $v0
	move $s2, $v1
	
	# print found bool
	li $v0, 1
	move $a0, $s2
	syscall 
	
	# print nextl
	li $v0, 4
	la $a0, nextl
	syscall 
	
	# print adress in hex
	li $v0, 34
	move $a0, $s1
	syscall 
	
	# print nextl
	li $v0, 4
	la $a0, nextl
	syscall 
	
	jal displayListRev
	li $v0 10
	syscall
	 
insertNodeEnd: 
	# $s0 curr node adress
	# $s1 next node adress
	# a0  value of new node
	
	# save stack
	addi	 $sp, $sp, -12
	sw   $ra, 0($sp)
	sw   $s0, 4($sp)
	sw   $s1, 8($sp)
	
	# base: 
	lw $s1, 4($s0) 
	beq $s1, $zero, addNode

	lw $s0, 4($s0)
	jal insertNodeEnd
	j end
	
	addNode: 
	sw   $a0, 0($s0) 
	add  $s1, $s0, 8 # 4 byte integer + 4 byte nextAdress 
	sw	 $s1, 4($s0) 
	
	end:
	# load stack
	lw   $ra, 0($sp)
	lw   $s0, 4($sp)
	lw   $s1, 8($sp) 
	addi	 $sp, $sp, 12
	jr $ra
	
deleteNodeEnd: 
	# $s0 curr node adress
	# $s1 next node adress
	# a0  value of node to be deleted
	# v0 1 : deleted / 0 : not found 
	
	# save stack
	addi	 $sp, $sp, -12
	sw   $ra, 0($sp)
	sw   $s0, 4($sp)
	sw   $s1, 8($sp)
	
	# base: 
	lw  $s1, 4($s0) 
	beq $s1, $zero, returnDel
	lw  $s0, 4($s0)
	jal deleteNodeEnd
	j returnDel
	
	delete: 
	sw   $a0, 0($s0) 
	sw	 $s1, 4($s0) 
	
	returnDel:
	# load stack
	lw   $ra, 0($sp)
	lw   $s0, 4($sp)
	lw   $s1, 8($sp) 
	addi	 $sp, $sp, 12
	jr $ra
	
searchNode : 
 	# $s0 curr node adress
	# $s1 next node adress
	# a0 value of node to be search
	# v0 adress of the node
	# v1 found : 1 / not found : 0 
	
	# save stack
	addi	 $sp, $sp, -12
	sw   $ra, 0($sp)
	sw   $s0, 4($sp)
	sw   $s1, 8($sp)
	
	forS: 
	lw   $s1, 4($s0) # next adress
	beq  $s1, $zero, endS
	lw   $s1, 0($s0) # cur value
	beq  $s1, $a0, foundS
	
	lw   $s0, 4($s0)
	j forS
	
	foundS: 
	move $v0, $s0, # load cur adress to result
	li   $v1, 1 	   # found true
	
	endS: 
	# load stack
	lw   $ra, 0($sp)
	lw   $s0, 4($sp)
	lw   $s1, 8($sp) 
	addi	 $sp, $sp, 12
	jr $ra
	
displayList: 
	# save stack
	addi	 $sp, $sp, -12
	sw   $ra, 0($sp)
	sw   $s0, 4($sp)
	sw   $s1, 8($sp)
	
	forD: 
	lw $s1, 4($s0) 
	beq $s1, $zero, endD
	# print val
	li $v0, 1
	lw $a0, 0($s0)
	syscall 
	
	# print arw
	li $v0, 4
	la $a0, arrow
	syscall 
	
	lw $s0, 4($s0)
	j forD 
	
	endD: 
	# load stack
	lw   $ra, 0($sp)
	lw   $s0, 4($sp)
	lw   $s1, 8($sp) 
	addi	 $sp, $sp, 12
	jr $ra
	
displayListRev: 
	# save stack
	addi	 $sp, $sp, -12
	sw   $ra, 0($sp)
	sw   $s0, 4($sp)
	sw   $s1, 8($sp)
	
	# check base
	lw $s1, 4($s0) 
	beq $s1, $zero, endDR
	lw $s0, 4($s0)
	jal displayListRev

	endDR: 
	# load stack
	lw   $ra, 0($sp)
	lw   $s0, 4($sp)
	lw   $s1, 8($sp) 
	addi	 $sp, $sp, 12
	
	# print val
	li $v0, 1
	lw $a0, 0($s0)
	syscall 
	
	# print arw
	li $v0, 4
	la $a0, arrowR
	syscall 
	
	jr $ra
