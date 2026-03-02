# FUNDAL

>#### Fortran UNified Device Acceleration Library
>a pure Fortran library providing a unified API for GPU/device memory management over OpenACC and OpenMP backends.

[![GitHub tag](https://img.shields.io/github/tag/szaghi/FUNDAL.svg)](https://github.com/szaghi/FUNDAL/releases)
[![GitHub issues](https://img.shields.io/github/issues/szaghi/FUNDAL.svg)](https://github.com/szaghi/FUNDAL/issues)
[![CI](https://github.com/szaghi/FUNDAL/actions/workflows/ci.yml/badge.svg)](https://github.com/szaghi/FUNDAL/actions/workflows/ci.yml)
[![Coverage](https://img.shields.io/codecov/c/github/szaghi/FUNDAL.svg)](https://app.codecov.io/gh/szaghi/FUNDAL)
[![License](https://img.shields.io/badge/license-GPLv3%20%7C%20BSD%20%7C%20MIT-blue.svg)](#copyrights)

| 🔀 **Unified API**<br>OpenACC or OpenMP backend selected at compile time — no conditional code in user programs | 🧱 **Structured memory**<br>Device-only `pointer` arrays via `dev_alloc`, `dev_free`, `dev_memcpy_*` | 📦 **Unstructured memory**<br>Host `allocatable` arrays mapped to the device via `dev_alloc_unstr` | 🔄 **Assignment-style copy**<br>`dev_assign_to/from_device` with automatic reallocation on size change |
|:---:|:---:|:---:|:---:|
| 🖥️ **Device handling**<br>Query device type, ID, count, memory, and properties | 🌐 **MPI multi-device**<br>`mpih_object` class for multi-GPU parallel scenarios | 📐 **Full rank & kind coverage**<br>Array ranks 1–7; numeric kinds R8P, R4P, I8P, I4P, I2P, I1P | 🏗️ **Multiple build systems**<br>FoBiS, make |

>#### [Documentation](https://szaghi.github.io/FUNDAL/)
> For full documentation (guide, API reference, examples, etc...) see the [FUNDAL website](https://szaghi.github.io/FUNDAL/).

---

## Authors

- Stefano Zaghi — [stefano.zaghi@cnr.it](mailto:stefano.zaghi@cnr.it)
- Giacomo Rossi — [giacomo.rossi@amd.com](mailto:giacomo.rossi@amd.com)
- Andrea di Mascio — [andrea.dimascio@univaq.it](mailto:andrea.dimascio@univaq.it)
- Francesco Salvadore — [f.salvadore@cineca.it](mailto:f.salvadore@cineca.it)

Contributions are welcome — see the [Contributing](https://szaghi.github.io/FUNDAL/guide/contributing) page.

## Copyrights

This project is distributed under a multi-licensing system:

- **FOSS projects**: [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html)
- **Closed source / commercial**: [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause), [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause), or [MIT](http://opensource.org/licenses/MIT)

> Anyone interested in using, developing, or contributing to FUNDAL is welcome — pick the license that best fits your needs.

---

## Quick start

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

See [`src/tests/`](src/tests/) for more examples including MPI multi-device and unstructured memory patterns.

---

## Install

### FoBiS

```bash
git clone https://github.com/szaghi/FUNDAL && cd FUNDAL
FoBiS.py build -mode fundal-test-oac-nvf   # NVIDIA nvfortran + OpenACC
FoBiS.py build -mode fundal-test-omp-ifx   # Intel IFX + OpenMP
FoBiS.py build -mode fundal-test-oac-gnu   # GNU gfortran + OpenACC (partial)
FoBiS.py build -mode fundal-test-omp-amd   # AMD Flang + OpenMP
```

Run all tests:

```bash
utils/run_tests.sh
```

Each test prints `test passed` on success.

### install.sh

Download and build in one step using the bundled install script from the latest release:

```bash
wget $(curl -s https://api.github.com/repos/szaghi/FUNDAL/releases/latest \
  | jq -r '.assets[] | select(.name | test("install.sh";"i")) | .browser_download_url')
chmod +x install.sh
./install.sh --download wget --build fobis
```
