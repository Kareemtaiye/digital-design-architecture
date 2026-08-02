# a0 = a, a1 = b, s1, x, s2 = i
f1:
    addi sp, sp, -12     # allocate 12 bytes for x, i, and ra
    sw ra, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

    add t0, a0, a1      # temp(t0) = a + b
    sub t1, a0, a1      # temp(t1) = a -b
    mul s1, t0, t1      
    addi s2, zero, 0    # i = 0

    for: 
        bge s2, a0, return     # if i >= a return from loop

        addi sp, sp, -8         # make room for 2 register
        sw a0, 4(sp)
        sw a1, 0(sp)
        add a0, s2, a1          # arg = i + b

        jal f2                  # call f2

        add s1, s1, a0          # x = return value of f2 + x
        lw a0, 4(sp)            # restore the original arg values and deallocate space
        lw a1, 0(sp)
        addi sp, sp, 8
        addi s2, s2, 1          # i++
        j for                   # repeat look

return:
    add a0, zero, s1        # return value = x
    lw ra, 8(sp)            # restore prev register and deallocate space
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 12     

    ret                   # return to caller

# a0 = p, s4 = r
f2:
    addi sp, sp, -4      # allocate 1 register(4 bytes) space on stack for r
    sw s4, 0(sp)       # save original value on the space

    addi s4, a0, 5     # r = p + 5
    add a0, s4, a0     # return value is r + p

    lw s4, 0(sp)        # load the saved value into s4
    addi sp, sp, 4           # deallocate the stack space
    ret
    

    