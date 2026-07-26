.globl main

#s0 = a, s1 = b, s2 = c
main:
     addi s0, zero, 50  # a = 50
     addi s1, zero, 60  # b = 60

     beq s0, s1, L1  # if (a == b), branch straight to the ELSE block
	
     #if (a = b)	
     addi s2, zero, 1
     j L2  

    L1: 
     addi s2, zero, 2

    L2:
    li a0, 0
    ret
     
