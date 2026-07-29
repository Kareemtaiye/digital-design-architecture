.globl main

main:
    # s0 = sum, s1 = i
    addi s0, zero, 0	# sum = 0
    addi s1, zero, 0	# i = 0
    addi t0, zero, 10	

    for: bge s1, t0, done	# i >= 10
         addi s0, s0, s1	# sum = sum + i
	 addi s1, s1, 1		# i = i + 1
	 j for			# repeat loop
    
    done:
    li a0, 0
    ret
