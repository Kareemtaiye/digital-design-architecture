# RISC-V Addressing Modes

Fewer addressing modes = simpler decode/execute hardware. Same tradeoff logic as the four instruction formats
(Design Principle 4).

## The modes

- **Register addressing** — operand is a register value.
  `add s0, s1, s2`

- **Immediate addressing** — operand is baked into the instruction itself.
  `addi s3, s4, 42`

- **Base + offset (displacement)** — used for loads/stores. `rs1` holds a
  base address, the immediate is a signed offset added to it.
  `lw t3, -36(s4)` → address = s4 + (-36)

- **PC-relative** — used for branches/jumps. The immediate is added to the
  **program counter**, not a register (`beq`, `jal`). Branch/jump immediates
  are shifted left by 1 since instructions are minimum 2-byte aligned.

## Why `gp` sits in the middle of global data, not the start

This is the clever payoff of base+offset addressing. The 12-bit
signed offset from I-type addressing can only reach ±2048 bytes from
wherever the base register sits. Put `gp` at the **middle** of the global
data segment instead of the start, and that same ±2048 window covers a full
4KB range instead of only reaching forward.

## `%hi`/`%lo` — splitting a 32-bit address across two instructions

No RISC-V instruction has a 32-bit immediate field. Global variable access
(`f = 2;`) compiles to:

```
lui  a5, %hi(f)
sw   a4, %lo(f)(a5)
```

`lui` places the upper 20 bits directly into bits 31:12, zeroing the bottom
12 (`imm << 12` — not multiplication, just positioning the 20 bits you have
into the top of a 32-bit value). `%lo(f)` supplies the bottom 12 bits as the
signed offset in the store — same base+offset mechanism as `lw t3, -36(s4)`.

`lui`/`%hi`/`%lo` → **absolute** address, no PC involved.
`auipc`/`%pcrel_hi`/`%pcrel_lo` → **PC-relative** address (see 04 for why
function calls use this variant instead).
