 addi s0, zero, 4 # s0 = 0 + 4 = 4
 addi s1, zero, 1 # s1 = 0 + 1 = 1
 slli s1, s1, 2  # s1 = 1 << 2 = 4
 bne s0, s1, target # branch is not taken
 add s1, s1, 1 # not executed
 sub s1, s1, s0 # not executed
target: 
 add s1, s1, s0 # s1 = 4 + 4 = 8
