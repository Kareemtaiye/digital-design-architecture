# Digital Design & Architecture Logs

A repository documenting my deep-dive into digital logic, computer architecture, and the hardware-software interface (RISC-V).

Rather than chasing superficial abstractions or memorizing slides, this repository serves as a technical ledger of my journey mastering the "silicon-to-software" stack—building a raw, physical intuition for how electricity moving through transistors ultimately powers high-level software, embedded systems, and hardware accelerators.

---

## Tech Stack & Tooling

* **HDL:** SystemVerilog
* **Simulation & Verification:** Icarus Verilog (`iverilog`), `vvp`, GTKWave
* **Synthesis & Visual Analysis:** Yosys, DigitalJS (VS Code Integration)
* **Target Architecture:** RISC-V (RV32I)
* **Assembly & C Toolchain:** GCC / LLVM 

---

## Technical Insights & Engineering Logs

All detailed engineering write-ups, circuit analysis reports, and timing breakdowns are organized inside the `/docs` directory:

* **`01_z_and_x.md`** — Tri-state buses, floating values, and simulator representation of unknown states.
* **`02_logic_gate_delay.md`** — Propagation delays, critical paths, and empirical observation of simulator state evaluation during asynchronous transitions.
* **`03_sequential_logic.md`** — Clocking, state retention, and feedback loops in hardware logic.
* **`04_latches_flipflops.md`** — Architectural differences between level-triggered latches and edge-triggered flip-flops; strategies for preventing unwanted latch synthesis.
* **`05_fsm_pattern_recognizer.md`** — Mealy vs. Moore state machines, state encoding, and sequence detection.
* **`06_counter.md`** — Synchronous state counters, enable logic, and ripple carry propagation.
* **`07_memory_hierarchy.md`** — Register files, RAM arrays, and address decoding structures.

---

## 📂 Repository Structure

```text
digital-design-architecture/
├── assets/                          # Waveform captures, state diagrams, and schematics
├── build/                           # Output artifacts (sim executables, synth outputs, VCDs)
│   ├── sim/                         # Compiled simulation binaries (.out)
│   ├── synth/                       # DigitalJS hardware visualizations
│   └── waveforms/                   # Value Change Dump (.vcd) timing files
├── ch4-combinational-logic/         # Basic logic gates, adders, muxes, and tri-states
├── ch4-sequential-logic/            # Flip-flops, registers, FSMs, and decoders
├── ch5-digital-building-block/      # ALUs, subtractors, shifters, and comparators
├── ch5-sequential-building-blocks/ # Counters, shift registers, RAM, ROM, and Register File
├── ch6-risc-v-architecture/         # RISC-V ISA exploration and processor implementation
│   ├── 01_add/                      # Assembly vs. C translation examples
│   └── hdl/                         # RISC-V CPU core implementation (.sv)
├── docs/                            # Deep-dive conceptual write-ups & logs
└── test/                            # Unit testbenches (.sv) and vector stimulus files
