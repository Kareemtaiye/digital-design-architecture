# Digital Design & Architecture Logs

A repository documenting my deep-dive into digital logic, computer architecture, and the hardware-software interface (RISC-V).

---

## Technical Insights & Hardware Intuition

### 1. Demystifying `z` (High Impedance) and `x` (Contention)

Coming from a traditional software background, it's easy to view variables as abstract values or `null`. Working with HDLs forces a shift to physical reality: wires don't just hold data; they handle electrical pressure (voltage).

- **`z` (Floating/High Impedance):** This is not a logical `0` or `1`. It represents a wire that has been physically disconnected from its electrical source by a **tristate buffer** ($E=0$). Because a microscopic copper wire cannot hold charge like a battery, its voltage drops instantly. It becomes electronically invisible.
- **`x` (Contention/Unknown):** If multiple tristate buffers try to drive a shared bus simultaneously with conflicting values (one pulling to Power, one draining to Ground), the circuit faces **contention**. This creates illegal voltage zones and physical heat, flagged by the simulator as an unstable `x`. If all gates float at `z`, noise distorts the wire into an unpredictable `x` state.

### 2. Zero-Cost Bit Swizzling

In software, isolating or rearranging bits requires logical shifting and masking operations (`(a << 2) | (b & 0x03)`), burning active CPU cycles. In hardware description languages, bit swizzling/concatenation via the `{}` operator is physically **free**.

It represents the direct physical routing and joining of copper tracks in mid-air. The moment electricity enters the source bus, it is instantly present at the destructured destination wires with zero gate overhead and 0ns of delay.

### 3. Modeling Physical Reality: Propagation Delay

Digital logic doesn't compute instantly; transistors require physical time to switch state based on their capacitance. Using directives like \` \`timescale 1ns/1ps \`, we can model sequential delays down to the picosecond:

\`\`\`systemverilog
// Parallel inversion layer introducing a 1ns gate delay
assign #1 {ab, bb, cb} = ~{a, b, c};
\`\`\`

Using **destructuring assignments** on the left side of the block allows us to immediately shatter multi-bit buses into explicitly named, readable signal tracks, mimicking the physical separation of wires across a microchip layout.
