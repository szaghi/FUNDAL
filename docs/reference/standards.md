---
title: Standards
---

# Standards

The specifications behind FUNDAL's two backends, and where to read about the compilers.

## OpenACC

FUNDAL's OpenACC backend uses the runtime routines `acc_malloc`, `acc_free`, `acc_memcpy_to_device`,
`acc_memcpy_from_device` (bound directly to their C interface), the device queries `acc_get_num_devices`,
`acc_get_device_num`, `acc_set_device_num`, `acc_get_device_type`, `acc_get_property`, `acc_get_property_string`,
`acc_init`, and the `deviceptr`, `present`, `enter data`/`exit data` and `update` constructs. They are all in the 3.x
specifications.

| Version | Date | Link |
|---|---|---|
| 3.4 | Jun 2025 | [OpenACC 3.4](https://www.openacc.org/sites/default/files/inline-images/Specification/OpenACC-3.4.pdf) |
| 3.3 | Nov 2022 | [local copy](/references/OpenACC-3.3-final.pdf), [openacc.org](https://openacc.org/sites/default/files/inline-images/Specification/OpenACC-3.3-final.pdf) |
| all | | [openacc.org/specification](https://www.openacc.org/specification) |

Further reading: the [OpenACC Programming and Best Practices Guide](https://openacc-best-practices-guide.readthedocs.io/),
the [NVIDIA HPC compilers user's guide](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-user-guide/),
[OpenACC in GCC](https://gcc.gnu.org/wiki/OpenACC).

## OpenMP

FUNDAL's OpenMP backend uses `omp_target_alloc`, `omp_target_free`, `omp_target_memcpy`, the device routines
`omp_get_num_devices`, `omp_get_default_device`, `omp_set_default_device`, `omp_get_initial_device`, and the
`target teams distribute parallel do`, `has_device_addr` (OpenMP 5.1), `target enter data`/`exit data` and
`target update` constructs.

| Version | Date | Link |
|---|---|---|
| 6.0 | Nov 2024 | [OpenMP 6.0](https://www.openmp.org/wp-content/uploads/OpenMP-API-Specification-6-0.pdf) |
| 5.2 | Nov 2021 | [local copy](/references/OpenMP-API-Specification-5-2.pdf), [openmp.org](https://www.openmp.org/wp-content/uploads/OpenMP-API-Specification-5-2.pdf) |
| all | | [openmp.org/specifications](https://www.openmp.org/specifications/) |

Further reading: the [OpenMP reference guides](https://www.openmp.org/resources/refguides/), the
[Intel OpenMP offload guide](https://www.intel.com/content/www/us/en/docs/oneapi/optimization-guide-gpu/2024-0/openmp-offloading-tuning-guide.html),
the [ROCm documentation](https://rocm.docs.amd.com/).

## Compilers

| Compiler | FUNDAL backend | `COMPILER_*` macro | fobos templates |
|---|---|---|---|
| NVIDIA nvfortran | OpenACC | `COMPILER_NVF` | `template-nvf`, `template-oac-nvf` |
| GNU gfortran | OpenACC | `COMPILER_GNU` | `template-gnu`, `template-oac-gnu` |
| Intel ifx | OpenMP offload | none | `template-ifx`, `template-omp-ifx` |
| AMD amdflang | OpenMP offload (with `DEV_HIP`) | none | `template-amd`, `template-omp-amd` |

Only these combinations have build modes. nvfortran and gfortran also implement OpenMP offload, and other compilers
(Cray, for example) OpenACC, but FUNDAL defines no macros or build modes for them: an OpenACC build needs
`COMPILER_NVF` or `COMPILER_GNU` (see [Macros](./macros)). Support for each specification version changes with every
compiler release: check the release notes of your compiler.
