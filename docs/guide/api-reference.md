---
title: API Reference
---

# API Reference

FUNDAL exposes a single public module:

```fortran
use :: fundal
```

## Exported names

```fortran
! memory routines
public :: dev_alloc,              FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
public :: dev_alloc_unstr
public :: dev_free
public :: dev_free_unstr
public :: dev_memcpy_from_device, dev_memcpy_to_device
public :: dev_memcpy_from_device_unstr, dev_memcpy_to_device_unstr
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

## Preprocessor macros (`fundal.H`)

The library uses C preprocessor macros to select the backend at compile time:

```c
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

Pass `-DDEV_OAC` or `-DDEV_OMP` (plus the appropriate compiler macro) to the preprocessor to activate the desired backend. Without either flag, a CPU-only fallback is used.

---

## MPI handler (`fundal_mpih_object`)

For MPI applications an auxiliary module is provided separately:

```fortran
use :: fundal_mpih_object
```

The `mpih_object` type wraps MPI initialisation, device assignment, barriers, and timing:

```fortran
type(mpih_object) :: mpih
call mpih%initialize(do_mpi_init=.true., do_device_init=.true.)
```

| Member | Type | Description |
|--------|------|-------------|
| `myrank` | `integer(I4P)` | MPI process ID |
| `procs_number` | `integer(I4P)` | Number of MPI processes |
| `devs_number` | `integer(I4P)` | Number of devices |
| `mydev` | `integer(I4P), pointer` | Points to global `mydev` |
| `myhos` | `integer(I4P), pointer` | Points to global `myhos` |
| `devtype` | `integer(IDK), pointer` | Points to global `devtype` |
| `dev_memory_avail` | `integer(I8P), pointer` | Points to global `dev_memory_avail` |
| `local_comm` | `integer(I4P), pointer` | Points to global `local_comm` |
| `hos_memory_avail` | `integer(I8P)` | Host memory available (bytes) |
| `timing(1:2)` | `real(R8P)` | Tic/toc wall-clock values |

| Method | Description |
|--------|-------------|
| `initialize` | Initialise MPI and optionally the device |
| `finalize` | Finalise MPI |
| `barrier` | MPI barrier |
| `abort` | MPI abort |
| `error_stop` | Stop with error output |
| `tic` / `toc` | Start / stop wall-clock timer |
| `tictoc_timing` | Return elapsed time from last tic/toc |
| `print_message` | Print a message prefixed with the MPI rank |
| `description` | Return a pretty-printed object description |

---

## Device memory handling

---

### `dev_alloc` {#dev_alloc}

Allocates space directly on the device and returns a Fortran `pointer` to it. The device memory is **not** mapped to any host memory.

```fortran
subroutine dev_alloc(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

| Argument | Intent | Description |
|----------|--------|-------------|
| `fptr_dev` | `out`, pointer | Pointer to allocated device memory (ranks 1–7, kinds R8P/R4P/I8P/I4P/I2P/I1P) |
| `ubounds(:)` | `in` | Upper bounds of `fptr_dev` |
| `ierr` | `out` | Error status (0 = success; `FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED` on failure) |
| `dev_id` | `in`, optional | Device ID. For OpenMP defaults to global `mydev`. |
| `lbounds(:)` | `in`, optional | Lower bounds of `fptr_dev` (default: 1) |
| `init_value` | `in`, optional | Scalar initial value; if provided, initialises `fptr_dev` with a parallel device loop |

```fortran
use :: fundal
real(R8P), pointer :: a(:,:,:)
integer(I4P)       :: ierr

call dev_alloc(fptr_dev=a, lbounds=[-1,-2,-3], ubounds=[1,2,3], init_value=1._R8P, ierr=ierr)
```

---

### `dev_alloc_unstr` {#dev_alloc_unstr}

Maps an existing host array onto the device using the *unstructured* memory model.

```fortran
subroutine dev_alloc_unstr(fptr_dev, init_value)
```

| Argument | Intent | Description |
|----------|--------|-------------|
| `fptr_dev` | `inout` | Host array to be mapped (ranks 1–7, kinds R8P/R4P/I8P/I4P/I2P/I1P) |
| `init_value` | `in`, optional | Scalar initial value for a parallel device initialisation |

```fortran
use :: fundal
real(R8P) :: a(:,:,:)

call dev_alloc_unstr(fptr_dev=a, init_value=1._R8P)
```

---

### `dev_free` {#dev_free}

Frees memory that was directly allocated on the device with `dev_alloc`.

```fortran
subroutine dev_free(fptr_dev, dev_id)
```

| Argument | Intent | Description |
|----------|--------|-------------|
| `fptr_dev` | `out`, pointer | Pointer to device memory to free |
| `dev_id` | `in`, optional | Device ID. For OpenMP defaults to global `mydev`. |

```fortran
use :: fundal
real(R8P), pointer :: a(:,:,:)

call dev_free(fptr_dev=a)
```

---

### `dev_free_unstr` {#dev_free_unstr}

Unmaps device memory that was mapped with `dev_alloc_unstr`.

```fortran
subroutine dev_free_unstr(fptr)
```

| Argument | Intent | Description |
|----------|--------|-------------|
| `fptr` | `inout` | Host array whose device mapping is to be released |

```fortran
use :: fundal
real(R8P) :: a(:,:,:)

call dev_free_unstr(fptr=a)
```

---

### `dev_memcpy_to_device` {#dev_memcpy_to_device}

Copies data from host memory to device memory (structured model).

```fortran
subroutine dev_memcpy_to_device(dst, src)
```

| Argument | Intent | Description |
|----------|--------|-------------|
| `dst` | `out`, target | Device memory destination (ranks 1–7) |
| `src` | `in`, target | Host memory source (ranks 1–7) |

```fortran
use :: fundal
real(R8P), pointer     :: a(:,:,:)   ! device
real(R8P), allocatable :: b(:,:,:)   ! host

call dev_memcpy_to_device(dst=a, src=b)
```

---

### `dev_memcpy_from_device` {#dev_memcpy_from_device}

Copies data from device memory to host memory (structured model).

```fortran
subroutine dev_memcpy_from_device(dst, src)
```

| Argument | Intent | Description |
|----------|--------|-------------|
| `dst` | `out`, target | Host memory destination (ranks 1–7) |
| `src` | `in`, target | Device memory source (ranks 1–7) |

```fortran
use :: fundal
real(R8P), pointer     :: a(:,:,:)   ! device
real(R8P), allocatable :: b(:,:,:)   ! host

call dev_memcpy_from_device(dst=b, src=a)
```

---

### `dev_memcpy_to_device_unstr` {#dev_memcpy_to_device_unstr}

Copies host data into a device-mapped (unstructured) array.

```fortran
subroutine dev_memcpy_to_device_unstr(dst)
```

| Argument | Intent | Description |
|----------|--------|-------------|
| `dst` | `inout` | Host array mapped on the device |

```fortran
use :: fundal
real(R8P), allocatable :: a(:,:,:)

call dev_memcpy_to_device_unstr(dst=a)
```

---

### `dev_memcpy_from_device_unstr` {#dev_memcpy_from_device_unstr}

Copies data from a device-mapped (unstructured) array back to host.

```fortran
subroutine dev_memcpy_from_device_unstr(dst)
```

| Argument | Intent | Description |
|----------|--------|-------------|
| `dst` | `inout` | Host array mapped on the device |

```fortran
use :: fundal
real(R8P), allocatable :: a(:,:,:)

call dev_memcpy_from_device_unstr(dst=a)
```

---

### `dev_assign_to_device` {#dev_assign_to_device}

Copies host memory to device memory, reallocating the device array if the size has changed. Mimics Fortran's automatic left-hand-side reallocation.

```fortran
subroutine dev_assign_to_device(dst, src)
```

| Argument | Intent | Description |
|----------|--------|-------------|
| `dst` | `inout`, pointer | Device memory (reallocated if needed) |
| `src` | `in` | Host memory source |

```fortran
use :: fundal
real(R8P), pointer     :: a(:,:,:)
real(R8P), allocatable :: b(:,:,:)

call dev_assign_to_device(dst=a, src=b)
```

---

### `dev_assign_from_device` {#dev_assign_from_device}

Copies device memory to host memory, reallocating the host array if the size has changed. Mimics Fortran's automatic left-hand-side reallocation.

```fortran
subroutine dev_assign_from_device(dst, src)
```

| Argument | Intent | Description |
|----------|--------|-------------|
| `dst` | `inout`, allocatable | Host memory (reallocated if needed) |
| `src` | `in` | Device memory source |

```fortran
use :: fundal
real(R8P), pointer     :: a(:,:,:)
real(R8P), allocatable :: b(:,:,:)

call dev_assign_from_device(dst=b, src=a)
```

---

## Device handling

---

### `dev_init` {#dev_init}

Initialises the device environment. Sets the global variables `myhos`, `devtype`, `mydev`, `devs_number`, and `dev_memory_avail`.

---

### `dev_set_device_num` {#dev_set_device_num}

Sets the current device for the calling thread.

```fortran
call dev_set_device_num(dev_id)
```

---

### `dev_get_device_num` {#dev_get_device_num}

Returns the current device ID for the calling thread.

```fortran
function dev_get_device_num() result(device_num)
integer(I4P) :: device_num
```

::: info
The global `devtype` must be set before calling this routine (set automatically by `dev_init`, or defaults to `acc_device_default` for OpenACC).
:::

```fortran
use :: fundal
integer(I4P) :: dev

dev = dev_get_device_num()
```

---

### `dev_get_device_type` {#dev_get_device_type}

Returns the device type. The return kind is `acc_device_kind` for OpenACC backends, or `I4P` (always 0) for OpenMP.

```fortran
function dev_get_device_type() result(devtype)
```

```fortran
use :: fundal
#ifdef DEV_OAC
  integer(acc_device_kind) :: devtype
#else
  integer(I4P)             :: devtype
#endif

devtype = dev_get_device_type()
```

---

### `dev_get_host_num` {#dev_get_host_num}

Returns the host ID for the calling thread and MPI process.

```fortran
function dev_get_host_num() result(host_num)
integer(I4P) :: host_num
```

```fortran
use :: fundal
integer(I4P) :: myhost

myhost = dev_get_host_num()
```

---

### `dev_get_num_devices` {#dev_get_num_devices}

Returns the number of available (non-host) devices.

```fortran
function dev_get_num_devices() result(devices_number)
integer(I4P) :: devices_number
```

::: info
For OpenMP, which does not provide an equivalent runtime routine, this always returns 1.
:::

```fortran
use :: fundal
integer(I4P) :: n

n = dev_get_num_devices()
```

---

### `dev_get_device_memory_info` {#dev_get_device_memory_info}

Returns available memory on the current device (bytes).

---

### `dev_get_property_string` {#dev_get_property_string}

Returns a pretty-printed string of device properties for the specified device.

```fortran
subroutine dev_get_property_string(dev_num, string, prefix, memory)
```

| Argument | Intent | Description |
|----------|--------|-------------|
| `dev_num` | `in`, value | Device ID to query |
| `string` | `out` | Output string with device properties |
| `prefix` | `in`, optional | String prepended to each line of output |
| `memory` | `out`, optional | Available device memory in bytes |

::: info
For OpenMP, which does not provide equivalent runtime queries, this always returns an empty string.
:::

```fortran
use :: fundal
integer        :: dev
character(999) :: prop

dev = dev_get_device_num()
call dev_get_property_string(dev_num=dev, string=prop, prefix='  ')
print '("device properties:",A)', new_line('a')//trim(prop)
```
