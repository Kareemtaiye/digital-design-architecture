# 10 — Exceptions, Interrupts, CSRs, and What "The Hardware" Actually Means

## The core reframe

An exception is an **unscheduled function call** — structurally identical
to a normal `call`/`jal`, except triggered by hardware instead of software,
and with zero warning.

| Normal function call              | Exception                                                      |
| --------------------------------- | -------------------------------------------------------------- |
| `call func` executed deliberately | Hardware detects a condition (keypress, bad instruction, etc.) |
| Save `ra` (return address)        | Hardware saves PC into `mepc`                                  |
| Jump to `func`'s address          | Jump to a fixed exception handler address (`mtvec`)            |
| Handler does its work             | Same                                                           |
| `jr ra` returns                   | `mret` restores PC (and privilege — see doc 09)                |

## Interrupts vs. traps

|              | Interrupts (hardware)        | Traps/faults (software)                                        |
| ------------ | ---------------------------- | -------------------------------------------------------------- |
| Origin       | External events (I/O, timer) | Instructions currently executing                               |
| Timing       | Asynchronous — any cycle     | Synchronous — exact instruction                                |
| Examples     | Keypress, timer tick         | Illegal instruction, `ecall`, page fault                       |
| Resume point | Next instruction (`PC+4`)    | Often the _faulting_ instruction (`PC`), re-executed after fix |

## The RISC-V mechanism (CSRs)

1. **`mepc`** — hardware copies the address of the current/faulting
   instruction here automatically.
2. **`mcause`** — hardware writes a code indicating _why_ (e.g. `0x2`
   illegal instruction, `0x8` ecall).
3. **`mtvec`** — PC gets overridden with this address; execution jumps to
   the handler.
4. **`mret`** — handler finishes, this instruction restores PC from `mepc`
   (and privilege level — doc 09) to resume exactly where execution left off.

Why dedicated CSRs instead of reusing `ra`/general registers the way
`jal`/`jalr` do: a normal function call trusts _software_ to keep `ra` in a
known, uncorrupted state. An exception can strike at literally any point
mid-instruction, possibly while `ra` is already in use for something
unrelated. Hardware needs protected storage software can't accidentally
clobber, because the entire point of an exception is that the program had
zero warning and zero chance to prepare.

## What "the hardware does X" actually means

This phrase shows up constantly in the textbook as a vague catch-all. It's
not magic — it always cashes out to **wires, registers, and combinational
logic**, the same primitives already built by hand (regfile, RAM).

Concrete translations:

- _"Hardware saves PC into `mepc`"_ = a register (structurally like the
  register file already built) whose input is wired to PC, with its
  write-enable tied to an "exception occurred" signal. Mechanically
  identical to the regfile's `we3` gating a write, just a different
  trigger condition.
- _"Hardware jumps to `mtvec`"_ = a mux sitting right before the PC
  register. One select line is "exception occurred?". When true, the mux
  picks `mtvec`'s value instead of the normal `PC+4`/branch-target value.
- _"Hardware records the cause into `mcause`"_ = another register, written
  the same way, fed by decode logic that determines _why_ the exception
  happened.

## Why this has to be hardware, not software

Software can only react by executing instructions, in sequence, at
addresses the program controls. An exception can strike _between_ any two
instructions with zero warning — by the time an instruction could check
"did an exception happen?", it might be too late. This response has to be
physically wired into the circuit, always watching, every clock cycle,
completely outside the instruction stream. That's the real reason the
vocabulary shifts from "the program does" to "the hardware does" — it
marks a boundary: everything past that line happens automatically, whether
or not any instruction asked for it.

**Mental substitution going forward:** whenever a text says "the hardware
handles this," try substituting _"there's a register/mux/gate combination,
wired to fire on a specific condition, with no instruction telling it to."_
If that substitution doesn't resolve cleanly, that's the sign to dig into
what's actually being described — which is exactly what Chapter 7 (building
the actual microprocessor) will force into the open.
