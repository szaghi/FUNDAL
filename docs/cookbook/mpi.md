---
title: MPI
---

# MPI

These recipes use `mpih_object` from `fundal_mpih_object` (build FUNDAL with `MPI=1` or an `mpi` FoBiS mode) and run on
2 ranks. They print from rank 0 only.

[[toc]]

## One device per rank

Initialize MPI and give each rank of a node its own device.

<<< @/examples/snippets/mpi-init.F90{fortran}

<<< @/examples/snippets/mpi-devices.F90{fortran}

<<< @/examples/output/mpi-devices.txt{text}

The documentation runs on the host, which is one device: both ranks get device 0. On a node with two GPUs the ranks get
devices 0 and 1, `mod(local_rank, devs_number)`.

::: warning
`local_comm` is set only by `initialize(do_device_init=.true.)`. To forbid the host fallback on every rank, pass
`require_device=.true.` to `initialize`: a rank without a device then stops.
:::

## A global sum of device results

Reduce on the device of each rank, then across the ranks with MPI.

<<< @/examples/snippets/mpi-allreduce.F90{fortran}

<<< @/examples/output/mpi-allreduce.txt{text}

## Exchange a halo through host buffers

Copy the boundary cells from the device, exchange them, copy the received values into the ghost cells (from
[tutorial chapter 6](/guide/tutorial/06-mpi)):

<<< @/examples/snippets/heat_6-halo.F90{fortran}

::: warning
`MPI_SENDRECV` (or non-blocking calls) avoids the deadlock of two ranks that both call a blocking `MPI_SEND` first.
Passing device pointers directly to MPI requires a GPU-aware MPI library.
:::
