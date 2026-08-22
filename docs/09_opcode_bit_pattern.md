# Opcode Bit Patterns — Recognizing Format from Bits Alone

## The discovery

While decoding instructions by hand, noticed the opcode bits themselves
follow a structure — not just a flat lookup table. Every RV32I opcode ends
in `11` (bits 1:0), but bits 6:5 and bit 4 further narrow down the format
family before you even need funct3/funct7.

## Verified against real RV32I opcodes

| Format              | Opcode (binary) | bit6  | bit5  | bit4  |
| ------------------- | --------------- | ----- | ----- | ----- |
| R-type ALU          | `0110011`       | 0     | **1** | **1** |
| I-type ALU (addi)   | `0010011`       | 0     | 0     | **1** |
| I-type Load (lw)    | `0000011`       | 0     | 0     | **0** |
| S-type Store (sw)   | `0100011`       | 0     | **1** | 0     |
| B-type Branch (beq) | `1100011`       | **1** | **1** | 0     |

Patterns that hold:

- R-type ALU: bits 5,4 = `11`
- I-type ALU: bit4 = `1`, bit5 = `0` (immediate, no second register)
- I-type Load: bit4 = `0`
- S-type: bit5 = `1` only
- B-type: bits 6,5 = `11`

## Why this isn't a coincidence

This is the actual structure of the real RISC-V opcode map — the spec
organizes all opcodes into a grid keyed by bits [6:5] and [4:2] for exactly
this reason. It's the literal first switch statement in every real RISC-V
decoder: hardware checks these top bits before it needs the rest of the
opcode to know "which family am I in."

## Where the reflex is actually useful

- **Decoder design (Ch. 7 territory)**: the decoder's first job is exactly
  this — look at bits 6:0, determine format, route the rest accordingly.
- **Debugging**: waveform viewers often show raw hex on the instruction bus,
  not clean assembly. Recognizing "I-type, ALU-immediate" from `0x02AA0993`
  at a glance is a real practical skill.
- **Not useful for**: memorizing every funct3/funct7 combo by heart — that's
  what the reference table (Appendix B) is for. The valuable skill is format
  recognition from opcode; specific operation within a format is a lookup,
  not a memory feat.
