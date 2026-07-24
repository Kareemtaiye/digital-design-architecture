#include <stdint.h>
#include <stdio.h>

int main() {
    uint32_t s0 = 0x12345678;
    uint32_t s1 = 0x46A11B77;
    uint32_t s2 = 0xFFFF0000;

    // Bitwise AND, OR, and XOR between registers
    uint32_t s3 = s1 & s2; // Mask lower 16 bits (clear them)
    uint32_t s4 = s1 | s2;  // Force upper 16 bits to 1
    uint32_t s5 = s1 ^ s2; //Toggle upper 16 bits

    //Clear (mask) Bit 3 using AND with 0xFF7 (-9 in decimal)
    // 0xFF7 in 12-bit is 1111 1111 0111 (Bit 3 is 0)
    uint32_t s6 = s0 & 0xFFFFFFF7;

    //Set Bit 5 using OR with 0x020 (32 in decimal)
    // 0x020 has bit 5 set to 1
    uint32_t s7 = s0 | 0x020;

    // 4. Invert (NOT) all bits of s1 using XOR with -1 (0xFFFFFFFF)
    uint32_t s8 = ~s1;

    return 0;
}