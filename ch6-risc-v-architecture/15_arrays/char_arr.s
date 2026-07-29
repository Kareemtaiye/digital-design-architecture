.globl main

main:
    # s0 = chararr(declared and initialzed earlier), s1 = i
    addi s1, zero, 0	# i = 0
    addi t1, zero, 10	# t1 = 10

    for: bge s1, t1, done  # i >= t1 ?
    	add t2, s0, s1     # t2 = addr of chararr[i]
	lb t3, 0(t2)	   # t3 = chararr[i]

	addi t3, t3, -32   # t3 = chararr[i] - 32
	sb t3, 0(t2)	   # chararr[i] = t3
	addi s1, s1, 1   # i =+ 1
	j for		   # repeat loop

     done:
     li a0, 0
     ret




