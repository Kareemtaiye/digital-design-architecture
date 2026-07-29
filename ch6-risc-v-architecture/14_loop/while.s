# s0 = pow, s1 = x, t0 = target

.globl main

main:
     addi s0, zero, 1	# pow = 1
     addi s1, zero, 0	# x = 0
     addi t0, zero, 128	# target = 128

     while: beq s0, t0, done	# pow = target(128)?
     	slli s0, s0, 1		# pow = pow * 2
	addi, s1, s1, 1		# x = x + 1
	j while			# repeat while loop

     done:
     li a0, 0
     ret
