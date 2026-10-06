---
title: 1. A first device array
---

# 1. A first device array

The heat solver starts with a temperature field of 8 cells: room temperature with a hot spot in the middle. Before any
kernel, the field must get to the device and back. Every FUNDAL program follows the same steps: **initialize** the
device, **allocate** device memory, **copy** to and from it, **free** it.

<<< @/examples/snippets/heat_1.F90{fortran}

- `dev_init` selects the device and sets the [global variables](/reference/globals) that describe it (`mydev`,
  `devs_number`, ...). Call it once, before any other FUNDAL call.
- `dev_alloc` allocates `n` reals on the device and associates the pointer `t_dev` with them. Device arrays are always
  `pointer`s, declared `=>null()`. `ierr` is not optional: a non-zero value means the allocation failed
  (`FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED`) and `t_dev` is null. The `label` names the allocation in leak reports
  ([chapter 7](./07-production)).
- `dev_memcpy_to_device` and `dev_memcpy_from_device` copy whole arrays; the arguments are always `dst` then `src`.
- `dev_free` releases the device memory and nullifies the pointer; `dev_get_alloc_stats` counts the live device
  allocations: zero at the end means nothing leaked.

The kinds come from `iso_fortran_env`: FUNDAL does not export kind parameters, so that its names cannot clash with those
of your code (PENF, for example, has its own `I4P` and `R8P`).

## Running it

<<< @/examples/output/heat_1.txt{text}

The hot spot made the round trip. On the host nothing distinguishes `t_dev` from a host array; on a GPU, reading
`t_dev(i)` outside a kernel reads a device address from the host, which is an error.

::: warning Device pointers on the host
A pointer returned by `dev_alloc` may be passed to FUNDAL and inquired (`lbound`, `ubound`, `size`) on the host, but its
elements must be read and written only inside kernels or through the copy routines.
:::

::: tip What you learned
The four steps `dev_init`, `dev_alloc`, `dev_memcpy_*`, `dev_free`; device arrays as pointers; `ierr` and the allocation
statistics.
Reference: [Structured memory](/reference/structured), [Initialization and devices](/reference/devices#dev-init).
:::

Next: [2. Bounds, resizing, copies](./02-bounds-resizing).
