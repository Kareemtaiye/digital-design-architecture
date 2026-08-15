.globl main	# Make the main label global
.equ N, 5	# N = 5

.data		# global data segment
A: .word 5, 42, -88, 2, -5033, 720, 314
str1: .string "RISC-V"

.align 2	# align next data on 2^2 byte address boundary
B: .word 0x32A	

.bss		# bss segments
C: .space 4
D: .space 1

.balign 4	# align next data on 4 byte boundary
.text		# text segment(code)

main:
    la t0, A	# t0 = addr of A
    la t1, str1	# t1 = addr of str1
    la t2, B	# t2 = addr of B
    la t3, C	#....
    la t4, D
    lw t5, N*4(t0)	# t5 = A[N] = A[5] = 720
    lw t6, 0(t2)	# t6 = 0x32A(810)
    add t5, t5, t6	# t5 = 720 + 810 = 1530
    sw t5, 0(t3)	# C = 1530
    lb t5, N-1(t1)	# t5 = str1[N-1] = str1[4] = '-'
    sb t5, 0(t4)	# D = '-'
    la t5, str2		# t5 = addr of str2
    lb t6, 8(t5)        # t6 = str2[8] = 'r'
    sb t6, 0(t1)	# str1[0] = 'r'
    jr ra

.section .rodata
str2: .string "Hello world!"
.end 			# End of assembly line


