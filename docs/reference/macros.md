---
title: Macros
---

# Macros

## Build macros

Passed on the command line (`-D...`), to FUNDAL and to every source of your program that uses `fundal.H`:

| Macro | Meaning |
|---|---|
| `DEV_OAC` | OpenACC backend |
| `DEV_OMP` | OpenMP offload backend |
| `DEV_HIP` | with `DEV_OMP`, on AMD GPUs: device memory and properties queried from the HIP runtime (link `-lamdhip64`); not used by `fundal.H` |
| `COMPILER_NVF` | nvfortran: required with `DEV_OAC` |
| `COMPILER_GNU` | gfortran: required with `DEV_OAC` |

Neither `DEV_OAC` nor `DEV_OMP` is the compile-time CPU mode. With `DEV_OAC` and no `COMPILER_*` macro, `DEVICEVAR` is
not defined and the OpenACC directives that use it do not compile (FUNDAL's own `dev_alloc` has one).

## fundal.H

`src/lib/fundal.H`, included at the top of a source file with `#include "fundal.H"` (compile with `-I<FUNDAL>/src/lib`):

```c
/* cpp macros to setup backends */
#if defined DEV_OAC
#   define DEVMODULE openacc
#   if defined COMPILER_NVF
#      define DEVICEVAR deviceptr
#   elif defined COMPILER_GNU
#      define DEVICEVAR present
#   endif
#elif defined DEV_OMP
#   define DEVMODULE omp_lib
#   define DEVICEPTR has_device_addr
#   define OMPLOOP target teams distribute parallel do
#else
#   define DEVMODULE omp_lib
#   define DEVICEVAR shared
#   define DEVICEPTR shared
#   define OMPLOOP parallel do
#endif
```

| Macro | `DEV_OAC` + `COMPILER_NVF` | `DEV_OAC` + `COMPILER_GNU` | `DEV_OMP` | CPU mode |
|---|---|---|---|---|
| `DEVICEVAR` | `deviceptr` | `present` | not defined | `shared` |
| `DEVICEPTR` | not defined | not defined | `has_device_addr` | `shared` |
| `OMPLOOP` | not defined | not defined | `target teams distribute parallel do` | `parallel do` |
| `DEVMODULE` | `openacc` | `openacc` | `omp_lib` | `omp_lib` |

## The kernel pattern

```fortran
!$acc parallel loop [clauses] DEVICEVAR(a, b)
!$omp OMPLOOP [clauses] DEVICEPTR(a, b)
do i=...
```

<<< @/examples/snippets/kernels-reduction.F90{fortran}

- `DEVICEVAR` belongs to the `!$acc` line, `OMPLOOP` and `DEVICEPTR` to the `!$omp` line. The other clauses
  (`collapse`, `reduction`, `private`) are written in both.
- Only the directive of the enabled model is compiled; the other is a comment, and its undefined macros do not matter.
  Do not enable OpenACC and OpenMP in the same build.
- Name in `DEVICEVAR`/`DEVICEPTR` only structured device arrays (`dev_alloc` pointers or dummy arguments associated with
  them). Arrays mapped by `dev_alloc_unstr` take `present` (OpenACC) and no clause (OpenMP).
- The OpenACC specification allows `deviceptr` only on dummy arguments that are not pointers: in portable code, put
  kernels in procedures that receive the device arrays as arguments
  ([tutorial chapter 4](/guide/tutorial/04-routines-types)). nvfortran also accepts pointer variables.
- In the CPU mode the `!$omp` line is `!$omp parallel do shared(...)`: host threads if OpenMP is enabled, a serial loop
  otherwise.
- `DEVMODULE` names the runtime module, for `use DEVMODULE` in code that calls `acc_*`/`omp_*` routines directly.
