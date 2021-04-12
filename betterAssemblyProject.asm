##################################################################### #
# CSCB58 Winter 2021 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Carlos Huang, 1006274274, huan1942
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp) 
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 4-ish (choose the one the applies)
#
# Which approved features have been implemented for milestone 4?
# (See the assignment handout
# 1. Increased difficulty as game progresses, blocks speed up
# 2. (fill in the feature, if
# 3. (fill in the feature, if
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - https://youtu.be/K9tQJp2YeYQ
# Are you OK with us sharing the video with people outside course staff?
# - yes 
#
#
# Any additional information that the TA needs to know:
# - (write here, if any)
# #####################################################################



.eqv BASE_ADDRESS 0x10008000

.data

astroidscurrarr: .word  268468716 ,268469620, 268470256, 268470760
astroidarrlength: .word 12 	#Is 3 elems, with size 4 bytes each so 12




.text 
.globl main

main:
	li $t0, BASE_ADDRESS 	#$t0 stores the base address for display
	li $t3, 0x0000ff	# $t3 stores the blue colour code
	li $t4, 0x00000000	#Stores the value of black
	addi $s0, $t0, 4092	#$s0 stores the total number of pixels that we can traverse
	li $t1, 0xffff0000	# t1 stores the address that indicates whether button press happened
	addi $t7, $t0, 3584	#$t7 stores the value of the current pixel
	addi $s1, $zero, 128	#$s1 stores 128, useful constant
	li $s2, 0x00ff00 	# $s2 stores the green colour code
	la $s3, astroidscurrarr
	addi $a3, $zero, 0	#$a3 stores the count of number of astroids passed by
	
	
	
	sw $t9, 448($t0)
	
	addi $s7,$zero, 24
	
	jal initialize_objects
	

	
	j mainloop

	
initialize_objects:


	sw $t3, 0($t7)	#Displaying the current player position
	sw $t3, 4($t7)
	sw $t3, 8($t7)
	
	sw $t3, 128($t7)	#Displaying the current player position
	sw $t3, 132($t7)
	sw $t3, 136($t7)
	
	
	sw $t3, 256($t7)	#Displaying the current player position
	sw $t3, 260($t7)
	sw $t3, 264($t7)
	
	
	li $t9, 0xff0000 #Loads the colour red into the register
	
	sw $t9, 48($t0)
	sw $t9, 52($t0)
	sw $t9, 56($t0)
	sw $t9, 60($t0)
	sw $t9, 64($t0)
	sw $t9, 68($t0)
	sw $t9, 72($t0)
	sw $t9, 76($t0)
	
	
	#$t5 gets our value from the astroids array
	addi $t6, $s3, 16	#$t6 sets our breakpoint for the loop
	add $s4, $s3, $zero 	#$s4 is our iterator
	
	addi $sp, $sp, -4		# save $ra on the stack
	sw $ra, 0($sp)
	
	jal initializeLoop
	
	
	lw $ra, 0($sp) #pop ra
      	addi, $sp,$sp,4
	
	
	jr $ra
	
initializeLoop:
	beq $s4, $t6, endInitializeLoop
	
	lw $t5, 0($s4)
	
	sw $s2, 0($t5)	#Sets the Unit at Arr[i] to be the colour green
	sw $s2, 4($t5)	#Sets the Unit at Arr[i+4]  to be the colour green
	sw $s2, 8($t5)
	
	sw $s2, 128($t5)	#Sets the Unit at Arr[i] to be the colour green
	sw $s2, 132($t5)	#Sets the Unit at Arr[i+4]  to be the colour green
	sw $s2, 136($t5)
	
	sw $s2, 256($t5)	#Sets the Unit at Arr[i] to be the colour green
	sw $s2, 260($t5)	#Sets the Unit at Arr[i+4]  to be the colour green
	sw $s2, 264($t5)
	
	
	
	addi $s4, $s4, 4	#Incrementing iterator
	j initializeLoop

endInitializeLoop:
	#End of the intializeloop
	jr $ra
	
respond_to_a:
	sub $t8, $t7, $t0	#checking if you can move over to the left
	div $t8, $s1
	mfhi $t8		
	beq $t8, $zero, invalidMove
	
	sw $t4, 8($t7)		#Setting right column to be black
	sw $t4, 136($t7)
	sw $t4, 264($t7)
	
	addi $t7, $t7, -4	#move over 1 pixel
	
	sw $t3, 0($t7)
	sw $t3, 128($t7)
	sw $t3, 256($t7)
	
	
	j mainloop
	
respond_to_d:
	sub $t8, $t7, $t0	#checking if you can right up by 1 unit
	addi $t8, $t8, 8
	addi $t9, $zero, 124
	sub $t8, $t8, $t9
	div $t8, $s1
	mfhi $t8
	beq $t8, $zero, invalidMove
	
	sw $t4, 0($t7)		#Setting current column to be black
	sw $t4, 128($t7)
	sw $t4, 256($t7)		

	
	addi $t7, $t7, 4
	
	sw $t3, 8($t7)		#Setting right column to be blue
	sw $t3, 136($t7)
	sw $t3, 264($t7)
	
	
	j mainloop

respond_to_w:
	sub $t8, $t7, $t0	#checking if you can move up by 1 unit
	addi $t9, $zero, 252
	ble $t8, $t9, invalidMove
	
	sw $t4, 256($t7)	#Set the last row of player to be black
	sw $t4, 260($t7)
	sw $t4, 264($t7)
		
	addi $t7, $t7, -128	#Update player position
	
	sw $t3, 0($t7)		#update current player row to be blue
	sw $t3, 4($t7)
	sw $t3, 8($t7)
	
	j mainloop
	
respond_to_s:
	sub $t8, $s0, $t7	#checking if you can down up by 1 unit
	addi $t8, $t8, -256
	addi $t9, $zero, 124
	ble $t8, $t9, invalidMove
	
	
	sw $t4, 0($t7)	#Set the current player position row to be black, row below is now blue
	sw $t4, 4($t7)
	sw $t4, 8($t7)

	addi $t7, $t7, 128
	
	sw $t3, 256($t7)	#Row below is now blue
	sw $t3, 260($t7)
	sw $t3, 264($t7)
	
	j mainloop

invalidMove:
	j mainloop
	
respond_to_p:
	j resetScreenAndAstroids

	
resetScreenAndAstroids:
	#$t5 gets our value from the astroids array
	addi $t6, $s3, 16	#$t6 sets our breakpoint for the loop
	add $s4, $s3, $zero 	#$s4 is our iterator
	
	jal resetAstroidsToOriginalLoop
	jal setPlayerPositionToBlack
	
	li $v0, 32
	li $a0, 600 # Wait 0.5 seconds (500 milliseconds) 
	syscall
	
	j main

	
resetAstroidsToOriginalLoop:
	beq $s4, $t6, endResetAstoidsToOriginal #checking for break condition
	lw $t5, 0($s4) 			#$t5 = A[i]
	
	sw $t4, 0($t5)	#Sets the Unit at Arr[i] to be the colour green
	sw $t4, 4($t5)	#Sets the Unit at Arr[i+4]  to be the colour green
	sw $t4, 8($t5)
	
	sw $t4, 128($t5)	#Sets the Unit at Arr[i] to be the colour green
	sw $t4, 132($t5)	#Sets the Unit at Arr[i+4]  to be the colour green
	sw $t4, 136($t5)
	
	sw $t4, 256($t5)	#Sets the Unit at Arr[i] to be the colour green
	sw $t4, 260($t5)	#Sets the Unit at Arr[i+4]  to be the colour green
	sw $t4, 264($t5)
	
	
	
	li $v0, 42	#Gets a random number in range [0, 29], then stores it in $a0
	li $a0, 0
	li $a1, 29
	syscall
	
	move $t5, $a0
	#mflo $t5
	mult $t5, $s1 #lo = k* 128
	mflo $t5	#$t5 = k* 128
	
	addi $t5, $t5, 128	#$t5 = k* 128 + 128
	addi $t5, $t5, 116	#$t5 = k* 128 + +128 116

	add $t5, $t5, $t0	#$t5 = k* 128 + +128 116 + BASEPOS
	
	
	sw $t5, 0($s4)	#Sets the new pixel position to be at the end
	
		
	addi $s4, $s4, 4	#Incrementing iterator
	j resetAstroidsToOriginalLoop


endResetAstoidsToOriginal:
	jr $ra


setPlayerPositionToBlack:
	sw $t4, 0($t7)	#Displaying the current player position
	sw $t4, 4($t7)
	sw $t4, 8($t7)
	
	sw $t4, 128($t7)	#Displaying the current player position
	sw $t4, 132($t7)
	sw $t4, 136($t7)
	
	
	sw $t4, 256($t7)	#Displaying the current player position
	sw $t4, 260($t7)
	sw $t4, 264($t7)
	
	jr $ra
	

# Function for handling button presses
buttonPressed:
	lw $t8, 4($t1)

	
	beq $t8, 0x61, respond_to_a # ASCII code of 'a' is 0x61
	beq $t8, 0x64, respond_to_d # ASCII code of 'd' is 0x64 
	beq $t8, 0x77, respond_to_w # ASCII code of 'w' is 0x77 
	beq $t8, 0x73, respond_to_s # ASCII code of 's' is 0x73 
	beq $t8, 0x70, respond_to_p # ASCII code of 'p' is 0x70
	
	
updateAstroidPos:
				#$t5 gets our value from the astroids array
	addi $t6, $s3, 16	#$t6 sets our breakpoint for the loop
	add $s4, $s3, $zero 	#$s4 is our iterator

	j astroidsLoop
	
	


astroidsLoop:

	beq $s4, $t6, endAstroidLoop
	lw $s5, 0($s4)	#Gets Arr[i], store in $s5
	
	sub $t5, $s5, $t0	#$t5 = currentPos ($s5) - BasePos
	div $t5, $s1	#lo = $t5 / 128, hi = $t5% 128
	
	mfhi $t5	#$t5 = (currentPos-Basepos) % 128
	
	
	#Check for collisons
	beq $s5, $t7, collision
	
	addi $t2, $t7,128		#$t2 is positions for player
	addi $s6, $s5,128		#$s6 is positions for astroid
	
	beq $t2, $s5, collision
	addi $t2, $t2, 128
	beq $t2, $s5, collision
	
	
	beq $s6, $t7, collision
	addi $s6, $s6, 128
	beq $s6, $t7, collision
	
	
	beq $t5, $zero, atEdge
	#Not at the edge
	
	sw $t4, 8($s5)	#Sets the Unit at Arr[i+8] to be the colour black
	sw $t4, 136($s5)	#Sets the Unit at Arr[i+8+126]  to be the colour black
	sw $t4, 264($s5)	#Sets the Unit at Arr[i+8+2*126]  to be the colour black
	

	addi $s5, $s5, -4
	
	sw $s2, 0($s5)	#Sets the Unit at Arr[i] to be the colour green
	sw $s2, 128($s5)	#Sets the Unit at Arr[i+128] to be the colour green
	sw $s2, 256($s5)	#Sets the Unit at Arr[i+256] to be the colour green
	
	
		
	sw $s5, 0($s4)	#Store new value back into $s4
	
	addi $s4, $s4, 4	#update loop iterator
	j astroidsLoop
	
collision:

	li $t9, 0xff0000 #Loads the colour red into the register
	#sw $s7, 0($t7)	#Displaying the current player position
	#sw $s7, 4($t7)
	#sw $s7, 8($t7)
	
	sw $t9, 0($t7)	#Displaying the current player position
	sw $t9, 4($t7)
	sw $t9, 8($t7)
	
	#sw $s7, 128($t7)	#Displaying the current player position
	#sw $s7, 132($t7)
	#sw $s7, 136($t7)
	
	sw $t9, 128($t7)	#Displaying the current player position
	sw $t9, 132($t7)
	sw $t9, 136($t7)
	
	
	#sw $s7, 256($t7)	#Displaying the current player position
	#sw $s7, 260($t7)
	#sw $s7, 264($t7)
	
	sw $t9, 256($t7)	#Displaying the current player position
	sw $t9, 260($t7)
	sw $t9, 264($t7)
	
	
	
	li $v0, 32
	li $a0, 200 # Wait 0.1 seconds (100 milliseconds) 
	syscall
	
	add $t9,$t0, $s7
	sw $t4, 52($t9)	#Set current health bar unit to black
	sw $t4, 48($t9) #Set current health bar unit to black
	
	addi $s7, $s7, -8	#Decrease health counter by 8
	blt $s7, $zero, end	#check if we player had ran out of health
	
	
	move $s6, $zero
	
	#addi $s4, $s4, 4
	#j astroidsLoop
	
	j atEdge

atEdge:
	li $v0, 42	#Gets a random number in range [0, 30], then stores it in $a0
	li $a0, 0
	li $a1, 29
	syscall
	
	move $t5, $a0
	#mflo $t5
	mult $t5, $s1 #lo = k* 128
	mflo $t5	#$t5 = k* 128
	addi $t5, $t5, 128	#$t5 = k* 128 + +128 116
	addi $t5, $t5, 116	#$t5 = k* 128 + +128 116

	add $t5, $t5, $t0	#$t5 = k* 128 +128 + 116 + BASEPOS
	
	
	addi $a3, $a3, 1	#Another astroid has either passed or been hit, update $a3
	
	
	
	sw $t4, 0($s5)	#Sets the Unit at Arr[i] to be the colour black
	sw $t4, 4($s5)	#Sets the Unit at Arr[i+4]  to be the colour black
	sw $t4, 8($s5)
	
	sw $t4, 128($s5)	#Sets the Unit at Arr[i] to be the colour black
	sw $t4, 132($s5)	#Sets the Unit at Arr[i+4]  to be the colour black
	sw $t4, 136($s5)
	
	sw $t4, 256($s5)	#Sets the Unit at Arr[i] to be the colour green
	sw $t4, 260($s5)	#Sets the Unit at Arr[i+4]  to be the colour black
	sw $t4, 264($s5)
	
	

	
	
	
	sw $t3, 0($t7)	#Sets the Unit at Arr[i] to be the colour green
	sw $t3, 4($t7)	#Sets the Unit at Arr[i+4]  to be the colour green
	sw $t3, 8($t7)
	
	sw $t3, 128($t7)	#Sets the Unit at Arr[i] to be the colour green
	sw $t3, 132($t7)	#Sets the Unit at Arr[i+4]  to be the colour green
	sw $t3, 136($t7)
	
	sw $t3, 256($t7)	#Sets the Unit at Arr[i] to be the colour green
	sw $t3, 260($t7)	#Sets the Unit at Arr[i+4]  to be the colour green
	sw $t3, 264($t7)
	
	
	
	#Now need to reset position of astroid
	
	sw $t5, 0($s4)	#Sets the new pixel position to be at the end
	
	sw $s2, 0($t5)	#Sets the Unit at Arr[i] to be the colour green
	sw $s2, 4($t5)	#Sets the Unit at Arr[i+4]  to be the colour green
	sw $s2, 8($t5)
	
	sw $s2, 128($t5)	#Sets the Unit at Arr[i] to be the colour green
	sw $s2, 132($t5)	#Sets the Unit at Arr[i+4]  to be the colour green
	sw $s2, 136($t5)
	
	sw $s2, 256($t5)	#Sets the Unit at Arr[i] to be the colour green
	sw $s2, 260($t5)	#Sets the Unit at Arr[i+4]  to be the colour green
	sw $s2, 264($t5)
	
	addi $s4, $s4, 4
	j astroidsLoop	


endAstroidLoop:
	jr $ra
	


pauseForABit:
	addi $t9, $zero, 20
	blt $a3, $t9, longDelay
	addi $t9, $zero, 40
	blt $a3, $t9, mediumDelay
	addi $t9, $zero, 60
	blt $a3, $t9, shortDelay
	
	j superShortDelay

longDelay:
	li $v0, 32
	li $a0, 60 # Wait one second (1000 milliseconds) 
	syscall
	jr $ra
mediumDelay:
	li $v0, 32
	li $a0, 45 # Wait one second (1000 milliseconds) 
	syscall
	jr $ra

shortDelay:
	li $v0, 32
	li $a0, 30 # Wait one second (1000 milliseconds) 
	syscall
	jr $ra	
	
superShortDelay:
	li $v0, 32
	li $a0, 15 # Wait one second (1000 milliseconds) 
	syscall
	jr $ra
	
	

mainloop:
	lw $t8, 0($t1)
	beq $t8, 1, buttonPressed
	
	jal updateAstroidPos

	
	#jal refreshScreen
	#jal refreshastroid
	
	#li $v0, 32
	#li $a0, 50 # Wait one second (1000 milliseconds) 
	#syscall
	
	jal pauseForABit
	
	j mainloop
	

displayEndScreen:
		#$t5 gets our value from the astroids array
	addi $t6, $t0, 1424	#$t6 sets our breakpoint for the loop
	addi $s4, $t0, 400 	#$s4 is our iterator
	li $t9, 0xc023db	#t9 stores our colour value
		
displayEndScreenLoop:
	beq $s4, $t6, endDisplayEndScreenLoop
	
	sw $t9, 0($s4)
	sw $t9, 4($s4)
	sw $t9, 8($s4)
	sw $t9, 12($s4)
	sw $t9, 16($s4)
	sw $t9, 20($s4)
	sw $t9, 24($s4)
	
	
	
	
	sw $t9, 60($s4)
	sw $t9, 64($s4)
	sw $t9, 68($s4)
	sw $t9, 72($s4)
	sw $t9, 76($s4)
	sw $t9, 80($s4)
	sw $t9, 84($s4)
	
	
	addi $s4, $s4, 128
	j displayEndScreenLoop
	
	
endDisplayEndScreenLoop:
	jr $ra


displayFrownyFaceSides:
	addi $t6, $t0, 3612	#$t6 sets our breakpoint for the loop
	addi $s4, $t0, 1948 	#$s4 is our iterator
	li $t9, 0xc023db	#t9 stores our colour value
	j displayFrownyFaceSidesLoop
	
displayFrownyFaceSidesLoop:
	beq $s4, $t6, endDisplayFrownyFaceSidesLoop
	
	sw $t9, 0($s4)
	sw $t9, 4($s4)
	
	sw $t9, 56($s4)
	sw $t9, 60($s4)
	
	addi $s4, $s4, 128
	j displayFrownyFaceSidesLoop
	
endDisplayFrownyFaceSidesLoop:
	jr $ra




displayFrownyFaceTop:
	addi $t6, $t0, 2012	#$t6 sets our breakpoint for the loop
	addi $s4, $t0, 1956 	#$s4 is our iterator
	li $t9, 0xc023db	#t9 stores our colour value
	j displayFrownyFaceTopLoop
	
displayFrownyFaceTopLoop:
	beq $s4, $t6, endDisplayFrownyFaceTopLoop
	
	sw $t9, 0($s4)
	sw $t9, 128($s4)
	
	
	addi $s4, $s4, 4
	j displayFrownyFaceTopLoop
	
endDisplayFrownyFaceTopLoop:
	jr $ra
	
end:

	jal displayEndScreen
	jal displayFrownyFaceTop
	jal displayFrownyFaceSides
	li $v0, 10		#Exiting the program
	syscall

