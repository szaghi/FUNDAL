---
layout: home

hero:
  name: FUNDAL
  text: Fortran UNified Device Acceleration Library
  tagline: A pure Fortran library providing a unified API for GPU/device memory management over OpenACC and OpenMP backends — one interface, any accelerator.
  actions:
    - theme: brand
      text: Guide
      link: /guide/
    - theme: alt
      text: API Reference
      link: /guide/api-reference
    - theme: alt
      text: View on GitHub
      link: https://github.com/szaghi/FUNDAL

features:
  - icon: 🚀
    title: OpenACC & OpenMP
    details: Unified API covering both OpenACC and OpenMP backends. The backend is selected at compile time — no conditional code required in user programs.
  - icon: 🔗
    title: Seamless Memory Model
    details: Structured (pure device) and unstructured (host-mapped) memory models. Allocate, copy, and free device memory with consistent Fortran-idiomatic calls.
  - icon: 🌐
    title: MPI Multi-Device
    details: Built-in MPI handler class for distributing work across multiple GPUs in a cluster, with device initialisation, barriers, and timing utilities.
  - icon: 🛠️
    title: Multi-Compiler Support
    details: Tested with NVIDIA nvfortran, Intel IFX, GNU gfortran, and AMD Flang. Builds with FoBiS.py or GNU Make.
  - icon: 🆓
    title: Free & Open Source
    details: Multi-licensed — GPLv3 for FOSS projects, BSD 2/3-Clause or MIT for commercial use.
---

## Quick start

A minimal FUNDAL program: allocate device memory, copy data to the GPU, run a kernel, copy back.

```fortran
program fundal_taste
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal

implicit none
real(R8P), pointer :: a_dev(:,:,:)=>null()  ! device memory
real(R8P), pointer :: b_hos(:,:,:)=>null()  ! host   memory
integer(I4P)       :: ierr
integer(I4P)       :: i, j, k

! initialise environment global variables
myhos   = dev_get_host_num()
devtype = dev_get_device_type()
call dev_set_device_num(0)
mydev   = dev_get_device_num()

! allocate device memory
call dev_alloc(fptr_dev=a_dev, lbounds=[-1,-2,-3], ubounds=[1,2,3], ierr=ierr, dev_id=mydev)

! allocate and set host memory
allocate(b_hos(-1:1,-2:2,-3:3))
b_hos = -3._R8P

! copy to device, work on device, copy back
call dev_memcpy_to_device(dst=a_dev, src=b_hos)

!$acc parallel loop independent deviceptr(a_dev) collapse(3)
!$omp target teams distribute parallel do collapse(3) has_device_addr(a_dev)
do k=-3,3; do j=-2,2; do i=-1,1
  a_dev(i,j,k) = a_dev(i,j,k) / 2._R8P
enddo; enddo; enddo

call dev_memcpy_from_device(dst=b_hos, src=a_dev)
print*, b_hos
endprogram fundal_taste
```

Device memory is declared as `pointer`; host memory can be `pointer` or `allocatable`. OpenACC and OpenMP pragmas coexist safely — unrecognised directives are ignored by the compiler.

## Authors

- Stefano Zaghi — [stefano.zaghi@cnr.it](mailto:stefano.zaghi@cnr.it)
- Giacomo Rossi — [giacomo.rossi@intel.com](mailto:giacomo.rossi@intel.com)
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
