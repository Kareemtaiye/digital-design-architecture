# Endianness

## The core idea

Endianness = which byte of a multi-byte value lives at the lowest memory
address. Word addresses are identical either way. only the addressing of
individual **bytes within a word** differs.

- **Big-endian**: most significant byte at the lowest address (reads
  naturally, matches how you'd write the number on paper).
- **Little-endian**: least significant byte at the lowest address (looks
  "backwards" reading memory left to right).

RV32I is little-endian by default (spec technically allows big-endian
variants, rarely seen in practice).

## Why it's invisible until you access bytes

If a whole 32-bit word is read/written at once (as with the RAM/regfile
modules built earlier in this project), endianness is invisible. It only
becomes visible at **byte-level** access (`lb`/`sb`), like the string
indexing done in the `.data`/`.bss`/`.rodata` practice program (`str1`,
`str2`).
