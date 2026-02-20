---
title: About FUNDAL
---

# About FUNDAL

**FUNDAL** (Fortran UNified Device Acceleration Library) is a pure Fortran library that provides a unified API for managing accelerated device memory using either OpenACC or OpenMP offloading.

OpenACC and OpenMP both offer runtime routines for device memory management (allocation, copy, free), but they expose different C-pointer-based interfaces. FUNDAL wraps these routines behind a single Fortran API, eliminating the need for conditional compilation macros in user code and making it straightforward to write programs that are portable across GPU vendors and compiler toolchains.

## Design goals

- **KISS** — Keep It Simple and Stupid: minimal API surface, no unnecessary abstractions
- **Unified** — one set of calls works for both OpenACC and OpenMP backends
- **Seamless** — OpenACC and OpenMP pragmas can coexist in the same source; unrecognised directives are safely ignored by the compiler
- **Pure Fortran** — no C code in the library itself; C interoperability is used internally for runtime calls only

## Authors

- Stefano Zaghi — [stefano.zaghi@cnr.it](mailto:stefano.zaghi@cnr.it)
- Giacomo Rossi — [giacomo.rossi@amd.com](mailto:giacomo.rossi@amd.com)
- Andrea di Mascio — [andrea.dimascio@univaq.it](mailto:andrea.dimascio@univaq.it)
- Francesco Salvadore — [f.salvadore@cineca.it](mailto:f.salvadore@cineca.it)

## Copyrights

FUNDAL is distributed under a multi-licensing system:

| Use case | License |
|----------|---------|
| FOSS projects | [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html) |
| Closed source / commercial | [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause) |
| Closed source / commercial | [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause) |
| Closed source / commercial | [MIT](http://opensource.org/licenses/MIT) |

> Anyone interested in using, developing, or contributing to FUNDAL is welcome — pick the license that best fits your needs.
