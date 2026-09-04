# Microarchitecture Design Space

## The core distinction: architecture vs. microarchitecture

A single ISA (instruction set architecture — the RV32I encoding, registers, memory model I already know) can be implemented by many different **microarchitectures**. Architecture defines _what_ a processor must do; microarchitecture defines _how_ it does it. Architectural state: the PC and the 32 registers, must exist in any correct implementation. Everything else a specific microarchitecture adds (extra registers, pipeline stages) is **nonarchitectural state**: hardware needed to make the implementation work, but not part of the definition of "what a RISC-V processor is." A program can never observe nonarchitectural state directly .

## Design process: state first, then combinational logic

Good methodology for building a complex system: start with the state elements (things that must remember something between clock cycles — PC, register file, instruction memory, data memory), then add combinational logic between them to compute new state from current state.

- All memories/register file are **read combinationally**: change the address, the data appears after propagation delay, no clock involved.
- They are **written only on the rising clock edge**: state changes only happen at that instant.
- This makes the whole processor a **synchronous sequential circuit**: clocked state elements + combinational logic, same category as anything else built from flip-flops and gates. A processor is really just a big finite state machine.

## Datapath vs. control unit

- **Datapath**: the wide, 32-bit stuff that actually moves and computes data: memories, register file, ALU, muxes.
- **Control unit**: reads the current instruction's opcode/funct3/funct7 and generates the _select signals_ (mux selects, register write-enables, memory write-enables) that tell the datapath what to do this cycle.

## Why instruction memory and data memory are separate (in single-cycle)

Instructions must be fetched every single cycle to drive the fetch loop. Data memory is only touched by `lw`/`sw`. Single-cycle needs both accessible simultaneously within one cycle, so it uses two separate memories, flagged in the book as "generally unrealistic" for real hardware, which is one of single-cycle's core weaknesses.

## The three microarchitectures — what's actually being traded

|                               | Single-cycle                             | Multicycle                                                    | Pipelined                                                   |
| ----------------------------- | ---------------------------------------- | ------------------------------------------------------------- | ----------------------------------------------------------- |
| Instructions per cycle (rate) | 1 (always)                               | <1 (each instr. spans multiple cycles)                        | ~1 in steady state (throughput)                             |
| Cycle time                    | Fixed to slowest instruction             | Short, but many needed per instruction                        | Fixed to slowest _pipeline stage_                           |
| Hardware                      | Simple, no reuse                         | Reuses adder/ALU across cycles via nonarchitectural registers | More total hardware, but high utilization                   |
| Memory                        | Needs separate I-mem/D-mem (unrealistic) | Single shared memory, accessed on different cycles            | Needs simultaneous instruction+data access → caches (Ch. 8) |
| Real-world use                | Teaching tool                            | Historical low-cost systems                                   | **All modern commercial high-performance processors**       |

**Single-cycle**: one instruction, one clock cycle, always. Simplest to design and reason about — no nonarchitectural state needed at all, since everything finishes before the next clock edge. The cost: cycle time is set by the _slowest possible instruction_ (likely `lw`, since it touches memory + regfile + ALU all in one pass), so every instruction — even a trivial `add` — pays that same slow cost.

**Multicycle**: spreads one instruction across several shorter cycles, reusing the same hardware block (e.g., one adder) for different jobs at different points in executing a single instruction. This requires nonarchitectural registers to hold intermediate results between cycles, since the same physical hardware is doing different jobs moment to moment. Payoff: less total hardware, and a single shared memory becomes workable again (fetch on one cycle, access data on another).

**Pipelined**: applies pipelining to the single-cycle datapath — starts a new instruction every cycle while previous instructions are still mid-flight in different stages (like an assembly line). Gets single-cycle's fast clock _and_ near-1 IPC throughput, without being bottlenecked by the slowest instruction type. Cost: genuinely hard new problem — dependencies between simultaneously in-flight instructions (hazards), plus nonarchitectural pipeline registers to hold state between stages. Needs separate instruction/data _caches_ rather than raw separate memories, since both must be accessed every cycle.
