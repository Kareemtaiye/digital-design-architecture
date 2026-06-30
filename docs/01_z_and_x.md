### 1. Demystifying `z` (High Impedance) and `x` (Contention)

Coming from a traditional software background, it's easy to view variables as abstract values or `null`. Working with HDLs forces a shift to physical reality: wires don't just hold data; they handle electrical pressure (voltage).

- **`z` (Floating/High Impedance):** This is not a logical `0` or `1`. It represents a wire that has been physically disconnected from its electrical source by a **tristate buffer** ($E=0$). Because a microscopic copper wire cannot hold charge like a battery, its voltage drops instantly. It becomes electronically invisible.
- **`x` (Contention/Unknown):** If multiple tristate buffers try to drive a shared bus simultaneously with conflicting values (one pulling to Power, one draining to Ground), the circuit faces **contention**. This creates illegal voltage zones and physical heat, flagged by the simulator as an unstable `x`. If all gates float at `z`, noise distorts the wire into an unpredictable `x` state.
