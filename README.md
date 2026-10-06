# FUNDAL

>#### Fortran UNified Device Acceleration Library
>a pure Fortran library providing a unified API for GPU/device memory management over OpenACC and OpenMP backends.

[![GitHub tag](https://img.shields.io/github/tag/szaghi/FUNDAL.svg)](https://github.com/szaghi/FUNDAL/releases)
[![GitHub issues](https://img.shields.io/github/issues/szaghi/FUNDAL.svg)](https://github.com/szaghi/FUNDAL/issues)
[![CI](https://github.com/szaghi/FUNDAL/actions/workflows/ci.yml/badge.svg)](https://github.com/szaghi/FUNDAL/actions/workflows/ci.yml)
[![Coverage](https://img.shields.io/codecov/c/github/szaghi/FUNDAL.svg)](https://app.codecov.io/gh/szaghi/FUNDAL)
[![License](https://img.shields.io/badge/license-GPLv3%20%7C%20BSD%20%7C%20MIT-blue.svg)](#copyrights)

| 🔀 **One API, three builds**<br>OpenACC, OpenMP offload or the compile-time CPU mode, chosen by a macro: the same `dev_*` calls | 🧱 **Structured memory**<br>Device arrays as Fortran pointers: `dev_alloc`, `dev_free`, `dev_memcpy_*`, custom bounds | 📦 **Unstructured memory**<br>Host allocatables mapped to the device: `dev_alloc_unstr`, `dev_memcpy_*_unstr` | 🔄 **Allocate and copy**<br>`dev_assign_to/from_device`, transposed copies, `dev_alloc_replace` |
|:---:|:---:|:---:|:---:|
| 🧩 **Portable kernels**<br>`fundal.H` macros: one loop, an OpenACC and an OpenMP directive | 🛑 **No silent host fallback**<br>`dev_init(require_device=.true.)`, `dev_is_host_fallback` | 🔎 **Allocation registry**<br>Frees on the right device, catches double frees, `dev_alloc_report` finds leaks | 🌐 **MPI multi-device**<br>`mpih_object`: one device per rank |

>#### [Documentation](https://szaghi.github.io/FUNDAL/)
> The [FUNDAL website](https://szaghi.github.io/FUNDAL/) has a tutorial, a cookbook and the reference of every
> procedure; every code sample there is compiled and run.

---

## Quick start

```fortran
#include "fundal.H"

program quickstart
!< A first FUNDAL program: device memory, copies, a kernel.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal
implicit none
integer(I4P), parameter :: n=8              ! array size
real(R8P), pointer      :: a_dev(:)=>null() ! device memory
real(R8P)               :: a(n)             ! host memory
integer(I4P)            :: i                ! counter
integer(I4P)            :: ierr             ! error status

call dev_init                                          ! select the device
call dev_alloc(fptr_dev=a_dev, ubounds=[n], ierr=ierr) ! allocate on the device
if (ierr /= 0) error stop 'device allocation failed'
a = [(real(i, R8P), i=1, n)]
call dev_memcpy_to_device(dst=a_dev, src=a)            ! host -> device

!$acc parallel loop DEVICEVAR(a_dev)
!$omp OMPLOOP DEVICEPTR(a_dev)
do i=1, n                                              ! a kernel, on the device
   a_dev(i) = 2._R8P * a_dev(i)
enddo

call dev_memcpy_from_device(dst=a, src=a_dev)          ! device -> host
call dev_free(a_dev)                                   ! release the device memory
print '(A,*(F5.1))', 'a:', a
print '(A,L1)', 'doubled on the device: ', all(a == [(2._R8P * i, i=1, n)])
endprogram quickstart
```

`DEVICEVAR`, `DEVICEPTR` and `OMPLOOP` come from `fundal.H`: the compiler reads the directive of the backend it builds
for. Build FUNDAL and the program with the same macros (here gfortran and OpenACC):

```bash
make COMPILER=gnu BACKEND=oac
gfortran -cpp -DCOMPILER_GNU -DDEV_OAC -fopenacc -I src/lib -I build/gnu-oac/mod \
         quickstart.F90 build/gnu-oac/libfundal.a -o quickstart
./quickstart
```

---

## Install

### FoBiS

```bash
git clone https://github.com/szaghi/FUNDAL && cd FUNDAL
fobis build --lmodes                       # list the modes
fobis build --mode fundal-test-oac-nvf     # NVIDIA nvfortran + OpenACC
fobis build --mode fundal-test-omp-ifx     # Intel ifx + OpenMP offload
fobis build --mode fundal-test-oac-gnu     # GNU gfortran + OpenACC
fobis build --mode fundal-test-omp-amd     # AMD amdflang + OpenMP offload
bash scripts/run_tests.sh                  # run the tests built into exe/
```

### make

```bash
make COMPILER=nvf BACKEND=oac GPU=cc89     # build/nvf-oac/libfundal.a and build/nvf-oac/mod/
make COMPILER=gnu BACKEND=oac MPI=1        # also the MPI handler, compiled by mpif90
```

`COMPILER=gnu|nvf|ifx|amd`, `BACKEND=none|oac|omp`.

### CMake

```bash
cmake -B build -DFUNDAL_BACKEND=oac        # none|oac|omp; -DCMAKE_Fortran_COMPILER=nvfortran|ifx|amdflang, -DFUNDAL_MPI=ON
cmake --build build && ctest --test-dir build
cmake --install build --prefix <prefix>    # then find_package(FUNDAL) and link FUNDAL::fundal
```

### fpm

```bash
fpm build                                              # compile-time CPU mode (no MPI handler)
fpm build --flag "-DDEV_OAC -DCOMPILER_GNU -fopenacc"  # gfortran + OpenACC
```

See the
[installation guide](https://szaghi.github.io/FUNDAL/guide/install) for every option and for using FUNDAL in your
project.

### install.sh

Download and build the latest release in one step:

```bash
wget $(curl -s https://api.github.com/repos/szaghi/FUNDAL/releases/latest \
  | jq -r '.assets[] | select(.name | test("install.sh";"i")) | .browser_download_url')
chmod +x install.sh
./install.sh --download wget --build fobis   # default mode: the library, build/fobis-lib-gnu/libfundal.a
./install.sh --download wget --build make    # or the make build (CPU mode)
```

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
