---
title: 2. Bounds, resizing, copies
---

# 2. Bounds, resizing, copies

The scheme reads the neighbours of each cell, so the field needs two **ghost cells**, 0 and $n+1$, that hold the
boundary values. Fortran indexes them naturally with lower bound 0; FUNDAL allocates device arrays with any bounds.

<<< @/examples/snippets/heat_2-bounds.F90{fortran}

`lbounds` and `ubounds` give the bounds of every dimension (here one); `init_value` sets every element on the device, by
a kernel, so no host array and no copy are needed to start from zero.

## Resizing

Refining the grid doubles the cells. `dev_alloc` on a pointer that already holds a buffer would lose that buffer (a leak,
with pointer-`allocate` semantics); `dev_alloc_replace` frees it first:

<<< @/examples/snippets/heat_2-replace.F90{fortran}

The contents are **not** preserved, as with `deallocate` and `allocate`: they are undefined unless `init_value` is
passed. The pointer passed to `dev_alloc_replace` must have a defined association status: declared `=>null()`, nullified,
or allocated.

## Allocate and copy in one call

`dev_assign_to_device` mimics the assignment of an allocatable: it (re)allocates the device array with the shape of the
host array and copies it. Its bounds deserve attention:

<<< @/examples/snippets/heat_2-assign.F90{fortran}

`dev_assign_from_device` does the same towards a host allocatable:

<<< @/examples/snippets/heat_2-back.F90{fortran}

<<< @/examples/output/heat_2.txt{text}

::: warning Lower bounds are reset to 1
`dev_assign_to_device(dst, src)` and `dev_assign_from_device(dst, src)` receive `src` as an assumed-shape array, whose
lower bounds are 1: the destination is allocated `1:size`, whatever the bounds of the source. Pass the lower bounds
first, `dev_assign_to_device(lbounds, dst, src)`, to keep them. Both routines always reallocate the destination, even
when the shape does not change.
:::

::: tip What you learned
Custom bounds and `init_value`; `dev_alloc_replace` to resize without leaks; `dev_assign_*` and the lower-bounds-first
form that keeps the bounds.
Reference: [dev_alloc](/reference/structured#dev-alloc), [dev_alloc_replace](/reference/structured#dev-alloc-replace),
[dev_assign_to_device](/reference/structured#dev-assign-to-device).
:::

Next: [3. Portable kernels](./03-portable-kernels).
