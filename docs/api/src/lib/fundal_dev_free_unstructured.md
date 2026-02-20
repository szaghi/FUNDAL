---
title: fundal_dev_free_unstructured
---

# fundal_dev_free_unstructured

> FUNDAL, memory free routines module, unstructured model.

**Source**: `src/lib/fundal_dev_free_unstructured.F90`

**Dependencies**

```mermaid
graph LR
  fundal_dev_free_unstructured["fundal_dev_free_unstructured"] --> iso_fortran_env["iso_fortran_env"]
```

## Contents

- [dev_free_unstr](#dev-free-unstr)
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

### dev_free_unstr

Free device memory, unstructured model.

**Module procedures**: [`dev_free_R8P_1D`](/api/src/lib/fundal_dev_free#dev-free-r8p-1d), [`dev_free_R8P_2D`](/api/src/lib/fundal_dev_free#dev-free-r8p-2d), [`dev_free_R8P_3D`](/api/src/lib/fundal_dev_free#dev-free-r8p-3d), [`dev_free_R8P_4D`](/api/src/lib/fundal_dev_free#dev-free-r8p-4d), [`dev_free_R8P_5D`](/api/src/lib/fundal_dev_free#dev-free-r8p-5d), [`dev_free_R8P_6D`](/api/src/lib/fundal_dev_free#dev-free-r8p-6d), [`dev_free_R8P_7D`](/api/src/lib/fundal_dev_free#dev-free-r8p-7d), [`dev_free_R4P_1D`](/api/src/lib/fundal_dev_free#dev-free-r4p-1d), [`dev_free_R4P_2D`](/api/src/lib/fundal_dev_free#dev-free-r4p-2d), [`dev_free_R4P_3D`](/api/src/lib/fundal_dev_free#dev-free-r4p-3d), [`dev_free_R4P_4D`](/api/src/lib/fundal_dev_free#dev-free-r4p-4d), [`dev_free_R4P_5D`](/api/src/lib/fundal_dev_free#dev-free-r4p-5d), [`dev_free_R4P_6D`](/api/src/lib/fundal_dev_free#dev-free-r4p-6d), [`dev_free_R4P_7D`](/api/src/lib/fundal_dev_free#dev-free-r4p-7d), [`dev_free_I8P_1D`](/api/src/lib/fundal_dev_free#dev-free-i8p-1d), [`dev_free_I8P_2D`](/api/src/lib/fundal_dev_free#dev-free-i8p-2d), [`dev_free_I8P_3D`](/api/src/lib/fundal_dev_free#dev-free-i8p-3d), [`dev_free_I8P_4D`](/api/src/lib/fundal_dev_free#dev-free-i8p-4d), [`dev_free_I8P_5D`](/api/src/lib/fundal_dev_free#dev-free-i8p-5d), [`dev_free_I8P_6D`](/api/src/lib/fundal_dev_free#dev-free-i8p-6d), [`dev_free_I8P_7D`](/api/src/lib/fundal_dev_free#dev-free-i8p-7d), [`dev_free_I4P_1D`](/api/src/lib/fundal_dev_free#dev-free-i4p-1d), [`dev_free_I4P_2D`](/api/src/lib/fundal_dev_free#dev-free-i4p-2d), [`dev_free_I4P_3D`](/api/src/lib/fundal_dev_free#dev-free-i4p-3d), [`dev_free_I4P_4D`](/api/src/lib/fundal_dev_free#dev-free-i4p-4d), [`dev_free_I4P_5D`](/api/src/lib/fundal_dev_free#dev-free-i4p-5d), [`dev_free_I4P_6D`](/api/src/lib/fundal_dev_free#dev-free-i4p-6d), [`dev_free_I4P_7D`](/api/src/lib/fundal_dev_free#dev-free-i4p-7d), [`dev_free_I2P_1D`](/api/src/lib/fundal_dev_free#dev-free-i2p-1d), [`dev_free_I2P_2D`](/api/src/lib/fundal_dev_free#dev-free-i2p-2d), [`dev_free_I2P_3D`](/api/src/lib/fundal_dev_free#dev-free-i2p-3d), [`dev_free_I2P_4D`](/api/src/lib/fundal_dev_free#dev-free-i2p-4d), [`dev_free_I2P_5D`](/api/src/lib/fundal_dev_free#dev-free-i2p-5d), [`dev_free_I2P_6D`](/api/src/lib/fundal_dev_free#dev-free-i2p-6d), [`dev_free_I2P_7D`](/api/src/lib/fundal_dev_free#dev-free-i2p-7d), [`dev_free_I1P_1D`](/api/src/lib/fundal_dev_free#dev-free-i1p-1d), [`dev_free_I1P_2D`](/api/src/lib/fundal_dev_free#dev-free-i1p-2d), [`dev_free_I1P_3D`](/api/src/lib/fundal_dev_free#dev-free-i1p-3d), [`dev_free_I1P_4D`](/api/src/lib/fundal_dev_free#dev-free-i1p-4d), [`dev_free_I1P_5D`](/api/src/lib/fundal_dev_free#dev-free-i1p-5d), [`dev_free_I1P_6D`](/api/src/lib/fundal_dev_free#dev-free-i1p-6d), [`dev_free_I1P_7D`](/api/src/lib/fundal_dev_free#dev-free-i1p-7d)

## Subroutines

### dev_free_R8P_1D

Free array from device, R8P kind, rank 1.

```fortran
subroutine dev_free_R8P_1D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout |  | Memory device pointer. |

### dev_free_R8P_2D

Free array from device, R8P kind, rank 2.

```fortran
subroutine dev_free_R8P_2D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout |  | Memory device pointer. |

### dev_free_R8P_3D

Free array from device, R8P kind, rank 3.

```fortran
subroutine dev_free_R8P_3D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout |  | Memory device pointer. |

### dev_free_R8P_4D

Free array from device, R8P kind, rank 4.

```fortran
subroutine dev_free_R8P_4D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout |  | Memory device pointer. |

### dev_free_R8P_5D

Free array from device, R8P kind, rank 5.

```fortran
subroutine dev_free_R8P_5D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout |  | Memory device pointer. |

### dev_free_R8P_6D

Free array from device, R8P kind, rank 6.

```fortran
subroutine dev_free_R8P_6D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout |  | Memory device pointer. |

### dev_free_R8P_7D

Free array from device, R8P kind, rank 7.

```fortran
subroutine dev_free_R8P_7D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R8P) | inout |  | Memory device pointer. |

### dev_free_R4P_1D

Free array from device, R4P kind, rank 1.

```fortran
subroutine dev_free_R4P_1D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout |  | Memory device pointer. |

### dev_free_R4P_2D

Free array from device, R4P kind, rank 2.

```fortran
subroutine dev_free_R4P_2D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout |  | Memory device pointer. |

### dev_free_R4P_3D

Free array from device, R4P kind, rank 3.

```fortran
subroutine dev_free_R4P_3D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout |  | Memory device pointer. |

### dev_free_R4P_4D

Free array from device, R4P kind, rank 4.

```fortran
subroutine dev_free_R4P_4D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout |  | Memory device pointer. |

### dev_free_R4P_5D

Free array from device, R4P kind, rank 5.

```fortran
subroutine dev_free_R4P_5D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout |  | Memory device pointer. |

### dev_free_R4P_6D

Free array from device, R4P kind, rank 6.

```fortran
subroutine dev_free_R4P_6D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout |  | Memory device pointer. |

### dev_free_R4P_7D

Free array from device, R4P kind, rank 7.

```fortran
subroutine dev_free_R4P_7D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | real(kind=R4P) | inout |  | Memory device pointer. |

### dev_free_I8P_1D

Free array from device, I8P kind, rank 1.

```fortran
subroutine dev_free_I8P_1D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout |  | Memory device pointer. |

### dev_free_I8P_2D

Free array from device, I8P kind, rank 2.

```fortran
subroutine dev_free_I8P_2D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout |  | Memory device pointer. |

### dev_free_I8P_3D

Free array from device, I8P kind, rank 3.

```fortran
subroutine dev_free_I8P_3D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout |  | Memory device pointer. |

### dev_free_I8P_4D

Free array from device, I8P kind, rank 4.

```fortran
subroutine dev_free_I8P_4D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout |  | Memory device pointer. |

### dev_free_I8P_5D

Free array from device, I8P kind, rank 5.

```fortran
subroutine dev_free_I8P_5D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout |  | Memory device pointer. |

### dev_free_I8P_6D

Free array from device, I8P kind, rank 6.

```fortran
subroutine dev_free_I8P_6D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout |  | Memory device pointer. |

### dev_free_I8P_7D

Free array from device, I8P kind, rank 7.

```fortran
subroutine dev_free_I8P_7D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I8P) | inout |  | Memory device pointer. |

### dev_free_I4P_1D

Free array from device, I4P kind, rank 1.

```fortran
subroutine dev_free_I4P_1D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout |  | Memory device pointer. |

### dev_free_I4P_2D

Free array from device, I4P kind, rank 2.

```fortran
subroutine dev_free_I4P_2D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout |  | Memory device pointer. |

### dev_free_I4P_3D

Free array from device, I4P kind, rank 3.

```fortran
subroutine dev_free_I4P_3D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout |  | Memory device pointer. |

### dev_free_I4P_4D

Free array from device, I4P kind, rank 4.

```fortran
subroutine dev_free_I4P_4D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout |  | Memory device pointer. |

### dev_free_I4P_5D

Free array from device, I4P kind, rank 5.

```fortran
subroutine dev_free_I4P_5D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout |  | Memory device pointer. |

### dev_free_I4P_6D

Free array from device, I4P kind, rank 6.

```fortran
subroutine dev_free_I4P_6D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout |  | Memory device pointer. |

### dev_free_I4P_7D

Free array from device, I4P kind, rank 7.

```fortran
subroutine dev_free_I4P_7D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I4P) | inout |  | Memory device pointer. |

### dev_free_I2P_1D

Free array from device, I2P kind, rank 1.

```fortran
subroutine dev_free_I2P_1D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout |  | Memory device pointer. |

### dev_free_I2P_2D

Free array from device, I2P kind, rank 2.

```fortran
subroutine dev_free_I2P_2D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout |  | Memory device pointer. |

### dev_free_I2P_3D

Free array from device, I2P kind, rank 3.

```fortran
subroutine dev_free_I2P_3D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout |  | Memory device pointer. |

### dev_free_I2P_4D

Free array from device, I2P kind, rank 4.

```fortran
subroutine dev_free_I2P_4D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout |  | Memory device pointer. |

### dev_free_I2P_5D

Free array from device, I2P kind, rank 5.

```fortran
subroutine dev_free_I2P_5D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout |  | Memory device pointer. |

### dev_free_I2P_6D

Free array from device, I2P kind, rank 6.

```fortran
subroutine dev_free_I2P_6D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout |  | Memory device pointer. |

### dev_free_I2P_7D

Free array from device, I2P kind, rank 7.

```fortran
subroutine dev_free_I2P_7D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I2P) | inout |  | Memory device pointer. |

### dev_free_I1P_1D

Free array from device, I1P kind, rank 1.

```fortran
subroutine dev_free_I1P_1D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout |  | Memory device pointer. |

### dev_free_I1P_2D

Free array from device, I1P kind, rank 2.

```fortran
subroutine dev_free_I1P_2D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout |  | Memory device pointer. |

### dev_free_I1P_3D

Free array from device, I1P kind, rank 3.

```fortran
subroutine dev_free_I1P_3D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout |  | Memory device pointer. |

### dev_free_I1P_4D

Free array from device, I1P kind, rank 4.

```fortran
subroutine dev_free_I1P_4D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout |  | Memory device pointer. |

### dev_free_I1P_5D

Free array from device, I1P kind, rank 5.

```fortran
subroutine dev_free_I1P_5D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout |  | Memory device pointer. |

### dev_free_I1P_6D

Free array from device, I1P kind, rank 6.

```fortran
subroutine dev_free_I1P_6D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout |  | Memory device pointer. |

### dev_free_I1P_7D

Free array from device, I1P kind, rank 7.

```fortran
subroutine dev_free_I1P_7D(fptr)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr` | integer(kind=I1P) | inout |  | Memory device pointer. |
