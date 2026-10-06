---
title: Kernels
---

# Kernels

Every source file with kernels starts with `#include "fundal.H"` (see [Macros](/reference/macros)).

[[toc]]

## A nested loop

Collapse two loops into one kernel; the inner loop runs over the first index, contiguous in memory.

<<< @/examples/snippets/kernels-collapse.F90{fortran}

<<< @/examples/output/kernels-collapse.txt{text}

## A reduction

Sum and maximum of a device array: the clause goes before the macros, in both directives.

<<< @/examples/snippets/kernels-reduction.F90{fortran}

<<< @/examples/output/kernels-reduction.txt{text}

## An iterative solver with swapped buffers

Jacobi iterations for the Laplace equation until the largest change is below a tolerance: the new iterate is written to
a second buffer, and the two pointers are swapped after each iteration.

<<< @/examples/snippets/kernels-jacobi.F90{fortran}

<<< @/examples/output/kernels-jacobi.txt{text}

::: warning
Without the swap, every iteration recomputes the same `tn_dev` from the same `t_dev` and the loop never converges. The
swap exchanges the host pointers only; do not copy one array into the other.
:::

## A kernel in a procedure

Pass the device arrays as dummy arguments and name the dummies in the clauses, as
[tutorial chapter 4](/guide/tutorial/04-routines-types) does:

<<< @/examples/snippets/heat_4-kernel.F90{fortran}

## A procedure working on a mapped array

An array mapped by `dev_alloc_unstr` is found by OpenACC with `present`; OpenMP needs no clause.

<<< @/examples/snippets/kernels-unstructured-routine.F90{fortran}

<<< @/examples/snippets/kernels-unstructured.F90{fortran}

<<< @/examples/output/kernels-unstructured.txt{text}

::: warning
Do not use `DEVICEVAR`/`DEVICEPTR` on mapped arrays, nor `present` on `dev_alloc` pointers with nvfortran: the first are
host arrays with a device copy, the second are device addresses unknown to the present table.
:::

## Which clause for which build

| Memory | OpenACC, nvfortran | OpenACC, gfortran | OpenMP offload | CPU mode |
|---|---|---|---|---|
| `dev_alloc` pointer | `DEVICEVAR` = `deviceptr` | `DEVICEVAR` = `present` | `DEVICEPTR` = `has_device_addr` | `shared` |
| `dev_alloc_unstr` array | `present` | `present` | none | none |
