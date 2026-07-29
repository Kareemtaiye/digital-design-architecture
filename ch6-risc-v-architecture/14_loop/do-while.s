.globl main

main:
    # s0 = pow, s1 = x, t0 = target
    addi s0, zero, 1	# pow = 1
    addi s1, zero, 0	# x = 0

    addi t0, zero, 128	# target = 128
    while: slli s0, s0, 1 # pow = pow * 2
    addi, s1, s1, 1	  # x = x + 1
    bne s0, t0, while	  # pow == target(128)?

    done:
    li a0, 0
    ret
