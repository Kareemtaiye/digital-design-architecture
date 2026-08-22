# RISC-V Instruction Formats (R, I, S/B, U/J)

## The core idea

All RV32I instructions are 32 bits, always. Variable-length instructions would
add decoder complexity, and a single format would be too restrictive — so
RISC-V compromises with four main formats. This is **Design Principle 4:
good design demands good compromises.**

## The four formats

**R-type** (register-register ops — `add`, `sub`, `and`, `or`, `xor`, `sll`, `srl`, `sra`)

```
31:25    24:20   19:15   14:12    11:7    6:0
funct7   rs2     rs1     funct3   rd      op
7 bits   5 bits  5 bits  3 bits   5 bits  7 bits
```

**I-type** (immediates, loads, `jalr`)

```
31:20          19:15   14:12    11:7   6:0
imm[11:0]      rs1     funct3    rd     op
12 bits        5 bits  3 bits   5 bits  7 bits
```

**S-type** (stores) / **B-type** (branches) — two registers + a signed
immediate, immediate split across fields to keep rs1/rs2 in the same bit
positions as R-type.

**U-type** (`lui`, `auipc`) / **J-type** (`jal`) — one register + a large
(20/21-bit) immediate.

## Key gotcha: register order flips

`add s2, s3, s4` reads left-to-right as dest, src1, src2 in assembly — but
in the 32-bit word, `rd` sits low (bits 11:7), `rs1` next (19:15), `rs2`
above that (24:20). Source and destination are listed left-to-right in
assembly but right-to-left in the machine word.

## Worked examples (hand-verified)

- `add s2, s3, s4` → `add x18, x19, x20`: rd=18, rs1=19, rs2=20, funct7=0, funct3=0, op=51
- `addi s3, s4, 42` → `0x02AA0993`
- `lw t3, -36(s4)` → `0xFDCA2E03`
  - 36 in 12-bit binary: `000000100100`
  - invert: `111111011011`, add 1: `111111011100` → top nibbles = `0xFDC`
  - Negative immediates are just standard two's complement squeezed into
    whatever field width the format gives you. The ALU doesn't need to know
    it's "negative" — it sign-extends and adds, same adder circuit as everything else.

## Why opcode + funct7/funct3 matters

`add` and `sub` share the same opcode (51) and same funct3 (0) — the only
difference is funct7 (0 vs 32). This isn't arbitrary: the ALU has every
operation built in hardware simultaneously (adder, shifter, AND/OR/XOR gates
all sitting in silicon at once). funct7/funct3 aren't _causing_ an operation
— they're a **selector**, like control lines on a mux, choosing which
already-computed result gets passed to the output. Subtraction is just
addition with the second operand inverted and carry-in forced to 1 —
funct7 flips that inversion.

## Instruction formats connect straight to the register file

The 5-bit `rs1`/`rs2`/`rd` fields are the same 5-bit addresses used in a
32-entry register file (2^5 = 32). The encoding isn't inventing a new
number — it's the same width you'd already hardcode in a `regfile` module's
address ports.
