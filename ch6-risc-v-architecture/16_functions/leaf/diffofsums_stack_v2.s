# s3 = result
diffofsums:
    addi sp, sp, -4 # make sp to store only one register
    sw s3, 0(sp)    # store s3 on the stack
    add t0, a0, a1  # t0 = a + b
    add t1, a2, a3  # t1 = c + d
    sub s3, t0, t1  # result = t0 - t1
    add a0, s3, zero    # store result in return reg
    lw s3, 0(sp)    # restore s3 from stack
    addi sp, sp, 4  # deallocate the space for s3

    jr ra


