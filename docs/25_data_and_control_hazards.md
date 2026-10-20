# 25: Data and Control Hazards in the Pipeline

Doc 24 covered the pipelined datapath and ended on the branch problem. This doc covers the fixes: forwarding, the load stall, and branch flushing. All three are handled by a hazard unit that watches the pipeline and controls the muxes, the pipeline registers and the PC.

## The data hazard

An instruction needs a register value that an earlier instruction hasn't written back yet. There are three cases, depending on where the earlier instruction (the producer) is when the later one (the consumer) is in Decode:

| Producer is in | Result                                                                                                                                                      |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Writeback      | No problem. The register file writes on the falling edge and the read is combinational, so the consumer sees the new value in the second half of the cycle. |
| Memory         | Hazard. The value isn't in the register file yet.                                                                                                           |
| Execute        | Hazard. The value isn't in the register file yet.                                                                                                           |

## Forwarding

Forwarding (also called bypassing) sends a result straight from the Memory or Writeback stage to the ALU in the Execute stage, without waiting for it to reach the register file.

Example: add s8, ... followed by sub, or and and, which all use s8.

| Cycle | 1   | 2   | 3   | 4   | 5   | 6   | 7   | 8   |
| ----- | --- | --- | --- | --- | --- | --- | --- | --- |
| add   | F   | D   | E   | M   | W   |     |     |     |
| sub   |     | F   | D   | E   | M   | W   |     |     |
| or    |     |     | F   | D   | E   | M   | W   |     |
| and   |     |     |     | F   | D   | E   | M   | W   |

- sub reaches Execute in cycle 4 while add is in Memory, so s8 is forwarded from Memory.
- or reaches Execute in cycle 5 while add is in Writeback, so s8 is forwarded from Writeback.
- and is in Decode in cycle 5, when add is in Writeback. The falling-edge write covers it, so no forwarding is needed.

### Hardware

A mux goes in front of each ALU input (SrcA and SrcB). Each mux picks from three places:

1. the normal register file value
2. the ALU result in the Memory stage register
3. the result in the Writeback stage

The hazard unit sets the mux selects. For each source register of the instruction in Execute, it checks whether it matches the destination register (Rd) of the instruction in Memory or Writeback, and the matching instruction must actually write a register (RegWrite = 1) and the register can't be x0. If both stages match, Memory wins because its value is newer. This is where Rd traveling through the pipeline registers (doc 24) gets used.

## The load-use hazard

Forwarding doesn't fix everything. lw only has its data at the end of its Memory stage, but a dependent instruction needs it at the start of its Execute stage, and in the normal pipeline those fall in the same cycle. The data isn't there yet.

One cycle of delay fixes it. Then the dependent instruction reaches Execute while lw is in Writeback, and the value can be forwarded from there.

### How the stall works

The hazard unit detects that the instruction in Execute is a load (from ResultSrcE) and that its destination register (RdE) matches a source register of the instruction in Decode. When that happens (lwStall), it does three things:

1. Holds the PC, so Fetch reads the same instruction again.
2. Holds the Fetch-to-Decode pipeline register, so the dependent instruction stays in Decode.
3. Clears the Decode-to-Execute pipeline register (FlushE), which puts a bubble into Execute.

Instructions ahead of lw keep moving. Only the ones behind it are held.

| Cycle                  | 1   | 2   | 3   | 4   | 5   | 6   | 7   | 8   |
| ---------------------- | --- | --- | --- | --- | --- | --- | --- | --- |
| lw                     | F   | D   | E   | M   | W   |     |     |     |
| add (uses lw's result) |     | F   | D   | D   | E   | M   | W   |     |
| sub (independent)      |     |     | F   | F   | D   | E   | M   | W   |

In cycle 4, add stays in Decode, sub is fetched again, and a bubble sits in Execute. In cycle 5, add reaches Execute and gets lw's value from Writeback.

Cost: one lost cycle per load-use pair. A compiler can often avoid it by putting an unrelated instruction between the lw and the instruction that uses it.

### Bubbles are safe

A bubble is a pipeline register cleared to 0, so all its control signals are off: RegWrite, MemWrite, Branch and Jump. It can still read memory or compute an address from leftover data, but nothing gets written, so nothing changes. (This holds for this processor. On real hardware with memory-mapped I/O, a stray read can have side effects.)

### False stalls

The lwStall check is simple, so it sometimes stalls when it doesn't need to:

- when the load's destination is x0, since nothing will use that value
- when bits in an I-type or J-type immediate happen to match RdE, because the hazard unit compares raw instruction bits and doesn't check whether those bits are really a register number

The book says both cases are rare and cost little performance, and loading into x0 is poor coding practice anyway.

## The control hazard (branches)

beq decides in the Execute stage (the ALU produces the Zero flag, and PCSrcE is computed). By then two more instructions have been fetched.

Stalling the pipeline until the branch resolves would cost two cycles on every branch, which hurts because branches are common. The book's pipeline predicts that branches are not taken and keeps fetching in order.

- Prediction right (branch not taken): no cost.
- Prediction wrong (branch taken): the two instructions behind the branch must be flushed.

Book example: a branch at 0x20 jumps to 0x58. The sub at 0x24 and the or at 0x28 have already been fetched, so they get flushed. The add at 0x58 is fetched in cycle 4. The wasted cycles are the branch misprediction penalty.

### Flush hardware

The Decode and Execute pipeline registers get a synchronous clear input (CLR). The hazard unit asserts FlushD and FlushE when PCSrcE = 1, which clears those two registers on the next clock edge. Cleared registers mean all control signals are 0, so the two wrong-path instructions turn into bubbles.

The penalty is 2 cycles per taken branch. Branch prediction in real processors exists to shrink it.

## Effect on CPI

An ideal pipeline would have CPI = 1. Load stalls and branch flushes push it above 1. The size of the gap depends on how often load-use pairs and taken branches show up in the program.

## My note on jal (not from the book)

In this pipeline PCSrcE also includes Jump, so jal pays the same two-cycle flush as a taken branch. That's wasteful, because jal's target is already known when it's decoded.

- Computing the jal target in Decode cuts the penalty to one cycle, not zero, because the instruction fetched while jal was being decoded is still on the wrong path. Getting to zero needs a prediction in Fetch (a branch target buffer).
- jalr is harder to speed up, because its target depends on the value of rs1, so it needs forwarding or a stall before it can be resolved.
- RISC-V doesn't have a branch delay slot. That's a MIPS feature.
