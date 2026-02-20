# FUNDAL

**Fortran UNified Device Acceleration Library** — a pure Fortran library providing a unified API for GPU/device memory management over OpenACC and OpenMP backends.

[![GitHub tag](https://img.shields.io/github/tag/szaghi/FUNDAL.svg)](https://github.com/szaghi/FUNDAL/releases)
[![GitHub issues](https://img.shields.io/github/issues/szaghi/FUNDAL.svg)](https://github.com/szaghi/FUNDAL/issues)
[![License](https://img.shields.io/badge/license-GPLv3%20%7C%20BSD%20%7C%20MIT-blue.svg)](#copyrights)

---

## Features

- Unified API for both OpenACC and OpenMP backends — backend selected at compile time, no conditional code in user programs
- Structured model: device-only memory as Fortran `pointer` arrays (`dev_alloc`, `dev_free`, `dev_memcpy_*`)
- Unstructured model: host `allocatable` arrays mapped onto the device (`dev_alloc_unstr`, `dev_free_unstr`, `dev_memcpy_*_unstr`)
- Assignment-style copy with automatic reallocation on size change (`dev_assign_to_device`, `dev_assign_from_device`)
- Device handling: query type, ID, count, memory, and properties
- MPI multi-device support via the `mpih_object` class
- Arrays of any rank (1–7) and numeric kind (R8P, R4P, I8P, I4P, I2P, I1P)

**[Documentation](https://szaghi.github.io/FUNDAL/)** | **[API Reference](https://szaghi.github.io/FUNDAL/guide/api-reference)**

---

## Authors

- Stefano Zaghi — [stefano.zaghi@cnr.it](mailto:stefano.zaghi@cnr.it)
- Giacomo Rossi — [giacomo.rossi@intel.com](mailto:giacomo.rossi@intel.com)
- Andrea di Mascio — [andrea.dimascio@univaq.it](mailto:andrea.dimascio@univaq.it)
- Francesco Salvadore — [f.salvadore@cineca.it](mailto:f.salvadore@cineca.it)

Contributions are welcome — see the [Usage](https://szaghi.github.io/FUNDAL/guide/usage) page.

## Copyrights

This project is distributed under a multi-licensing system:

- **FOSS projects**: [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html)
- **Closed source / commercial**: [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause), [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause), or [MIT](http://opensource.org/licenses/MIT)

> Anyone interested in using, developing, or contributing to FUNDAL is welcome — pick the license that best fits your needs.

---

## Quick start

Allocate device memory, copy data to the GPU, run a kernel, copy back:

```fortran
program fundal_taste
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal

implicit none
real(R8P), pointer     :: a_dev(:,:,:)=>null()  ! device memory
real(R8P), allocatable :: b_hos(:,:,:)           ! host   memory
integer(I4P)           :: ierr, i, j, k

call dev_init  ! initialise device environment

call dev_alloc(fptr_dev=a_dev, lbounds=[-1,-2,-3], ubounds=[1,2,3], ierr=ierr)
allocate(b_hos(-1:1,-2:2,-3:3))
b_hos = -3._R8P

call dev_memcpy_to_device(dst=a_dev, src=b_hos)

!$acc parallel loop independent deviceptr(a_dev) collapse(3)
!$omp target teams distribute parallel do collapse(3) has_device_addr(a_dev)
do k=-3,3; do j=-2,2; do i=-1,1
  a_dev(i,j,k) = a_dev(i,j,k) / 2._R8P
enddo; enddo; enddo

call dev_memcpy_from_device(dst=b_hos, src=a_dev)
print*, b_hos

call dev_free(a_dev)
endprogram fundal_taste
```

Device memory must be declared as `pointer`; host memory can be `pointer` or `allocatable`. OpenACC and OpenMP pragmas coexist safely — unrecognised directives are ignored by the compiler.

---

## Install

```sh
git clone https://github.com/szaghi/FUNDAL.git
cd FUNDAL
```

Build with [FoBiS.py](https://github.com/szaghi/FoBiS):

| Compiler | Backend | Build mode |
|----------|---------|------------|
| NVIDIA nvfortran ≥ 12.3 | OpenACC | `FoBiS.py build -mode fundal-test-oac-nvf` |
| Intel IFX ≥ 2024.0.2 | OpenMP | `FoBiS.py build -mode fundal-test-omp-ifx` |
| GNU gfortran ≥ 13.1 | OpenACC (partial) | `FoBiS.py build -mode fundal-test-oac-gnu` |
| AMD Flang | OpenMP | `FoBiS.py build -mode fundal-test-omp-amd` |

Run all tests:

```sh
utils/run_tests.sh
# or: FoBiS.py rule -ex build-run-tests-oac-nvf
```

Each test prints `test passed` on success.
