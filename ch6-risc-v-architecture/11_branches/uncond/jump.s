 j target # jump to target
 srai s1, s1, 2 # not executed
 addi s1, s1, 1 # not executed
 sub s1, s1, 3 # not executed
target:
 add s1, s1, s0 # s1 = s1 + s0
