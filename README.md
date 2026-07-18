# Digital Design & Architecture Logs

A repository documenting my deep-dive into digital logic, computer architecture, and the hardware-software interface (RISC-V).

Rather than chasing superficial performance or academic grades, this repository serves as a technical ledger of my journey mastering the "silicon-to-software" stack—building a raw, physical intuition for how electricity moving through transistors ultimately powers high-level software and systems AI.

---

## Tech Stack & Tooling

- **HDL:** SystemVerilog
- **Simulation Engine:** Icarus Verilog (`iverilog`), `vvp`
- **Verification & Analysis:** EDA Playground, EPWave (HTML5 Waveform Viewer), DigitalJS (VS Code Integration)
- **Target Architecture:** RISC-V

---

## Technical Insights & Hardware Intuition

All detailed engineering logs, circuit analyses, and waveform breakdown reports are organized inside the [`/docs`](./docs) folder.

### Featured Logs:

- **[Propagation Delays & Critical Paths](./docs/03_propagation_delays.md):** An empirical look at how physical gate delays compound across sequential layers. Highlights the discovery of simulator "lazy evaluation" when handling unknown (`x`) states and asynchronous signal transitions.
- **[The Synchronizer & Metastability (Upcoming)]:** An analysis of clock domain crossing, the physical behavior of a D flip-flop caught on the "knife's edge" of setup-time violations, and how dual-stage airlocks mitigate MTBF.
- **[Sequential Logic Boundaries (Upcoming)]:** Breaking down the architectural hazards of level-triggered D Latches vs. edge-triggered D Flip-Flops, and avoiding unintended latch synthesis by escaping software-centric coding habits.

---

## 📂 Repository Structure

```text
digital-design-architecture/
├── docs/                         # Detailed engineering logs & conceptual breakdowns
│   └── 03_propagation_delays.md
├── assets/                       # Waveform screenshots and hardware schematics
│   └── gate_delay_waveform.png
├── *sv_folders*/                          # SystemVerilog design modules (.sv)
└── tb/                           # Testbenches and simulation vectors
```
