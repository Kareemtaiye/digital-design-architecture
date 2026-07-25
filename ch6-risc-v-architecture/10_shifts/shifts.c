#include <stdint.h>

int main() {
    uint32_t s5 = 0xFF1C10E7;        // Source value
    uint32_t t0 = s5 << 7;           // Logical Shift Left (slli)
    uint32_t s1 = s5 >> 17;          // Logical Shift Right (srli)
    int32_t  t2 = ((int32_t)s5) >> 3; // Arithmetic Shift Right (srai)

    // Extracting bits [15:8] from 0x1234ABCD -> 0xAB
    uint32_t s6 = 0x1234ABCD;
    uint32_t s7 = (s6 >> 8) & 0xFF;  // Shift s6 right by 8, mask bottom byte

    return 0;
}