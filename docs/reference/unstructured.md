---
title: Unstructured memory
---

# Unstructured memory

A host array with a copy on the device. Every procedure is generic over the kinds `R8P`, `R4P`, `I8P`, `I4P`, `I2P`,
`I1P` and the ranks 1 to 7 (rank 1 shown). The array is passed as an assumed-shape dummy: any contiguous host array
works, typically an `allocatable`, and it must stay allocated while it is mapped.

[[toc]]

## dev_alloc_unstr {#dev-alloc-unstr}

```fortran
subroutine dev_alloc_unstr(fptr_dev, init_value)
VARTYPE(KKP), intent(inout)        :: fptr_dev(:)
VARTYPE(KKP), intent(in), optional :: init_value
```

| Argument | Intent | Description |
|---|---|---|
| `fptr_dev` | inout | Host array to map: a device copy is created (OpenACC `enter data create`, OpenMP `target enter data map(alloc:)`) |
| `init_value` | in, optional | Value given to every element of the **device** copy, by a kernel; the host copy is unchanged |

Without `init_value` the device copy is undefined: copy the host values with
[`dev_memcpy_to_device_unstr`](#dev-memcpy-to-device-unstr).

## dev_free_unstr {#dev-free-unstr}

```fortran
subroutine dev_free_unstr(fptr)
VARTYPE(KKP), intent(inout) :: fptr(:)
```

| Argument | Intent | Description |
|---|---|---|
| `fptr` | inout | Mapped host array: its device copy is deleted (OpenACC `exit data delete`, OpenMP `target exit data map(delete:)`); the host array is unchanged |

## dev_memcpy_to_device_unstr {#dev-memcpy-to-device-unstr}

```fortran
subroutine dev_memcpy_to_device_unstr(dst)
VARTYPE(KKP), intent(inout) :: dst(:)
```

| Argument | Intent | Description |
|---|---|---|
| `dst` | inout | Mapped host array: its host values are copied to its device copy (`update device`, `target update to`) |

## dev_memcpy_from_device_unstr {#dev-memcpy-from-device-unstr}

```fortran
subroutine dev_memcpy_from_device_unstr(dst)
VARTYPE(KKP), intent(inout) :: dst(:)
```

| Argument | Intent | Description |
|---|---|---|
| `dst` | inout | Mapped host array: its device values are copied to the host (`update self`, `target update from`) |

## Rules

- In kernels, name the host array: OpenACC with `present(a)`, OpenMP without a clause (the array is already mapped).
  Do not use `DEVICEVAR`/`DEVICEPTR`, which are for structured pointers.
- The two copies are independent until a `dev_memcpy_*_unstr`; in a host run (fallback, CPU mode) they are the same
  memory, which hides a missing copy.
- To pass the **device address** of a mapped array to a library (a GPU-aware MPI, cuBLAS), use
  `!$acc host_data use_device(a)` or `!$omp target data use_device_addr(a)` around the call.
- Unstructured mappings are not in the [allocation registry](./registry): the runtime present table tracks them.

<<< @/examples/snippets/heat_5-map.F90{fortran}

<<< @/examples/snippets/heat_5-unmap.F90{fortran}
