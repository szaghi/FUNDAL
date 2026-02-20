---
title: Features
---

# Features

## Memory Management

- **Structured model** — purely device-allocated memory returned as Fortran `pointer` arrays (`dev_alloc`, `dev_free`, `dev_memcpy_*`). Device memory is not mapped to any host memory.
- **Unstructured model** — host `allocatable` arrays mapped onto the device (`dev_alloc_unstr`, `dev_free_unstr`, `dev_memcpy_*_unstr`).
- **Assignment-style copy** — `dev_assign_to_device` / `dev_assign_from_device` deallocate and reallocate automatically on size change, mimicking Fortran's left-hand-side reallocation for allocatables.

## Device Handling

- Query and set the current device ID (`dev_get_device_num`, `dev_set_device_num`)
- Query device type, host ID, number of available devices, and device memory
- Pretty-printed device property string for diagnostics (`dev_get_property_string`)

## MPI Multi-Device

The `fundal_mpih_object` module provides an auxiliary `mpih_object` class for MPI-enabled applications:

- MPI initialisation and finalisation wrappers
- Automatic device assignment per MPI rank
- Barrier, abort, and error-stop helpers
- Tic/toc wall-clock timing utilities
- Global environment variables (`mydev`, `myhos`, `devtype`, etc.) are exposed as pointers on the object for convenience

## Supported Array Types

| Numeric kind | Ranks |
|--------------|-------|
| `real(R8P)` (real64) | 1–7 |
| `real(R4P)` (real32) | 1–7 |
| `integer(I8P)` (int64) | 1–7 |
| `integer(I4P)` (int32) | 1–7 |
| `integer(I2P)` (int16) | 1–7 |
| `integer(I1P)` (int8) | 1–7 |

## Implementation Status

### Device memory handling

| Routine | OpenACC | OpenMP |
|---------|:-------:|:------:|
| `dev_alloc` | ✅ | ✅ |
| `dev_free` | ✅ | ✅ |
| `dev_memcpy_to_device` | ✅ | ✅ |
| `dev_memcpy_from_device` | ✅ | ✅ |
| `dev_assign_to_device` | ✅ | ✅ |
| `dev_assign_from_device` | ✅ | ✅ |
| `dev_alloc_unstr` / `dev_free_unstr` | ✅ | ✅ |
| `dev_memcpy_*_unstr` | ✅ | ✅ |

### Device handling

| Routine | OpenACC | OpenMP |
|---------|:-------:|:------:|
| `dev_get_device_num` | ✅ | ✅ |
| `dev_get_host_num` | ✅ | ✅ |
| `dev_get_num_devices` | ✅ | ✅ |
| `dev_get_device_type` | ✅ | ❌ (returns 0) |
| `dev_get_property_string` | ✅ | ❌ (returns empty string) |

## Compiler Support

| Compiler | Backend | Status |
|----------|---------|--------|
| NVIDIA nvfortran ≥ 12.3 | OpenACC | Fully supported |
| Intel IFX ≥ 2024.0.2 | OpenMP | Fully supported |
| GNU gfortran ≥ 13.1 | OpenACC | Partial — compiles, some tests fail |
| AMD Flang | OpenMP | Supported |
