---
title: About FUNDAL
---

# About FUNDAL

FUNDAL (Fortran UNified Device Acceleration Library) is a pure Fortran library that manages device (GPU) memory through
one API over two offloading backends, OpenACC and OpenMP. A program allocates device arrays, copies data between host
and device, frees them and selects devices with the same `dev_*` calls whatever the backend; the backend is chosen when
the code is compiled, by a preprocessor macro.

Both OpenACC and OpenMP have runtime routines for device memory, but with different names, different arguments and C
pointers instead of Fortran arrays. FUNDAL wraps them into generic Fortran procedures (six kinds, ranks 1 to 7) that
return Fortran pointers with the bounds you choose, so device arrays are indexed like any other array inside kernels.

## Backends

| Build | Macros | Device memory | Compilers |
|---|---|---|---|
| OpenACC | `-DDEV_OAC` with `-DCOMPILER_NVF` or `-DCOMPILER_GNU` | `acc_malloc`, `acc_free`, `acc_memcpy_*` | nvfortran, gfortran |
| OpenMP offload | `-DDEV_OMP` (AMD: also `-DDEV_HIP`) | `omp_target_alloc`, `omp_target_free`, `omp_target_memcpy` | Intel ifx, AMD amdflang |
| Compile-time CPU mode | none | `malloc`, `free`, assignment | any |

The [concepts](./concepts) page explains the two memory models and how the backends differ; the [macros](/reference/macros)
page lists what `fundal.H` defines for each build.

## Reading order

This documentation reads in order, and each page links to the next one:

1. [Installation](./install): build FUNDAL and use it in your project.
2. [Concepts](./concepts): the two memory models, the backends, the host fallback.
3. The [tutorial](./tutorial/): seven chapters that grow one program, a 1-D heat solver, from a first device array to
   MPI and production checks.
4. The [cookbook](/cookbook/): short recipes, one for each "how do I ...?".
5. The [reference](/reference/): every procedure with its exact signature, every macro, error code and global variable.

The [API](/api/) pages are generated from the sources. Upgrading from an older release? See
[Upgrading](/project/upgrading): some releases changed a behaviour.

Every code sample of this documentation is part of a program in
[`docs/examples/src`](https://github.com/szaghi/FUNDAL/tree/main/docs/examples/src) that is compiled and run to produce
the output shown, by `scripts/docs_examples.sh`; a workflow fails when the committed outputs differ from the regenerated
ones. The programs are built with gfortran and the OpenACC backend and run on the host (no GPU is needed), so they print
only values that do not depend on the machine.

## Authors

- Stefano Zaghi — [stefano.zaghi@cnr.it](mailto:stefano.zaghi@cnr.it)
- Giacomo Rossi — [giacomo.rossi@amd.com](mailto:giacomo.rossi@amd.com)
- Andrea di Mascio — [andrea.dimascio@univaq.it](mailto:andrea.dimascio@univaq.it)
- Francesco Salvadore — [f.salvadore@cineca.it](mailto:f.salvadore@cineca.it)

Contributions are welcome: see [Contributing](./contributing).

## Copyrights

FUNDAL is distributed under a multi-licensing system:

| Use case | License |
|---|---|
| FOSS projects | [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html) |
| Closed source / commercial | [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause) |
| Closed source / commercial | [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause) |
| Closed source / commercial | [MIT](http://opensource.org/licenses/MIT) |
