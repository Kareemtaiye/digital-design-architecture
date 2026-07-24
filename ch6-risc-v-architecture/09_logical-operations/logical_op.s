# load test values into registers
lui s0, 0x12345		# Upper 20 bits
addi s0, s0, 0x678	# s0 = 0x12345678

lui s1, 0x46A12	# Upper 20 bits (Added 1 to the original value cos the addi instruction below will sign extend the remaining 12 bits)
addi s1, s1, 0xB77	# s1 = 0x46A11B77

lui s2, 0xFFFF0		# s2 = 0XFFFF0000

# Basic register-to-register operations
and s3, s1, s2		# s3 = s1 & s2 
or s4, s1, s2		# s4 = s1 | s2
xor s5, s1, s2		# s3 = s1 ^ s2 

# Masking Bit 3
and s6, s0, 0xFF7	# s0 = s0 & ~~bit3

# Setting bit 5
or s7, s0, 0x20		#s7 = s0 | (1 << 5)

# Inverting s1
xori s8, s1, -1		# s8 = ~s1 (One's complement of s1)

