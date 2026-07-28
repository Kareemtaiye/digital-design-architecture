# s0 = button s1 = amt
.globl main


main: 
     case1: 
     	addi t0, zero, 1	# t0 = 1
	bne s0, t0, case2	# button == 1?
	addi s1, zero, 20	# if yes, amt = 20
	j done

     case2:
     	addi t0, zero, 2	# t0 = 2
	bne s0, t0, case3	# button == 2?
	addi s1, zero, 50	# amt = 50
	j done			# break

     case3:
     	addi t0, zero, 3	# t0 = 3
	bne s0, t0, default	# button == 3?
	addi s1, zero, 200	#amt = 100
	j done

     default:
     	addi s1, zero, 0	# amt = 0
	
     done:
     li a0, 0
     ret




