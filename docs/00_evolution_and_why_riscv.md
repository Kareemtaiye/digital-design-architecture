# 00 — Evolution of RISC-V (Why This Project Is Even Possible)

## Context

Before diving into instruction formats, opcode patterns, addressing modes,
and everything else in this series, it's worth understanding _why_ RISC-V
is the architecture that made a project like this possible in the first place.
This isn't a mechanism to trace or a bit pattern to decode. It's the backstory
that explains several decisions I ran into without knowing the reasoning
behind them.

## What RISC-V Actually Is

RISC-V was designed to be a commercially viable, open-source computer
architecture, which makes it robust, efficient, and flexible. It differentiates itself from
other architectures in a few concrete ways:

- **Open source.** No license required to implement it.
- **Base instruction sets** that keep compatibility simple.
- **Support for the full range of microarchitectures** — from tiny embedded
  chips to high-performance computers.
- **Defined _and_ customizable extensions**, so implementations can scale
  up or down without breaking compatibility with the core.
- **Forward-looking features** (compressed instructions, RV128I) that
  optimize for both current and future hardware, aimed at longevity.

## Why This Matters for This Project Specifically

**Open source is the actual reason a solo learner can do any of this.**
Every other major ISA (x86, ARM) requires a license to legally implement,
which means you can't build a compatible processor without paying and signing
agreements. RISC-V being open is _why_ it's possible to hand-encode
instructions, build a register file, and eventually build a working CPU
from the spec alone, with zero legal or financial gatekeeping.

**Base instruction set + extensions is why RV32I felt learnable in a
bounded way.** Everything in this series so far has been within the _base_
integer set, which is the small, mandatory core.

**RISC-V International existing means the spec isn't arbitrary.** If a weird
edge case or ambiguity ever comes up, there's a real, formal process
behind the decisio and not a single vendor's whim.

## Takeaway

Everything documented in `01` onward only exists as a personal,
self-taught project _because_ of the choices described here: openness,
a minimal mandatory core, and a real standards body keeping it coherent.
Worth remembering as the "why" underneath all the "how" that follows.
