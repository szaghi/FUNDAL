---
title: 6. Several devices with MPI
---

# 6. Several devices with MPI

A node often has several GPUs, and a cluster many nodes. The usual layout is one MPI rank per device: the domain is split
among the ranks, each rank advances its part on its device, and neighbouring ranks exchange the cells next to their
boundary (the **halo**) at each step. `mpih_object`, in the module `fundal_mpih_object` (built with `MPI=1` or an `mpi`
FoBiS mode), initializes MPI and the device together:

<<< @/examples/snippets/heat_6-init.F90{fortran}

`initialize(do_mpi_init=.true.)` calls `MPI_Init`; `do_device_init=.true.` splits `MPI_COMM_WORLD` by node
(`MPI_COMM_TYPE_SHARED`, stored in `local_comm`) and calls `dev_init(local_rank=...)`, so that the ranks of a node take
the devices `mod(local_rank, devs_number)`. The 15 cells are split into contiguous blocks, and the neighbours at the
physical boundaries are `MPI_PROC_NULL`.

Each rank allocates only its cells and their two ghost cells, with the global indexes as bounds, so the kernel and the
initial condition keep the indexing of the serial code:

<<< @/examples/snippets/heat_6-alloc.F90{fortran}

## The halo exchange

Before each step, each rank sends its first and last cells to its neighbours and receives their values into its ghost
cells. MPI cannot read device memory here, so the values go through host buffers:

<<< @/examples/snippets/heat_6-halo.F90{fortran}

The copies take array sections of the device pointer: a section is contiguous here, and only contiguous arrays may be
copied. `MPI_SENDRECV` pairs every send with a receive, so no rank waits for another, and a transfer to or from
`MPI_PROC_NULL` does nothing: the physical ghost cells keep the boundary value 0 set by `init_value`.

## Gathering the result

Only rank 0 prints, after collecting the whole field (each rank contributes its cells, zero elsewhere, so a sum
reassembles it):

<<< @/examples/snippets/heat_6-gather.F90{fortran}

<<< @/examples/output/heat_6.txt{text}

The same temperature as the serial chapters: the domain decomposition is exact.

::: warning MPI and device memory
Passing a device pointer to MPI works only with a GPU-aware MPI library and the device address of the buffer; staging
through host buffers, as here, works with every MPI. On a node, each rank must use its own device: initialize through
`mpih_object` (or `dev_init(local_rank=...)`), not by setting `mydev` by hand, so that the host fallback and the device
count are checked.
:::

::: tip What you learned
`mpih_object%initialize`, one device per rank from the local rank, global bounds per rank, a halo exchange through host
buffers, gathering before printing.
Reference: [MPI handler](/reference/mpi), [dev_init](/reference/devices#dev-init).
:::

Next: [7. Production runs](./07-production).
