# Function Calls: jal vs jalr, and Linker Relaxation

## jal vs jalr — different formats, different purposes

**`jal rd, offset`** — J-type. Target = `PC + offset` (signed 20-bit
immediate, ±1MB reach, always even). **Direct, PC-relative** — destination
baked into the instruction as an offset from where you currently are.
`rd` gets `PC+4` written to it (return address).

**`jalr rd, rs1, offset`** — I-type. Target = `rs1 + offset` (signed 12-bit
immediate, ±2048). **Indirect** — destination comes from a register plus a
small offset, not from the instruction's own bits. `rd` gets `PC+4` written
to it, same as `jal`.

Why both exist: `jal` alone can't guarantee reaching every address in a 4GB
space. `jalr` is also how indirect/computed calls work, since `jal`'s target is fixed at assembly
time, but `jalr`'s target is whatever's in a register at runtime.

`jr ra` is a pseudoinstruction for `jalr x0, ra, 0` — jump to the address in
`ra`, discard the "write return address" side effect by targeting `x0`
(which discards anything written to it, per its hardwired-zero design).

## The `call` pseudoinstruction — why it becomes two instructions

The compiler can't know at compile time whether the target function will
end up within `jal`'s ±1MB reach once everything is linked. So `call func`
conservatively expands to:

```
auipc ra, %pcrel_hi(func)   # ra = PC(of this instr) + upper 20 bits
jalr  ra, %pcrel_lo(func)(ra)
```

**auipc** (Add Upper Immediate to PC): computes `ra = PC(of this
instruction) + (upper20 << 12)`. Placeholder `0x0` gets patched by the
linker once it knows func's real address (relocation `R_RISCV_PCREL_HI20`).

**jalr**: reads `ra`'s _current_ value first to compute the jump target
(`ra_old + lower12`), jumps there — **then**, and only then, overwrites `ra`
with `PC(of this jalr) + 4` (the return address). The read-before-write
order matters: jalr reads rs1 before it writes rd, even when both happen to
be the same register.

## Linker relaxation

If the linker discovers the target actually **is** close enough for `jal`
alone, it rewrites the `auipc`+`jalr` pair down to a single `jal` —
enabled by an `R_RISCV_RELAX` relocation, on by default in GNU toolchains
(`-mno-relax` disables it).

Same relaxation applies to global variable access: the safe 3-instruction
sequence (`auipc`+`addi`+`lw`/`sw`, building a full address) collapses to a
single `gp`-relative instruction if the linker finds the symbol within
`gp`'s ±2048-byte reach.

### Verified in real linked output

Before linking (placeholders):

```
68: 00000097 auipc ra,0x0
6c: 000080e7 jalr ra
```

After linking (func at 0x10144, call site at 0x101a0 — well within ±1MB):

```
101a0: fa5ff0ef jal ra,10144 <func>
```

Global stores collapsed the same way:

```
1018c: c4e1a823 sw a4,-944(gp)   # 11a30 <f>
```

`-944` being negative confirms `f` sits _below_ `gp`, which is consistent with `gp`
deliberately placed at the middle of the segment, reaching both directions.

## Recursive function example (traced end to end)

Full trace of `func(a,b) = b<0 ? a+b : a+func(a,b-1)` compiling to RISC-V,
including prologue/epilogue, caller/callee-save discipline (`ra` and `s0`
saved because `func` is non-leaf and reuses `s0` across the recursive call),
and the compiler's optimization of computing the base case speculatively
before checking the branch condition. See `func`/`main` disassembly notes
in project history for the full line-by-line.
