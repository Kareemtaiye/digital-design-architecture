.globl main

main:
    # Load 0xFF1C10E7 into s5  
     lui s5, 0xFF1C1
     addi s5, s5, 0x0E7	 #s5, 0xFF1C10E7

     # Shift operations
     slli t0, s5, 7
     srli s1, s5, 17
     srai t2, s5, 3

     # Extracting [15:8] from 0X1234ABCD
     lui s6, 0x1234B #0x1234A + 1
     addi s6, s6, 0xBCD #s6 = 0x1234ABCD

     srli s7, s6, 8 # s7 = 0x001234AB
     andi s7, s7, 0xFF #s7 = 0xAB 
    
     # Return 0
     li a0, 0  # Return code 0
     ret       # Return from main

