---
title: 3. Portable kernels
---

# 3. Portable kernels

Now the solver advances in time on the device: 15 cells, 50 steps of the explicit scheme, starting from a sine arch.
The kernel is an ordinary loop with an OpenACC and an OpenMP directive; the clauses that differ between backends and
compilers come from `fundal.H`, included at the top of the source file (it is a C preprocessor header: the file must be
preprocessed, `.F90` or `-cpp`/`-fpp`):

<<< @/examples/snippets/heat_3-include.F90{fortran}

<<< @/examples/snippets/heat_3-step.F90{fortran}

- With OpenACC the compiler reads the `!$acc` line: `DEVICEVAR` becomes `deviceptr` with nvfortran, `present` with
  gfortran. The `!$omp` line is a comment.
- With OpenMP offload it reads the `!$omp` line: `OMPLOOP` becomes `target teams distribute parallel do` and
  `DEVICEPTR` becomes `has_device_addr`.
- In the compile-time CPU mode `OMPLOOP DEVICEPTR(...)` becomes `parallel do shared(...)`, active only if OpenMP is
  enabled.

The scalars `n` and `r` need no clause: they are copied to the kernel. After each step the two pointers are swapped:
only the host descriptors change, no data moves.

## Checking the result

<<< @/examples/snippets/heat_3-check.F90{fortran}

<<< @/examples/output/heat_3.txt{text}

The device result agrees with the exact discrete solution to round-off. The whole program:

<<< @/examples/snippets/heat_3.F90{fortran}

::: warning deviceptr is meant for dummy arguments
The OpenACC specification allows `deviceptr` only on dummy arguments without the `pointer` attribute. nvfortran also
accepts a pointer variable, as in this chapter; a portable code passes the device arrays to a procedure, which the next
chapter does. Enable only one offload model per build: with both OpenACC and OpenMP enabled, the macros of the other
backend are left undefined in its directives.
:::

::: tip What you learned
`#include "fundal.H"`; one kernel, two directives; `DEVICEVAR`, `DEVICEPTR`, `OMPLOOP`; pointer swaps; a kernel that
checks itself against an exact solution.
Reference: [Macros](/reference/macros).
:::

Next: [4. Routines and types](./04-routines-types).
