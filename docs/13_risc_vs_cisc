# RISC vs CISC — Why RISC-V Is Learnable at This Pace

## The insight

RISC-V does everything a CISC architecture like x86 does, it just gets
there through **composition of simple primitives** instead of **one
instruction doing a lot**. x86 might load, add, and store in a single
instruction. RISC-V does the same job as three separate instructions, but
each one maps to hardware simple enough to actually draw and build.

## The tradeoff

- **RISC-V**: more instructions per program, but each instruction is
  trivial to decode/execute → simpler hardware, easier to pipeline, easier
  to reason about.
- **CISC (x86)**: fewer instructions per program, but each can be a small
  saga to decode → the decoder itself becomes a significant chunk of the
  chip, harder to pipeline cleanly.

## Why this matters practically

This is directly why hand-encoding instructions, understanding fixed field
positions, and building an actual register file is even feasible as a solo,
few-weeks project. Nobody hand-builds an x86 decoder for fun, the
complexity is the whole point of why it needs a team and years. RISC-V
being learnable module by module is a direct consequence of the same
simplicity that makes it fast and simple in hardware.

Reused evidence for this, from earlier work in this project:

- Fixed field positions across all four instruction formats (opcode always
  bits 6:0, rd always bits 11:7 where present, rs1 always bits 19:15). A
  decoder can extract these before even knowing the full instruction format.
- The opcode bit-pattern structure (see doc 09) is a format recognizable from
  a handful of top bits, not a flat lookup.
- Small, fixed set of addressing modes (see doc 10) instead of an open-ended
  list like some CISC ISAs support.
