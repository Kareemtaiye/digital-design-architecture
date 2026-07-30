#s7 = y
main: 
    ...
    addi a0, zero, 2    # arg 0 
    addi a1, zero, 3    # arg 1
    addi a2, zero, 4    # arg 2
    addi a3, zero, 5    # arg 3

    jal ra, diffofsums  # call function
    add s7, a0, zero    # y = return value

diffofsums:
    add t0, a0, a1      # t0 = a + b
    add t1, a2, a3      # t1 = b + c
    sub s3, t0, t1      # result = t0 - t1
    addi a0, s3, zero   # put return val in a0
    jr ra               # return to caller