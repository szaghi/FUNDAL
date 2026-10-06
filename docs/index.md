---
layout: home

hero:
  name: FUNDAL
  text: Fortran UNified Device Acceleration Library
  tagline: "Allocate, copy and free device memory from Fortran with one API, whether the code is built for OpenACC, for OpenMP offload, or for the CPU alone. The backend is a compile-time choice; the calls stay the same."
  actions:
    - theme: brand
      text: Tutorial
      link: /guide/tutorial/
    - theme: alt
      text: Cookbook
      link: /cookbook/
    - theme: alt
      text: Reference
      link: /reference/
    - theme: alt
      text: API
      link: /api/
    - theme: alt
      text: View on GitHub
      link: https://github.com/szaghi/FUNDAL

features:
  - title: One API, three builds
    details: "OpenACC (nvfortran, gfortran), OpenMP offload (ifx, amdflang) or the compile-time CPU mode: the same dev_* calls, the backend chosen by a preprocessor macro."
    link: /guide/concepts
    linkText: Concepts
  - title: Device arrays as Fortran pointers
    details: "dev_alloc returns a pointer to device memory with the bounds you ask for, ranks 1 to 7, six integer and real kinds, an optional initial value set on the device."
    link: /reference/structured
    linkText: Structured memory
  - title: Explicit copies
    details: "dev_memcpy_to_device and dev_memcpy_from_device move data between host and device; dev_assign_* allocate and copy in one call, transposed copies reorder indexes."
    link: /reference/structured#copies
    linkText: Copies
  - title: Host arrays mapped to the device
    details: "The unstructured model: dev_alloc_unstr maps an existing host allocatable to the device, the dev_memcpy_*_unstr calls keep the two copies in step."
    link: /reference/unstructured
    linkText: Unstructured memory
  - title: Portable kernels
    details: "fundal.H defines the clauses that differ between backends and compilers, so one loop carries both the OpenACC and the OpenMP directive."
    link: /reference/macros
    linkText: Macros
  - title: No silent host fallback
    details: "dev_init reports a run that found no device, and require_device=.true. (or the environment) turns it into an error for production runs."
    link: /reference/devices#host-fallback
    linkText: Host fallback
  - title: Allocation registry
    details: "Every structured allocation is recorded with its size, device and label: dev_free frees on the right device and catches double frees, dev_alloc_report finds leaks."
    link: /reference/registry
    linkText: Registry
  - title: Several devices with MPI
    details: "mpih_object initializes MPI, binds each rank to a device of its node and wraps barriers, timing and aborts."
    link: /reference/mpi
    linkText: MPI handler
  - title: Multi-licensed
    details: "GPL v3 for FOSS projects; BSD 2-Clause, BSD 3-Clause or MIT for closed source and commercial ones."
    link: /guide/#copyrights
    linkText: Copyrights
---

## Quick start

A whole FUNDAL program: it allocates an array on the device, copies data to it, runs a kernel there and copies the
result back.

<<< @/examples/snippets/quickstart.F90{fortran}

Built with gfortran and OpenACC, as every example of this documentation (see [Installation](/guide/install)), it prints:

<<< @/examples/output/quickstart.txt{text}

The two directives before the loop are the OpenACC and the OpenMP form of the same kernel: the compiler reads only the
one of the backend it is building for, and `DEVICEVAR`/`DEVICEPTR`/`OMPLOOP` come from `fundal.H`. Every code sample of
this documentation is part of a program that is compiled and run to produce the output shown.

Learn FUNDAL step by step in the [tutorial](/guide/tutorial/), find short answers in the [cookbook](/cookbook/), look up
every argument in the [reference](/reference/). Upgrading from an older release? Read [Upgrading](/project/upgrading).
