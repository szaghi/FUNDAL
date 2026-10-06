---
title: Cookbook
---

# Cookbook

Short answers to "how do I ...?". Each recipe shows the code and its real output; the [reference](/reference/) has the
details. The programs are in [`docs/examples/src`](https://github.com/szaghi/FUNDAL/tree/main/docs/examples/src): one per
page, the recipe chosen by the command line argument.

| Page | Recipes |
|---|---|
| [Device memory](./memory) | custom bounds and an initial value, other kinds, resizing, allocate-and-copy keeping the bounds, transposed copies, counting the allocations |
| [Kernels](./kernels) | nested loops, reductions, an iterative solver with swapped buffers, kernels in procedures, mapped arrays in procedures |
| [MPI](./mpi) | one device per rank, a global sum of device results, a halo exchange |
| [Debugging](./debugging) | where the run happens, leaks, double frees, a wrong `dev_id`, making misuse fatal |
