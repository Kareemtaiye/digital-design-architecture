.globl main

#s0 = a, s1 = b s2 = c
main:
     addi s0, zero, 10
     addi, s1, zero, 15
     bne s0, s1, L1 #skip if (a != b)
     addi s2, zero, 2   # c = 2
    L1:
     addi, s2, 1 # c = 1

    li a0, 0
    ret 
    

    