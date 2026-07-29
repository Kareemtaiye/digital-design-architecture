.globl main

main:
    # s0 = scores, s1 = i
    # the scores initialization not in code
    addi s1, zero, 0	# i = 0
    addi t2, zero, 200	# t2 = 200

    for: bge s1, t2, done # i >= 200 ? 
	slli t0, s1, 2 	  # t0 = i * 4
	addi t0, t0, s0   # addr of scores[i]
	lw t1, 0(t0)	  # t1 = scores[i]
	addi t1, t1, 10	  # t1 = scores[i] + 10
	sw t1, 0(t0)	  # scores[i] = t1

	addi s1, s1, 1	  # i += 1
	j for		  # repeat loop
		

    done:
    li, a0, 0
    ret

