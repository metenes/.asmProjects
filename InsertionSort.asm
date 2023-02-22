# done
.data
promString : .asciiz "Enter the Size of Array \n"
true : .asciiz "String is polindrom /n"
false : .asciiz "String is not polindrom /n"
nextLine : .asciiz "\n"
.align 2
array : .space 100 # subject to change
.text
main: 
	# s0 : size
	# s1 : index - key
	# s2 : current num
	
	# s3 : i
	# s4 : j
	
	# s5 curELm while
	
	# prompt
	li $v0, 4
	la $a0, promString
		syscall 
	
	# input
	li $v0, 5
		syscall
	move $s0, $v0
	
	
	addi $s1, $zero, 0
	loop:
		beq  $s1, $s0, end
		# cur input
		li $v0, 5
			syscall
		move $s2, $v0 
		# index adjust
		mul $s1, $s1, 4
    		sw   $s2, array($s1)
    		div $s1, $s1, 4 
   		addi	 $s1, $s1, 1
    		j loop
	end:
  	
  	# index i 
	li $s3, 1
	# index j
	li $s4, 0 
	 
	for1: 
	beq $s3, $s0, end1
	# key
	# index adjust
	mul $s3, $s3, 4
	lw $s1, array($s3)
	div $s3, $s3, 4 
	
	# j index 
	addi $s4, $s3, -1
		while: 
			# j >= 0
			blt $s4, $zero, end2
			# s5  array(j)
			mul $s4, $s4, 4
			lw $s5, array($s4)
			div $s4, $s4, 4 
			# array(j) > key
			ble $s5 $s1, end2
			# s6 array(j+1)
			addi $s4, $s4, 1
			# array(j+1) = array(j)
			mul $s4, $s4, 4
			lw $s6, array($s4)
			sw $s5, array($s4) 
			div $s4, $s4, 4 
			# (j+1)-1-1
			addi $s4, $s4, -2
		j while
		end2:
		# s6 array(j+1)
		addi $s4, $s4, 1
		# array(j+1) = key
		mul $s4, $s4, 4
		sw $s1, array($s4) 
		div $s4, $s4, 4 
		
		addi $s3, $s3, 1
	j for1 
	end1: 
	
	# Display array
	addi $s1, $zero, 0
	loop2:
		beq  $s1, $s0, done2
		
		mul $s1, $s1, 4
    		lw   $s2, array($s1)
    		div $s1, $s1, 4 
    		
    		# print
    		li $v0, 1
    		addi $a0, $s2, 0
    		syscall
    		
   		addi	 $s1, $s1, 1
    		j loop2
	done2:
	
li $v0, 10
syscall
