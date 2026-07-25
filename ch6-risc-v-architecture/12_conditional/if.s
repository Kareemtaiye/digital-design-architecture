.globl main

#s0 = apples, s1 = oranges s2 = f, s3 = g, s4 = h
main:
     bne s0, s1, L1 #skip if (apples != oranges)
     add s2, s3, s4
    L1:
     sub s4, s1, s4 # apples = oranges - h

    