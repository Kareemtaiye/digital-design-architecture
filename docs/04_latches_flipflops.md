# Architectural Log: Latches vs. Flip-Flops & The HDL Mindset

In this entry, I break down the transition from edge-triggered sequential logic to level-triggered logic, analyzing the mechanics of a D Latch and the common pitfalls of treating a Hardware Description Language (HDL) like traditional software.

---

## 1. Core Mechanics: Flip-Flop vs. Latch

The fundamental difference between a D Flip-Flop and a D Latch comes down to **when** the device is allowed to sample its input wire (`d`) and update its state (`q`).

| Device          | Trigger Type        | Window of Operation                       | Behavior                                                                                                                                              |
| :-------------- | :------------------ | :---------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------- |
| **D Flip-Flop** | **Edge-Triggered**  | Pos-edge fraction of a picosecond         | **Opaque** at all times except the exact moment the clock transitions from `0` to `1`.                                                                |
| **D Latch**     | **Level-Triggered** | Entire duration of the `HIGH` clock phase | **Transparent** while the clock is `HIGH` (any changes to `d` instantly pass through to `q`). Becomes **Opaque** the moment the clock drops to `LOW`. |

---

## 2. SystemVerilog Idiom for a D Latch

While edge-triggered circuits are the commercial standard, a basic transparent latch can be described using an `always` block that is sensitive to both the clock level and the input data:

```
systemverilog
module latch(input  logic     clk,
             input  logic d,
             output logic q);

    always_latch
        if (clk) q <= d; // Transparent when clk is high
endmodule
```

## The Danger of **Unintended Latches**

In modern hardware pipelines(e.g RISC-V microarchitecture), latches are generally avoided due to the complexities they introduced to timing analysis. A major hazard for SE/SD transitioning to hardware is the creation of _unintended_ latches.

It may happend when writing a combinational logic inside a standard conditional statement(if-else or case block) and every single path is not explicitly mapped.
If a path is omitted:

// WARNING: HARMFUL CODE EXAMPLE (Implying a Latch)

```
    always_comb begin
    if (en) y = a; // Missing the "else" branch!
end
```

The synthesis engine cannot assume what y should be when en is false. To guarantee that y retains its previous state, the compiler is forced to manufacture a physical hardware latch out of silicon.
