# s3 = result
diffofsums:
    addi sp, sp, -12	# allocate space for 3 registers on the stack
    
    sw s3, 8(sp)		# store s3 on the stack
    sw t0, 4(sp)		# store t0 on the stack
    sw t1, 0(sp)		# store t1 on the stack
    add t0, a0, a1		# t0 = a + b
    add t1, a2, a3		# t1 = b + c
    sub s3, t0, t1		# s3 = t0 - t1
    addi a0, s3, zero	# save the result into the return value
    lw s3, 8(sp)		# restore s3 from stack
    lw t0, 4(sp)		# restore t0 from stack
    lw t1, 0(sp)		# restore t1 from stack
    addi sp, sp, 12		# deallocate the space
    
    jr ra			# return to caller
