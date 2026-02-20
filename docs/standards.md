---
title: Standards
---

# Standards & References

Specifications, reference cards, and vendor documentation relevant to FUNDAL's OpenACC and OpenMP backends.

---

## OpenACC

OpenACC (Open Accelerators) is a directive-based programming model for heterogeneous CPU/GPU systems. FUNDAL targets the **3.x** series of the standard.

### Specifications

| Version | Date | Notes |
|---------|------|-------|
| **3.4** | Jun 2025 | Latest — adds `capture` modifier, `alwaysin`/`alwaysout` data clauses, `loop self` construct |
| **3.3** | Nov 2022 | Bundled in this repository — see local copy below |
| 3.2 | Nov 2021 | Clarifications and minor additions |
| 3.1 | Nov 2020 | `serial` construct, `finalize` clause |
| 3.0 | Nov 2019 | `set` construct, `detach`/`attach` clauses |

**Local copy (bundled):**
- [OpenACC 3.3 Specification](./references/OpenACC-3.3-final.pdf) — the version FUNDAL was developed against

**Upstream:**
- [OpenACC 3.4 Specification](https://www.openacc.org/sites/default/files/inline-images/Specification/OpenACC-3.4.pdf) — current release
- [OpenACC 3.3 Specification](https://openacc.org/sites/default/files/inline-images/Specification/OpenACC-3.3-final.pdf) — online mirror
- [All versions — openacc.org/specification](https://www.openacc.org/specification)

### Reference material

| Resource | Description |
|----------|-------------|
| [Best Practices Guide (2022)](https://www.openacc.org/sites/default/files/inline-files/openacc-guide.pdf) | Porting workflow, profiling strategy, loop optimisation — essential reading |
| [Best Practices Guide (online)](https://openacc-best-practices-guide.readthedocs.io/) | Rendered HTML version, continuously updated |
| [Resources — openacc.org](https://www.openacc.org/resources) | Videos, tutorials, books, and code samples |

### Compiler support

| Compiler | Backend | OpenACC level | Notes |
|----------|---------|---------------|-------|
| NVIDIA nvfortran (HPC SDK ≥ 12.3) | GPU | 3.x | Full support; reference implementation |
| GNU gfortran ≥ 13.1 | GPU | 2.x | Partial — `deviceptr` clause not fully supported |
| Cray CCE | GPU | 3.x | Supported |

**Compiler documentation:**
- [NVIDIA HPC Compilers User's Guide](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-user-guide/) — nvfortran flags, GPU targeting, CUDA interop
- [NVIDIA OpenACC Getting Started Guide](https://docs.nvidia.com/hpc-sdk/compilers/openacc-gs/) — step-by-step porting and build instructions

---

## OpenMP

OpenMP (Open Multi-Processing) device offloading (`target` directives) is the second backend supported by FUNDAL. FUNDAL targets the **5.x** series.

### Specifications

| Version | Date | Notes |
|---------|------|-------|
| **6.0** | Nov 2024 | Latest — task graphs, simplified data offload, C23/C++23 support, loop transformations |
| **5.2** | Nov 2021 | Bundled in this repository — see local copy below |
| 5.1 | Nov 2020 | C++ attribute syntax, `interop` construct |
| 5.0 | Nov 2018 | First-class `target` offloading, `task` enhancements |

**Local copy (bundled):**
- [OpenMP 5.2 Specification](./references/OpenMP-API-Specification-5-2.pdf) — the version FUNDAL was developed against

**Upstream:**
- [OpenMP 6.0 Specification](https://www.openmp.org/wp-content/uploads/OpenMP-API-Specification-6-0.pdf) — current release
- [OpenMP 5.2 Specification](https://www.openmp.org/wp-content/uploads/OpenMP-API-Specification-5-2.pdf) — online mirror
- [All versions — openmp.org/specifications](https://www.openmp.org/specifications/)

### Reference material

| Resource | Description |
|----------|-------------|
| [OpenMP 5.2 Reference Card](https://www.openmp.org/wp-content/uploads/OpenMPRefCard-5-2-web.pdf) | 12-page quick reference: directives, clauses, runtime routines, environment variables |
| [OpenMP 5.1 Reference Card](https://www.openmp.org/wp-content/uploads/OpenMPRefCard-5.1-web.pdf) | Previous version reference card |
| [All reference guides — openmp.org](https://www.openmp.org/resources/refguides/) | Index of all reference cards by version |
| [LLNL OpenMP Tutorial](https://hpc-tutorials.llnl.gov/openmp/) | Comprehensive introductory tutorial with examples |

### Compiler support

| Compiler | Backend | OpenMP level | Notes |
|----------|---------|--------------|-------|
| Intel IFX ≥ 2024.0.2 (oneAPI) | Intel GPU | 5.0–5.2 `target` | Full support for FUNDAL; recommended for Intel GPUs |
| AMD Flang | AMD GPU | 5.x `target` | Supported via ROCm |
| GNU gfortran ≥ 13 | GPU | 5.x `target` | Experimental offloading support |
| NVIDIA nvfortran | GPU | 5.x `target` | Supported alongside OpenACC |

**Compiler documentation:**
- [Intel Fortran Compiler (ifx) — OpenMP Offloading](https://www.intel.com/content/www/us/en/docs/oneapi/programming-guide/2024-2/c-c-or-fortran-with-openmp-offload-programming.html)
- [Intel GPU Optimization Guide — OpenMP](https://www.intel.com/content/www/us/en/docs/oneapi/optimization-guide-gpu/2024-0/openmp-offloading-tuning-guide.html)
- [Porting from ifort to ifx](https://www.intel.com/content/www/us/en/developer/articles/guide/porting-guide-for-ifort-to-ifx.html) — migration guide for existing Fortran codebases

---

## Version matrix

Quick reference for which standard versions are supported by each compiler as of early 2025:

| Compiler | OpenACC | OpenMP target |
|----------|---------|---------------|
| NVIDIA nvfortran 25.x | 3.3 | 5.2 |
| Intel IFX 2024.x | — | 5.2 |
| GNU gfortran 14 | 2.7 (partial) | 5.1 (partial) |
| AMD Flang 18 | — | 5.x |

::: info
Compiler support evolves rapidly. Always cross-check against the official compiler release notes before relying on a specific standard feature.
:::
