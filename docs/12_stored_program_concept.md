# Stored Program, Memory Map, and the Compile→Link→Load Pipeline

## Stored program concept

Instructions are just 32-bit numbers, same as data, sitting in memory. The
processor doesn't "know" what it's running, it just does one loop forever:
fetch the instruction at PC, execute it, PC += 4, repeat. That relentless
loop is the entire illusion of a program "running." No dedicated rewiring
needed to run a different program, just different bits in memory. This is
the actual reason general-purpose computing exists (as opposed to dedicated
hardware for each task).

**Architectural state** = everything that determines what a program will do
next: **memory + register file + PC**. Nothing else. This is exactly what an
OS needs to save/restore to pause a program and resume it later, unaware it
was ever interrupted.

## Compile → assemble → link → load pipeline

1. **Compiler**: high-level code → assembly
2. **Assembler**: assembly → machine code (object file) — this is the step
   done by hand throughout this project (hand-encoding instructions to hex).
3. **Linker**: combines object files/libraries, resolves final addresses and
   branch targets, patches relocation placeholders (see doc 04).
4. **Loader**: places final machine code into memory, sets PC to start.

By the time bits hit real hardware, there is no concept of "functions" or
"variables", as those are just pure compiler/assembler abstractions, erased before
execution. This is the crux of hardware-software codesign: understanding
where the line sits between what the compiler figures out and what the
silicon actually has to do.

## Why symbol order in source files doesn't matter

Assemblers run in (effectively) two passes: Pass 1 builds a complete symbol
table of every label in the file, regardless of where it's written. Pass 2
generates machine code, looking up symbols in the already-complete table.
`main` referencing `f`/`g`/`y` before their `.comm`(bss data) declarations later in the
file works because of this and often isn't even fully resolved until the
**linker** runs, since final memory addresses aren't known until link time.
The assembler just emits a placeholder + relocation entry.

## The memory map

32-bit address space = 4GB. Divided into segments: text, global data,
dynamic data (stack + heap), exception handlers/OS.

- **Text segment**: machine code, literals, read-only data.
- **Global data segment**: global variables, accessed via `gp` (x3),
  deliberately placed at the _middle_ of the segment (see doc 03).
- **Dynamic data segment**: stack (grows down from top, `sp`/x2 initialized
  by the OS) and heap (grows up from bottom, allocated via `malloc`/`new`).
  Stack and heap grow toward each other on purpose — collision detection
  reduces to "have these two pointers crossed."

### Segfaults, explained via the memory map

- **Writing to a string literal** (`char *str = "..."; str[0]='h';`) →
  string lives in `.rodata`, a _write_ (`sw`/`sb`) targets a read-only page.
- **NULL pointer dereference** → address `0x0` sits in the
  reserved/exception segment, unmapped for user programs.
- **Stack overflow** → infinite recursion pushes `sp` past the segment's
  unmapped boundary.
- **Use-after-free** → accessing heap memory already returned to the OS.

Important nuance: the assembler/linker only _labels_ a section read-only in
ELF metadata. It's the **OS loader + MMU** that actually enforces it, by
marking pages non-writable in hardware page tables at load time. On
bare-metal (no OS, no MMU), that protection doesn't exist — writing to
`.rodata` wouldn't segfault, it would silently corrupt memory or hit ROM.
Segfaults are an OS/MMU feature, not an inherent property of `.rodata`.

## Assembly directives

Directives are the assembler's way of saying which segment something
belongs to:

- `.text` / `.data` / `.bss` — shorthand for `.section .text` etc.
- `.section <name>` — the general/universal directive; `.rodata` is a
  standard ELF section name, not a core RISC-V directive — it's created via
  `.section .rodata`.
- `.word` / `.byte` / `.string` — reserve and initialize memory.
- `.global`/`.globl` — expose a label to the linker across object files.
- `.align` / `.balign` — enforce alignment; RISC-V requires 4-byte
  instruction alignment, misalignment can trigger a hardware exception.
- `.comm` — declares an uninitialized global scalar (`.bss`-equivalent),
  lets the linker merge/place it across files.

## Toolchain notes (Apple Silicon)

- Native macOS `gcc`/`clang`/`objdump` target ARM64 and are LLVM-based —
  won't produce or correctly disassemble RISC-V code.
- Needed a real RISC-V cross-toolchain: `brew tap riscv-software-src/riscv`
  - `brew install riscv-gnu-toolchain`, then use the `riscv64-unknown-elf-*`
    prefixed tools.
- `-march=rv32i -mabi=ilp32` flags needed to target RV32 (default is RV64).
