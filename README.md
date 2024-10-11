<a name="top"></a>

# FUNDAL

> Fortran UNified Device Acceleration Library

OpenACC/OpenMP allows to manage (highly parallel, accelerated ) device memory by means of runtime rutines, e.g. allocate and copy to/from device.
These routines, in general, handles C's pointers: FUNDAL provides a convenient fortran API to use OpenMP/OpenACC runtime routines handling C's data
in background simplifying end-user experience. FUNDAL API is designed to (seamless) unify OpenACC and OpenMP runtime routines calling in order to minimize
end-user's effort in developing device-offloaded applications.

### A taste of FUNDAL

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
call dev_memcpy_to_device(dst=a_dev, src=b_hos)

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
call dev_memcpy_from_device(dst=b_hos, src=a_dev)

! check results
print*, b_hos
endprogram fundal_taste
```

The device memory **must** be defined as `pointer` while host memory can be either `pointer` or `allocatable`.

The memory handling (allocate, copy, free) is seamless exploiting a *unified* API for both OpenACC and OpenMP paradigms,
e.g. `call dev_memcpy_from_device(dst=b_hos, src=a_dev)` is the unified API for memory copy from device to host
for both OpenACC and OpenMP without the necessity to write different code for different backends and/or wraps snippets with
conditional preprocessing macros.

Additionaly, note that OpenACC pragmas are ignored when compiled with OpenMP without OpenACC flags (and viceversa) thus
there is no need to wrap pragmas with conditional preprocessing macros.

Go to [Top](#top)

---

| [Features](#features) | [Copyrights](#copyrights) | [Install](#install) | [API Documentation](#api-documentation) |

---

### Features

+ KISS, keep it simple and stupid;
+ easy handling OpenACC memory offloading on (higly parallel) accelerated devices (GPU);
+ easy handling OpenMP memory offloading on (higly parallel) accelerated devices (GPU);
+ MPI enabled for multi-devices clusters;
+ Free, Open Source Project.

#### Status

Status of implemented API:

* device memory handling:
  + [x] dev_alloc
     + [x] OpenACC
     + [x] OpenMP
  + [ ] dev_memcpy
     + [x] OpenACC
     + [x] OpenMP
  + [x] dev_assign_to_device
     + [x] OpenACC
     + [x] OpenMP
  + [x] dev_assign_from_device
     + [x] OpenACC
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

#### Issues

[![GitHub issues](https://img.shields.io/github/issues/szaghi/FUNDAL.svg)]()

#### Compilers support

- NVIDIA HPC SDK, NVFortran: fully support OpenACC backend, works on NVIDIA GPUs, tested with v12.3+;
- INTEL IFX: fully support OpenMP backend, works on INTEL GPUs, tested with v2024.0.2-20231213;
- GNU gfortran: partially support OpenACC backend, compile, but does not work with all tests, tested with v13.1.0;

Go to [Top](#top)

---

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

### Authors

+ Stefano Zaghi, [stefano.zaghi@cnr.it](stefano.zaghi@cnr.it)
+ Giacomo Rossi, [giacomo.rossi@intel.com](giacomo.rossi@intel.com)
+ Andrea di Mascio, [andrea.dimascio@univaq.it](andrea.dimascio@univaq.it)
+ Francesco Salvadore, [f.salvadore@cineca.it](mailto:f.salvadore@cineca.it)

Go to [Top](#top)

---

## Install

FUNDAL is a *pure* fortran library (exploiting few pre-processing C macros) thus it can be built as
any fortran library. The library sources are contained in the directory [src/lib](src/lib), while the examples are in
[src/examples](src/examples) and tests in [src/tests](src/tests). Clone or download the repository to get all
sources, e.g.

```shell
git clone git@github.com:szaghi/FUNDAL.git
```

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

---

# API documentation

In the following, the API of each FUNDAL routine is documented in details with also examples.

## API TOC
+ [Main library modules](#main-library-modules)
+ [Device memory handling](#device-memory-handling)
  - [dev_alloc](#dev_alloc)
  - [dev_alloc_unstr](#dev_alloc_unstr)
  - [dev_free](#dev_free)
  - [dev_free_unstr](#dev_free_unstr)
  - [dev_memcpy_from_device](#dev_memcpy_from_device)
  - [dev_memcpy_to_device](#dev_memcpy_to_device)
  - [dev_memcpy_from_device_unstr](#dev_memcpy_from_device_unstr)
  - [dev_memcpy_to_device_unstr](#dev_memcpy_to_device_unstr)
  - [dev_assign_from_device](#dev_assign_from_device)
  - [dev_assign_to_device](#dev_assign_to_device)
+ [Device handling](#device-handling)
  - [dev_get_device_num](#dev_get_device_num)
  - [dev_get_device_type](#dev_get_device_type)
  - [dev_get_host_num](#dev_get_host_num)
  - [dev_get_num_devices](#dev_get_num_devices)
  - [dev_get_property_string](#dev_get_property_string)

---

## Main library modules

FUNDAL library has a main module from witch all exported names can be used:

```fortran
use :: fundal
```

The (currently) exported names are:

```fortran
! runtime memory routines
public :: dev_alloc_unstr
public :: dev_alloc, FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
public :: dev_free_unstr
public :: dev_free
public :: dev_memcpy_from_device_unstr, dev_memcpy_to_device_unstr
public :: dev_memcpy_from_device, dev_memcpy_to_device
public :: dev_assign_from_device, dev_assign_to_device
! device handling routines
public :: dev_get_device_memory_info
public :: dev_get_device_num
public :: dev_get_device_type
public :: dev_get_host_num
public :: dev_get_num_devices
public :: dev_get_property_string
public :: dev_init
public :: dev_set_device_num
! environment global variables
public :: dev_memory_avail
public :: local_comm
public :: mydev
public :: myhos
public :: devtype
public :: IDK
```

For MPI applications, an auxiliary module is also provided, i.e. `fundal_mpih_object`, it contains the
definition of an object for handling MPI tasks (initializations, environment handling, finalizations, ecc...), e.g.

```fortran
use :: fundal_mpih_object
...
type(mpih_object) :: mpih ! MPI handler.
...
call mpih%initialize(do_mpi_init=.true., do_device_init=.true.)
...
if (mpih%myrank == 1_I4P) call MPI_SEND(var, 1, MPI_REAL8, 0, 100, MPI_COMM_WORLD, mpih%ierr)
...
call MPI_FINALIZE(mpih%error)
```

MPI handler class provides the following API

```fortran
type :: mpih_object
   !< MPI handler class.
   integer(I4P)              :: error=0_I4P              !< Error traping flag.
   integer(I4P)              :: myrank=0_I4P             !< MPI ID process.
   integer(I4P)              :: procs_number=1_I4P       !< Number of MPI processes.
   integer(I8P)              :: hos_memory_avail=0_I8P   !< Host (CPU) memory available (GB) for each process.
   real(R8P)                 :: timing(1:2)              !< Tic toc timing.
   integer(I4P)              :: tictoc=1_I4P             !< Next is tic or toc?
   integer(I4P), allocatable :: req_send_recv(:)         !< MPI request receive flags.
   integer(I4P)              :: devs_number=0_I4P        !< Number of devices.
   integer(I8P), pointer     :: dev_memory_avail=>null() !< Device memory available (GB).
   integer(I4P), pointer     :: mydev=>null()            !< Device ID.
   integer(I4P), pointer     :: local_comm=>null()       !< Local communicator.
   integer(I4P), pointer     :: myhos=>null()            !< Host ID.
   integer(IDk), pointer     :: devtype=>null()          !< Device type (currently used only for OpenACC backend).
   character(:), allocatable :: myrankstr                !< MPI ID stringified.
   contains
      ! public methods
      procedure, pass(self) :: abort         !< Handy MPI abort wrapper.
      procedure, pass(self) :: barrier       !< Handy MPI barrier wrapper.
      procedure, pass(self) :: description   !< Return pretty-printed object description.
      procedure, pass(self) :: error_stop    !< Stop run with error output.
      procedure, pass(self) :: finalize      !< Handy MPI finalize wrapper.
      procedure, pass(self) :: initialize    !< Initialize MPI handler data.
      procedure, pass(self) :: print_message !< Print a message on stdout with rank prefix.
      procedure, pass(self) :: tictoc_timing !< Return the last tic toc timing.
      procedure, pass(self) :: tic           !< Start a tic toc timing.
      procedure, pass(self) :: toc           !< Stop  a tic toc timing.
endtype mpih_object
```
> Note that some global environment variables are conventiently pointed by MPI handler class members, e.g. `mydev`,
`local_comm`, `myhos`, ecc...

Aside the main module and the MPI handler one, there is a C macros include source [fundal.H](src/lib/fundal.H), i.e.:

```c
/* cpp macros to setup backends */
#if defined DEV_OAC
#   define DEVMODULE openacc
#   if defined COMPILER_NVF
#      define DEVICEVAR deviceptr
#   elif defined COMPILER_GNU
#      define DEVICEVAR present
#   endif
#elif defined DEV_OMP
#   define DEVMODULE omp_lib
#   define DEVICEVAR has_device_addr
#   define OMPLOOP target teams distribute parallel do
#else
#   define DEVMODULE omp_lib
#   define DEVICEVAR shared
#   define OMPLOOP parallel do
#endif
```
This include set some compile-time macros necessary to compile the library with OpenACC or OpenMP backend (or with
a non-device fallback one).

Go to [API TOC](#api-toc)

---

## Device memory handling
Runtime routines to handle memory device.

---

### `dev_alloc`
The `dev_alloc` allocates space in the device memory returning a (fortran) pointer to it.
The device memory is **not** mapped to any host memory. The signature is:

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

Go to [API TOC](#api-toc)

---

### `dev_alloc_unstr`
The `dev_alloc_unstr` allocates space in the device memory using *unstructured* model. It actually **maps** device
memory to host one. The signature is:

```fortran
subroutine dev_alloc_unstr(fptr_dev, init_value)
```

##### required args
```fortran
real/integer, intent(inout) :: fptr_dev(..) !< Host memory to be mapped on device.
```

`fptr_dev` is an array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

##### optional args
```fortran
real/integer, intent(in), optional :: init_value   !< Optional initial value.
```

`init_value` is a real/integer scalar (of the same kind of `fptr_dev`): if it is passed it is used to initialized `fptr_dev` with a parallel device loop.

> `dev_alloc_unstr` usage example

```fortran
use :: fundal
...
real(R8P), :: a(:,:,:)
...
call dev_alloc_unstr(fptr_dev=a,init_value=1._R8P)
...
```

Go to [API TOC](#api-toc)

---

### `dev_free`
The `dev_free` frees memory directly allocated on the device.
The signature is:

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

Go to [API TOC](#api-toc)

---

### `dev_free_unstr`
The `dev_free_unstr` frees memory mapped (unstructured model) on the device.
The signature is:

```fortran
subroutine dev_free_unstr(fptr)
```

##### required args
```fortran
real/integer, intent(inout), pointer :: fptr(..) !< Mapped memory.
```

`fptr` is an array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

> `dev_free_unstr` usage example

```fortran
use :: fundal
...
real(R8P), :: a(:,:,:)
...
call dev_free(fptr=a)
...
```

Go to [API TOC](#api-toc)

---

### `dev_memcpy_from_device`
The `dev_memcpy_from_device` copies data from device memory to local host memory.
The signature is:

```fortran
subroutine dev_memcpy_from_device(dst, src)
```

##### required args
```fortran
real/integer, intent(out), target :: dst(:) !< Destination memory (host memory).
real/integer, intent(in),  target :: src(:) !< Source memory (device memory).
```

`dst` is a target, host memory, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

`src` is a target, device memory, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

> `dev_memcpy_from_device` usage example

```fortran
use :: fundal
...
real(R8P), pointer     :: a(:,:,:)
real(R8P), allocatable :: b(:,:,:)
...
call dev_memcpy_from_device(dst=b, src=a)
...
```

Go to [API TOC](#api-toc)

---

### `dev_memcpy_to_device`
The `dev_memcpy_to_device` copies data from local host memory to device memory.
The signature is:

```fortran
subroutine dev_memcpy_to_device(dst, src)
```

##### required args
```fortran
real/integer, intent(out), target :: dst(:) !< Destination memory (device memory).
real/integer, intent(in),  target :: src(:) !< Source memory (host memory).
```

`dst` is a target, device memory, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

`src` is a target, host memory, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

> `dev_memcpy_to_device` usage example

```fortran
use :: fundal
...
real(R8P), pointer     :: a(:,:,:)
real(R8P), allocatable :: b(:,:,:)
...
call dev_memcpy_to_device(dst=a, src=b)
...
```

Go to [API TOC](#api-toc)

---

### `dev_memcpy_from_device_unstr`
The `dev_memcpy_from_device` copies data from device memory (mapped) to local host memory.
The signature is:

```fortran
subroutine dev_memcpy_from_device_unstr(dst)
```

##### required args
```fortran
real/integer, intent(inout) :: dst(:) !< Destination memory (host memory mapped on device).
```

`dst` is host memory mapped on device, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

> `dev_memcpy_from_device_unstr` usage example

```fortran
use :: fundal
...
real(R8P), allocatable :: a(:,:,:)
...
call dev_memcpy_from_device_unstr(dst=a)
...
```

Go to [API TOC](#api-toc)

---

### `dev_memcpy_to_device_unstr`
The `dev_memcpy_to_device_unstr` copies data from local host memory to device mapped memory.
The signature is:

```fortran
subroutine dev_memcpy_to_device_unstr(dst)
```

##### required args
```fortran
real/integer, intent(inout) :: dst(:) !< Destination memory (mapped device memory).
```

`dst` is mapped device memory, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

> `dev_memcpy_to_device` usage example

```fortran
use :: fundal
...
real(R8P), allocatable :: a(:,:,:)
...
call dev_memcpy_to_device_unstr(dst=a)
...
```

Go to [API TOC](#api-toc)

---

### `dev_assign_from_device`
The `dev_assign_from_device` copies data from device memory to local host memory: the host memory is deallocated
and re-allocated of the correct size, this procedure mimics the automatic left-hand-side fortran reallocation
of standard allocatable arrays.
The signature is:

```fortran
subroutine dev_assign_from_device(dst, src)
```

##### required args
```fortran
real/integer, intent(inout), allocatable :: dst(:) !< Destination memory (host memory).
real/integer, intent(in)                 :: src(:) !< Source memory (device memory).
```

`dst` is a target, host memory, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

`src` is a target, device memory, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

> `dev_assign_from_device` usage example

```fortran
use :: fundal
...
real(R8P), pointer     :: a(:,:,:)
real(R8P), allocatable :: b(:,:,:)
...
call dev_assign_from_device(dst=b, src=a)
...
```

Go to [API TOC](#api-toc)

---

### `dev_assign_to_device`
The `dev_assign_to_device` copies data from local host memory to device memory: the device memory is deallocated
and re-allocated of the correct size, this procedure mimics the automatic left-hand-side fortran reallocation
of standard allocatable arrays.
The signature is:

```fortran
subroutine dev_assign_to_device(dst, src)
```

##### required args
```fortran
real/integer, intent(inout), pointer :: dst(:) !< Destination memory (device memory).
real/integer, intent(in)             :: src(:) !< Source memory (host memory).
```

`dst` is a target, device memory, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

`src` is a target, host memory, array of any ranks up to 7 of real (kinds R8P, R4P) or integer (kinds I8P, I4P, I1P).

> `dev_assign_to_device` usage example

```fortran
use :: fundal
...
real(R8P), pointer     :: a(:,:,:)
real(R8P), allocatable :: b(:,:,:)
...
call dev_assign_to_device(dst=a, src=b)
...
```

Go to [API TOC](#api-toc)

---

## Device handling

Runtime routines to handle device(s), in particular for complex scenario like MPI programming.

---

### `dev_get_device_num`
Return the value of current device ID (for the current thread and MPI process).
The signature is:

```fortran
function dev_get_device_num() result(device_num)
integer(I4P) :: device_num !< Device ID for current thread.
```

No args are required. Note that the device type environment global variable, `devtype`, must be set before use
this routine. By default it is seto to `acc_device_default` for the OpenACC backend.

> `dev_get_device_num` usage example

```fortran
use :: fundal
...
integer :: dev
...
dev = dev_get_device_num()
...
```

Go to [API TOC](#api-toc)

---

### `dev_get_device_type`
Return the device type.
The signature is:

```fortran
function dev_get_device_type() result(devtype)
#ifdef DEV_OAC
   integer(acc_device_kind) :: devtype
#else
   integer(I4P),            :: devtype
#endif
```
No args are required. The result is standard integer (always equal to 0) for OpenMP backend that does not provide such
a runtime routine, whereas it is `integer(acc_device_kind)` for OpenACC backend.

> `dev_get_device_type` usage example

```fortran
use :: fundal
...
#ifdef DEV_OAC
   integer(acc_device_kind) :: devtype
#else
   integer(I4P)             :: devtype
#endif
...
devtype = dev_get_device_type()
...
```

Go to [API TOC](#api-toc)

---

### `dev_get_host_num`
Return the value of current host ID (for the current thread and MPI process).
The signature is:

```fortran
function dev_get_host_num() result(host_num)
integer(I4P) :: host_num !< Device ID for current thread and MPI process.
```
No args are required.

> `dev_get_host_num` usage example

```fortran
use :: fundal
...
integer(I4P) :: myhost
...
myhost = dev_get_host_num()
...
```

Go to [API TOC](#api-toc)

---

### `dev_get_num_devices`
Return the number of available (non host) devices.
The signature is:

```fortran
function dev_get_num_devices() result(devices_number)
integer(I4P) :: devices_number !< Devices number.
```
No args are required. Note that the device type environment global variable, `devtype`, must be set before use
this routine. By default it is seto to `acc_device_default` for OpenACC backend. For OpenMP backend that does not
provide such a runtime routine it returns always 1.

> `dev_get_num_devices` usage example

```fortran
use :: fundal
...
integer(I4P) :: devices_number
...
devices_number = dev_get_num_devices()
...
```

Go to [API TOC](#api-toc)

---

### `dev_get_property_string`
Return the pretty-printed string value of device-property for the specified device. Note that the device type
environment global variable, `devtype`, must be set before use
this routine. By default it is seto to `acc_device_default` for OpenACC backend. For OpenMP backend that does not
provide such a runtime routine it returns always a null string.

```fortran
subroutine dev_get_property_string(dev_num, string, prefix, memory)
```

##### required args
```fortran
integer, value, intent(in)  :: dev_num !< Device ID.
character(*),   intent(out) :: string  !< Stringified device property.
```

`dev_num` is the device ID queried.

`string` is the output string containing the pretty-printed device-property value.

##### optional args
```fortran
character(*), intent(in),  optional :: prefix  !< String prefix.
integer(I8P), intent(out), optional :: memory  !< Device memory.
```

`prefix` is a prefix string prefixed to each row of output string.

`memory` is the value (bytes) of memory available on device.

> `dev_get_property_string` usage example

```fortran
use :: fundal
...
integer :: dev
character(999) :: property_string
...
dev = dev_get_device_num()
call dev_get_property_string(dev_num=dev, string=property_string, prefix='  ')
print '("current thread device property = ",A)', new_line('a')//trim(property_string)
...
```

Go to [API TOC](#api-toc)

Go to [Top](#top)
