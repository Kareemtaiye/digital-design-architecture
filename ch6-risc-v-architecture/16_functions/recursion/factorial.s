factorial:    
    addi sp, sp, -8	# space to store ra and n
    lw a0, 4(sp)		
    lw ra, 0(sp)
    add t0, zero, 1	# temp var - 1

    bgt a0, t0, else
    addi a0, zero, 1	# return 1 if n is 1
    addi sp, sp, 8	# deallocate the space
    jr ra		# return to caller

else:
    addi a0, a0, -1	# n - 1
    jal fatorial	# recursive call
    lw t0, 4(sp)
    addi sp, sp, 8	# restore sp
    mul a0, t0, a0	# a0 = n * factorial(n -1)
    jr ra		# return to caller
    
    
	

