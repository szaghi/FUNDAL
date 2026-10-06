---
title: 4. Routines and types
---

# 4. Routines and types

A real solver keeps its state in a derived type and its kernels in procedures. Here the two device arrays become
components of a `heat_solver` type, and the step becomes a procedure:

<<< @/examples/snippets/heat_4-kernel.F90{fortran}

Inside `diffuse`, `t` and `tn` are plain assumed-shape dummy arguments: the procedure does not know that they hold
device memory, and `DEVICEVAR`/`DEVICEPTR` tell the compiler. This is the form the OpenACC specification defines for
`deviceptr`, and the one that works with every compiler. The lower bound `0` in the declaration keeps the ghost-cell
indexing of the caller (an assumed-shape dummy otherwise starts at 1).

The type only stores the pointers, and passes its components to the kernel:

<<< @/examples/snippets/heat_4-module.F90{fortran}

The main program is now four calls:

<<< @/examples/snippets/heat_4-use.F90{fortran}

<<< @/examples/output/heat_4.txt{text}

The same numbers as chapter 3: moving the kernel into a procedure changed nothing.

::: warning Do not name type components in kernel clauses
`deviceptr(self%t_dev)` puts a component of a host variable in a data clause: the compiler may copy the descriptor of the
host variable to the device, and the kernel then dereferences a host address (nvfortran at `-fast`: illegal address).
Pass the components to a procedure, as `run` does, and name the dummy arguments in the clause.
:::

::: tip What you learned
Kernels in procedures with device arrays as dummy arguments; a derived type holding device pointers; the lower bound
of an assumed-shape dummy.
Reference: [Macros](/reference/macros), [Structured memory](/reference/structured).
:::

Next: [5. The unstructured model](./05-unstructured).
