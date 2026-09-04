# Execution Modes and Privilege Levels

## The core idea

A RISC-V processor can run in one of several **privilege levels**, which
dictate what instructions can be executed and what memory/registers can be
accessed:

- **M-mode (Machine mode)** — highest privilege. Full access to everything.
  The _only_ required mode, and the _only_ mode used in systems with no OS
  (bare metal, many embedded systems).
- **S-mode (Supervisor mode)** — where an OS kernel runs.
- **U-mode (User mode)** — where ordinary user applications run. No access
  to privileged registers or OS-reserved memory.
- **H-mode (Hypervisor mode)** — optional, sits between S and M. Supports
  virtualization (multiple OSes on one physical machine). Not relevant until
  deep into OS/systems work — noted for later, not needed now.

## Why this exists

Same motivation as the exceptions: **protecting
architectural state from corruption.** Without privilege separation, any
user program could freely overwrite kernel memory or registers, accidentally
or maliciously. Privilege levels make that impossible _at the hardware
level_, not because the program is well-behaved, but because the hardware
itself refuses the access.

## Where this fits in my own learning path

This maps directly onto the order I'm learning things in:

- **Bare metal (next phase) → M-mode only.** No OS means no need for
  privilege separation. Everything I write runs at the top level. My
  `crt0`/startup code won't need to think about privilege at all yet.
- **OS (later phase) → U-mode and S-mode become real.** The OS runs in
  S-mode; the programs it runs on top of run in U-mode. This is the whole
  point of an OS existing at all. A hardware-enforced boundary between
  "programs I don't trust" and "the kernel that has to stay intact."

## The connection to `mret`

This explains something I flagged as a loose end in exceptions doc:
`mret` doesn't just restore the PC — it also has to restore the _privilege
level_ the program was running at before the exception. An exception
handler runs with escalated privilege (M-mode, or S-mode depending on
setup) so it actually has the access it needs to fix things. If `mret` only
restored PC and left execution stuck in the escalated mode, every user
program would end up running with kernel-level access after its first
interrupt, which defeats the entire purpose of having privilege levels at
all.

## Hardware reframe

Privilege mode isn't magic. It's just another piece of state, typically
stored in a small register (often folded into `mstatus`, another CSR).
"Checking privilege before allowing an instruction" is a comparison circuit
gating whether a memory access or CSR write is permitted to proceed.
