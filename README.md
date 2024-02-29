<a name="top"></a>

# FUNDAL

> Fortran UNified Device Acceleration Library

### Authors

+ Francesco Salvadore, [f.salvadore@cineca.it](mailto:f.salvadore@cineca.it)
+ Andrea di Mascio, [andrea.dimascio@univaq.it](andrea.dimascio@univaq.it)
+ Giacomo Rossi, [giacomo.rossi@intel.com](giacomo.rossi@intel.com)
+ Stefano Zaghi, [stefano.zaghi@cnr.it](stefano.zaghi@cnr.it)

### Features

+ KISS, keep it simple and stupid;
+ easy handling OpenACC memory offloading on (higly parallel) accelerated devices (GPU);
+ easy handling OpenMP memory offloading on (higly parallel) accelerated devices (GPU);
+ MPI enabled for multi-devices clusters;
+ Fortran 2003+ with OpenACC directives standard compliant ;
+ Free, Open Source Project.

#### Issues

[![GitHub issues](https://img.shields.io/github/issues/szaghi/FUNDAL.svg)]()

---

| [What is FUNDAL?](#what-is-fundal) | [Status](#status) | [Copyrights](#copyrights) | [A taste of FUNDAL](#a-taste-of-fundal) | [Documentation](#documentation) | [Install](#install) |

---

## What is FUNDAL?

OpenACC/OpenMP allows to manage (highly parallel, accelerated ) device memory by means of runtime rutines, e.g. allocate and copy to/from device.
These routines, in general, handles C's pointers: FUNDAL provides a convenient fortran API to use OpenMP/OpenACC runtime routines handling C's data
in background simplifying end-user experience. FUNDAL API is designed to (seamless) unify OpenACC and OpenMP runtime routines calling in order to minimize
end-user's effort in developing device-offloaded applications.

Go to [Top](#top)

## Status

Status of implemented API:

* OpenaCC backend:
  + [x] acc_malloc
  + [x] acc_memcpy_to_device
  + [x] acc_memcpy_from_device
  + [x] acc_free
  + [ ] device handling:
     * dev_get_device_num
     * dev_get_num_devices
     * dev_get_property_string
     * dev_init_device
* OpenaMP backend:
  + [x] omp_malloc
  + [x] omp_memcpy
  + [x] omp_free
  + [ ] device handling:
     * dev_get_device_num
     * dev_get_num_devices
     * dev_get_host_num

Go to [Top](#top)

## Copyrights

FUNDAL is an open source project, it is distributed under a multi-licensing system:

+ for FOSS projects:
  - [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html);
+ for closed source/commercial projects:
  - [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause);
  - [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause);
  - [MIT](http://opensource.org/licenses/MIT).

Anyone is interest to use, to develop or to contribute is welcome, feel free to select the license that best matches your soul!

More details can be found on [wiki](https://github.com/szaghi/FUNDAL/wiki/Copyrights).

Go to [Top](#top)

## A taste of FUNDAL

A minimal example of FUNDAL usage is contained into `src\examples\fundal_taste.F90` and is reported below.

```fortran
program fundal_taste
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64 ! portable kinds
use            :: fundal                                          ! FUNDAL library

implicit none
real(R8P), pointer :: a_dev(:,:,:)=>null() ! device memory
real(R8P), pointer :: b_hos(:,:,:)=>null() ! host   memory
integer(I4P)       :: ierr                 ! error status
integer(I4P)       :: i, j, k              ! counter

! initialize device
myhos = dev_get_host_num()          ! get host ID
mydev = dev_get_device_num()        ! get device ID
call dev_init_device(dev_num=mydev) ! initialize device

! allocate device memory
call dev_alloc(fptr_dev=a_dev,lbounds=[-1,-2,-3],ubounds=[1,2,3],ierr=ierr,dev_id=mydev)

! allocate host memory
allocate(b_hos(-1:1,-2:2,-3:3))

! set host memory
b_hos = -3._R8P

! copy to device
call dev_memcpy_to_device(fptr_dst=a_dev, fptr_src=b_hos)

! work on device
!$acc parallel loop independent deviceptr(a_dev) collapse(3)
!$omp target teams distribute parallel do collapse(3) has_device_addr(a_dev)
do k=-3,3
  do j=-2,2
    do i=-1,1
       a_dev(i,j,k) = a_dev(i,j,k) / 2._R8P
    enddo
  enddo
enddo

! copy from device
call dev_memcpy_from_device(fptr_dst=b_hos, fptr_src=a_dev)

! check results
print*, b_hos
endprogram fundal_taste
```

The device memory **must** be defined as `pointer` while host memory can be either `pointer` or `allocatable`.

The memory handling (allocate, copy, free) is seamless exploiting a *unified* API for both OpenACC and OpenMP paradigms,
e.g. `call dev_memcpy_from_device(fptr_dst=b_hos, fptr_src=a_dev)` is the unified API for memory copy from device to host
for both OpenACC and OpenMP without the necessity to write different code for the 2 backend and/or wraps snippets with
conditional preprocessing macros.

Additionaly, note that OpenACC pragmas are ignored when compiled with OpenMP without OpenACC flags (and viceversa) thus
there is no need to wrap pragmas with conditional preprocessing macros.

Go to [Top](#top)

## Documentation

To be completed.

### Compile and Run tests

FUNDAL is a module-based Fortran library and must be compiled accordingly to the modules' hierarchy.
A `fobos` file is provided for easy building by means of [FoBiS.py](https://github.com/szaghi/FoBiS) program.

Currently only NVIDIA SDK (NVFortran) and INTEL IFX compilers are supported.

#### OpenACC

To build tests and examples with OpenACC backend by means of NVIDIA sdk type:

```shell
FoBiS.py build -mode fundal-test-nvf
tree exe/
exe/
├── fundal_alloc_free_test
├── fundal_array_access_test
├── fundal_derived_type_memcpy_test
├── fundal_device_handling_test
├── fundal_memcpy_test
├── fundal_use_test
```

#### OpenMP

To build tests and examples with OpenMP backend by means of INTEL sdk type:

```shell
FoBiS.py build -mode fundal-test-ifx
tree exe/
exe/
├── fundal_alloc_free_test
├── fundal_array_access_test
├── fundal_derived_type_memcpy_test
├── fundal_device_handling_test
├── fundal_memcpy_test
├── fundal_use_test
```

Go to [Top](#top)

### API documentation

To be written.

#### `dev_alloc`
#### `dev_free`
#### `dev_memcpy_from_device`
#### `dev_memcpy_to_device`

## Install

To be written.

Go to [Top](#top)
