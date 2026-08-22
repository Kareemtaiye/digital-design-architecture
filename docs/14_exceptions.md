# Exceptions, Interrupts, and CSRs — Hardware as "Unscheduled Function Calls"

## The reframe

An exception is structurally identical to the function-call mechanism. It just triggered by hardware instead of a
`call` instruction, with zero warning to the running program.

| Normal function call              | Exception                                                                              |
| --------------------------------- | -------------------------------------------------------------------------------------- |
| `call func` executed deliberately | Hardware detects a condition (keypress, bad instruction) — no instruction asked for it |
| Save `ra` (return address)        | Hardware saves the PC into `mepc`                                                      |
| Jump to `func`'s address          | Jump to a fixed exception handler address (`mtvec`)                                    |
| Handler does its work             | Same                                                                                   |
| `jr ra` returns                   | `mret` restores PC from `mepc`, resumes program                                        |

## Interrupts vs traps — distinguished by source, not mechanism

|              | Interrupts (hardware)        | Traps/faults (software)                      |
| ------------ | ---------------------------- | -------------------------------------------- |
| Origin       | External events (I/O, timer) | Current instruction in the pipeline          |
| Timing       | Asynchronous — any cycle     | Synchronous — tied to a specific instruction |
| Examples     | Keypress, timer tick         | Illegal instruction, `ecall`, page fault     |
| Resume point | `PC + 4` (next instruction)  | `PC` (re-execute the faulting instruction)   |

## RISC-V mechanism (privileged spec CSRs)

1. **`mepc`** (Machine Exception PC) — hardware copies the faulting/current
   instruction's address here automatically.
2. **`mcause`** — hardware writes a code indicating why (e.g. illegal
   instruction, `ecall`).
3. **`mtvec`** (Machine Trap Vector Base) — hardware overrides PC with this
   address, jumping to the handler.
4. **`mret`** — handler's return instruction; restores PC from `mepc` and
   restores privilege-mode state, resuming the interrupted program.

`mret`/`mepc` is the same "jump using a saved value" pattern as `jr ra`,
just with a dedicated, hardware-protected register instead of a
general-purpose one, which is necessary because an exception can strike at any
arbitrary point, possibly while `ra` is mid-use for something unrelated.
Software can't be trusted to leave `ra` in a known state at every possible
cycle; hardware needs its own protected storage software can't clobber.

## Demystifying "the hardware does X"

"The hardware" isn't a black box — it's wires, registers, and combinational
logic, the same primitives already built by hand (register file, RAM):

- "Hardware saves PC into mepc" = a register (structurally like the
  register file) whose input is wired to PC, write-enable tied to an
  "exception occurred" signal — same pattern as `we3` gating a regfile write.
- "Hardware jumps to mtvec" = a mux sitting before the PC register; one
  select line is "exception occurred?" - when true, the mux picks `mtvec`
  instead of the normal PC+4/branch-target value.
- "Hardware records the cause" = another register, fed by decode logic that
  determines _why_ and encodes it as a number.

Why the vocabulary shifts from "software does" to "hardware does" here:
software can only act by executing instructions in sequence. An exception
can strike between any two instructions with zero warning, and software can't
react to something it has no chance to check for. This response has to be
physically wired into the circuit, always watching, outside the instruction
stream entirely. That's the real dividing line the phrase is marking.
