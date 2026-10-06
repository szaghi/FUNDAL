---
title: Device memory
---

# Device memory

[[toc]]

## An array with custom bounds and an initial value

Allocate a rank-3 device array with lower bounds other than 1, set on the device.

<<< @/examples/snippets/memory-bounds.F90{fortran}

<<< @/examples/output/memory-bounds.txt{text}

## Arrays of other kinds

`dev_alloc` and the other generic procedures accept `real(real64)`, `real(real32)`, `integer(int64)`, `integer(int32)`,
`integer(int16)`, `integer(int8)`, ranks 1 to 7.

<<< @/examples/snippets/memory-kinds.F90{fortran}

<<< @/examples/output/memory-kinds.txt{text}

## Resize a device array

Reallocate with another size, freeing the previous buffer.

<<< @/examples/snippets/memory-replace.F90{fortran}

<<< @/examples/output/memory-replace.txt{text}

::: warning
The contents are not preserved. The pointer must have a defined association status (`=>null()`, nullified or
allocated): a pointer declared without `=>null()` and never assigned is undefined, and `dev_alloc_replace` cannot test
it. `dev_alloc` on an associated pointer leaks its buffer.
:::

## Allocate and copy a host array, keeping its bounds

`dev_assign_to_device` allocates the device array and copies; with the lower bounds passed first, the bounds of the
source are kept. `dev_assign_from_device` is the converse.

<<< @/examples/snippets/memory-assign.F90{fortran}

<<< @/examples/output/memory-assign.txt{text}

::: warning
Without `lbounds`, both routines allocate the destination with lower bounds 1. Both always reallocate the destination.
:::

## Copy back transposed

Get a device array on the host with two indexes swapped: `dev_memcpy_from_device` with the bounds of both arrays and a
host buffer of the source shape (rank 2), or `dev_assign_from_device` with the pair of indexes to swap (ranks 2 to 7),
which allocates the result.

<<< @/examples/snippets/memory-transpose.F90{fortran}

<<< @/examples/output/memory-transpose.txt{text}

`bb(1,:)` are the lower bounds and `bb(2,:)` the upper bounds of the device array, `tb` those of the transposed host
array. Ranks 3 to 7 of the copy routines also take `ij`, the two indexes to swap; see
[transposed copies](/reference/structured#transposed-copies).

## Count the live device allocations

Check at teardown that nothing leaked, on every device or on one.

<<< @/examples/snippets/memory-stats.F90{fortran}

<<< @/examples/output/memory-stats.txt{text}

Unstructured allocations (`dev_alloc_unstr`) are not counted.
