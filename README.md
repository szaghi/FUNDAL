<a name="top"></a>

# FUNDAL

> Fortran UNified Device Acceleration Library

### Authors

+ Stefano Zaghi, [stefano.zaghi@cnr.it](stefano.zaghi@cnr.it)
+ Giacomo Rossi, [giacomo.rossi@intel.com](giacomo.rossi@intel.com)
+ Andrea di Mascio, [andrea.dimascio@univaq.it](andrea.dimascio@univaq.it)
+ Francesco Salvadore, [f.salvadore@cineca.it](mailto:f.salvadore@cineca.it)

### Features

+ KISS, keep it simple and stupid;
+ easy handling OpenACC memory offloading on (higly parallel) accelerated devices (GPU);
+ easy handling OpenMP memory offloading on (higly parallel) accelerated devices (GPU);
+ MPI enabled for multi-devices clusters;
+ Free, Open Source Project.

#### Issues

[![GitHub issues](https://img.shields.io/github/issues/szaghi/FUNDAL.svg)]()

#### Compilers support

- NVIDIA HPC SDK, NVFortran: fully support OpenACC backend, works on NVIDIA GPUs, tested with v12.3;
- INTEL IFX: fully support OpenMP backend, works on INTEL GPUs, tested with v2024.0.2-20231213;
- GNU gfortran: partially support OpenACC backend, compile, but does not work with all tests, tested with v13.1.0;

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

* device memory handling:
  + [x] dev_malloc
     + [x] OpenACC
     + [x] OpenMP
  + [ ] dev_memcpy
     + [ ] OpenACC
     + [x] OpenMP
  + [x] dev_memcpy_to_device
     + [x] OpenACC
     + [x] OpenMP
  + [x] dev_memcpy_from_device
     + [x] OpenACC
     + [x] OpenMP
  + [x] dev_free
     + [x] OpenACC
     + [x] OpenMP
* [ ] device handling:
  + [x] dev_get_device_num
     + [x] OpenACC
     + [x] OpenMP
  + [x] dev_get_device_type
     + [x] OpenACC
     + [ ] OpenMP
  + [x] dev_get_host_num
     + [x] OpenACC
     + [x] OpenMP
  + [x] dev_get_num_devices
     + [x] OpenACC
     + [x] OpenMP
  + [ ] dev_get_property_string
     + [x] OpenACC
     + [ ] OpenMP

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

! initialize environment global variables
myhos = dev_get_host_num()      ! get host ID
devtype = dev_get_device_type() ! get device type
call dev_set_device_num(0)      ! set device ID (in complex scenario this ID is less trivial than 0, e.g. MPI)
mydev = dev_get_device_num()    ! get device ID

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

### Compile and Run tests

FUNDAL is a module-based Fortran library and must be compiled accordingly to the modules' hierarchy.
A `fobos` file is provided for easy building by means of [FoBiS.py](https://github.com/szaghi/FoBiS) program.

Currently only NVIDIA SDK (NVFortran) and INTEL IFX compilers are supported. GNU gfortran is only partially supported.

In the following, the bare minimal information to build FUNDAL tests is reported. For a more detailed documentation on tests
see [tests documentation](src/tests/README.md).

#### OpenACC

To build tests and examples with OpenACC backend by means of NVIDIA sdk type:

```shell
FoBiS.py build -mode fundal-test-oac-nvf
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
FoBiS.py build -mode fundal-test-omp-ifx
tree exe/
exe/
├── fundal_alloc_free_test
├── fundal_array_access_test
├── fundal_derived_type_memcpy_test
├── fundal_device_handling_test
├── fundal_memcpy_test
├── fundal_use_test
```

#### Run tests

All test can be executed without any argument and a successful execution produces a `test passed` output.
Test can also be executed all with a single script:

```shell
utils/run_test.sh
```

Moreover, the tests can be built and executed by means of [FoBiS.py](https://github.com/szaghi/FoBiS):

```shell
# only execution
FoBiS.py rule -ex run-tests
Executing rule "run-tests"
   Command => utils/run_tests.sh
...
# build and execution with OpenACC-NVF
FoBiS.py rule -ex build-run-tests-oac-nvf
Executing rule "build-run-tests-oac-nvf"
   Command => FoBiS.py clean
   Command => FoBiS.py build -mode fundal-test-oac-nvf
   Command => FoBiS.py rule -ex run-tests
...
# build and execution with OpenMP-IFX
FoBiS.py rule -ex build-run-tests-omp-ifx
Executing rule "build-run-tests-omp-ifx"
   Command => FoBiS.py clean
   Command => FoBiS.py build -mode fundal-test-omp-ifx
   Command => FoBiS.py rule -ex run-tests
...
```

Go to [Top](#top)

### API documentation

In the following, the API of each FUNDAL routine is documented in details with also examples.

+ Device memory handling
  - [dev_alloc](#dev_alloc)
  - [dev_memcpy_from_device](#dev_memcpy_from_device)
  - [dev_memcpy_to_device](#dev_memcpy_to_device)
  - [dev_free](#dev_free)
+ Device handling
  - [dev_get_device_num](#dev_get_device_num)
  - [dev_get_device_type](#dev_get_device_type)
  - [dev_get_host_num](#dev_get_host_num)
  - [dev_get_num_devices](#dev_get_num_devices)
  - [dev_get_property_string](#dev_get_property_string)

---

### Device memory handling
Runtime routines to handle memory device.

### `dev_alloc`
The dev_malloc allocates space in the current device memory. The signature is:

```fortran
subroutine dev_alloc(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

##### required args
```fortran
real/integer, intent(out), pointer :: fptr_dev(..) !< Pointer to allocated memory.
integer(I4P), intent(in)           :: ubounds(:)   !< Array upper bounds.
integer(I4P), intent(out)          :: ierr         !< Error status.
```

`fptr_dev` is a pointer array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

`ubounds` is an integer array of rank 1 containing the upper bounds of `fptr_dev`.

`ierr` returns the error status of allocation, it is 0 for a successful allocation.

##### optional args
```fortran
integer(I4P), intent(in), optional :: dev_id       !< Device ID.
integer(I4P), intent(in), optional :: lbounds(:)   !< Array lower bounds, 1 if not passed.
real/integer, intent(in), optional :: init_value   !< Optional initial value.
```

`dev_id` is the device num (ID) over the allocation happens. For OpenACC it is not used. For OpenMP is set to the environmental global
variable `mydev` (that must be previously initialized by means of `dev_get_device_num`) if it is not passed.

`lbounds` is an integer array of rank 1 containing the lower bounds of `fptr_dev`. It is set to 1 if it is not passed.

`init_value` is a real/integer scalar (of the same kind of `fptr_dev`): if it is passed it is used to initialized `fptr_dev` with a parallel device loop.

> `dev_alloc` usage example

```fortran
use :: fundal
...
real(R8P), pointer :: a(:,:,:)
integer(I4P)       :: ierr
...
call dev_alloc(fptr_dev=a,lbounds=[-1,-2,-3],ubounds=[1,2,3],init_value=1._R8P,ierr=ierr)
...
```
---
### `dev_memcpy_from_device`
The `dev_memcpy_from_device` copies data from device memory to local host memory.

```fortran
subroutine dev_memcpy_from_device(fptr_dst, fptr_src)
```

##### required args
```fortran
real/integer, intent(out), target :: fptr_dst(:) !< Destination memory (host memory).
real/integer, intent(in),  target :: fptr_src(:) !< Source memory (device memory).
```

`fptr_dst` is a target, host memory, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

`fptr_src` is a target, device memory, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

> `dev_memcpy_from_device` usage example

```fortran
use :: fundal
...
real(R8P), pointer     :: a(:,:,:)
real(R8P), allocatable :: b(:,:,:)
...
call dev_memcpy_from_device(fptr_dst=b, fptr_src=a)
...
```

---
### `dev_memcpy_to_device`
The `dev_memcpy_to_device` copies data from local host memory to device memory.

```fortran
subroutine dev_memcpy_to_device(fptr_dst, fptr_src)
```

##### required args
```fortran
real/integer, intent(out), target :: fptr_dst(:) !< Destination memory (device memory).
real/integer, intent(in),  target :: fptr_src(:) !< Source memory (host memory).
```

`fptr_dst` is a target, device memory, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

`fptr_src` is a target, host memory, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

> `dev_memcpy_to_device` usage example

```fortran
use :: fundal
...
real(R8P), pointer     :: a(:,:,:)
real(R8P), allocatable :: b(:,:,:)
...
call dev_memcpy_to_device(fptr_dst=a, fptr_src=b)
...
```

---
### `dev_free`
The `dev_free` frees memory on the current device.

```fortran
subroutine dev_free(fptr, dev_id)
```

##### required args
```fortran
real/integer, intent(out), pointer :: fptr_dev(..) !< Pointer to allocated memory.
```

`fptr_dev` is a pointer array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

##### optional args
```fortran
integer(I4P), intent(in), optional :: dev_id       !< Device ID.
```

`dev_id` is the device num (ID) over the allocation happens. For OpenACC it is not used. For OpenMP is set to the environmental global
variable `mydev` (that must be previously initialized by means of `dev_get_device_num`) if it is not passed.

> `dev_free` usage example

```fortran
use :: fundal
...
real(R8P), pointer :: a(:,:,:)
...
call dev_free(fptr_dev=a)
...
```

### Device handling

Runtime routines to handle device(s), in particular for complex scenario like MPI programming.

---
### `dev_get_device_num`

To be written.

---
### `dev_get_device_type`

To be written.

---
### `dev_get_host_num`

To be written.

---
### `dev_get_num_devices`

To be written.

---
### `dev_get_property_string`

To be written.

## Install

To be written.

Go to [Top](#top)
