---
title: Initialization and devices
---

# Initialization and devices

[[toc]]

## dev_init {#dev-init}

```fortran
subroutine dev_init(local_rank, require_device, ierr)
integer(I4P), intent(in),  optional :: local_rank
logical,      intent(in),  optional :: require_device
integer(I4P), intent(out), optional :: ierr
```

| Argument | Intent | Description |
|---|---|---|
| `local_rank` | in, optional | Rank of the process among those of its node: the device is `mod(local_rank, devs_number)`. Without it: device 0 (OpenACC), the default device (OpenMP). |
| `require_device` | in, optional | `.true.`: a [host fallback](#host-fallback) is an error. Default `.false.` |
| `ierr` | out, optional | 0, or `FUNDAL_ERR_NO_DEVICE` (102) when a device is required and none is available. Without `ierr` that case is an `error stop`. |

Call it once, before allocating; it can be called again (OpenACC is initialized only the first time). What it does:

| | OpenACC | OpenMP | CPU mode |
|---|---|---|---|
| Host fallback when | `acc_get_device_type()` is `acc_device_host` | no device, or the default device is the initial device | never |
| Device required by the environment | `ACC_DEVICE_TYPE` set, not `host`/`multicore` | `OMP_TARGET_OFFLOAD=MANDATORY` | |
| Explicit host request (no warning) | `ACC_DEVICE_TYPE=host` or `multicore` | `OMP_TARGET_OFFLOAD=DISABLED` | |
| Sets | `devtype`, `devs_number`, `mydev`, `myhos`, `dev_memory_avail`, `dev_memory_total` | `devs_number`, `mydev`, `myhos`, `dev_memory_avail`, `dev_memory_total` | nothing |
| Selects the device | `acc_set_device_num(mydev, devtype)` | `omp_set_default_device(mydev)` | |

- When `ierr` returns non-zero, `dev_init` returns at once: the device is not initialized and the globals after
  `devtype` (OpenACC) or `devs_number` (OpenMP) are not set.
- The environment variables are read case-insensitively. `require_device` is ignored in the CPU mode, where `ierr` is
  always 0.
- In an MPI code use [`mpih_object%initialize`](./mpi#initialize), which computes the local rank, or pass it yourself;
  setting `mydev` and calling `dev_set_device_num` by hand skips the fallback detection.

### Host fallback {#host-fallback}

A device build that finds no device runs on the host: "device" memory and kernels are host memory and host loops.
`dev_init` makes it explicit:

| Situation | Effect |
|---|---|
| fallback, nothing required | warning on standard error, once per process; `dev_is_host_fallback()` is `.true.` |
| fallback, host requested by the environment | no warning; `dev_is_host_fallback()` is `.true.` |
| fallback, `require_device=.true.` or a device required by the environment | `ierr = FUNDAL_ERR_NO_DEVICE`, or `error stop` without `ierr` |
| a device is available | nothing; `dev_is_host_fallback()` is `.false.` |

The warning is
`FUNDAL warning: no device available, running on the host (host fallback); pass require_device=.true. to dev_init to forbid it`;
the error, `FUNDAL error: no device available and host fallback forbidden (<reason>)` followed by
`error stop 'FUNDAL: no device available'`.

The fallback is allowed by default so that one build runs on GPU-less machines. Forbid it in production: a node whose
GPUs are not visible runs orders of magnitude slower, and host code that wrongly reads device pointers works on the host.

<<< @/examples/snippets/heat_7-init.F90{fortran}

## dev_is_host_fallback {#dev-is-host-fallback}

```fortran
function dev_is_host_fallback() result(is_fallback)
logical :: is_fallback
```

`.true.` if FUNDAL is built for a device backend and `dev_init` found no device (requested or not). Always `.false.` in
the compile-time CPU mode and before `dev_init`.

## dev_get_num_devices {#dev-get-num-devices}

```fortran
function dev_get_num_devices() result(devices_number)
integer(I4P) :: devices_number
```

The number of devices: `acc_get_num_devices(devtype)` (OpenACC), `omp_get_num_devices()` (OpenMP, non-host devices), 1
(CPU mode). The CPU-mode `dev_init` does not store it: `devs_number` stays 0 there.

## dev_get_device_num {#dev-get-device-num}

```fortran
function dev_get_device_num() result(device_num)
integer(I4P) :: device_num
```

The current device: `acc_get_device_num(devtype)` (OpenACC), `omp_get_default_device()` (OpenMP), 0 (CPU mode).

## dev_set_device_num {#dev-set-device-num}

```fortran
subroutine dev_set_device_num(dev_num)
integer, value, intent(in) :: dev_num
```

| Argument | Intent | Description |
|---|---|---|
| `dev_num` | in, value | Device to make current |

`acc_set_device_num(dev_num, devtype)` (OpenACC), `omp_set_default_device(dev_num)` (OpenMP), nothing (CPU mode);
then `mydev` is set to the current device, `dev_get_device_num()`. Every backend then works on `dev_num`: OpenACC
allocates on the current device, OpenMP allocates and copies on `mydev` by default. In the CPU mode `mydev` stays 0.

## dev_get_host_num {#dev-get-host-num}

```fortran
function dev_get_host_num() result(host_num)
integer(I4P) :: host_num
```

The host device number: `acc_get_device_num(acc_device_host)` (OpenACC), `omp_get_initial_device()` (OpenMP), 0 (CPU
mode).

## dev_get_device_type {#dev-get-device-type}

```fortran
function dev_get_device_type() result(devtype_)
integer(IDK) :: devtype_
```

| Build | Result |
|---|---|
| OpenACC | `acc_get_device_type()`, an `integer(acc_device_kind)` value (`acc_device_host`, `acc_device_nvidia`, ...) |
| OpenMP | `FUNDAL_DEVICE_HOST` (0) without an offload device, else `FUNDAL_DEVICE_GPU` (1) |
| CPU mode | 0 |

`IDK` is `acc_device_kind` on OpenACC and `I4P` otherwise (see [Global variables](./globals)). On OpenACC
`dev_get_device_type` is the OpenACC routine itself, renamed.

## dev_get_device_memory_info {#dev-get-device-memory-info}

```fortran
subroutine dev_get_device_memory_info(mem_free, mem_total)
integer(I8P), intent(out), optional :: mem_free
integer(I8P), intent(out), optional :: mem_total
```

| Argument | Intent | Description |
|---|---|---|
| `mem_free` | out, optional | Free memory of the device `mydev` [bytes] |
| `mem_total` | out, optional | Total memory of the device `mydev` [bytes] |

| Build | Source |
|---|---|
| OpenACC | `acc_get_property(mydev, devtype, acc_property_free_memory / acc_property_memory)` |
| OpenMP with `DEV_HIP` (AMD) | `hipSetDevice(mydev)`, `hipMemGetInfo` |
| OpenMP without `DEV_HIP` (Intel ifx) | 0, 0: OpenMP has no memory query |
| CPU mode | 0, 0 |

Guard against a zero budget if you size problems from it. For leak checks use
[`dev_get_alloc_stats`](./registry#dev-get-alloc-stats), which works on every backend.

## dev_get_property_string {#dev-get-property-string}

```fortran
subroutine dev_get_property_string(dev_num, string, prefix, memory)
integer,      value, intent(in)            :: dev_num
character(*),        intent(out)           :: string
character(*),        intent(in),  optional :: prefix
integer(I8P),        intent(out), optional :: memory
```

| Argument | Intent | Description |
|---|---|---|
| `dev_num` | in, value | Device to describe |
| `string` | out | Description, one property per line, each line starting with `prefix`; truncated if `string` is too short |
| `prefix` | in, optional | Start of every line (default empty) |
| `memory` | out, optional | **Total** memory of the device [bytes] |

| Build | Lines |
|---|---|
| OpenACC | `memory`, `memory free`, `device name`, `vendor`, `driver` |
| OpenMP with `DEV_HIP` | `memory`, `memory free`, `device name`, `compute cap`, `driver` |
| OpenMP without `DEV_HIP`, CPU mode | none: `string` is just `prefix`, `memory` is 0 |

## save_memory_status {#save-memory-status}

```fortran
subroutine save_memory_status(file_name, tag)
character(*), intent(in)           :: file_name
character(*), intent(in), optional :: tag
```

| Argument | Intent | Description |
|---|---|---|
| `file_name` | in | File to append to (created if missing) |
| `tag` | in, optional | Text written before the numbers |

Appends one list-directed line, `tag mem_free mem_total`, from
[`dev_get_device_memory_info`](#dev-get-device-memory-info): zeros where that routine returns zeros.
