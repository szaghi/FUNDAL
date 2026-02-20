---
title: fundal_dev_free
---

# fundal_dev_free

> FUNDAL, memory free routines module.

**Source**: `src/lib/fundal_dev_free.F90`

**Dependencies**

```mermaid
graph LR
  fundal_dev_free["fundal_dev_free"] --> fundal_env["fundal_env"]
  fundal_dev_free["fundal_dev_free"] --> iso_c_binding["iso_c_binding"]
  fundal_dev_free["fundal_dev_free"] --> iso_fortran_env["iso_fortran_env"]
  fundal_dev_free["fundal_dev_free"] --> omp_lib["omp_lib"]
```

## Contents

- [dev_free](#dev-free)
- [free_f](#free-f)
- [dev_free_R8P_1D](#dev-free-r8p-1d)
- [dev_free_R8P_2D](#dev-free-r8p-2d)
- [dev_free_R8P_3D](#dev-free-r8p-3d)
- [dev_free_R8P_4D](#dev-free-r8p-4d)
- [dev_free_R8P_5D](#dev-free-r8p-5d)
- [dev_free_R8P_6D](#dev-free-r8p-6d)
- [dev_free_R8P_7D](#dev-free-r8p-7d)
- [dev_free_R4P_1D](#dev-free-r4p-1d)
- [dev_free_R4P_2D](#dev-free-r4p-2d)
- [dev_free_R4P_3D](#dev-free-r4p-3d)
- [dev_free_R4P_4D](#dev-free-r4p-4d)
- [dev_free_R4P_5D](#dev-free-r4p-5d)
- [dev_free_R4P_6D](#dev-free-r4p-6d)
- [dev_free_R4P_7D](#dev-free-r4p-7d)
- [dev_free_I8P_1D](#dev-free-i8p-1d)
- [dev_free_I8P_2D](#dev-free-i8p-2d)
- [dev_free_I8P_3D](#dev-free-i8p-3d)
- [dev_free_I8P_4D](#dev-free-i8p-4d)
- [dev_free_I8P_5D](#dev-free-i8p-5d)
- [dev_free_I8P_6D](#dev-free-i8p-6d)
- [dev_free_I8P_7D](#dev-free-i8p-7d)
- [dev_free_I4P_1D](#dev-free-i4p-1d)
- [dev_free_I4P_2D](#dev-free-i4p-2d)
- [dev_free_I4P_3D](#dev-free-i4p-3d)
- [dev_free_I4P_4D](#dev-free-i4p-4d)
- [dev_free_I4P_5D](#dev-free-i4p-5d)
- [dev_free_I4P_6D](#dev-free-i4p-6d)
- [dev_free_I4P_7D](#dev-free-i4p-7d)
- [dev_free_I2P_1D](#dev-free-i2p-1d)
- [dev_free_I2P_2D](#dev-free-i2p-2d)
- [dev_free_I2P_3D](#dev-free-i2p-3d)
- [dev_free_I2P_4D](#dev-free-i2p-4d)
- [dev_free_I2P_5D](#dev-free-i2p-5d)
- [dev_free_I2P_6D](#dev-free-i2p-6d)
- [dev_free_I2P_7D](#dev-free-i2p-7d)
- [dev_free_I1P_1D](#dev-free-i1p-1d)
- [dev_free_I1P_2D](#dev-free-i1p-2d)
- [dev_free_I1P_3D](#dev-free-i1p-3d)
- [dev_free_I1P_4D](#dev-free-i1p-4d)
- [dev_free_I1P_5D](#dev-free-i1p-5d)
- [dev_free_I1P_6D](#dev-free-i1p-6d)
- [dev_free_I1P_7D](#dev-free-i1p-7d)

## Interfaces

### dev_free

Free device memory OpenACC backend.

**Module procedures**: [`dev_free_R8P_1D`](/api/src/lib/fundal_dev_free#dev-free-r8p-1d), [`dev_free_R8P_2D`](/api/src/lib/fundal_dev_free#dev-free-r8p-2d), [`dev_free_R8P_3D`](/api/src/lib/fundal_dev_free#dev-free-r8p-3d), [`dev_free_R8P_4D`](/api/src/lib/fundal_dev_free#dev-free-r8p-4d), [`dev_free_R8P_5D`](/api/src/lib/fundal_dev_free#dev-free-r8p-5d), [`dev_free_R8P_6D`](/api/src/lib/fundal_dev_free#dev-free-r8p-6d), [`dev_free_R8P_7D`](/api/src/lib/fundal_dev_free#dev-free-r8p-7d), [`dev_free_R4P_1D`](/api/src/lib/fundal_dev_free#dev-free-r4p-1d), [`dev_free_R4P_2D`](/api/src/lib/fundal_dev_free#dev-free-r4p-2d), [`dev_free_R4P_3D`](/api/src/lib/fundal_dev_free#dev-free-r4p-3d), [`dev_free_R4P_4D`](/api/src/lib/fundal_dev_free#dev-free-r4p-4d), [`dev_free_R4P_5D`](/api/src/lib/fundal_dev_free#dev-free-r4p-5d), [`dev_free_R4P_6D`](/api/src/lib/fundal_dev_free#dev-free-r4p-6d), [`dev_free_R4P_7D`](/api/src/lib/fundal_dev_free#dev-free-r4p-7d), [`dev_free_I8P_1D`](/api/src/lib/fundal_dev_free#dev-free-i8p-1d), [`dev_free_I8P_2D`](/api/src/lib/fundal_dev_free#dev-free-i8p-2d), [`dev_free_I8P_3D`](/api/src/lib/fundal_dev_free#dev-free-i8p-3d), [`dev_free_I8P_4D`](/api/src/lib/fundal_dev_free#dev-free-i8p-4d), [`dev_free_I8P_5D`](/api/src/lib/fundal_dev_free#dev-free-i8p-5d), [`dev_free_I8P_6D`](/api/src/lib/fundal_dev_free#dev-free-i8p-6d), [`dev_free_I8P_7D`](/api/src/lib/fundal_dev_free#dev-free-i8p-7d), [`dev_free_I4P_1D`](/api/src/lib/fundal_dev_free#dev-free-i4p-1d), [`dev_free_I4P_2D`](/api/src/lib/fundal_dev_free#dev-free-i4p-2d), [`dev_free_I4P_3D`](/api/src/lib/fundal_dev_free#dev-free-i4p-3d), [`dev_free_I4P_4D`](/api/src/lib/fundal_dev_free#dev-free-i4p-4d), [`dev_free_I4P_5D`](/api/src/lib/fundal_dev_free#dev-free-i4p-5d), [`dev_free_I4P_6D`](/api/src/lib/fundal_dev_free#dev-free-i4p-6d), [`dev_free_I4P_7D`](/api/src/lib/fundal_dev_free#dev-free-i4p-7d), [`dev_free_I2P_1D`](/api/src/lib/fundal_dev_free#dev-free-i2p-1d), [`dev_free_I2P_2D`](/api/src/lib/fundal_dev_free#dev-free-i2p-2d), [`dev_free_I2P_3D`](/api/src/lib/fundal_dev_free#dev-free-i2p-3d), [`dev_free_I2P_4D`](/api/src/lib/fundal_dev_free#dev-free-i2p-4d), [`dev_free_I2P_5D`](/api/src/lib/fundal_dev_free#dev-free-i2p-5d), [`dev_free_I2P_6D`](/api/src/lib/fundal_dev_free#dev-free-i2p-6d), [`dev_free_I2P_7D`](/api/src/lib/fundal_dev_free#dev-free-i2p-7d), [`dev_free_I1P_1D`](/api/src/lib/fundal_dev_free#dev-free-i1p-1d), [`dev_free_I1P_2D`](/api/src/lib/fundal_dev_free#dev-free-i1p-2d), [`dev_free_I1P_3D`](/api/src/lib/fundal_dev_free#dev-free-i1p-3d), [`dev_free_I1P_4D`](/api/src/lib/fundal_dev_free#dev-free-i1p-4d), [`dev_free_I1P_5D`](/api/src/lib/fundal_dev_free#dev-free-i1p-5d), [`dev_free_I1P_6D`](/api/src/lib/fundal_dev_free#dev-free-i1p-6d), [`dev_free_I1P_7D`](/api/src/lib/fundal_dev_free#dev-free-i1p-7d)

### free_f

## Subroutines

### dev_free_R8P_1D

Free array from device, R8P kind, rank 1.

```fortran
subroutine dev_free_R8P_1D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R8P_1D["dev_free_R8P_1D"] --> free_f["free_f"]
  style dev_free_R8P_1D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_R8P_2D

Free array from device, R8P kind, rank 2.

```fortran
subroutine dev_free_R8P_2D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R8P_2D["dev_free_R8P_2D"] --> free_f["free_f"]
  style dev_free_R8P_2D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_R8P_3D

Free array from device, R8P kind, rank 3.

```fortran
subroutine dev_free_R8P_3D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R8P_3D["dev_free_R8P_3D"] --> free_f["free_f"]
  style dev_free_R8P_3D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_R8P_4D

Free array from device, R8P kind, rank 4.

```fortran
subroutine dev_free_R8P_4D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R8P_4D["dev_free_R8P_4D"] --> free_f["free_f"]
  style dev_free_R8P_4D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_R8P_5D

Free array from device, R8P kind, rank 5.

```fortran
subroutine dev_free_R8P_5D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R8P_5D["dev_free_R8P_5D"] --> free_f["free_f"]
  style dev_free_R8P_5D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_R8P_6D

Free array from device, R8P kind, rank 6.

```fortran
subroutine dev_free_R8P_6D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R8P_6D["dev_free_R8P_6D"] --> free_f["free_f"]
  style dev_free_R8P_6D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_R8P_7D

Free array from device, R8P kind, rank 7.

```fortran
subroutine dev_free_R8P_7D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R8P_7D["dev_free_R8P_7D"] --> free_f["free_f"]
  style dev_free_R8P_7D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_R4P_1D

Free array from device, R4P kind, rank 1.

```fortran
subroutine dev_free_R4P_1D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R4P_1D["dev_free_R4P_1D"] --> free_f["free_f"]
  style dev_free_R4P_1D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_R4P_2D

Free array from device, R4P kind, rank 2.

```fortran
subroutine dev_free_R4P_2D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R4P_2D["dev_free_R4P_2D"] --> free_f["free_f"]
  style dev_free_R4P_2D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_R4P_3D

Free array from device, R4P kind, rank 3.

```fortran
subroutine dev_free_R4P_3D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R4P_3D["dev_free_R4P_3D"] --> free_f["free_f"]
  style dev_free_R4P_3D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_R4P_4D

Free array from device, R4P kind, rank 4.

```fortran
subroutine dev_free_R4P_4D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R4P_4D["dev_free_R4P_4D"] --> free_f["free_f"]
  style dev_free_R4P_4D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_R4P_5D

Free array from device, R4P kind, rank 5.

```fortran
subroutine dev_free_R4P_5D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R4P_5D["dev_free_R4P_5D"] --> free_f["free_f"]
  style dev_free_R4P_5D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_R4P_6D

Free array from device, R4P kind, rank 6.

```fortran
subroutine dev_free_R4P_6D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R4P_6D["dev_free_R4P_6D"] --> free_f["free_f"]
  style dev_free_R4P_6D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_R4P_7D

Free array from device, R4P kind, rank 7.

```fortran
subroutine dev_free_R4P_7D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_R4P_7D["dev_free_R4P_7D"] --> free_f["free_f"]
  style dev_free_R4P_7D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I8P_1D

Free array from device, I8P kind, rank 1.

```fortran
subroutine dev_free_I8P_1D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I8P_1D["dev_free_I8P_1D"] --> free_f["free_f"]
  style dev_free_I8P_1D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I8P_2D

Free array from device, I8P kind, rank 2.

```fortran
subroutine dev_free_I8P_2D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I8P_2D["dev_free_I8P_2D"] --> free_f["free_f"]
  style dev_free_I8P_2D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I8P_3D

Free array from device, I8P kind, rank 3.

```fortran
subroutine dev_free_I8P_3D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I8P_3D["dev_free_I8P_3D"] --> free_f["free_f"]
  style dev_free_I8P_3D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I8P_4D

Free array from device, I8P kind, rank 4.

```fortran
subroutine dev_free_I8P_4D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I8P_4D["dev_free_I8P_4D"] --> free_f["free_f"]
  style dev_free_I8P_4D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I8P_5D

Free array from device, I8P kind, rank 5.

```fortran
subroutine dev_free_I8P_5D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I8P_5D["dev_free_I8P_5D"] --> free_f["free_f"]
  style dev_free_I8P_5D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I8P_6D

Free array from device, I8P kind, rank 6.

```fortran
subroutine dev_free_I8P_6D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I8P_6D["dev_free_I8P_6D"] --> free_f["free_f"]
  style dev_free_I8P_6D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I8P_7D

Free array from device, I8P kind, rank 7.

```fortran
subroutine dev_free_I8P_7D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I8P_7D["dev_free_I8P_7D"] --> free_f["free_f"]
  style dev_free_I8P_7D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I4P_1D

Free array from device, I4P kind, rank 1.

```fortran
subroutine dev_free_I4P_1D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I4P_1D["dev_free_I4P_1D"] --> free_f["free_f"]
  style dev_free_I4P_1D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I4P_2D

Free array from device, I4P kind, rank 2.

```fortran
subroutine dev_free_I4P_2D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I4P_2D["dev_free_I4P_2D"] --> free_f["free_f"]
  style dev_free_I4P_2D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I4P_3D

Free array from device, I4P kind, rank 3.

```fortran
subroutine dev_free_I4P_3D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I4P_3D["dev_free_I4P_3D"] --> free_f["free_f"]
  style dev_free_I4P_3D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I4P_4D

Free array from device, I4P kind, rank 4.

```fortran
subroutine dev_free_I4P_4D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I4P_4D["dev_free_I4P_4D"] --> free_f["free_f"]
  style dev_free_I4P_4D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I4P_5D

Free array from device, I4P kind, rank 5.

```fortran
subroutine dev_free_I4P_5D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I4P_5D["dev_free_I4P_5D"] --> free_f["free_f"]
  style dev_free_I4P_5D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I4P_6D

Free array from device, I4P kind, rank 6.

```fortran
subroutine dev_free_I4P_6D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I4P_6D["dev_free_I4P_6D"] --> free_f["free_f"]
  style dev_free_I4P_6D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I4P_7D

Free array from device, I4P kind, rank 7.

```fortran
subroutine dev_free_I4P_7D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I4P_7D["dev_free_I4P_7D"] --> free_f["free_f"]
  style dev_free_I4P_7D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I2P_1D

Free array from device, I2P kind, rank 1.

```fortran
subroutine dev_free_I2P_1D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I2P_1D["dev_free_I2P_1D"] --> free_f["free_f"]
  style dev_free_I2P_1D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I2P_2D

Free array from device, I2P kind, rank 2.

```fortran
subroutine dev_free_I2P_2D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I2P_2D["dev_free_I2P_2D"] --> free_f["free_f"]
  style dev_free_I2P_2D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I2P_3D

Free array from device, I2P kind, rank 3.

```fortran
subroutine dev_free_I2P_3D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I2P_3D["dev_free_I2P_3D"] --> free_f["free_f"]
  style dev_free_I2P_3D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I2P_4D

Free array from device, I2P kind, rank 4.

```fortran
subroutine dev_free_I2P_4D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I2P_4D["dev_free_I2P_4D"] --> free_f["free_f"]
  style dev_free_I2P_4D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I2P_5D

Free array from device, I2P kind, rank 5.

```fortran
subroutine dev_free_I2P_5D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I2P_5D["dev_free_I2P_5D"] --> free_f["free_f"]
  style dev_free_I2P_5D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I2P_6D

Free array from device, I2P kind, rank 6.

```fortran
subroutine dev_free_I2P_6D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I2P_6D["dev_free_I2P_6D"] --> free_f["free_f"]
  style dev_free_I2P_6D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I2P_7D

Free array from device, I2P kind, rank 7.

```fortran
subroutine dev_free_I2P_7D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I2P_7D["dev_free_I2P_7D"] --> free_f["free_f"]
  style dev_free_I2P_7D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I1P_1D

Free array from device, I1P kind, rank 1.

```fortran
subroutine dev_free_I1P_1D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I1P_1D["dev_free_I1P_1D"] --> free_f["free_f"]
  style dev_free_I1P_1D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I1P_2D

Free array from device, I1P kind, rank 2.

```fortran
subroutine dev_free_I1P_2D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I1P_2D["dev_free_I1P_2D"] --> free_f["free_f"]
  style dev_free_I1P_2D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I1P_3D

Free array from device, I1P kind, rank 3.

```fortran
subroutine dev_free_I1P_3D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I1P_3D["dev_free_I1P_3D"] --> free_f["free_f"]
  style dev_free_I1P_3D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I1P_4D

Free array from device, I1P kind, rank 4.

```fortran
subroutine dev_free_I1P_4D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I1P_4D["dev_free_I1P_4D"] --> free_f["free_f"]
  style dev_free_I1P_4D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I1P_5D

Free array from device, I1P kind, rank 5.

```fortran
subroutine dev_free_I1P_5D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I1P_5D["dev_free_I1P_5D"] --> free_f["free_f"]
  style dev_free_I1P_5D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I1P_6D

Free array from device, I1P kind, rank 6.

```fortran
subroutine dev_free_I1P_6D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I1P_6D["dev_free_I1P_6D"] --> free_f["free_f"]
  style dev_free_I1P_6D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_free_I1P_7D

Free array from device, I1P kind, rank 7.

```fortran
subroutine dev_free_I1P_7D(fptr, dev_id)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout | pointer | Memory device pointer. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |

**Call graph**

```mermaid
flowchart TD
  dev_free_I1P_7D["dev_free_I1P_7D"] --> free_f["free_f"]
  style dev_free_I1P_7D fill:#3e63dd,stroke:#99b,stroke-width:2px
```
