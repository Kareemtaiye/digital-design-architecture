# Reset Vector

Reset is just another exception, with the same PC-redirect mechanism as any
other exception, except it's triggered by power-on instead of a keypress,
illegal instruction, or `ecall`.

There's no separate "how does a processor start running" logic sitting
apart from the exception system. At power-on, the hardware forces PC to a
fixed, hardwired address: the **reset vector**, the exact
same way `mtvec` redirects PC for any other exception. Reset is simply the
first exception a processor ever handles, unconditionally, before any
instruction has executed.

The condition here is just "power just turned on," instead of "illegal instruction detected."

## What happens at the reset vector

**With an OS:**

- Processor jumps to the reset vector at boot
- Boot code (the boot loader) runs at M-mode (highest privilege — nothing
  else is set up yet)
- Boot code configures the memory system, initializes CSRs, sets up the
  stack pointer
- Boot code reads part of the OS off disk
- A much longer OS boot process follows
- Eventually: OS loads a program, drops privilege to U-mode, jumps to the
  start of that program

**Bare metal (no OS):**

- Processor jumps to the reset vector at boot
- User code — potentially preceded by a small amount of boot code just to
  set up the stack pointer (`crt0`/`_start`), and is placed **directly** at
  the reset vector
- No privilege drop, no disk load, no separate boot stage. You _are_
  the boot code, the kernel, and the program, all running at M-mode,
  the whole time

## Why "reset" counts as an exception at all

Reset isn't a typical exception. It doesn't occur _during_ program
execution, since by definition nothing has executed yet. It's called an
exception anyway because it represents an "exceptional state" of the
processor: a condition (power-on) that forces PC away from normal
sequential flow, exactly like any other exception does.

## Tying back to the fetch loop

The stored-program fetch loop (fetch instruction at PC → execute → PC+4 →
repeat) needs a _starting_ PC value before it can begin at all. That
starting value is the reset vector, hardwired into the
processor. Put together:

- **Stored program** — the loop that runs forever once started
- **Exceptions** — the mechanism that can redirect PC under certain
  conditions
- **Reset** — the very first, unconditional PC redirection, which is what
  gives the fetch loop somewhere to start from in the first place
