---
title: Errors and constants
---

# Errors and constants

## Error codes

Returned in `ierr`; 0 is success. The codes 101 to 104 are exported named constants: compare with the name.

| Code | Constant | Returned by | Meaning |
|---:|---|---|---|
| 101 | `FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED` | `dev_alloc`, `dev_alloc_replace`, `dev_assign_to_device` | The runtime returned no device memory (out of memory, no device context); the pointer is null |
| 102 | `FUNDAL_ERR_NO_DEVICE` | `dev_init` | No device available and the host fallback is forbidden (`require_device`, `ACC_DEVICE_TYPE`, `OMP_TARGET_OFFLOAD=MANDATORY`) |
| 103 | `FUNDAL_ERR_NOT_REGISTERED` | `dev_free`; `dev_alloc_replace` and `dev_assign_to_device` under policy `error` | The pointer is not a live FUNDAL allocation: freed already (double free, alias), a section, or from elsewhere; nothing is freed |
| 104 | `FUNDAL_ERR_DEV_ID_MISMATCH` | `dev_free` | `dev_id` differs from the device where the buffer lives; nothing is freed |
| 1 | (no constant) | `dev_set_registry_policy` | Policy name not valid; the policy is unchanged |

```fortran
use fundal, only : dev_free, FUNDAL_ERR_NOT_REGISTERED
```

### dev_error_message {#dev-error-message}

```fortran
pure function dev_error_message(ierr) result(msg)   ! signature
integer(I4P), intent(in)  :: ierr
character(:), allocatable :: msg
```

Returns the description of an error code: `'no error'` for 0, a sentence for 101 to 104,
`'unknown FUNDAL error code <n>'` otherwise. Use it to report an `ierr` instead of a bare number, e.g.
`print '(A)', 'dev_free: '//dev_error_message(ierr)` after a call that returned a non-zero `ierr`.

## Stops and messages

Without `ierr`, some errors stop the program. Messages go to standard error.

| Situation | Message | Stop |
|---|---|---|
| `dev_init` without `ierr`, device required, none available | `FUNDAL error: no device available and host fallback forbidden (<reason>)` | `error stop 'FUNDAL: no device available'` |
| `dev_init`, host fallback not requested | `FUNDAL warning: no device available, running on the host (host fallback); ...` | none |
| `dev_free` without `ierr`, misuse, policy `error` | `FUNDAL error: dev_free: ...` | `error stop 'FUNDAL: allocation registry misuse'` |
| `dev_free` without `ierr`, misuse, policy `warn` | `FUNDAL warning: dev_free: ..., freed as before the allocation registry` (or `..., freed there`) | none |
| `dev_alloc` on OpenACC with a `dev_id` that is not the current device | `FUNDAL warning: dev_alloc: dev_id=... is not used by the OpenACC backend, ...` | none |
| `dev_assign_to_device` without `ierr`, `dst` not reallocated | `FUNDAL error: dev_assign_to_device: <dev_error_message of the code>`: 101 (allocation failed) or, under policy `error`, 103 (`dst` not allocated by FUNDAL: nothing freed, nothing allocated) | `error stop 'FUNDAL: dev_assign_to_device failed'` |
| `mpih_object%error_stop` | `<myrankstr>error stop <msg>` | `MPI_Finalize`, `stop 1` |
| `mpih_object%abort` | `<myrankstr>abort <msg>` | `MPI_Abort` |

## Registry policies

| Constant | Value | Policy name |
|---|---:|---|
| `FUNDAL_REGISTRY_OFF` | 0 | `'off'` |
| `FUNDAL_REGISTRY_WARN` | 1 | `'warn'` (default) |
| `FUNDAL_REGISTRY_ERROR` | 2 | `'error'` |

Set the policy by name with [`dev_set_registry_policy`](./registry#dev-set-registry-policy) or `FUNDAL_REGISTRY`.

## Device types

| Constant | Value | Meaning |
|---|---:|---|
| `FUNDAL_DEVICE_HOST` | 0 | Returned by `dev_get_device_type` on OpenMP when there is no offload device (and the value of the CPU mode) |
| `FUNDAL_DEVICE_GPU` | 1 | Returned by `dev_get_device_type` on OpenMP when the default device is an offload device |

On OpenACC `dev_get_device_type` returns the OpenACC device types (`acc_device_host`, `acc_device_nvidia`, ...) of the
`openacc` module, not these constants.
