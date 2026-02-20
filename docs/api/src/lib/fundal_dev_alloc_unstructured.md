---
title: fundal_dev_alloc_unstructured
---

# fundal_dev_alloc_unstructured

> FUNDAL, memory allocation routines module, unstructured model.

**Source**: `src/lib/fundal_dev_alloc_unstructured.F90`

**Dependencies**

```mermaid
graph LR
  fundal_dev_alloc_unstructured["fundal_dev_alloc_unstructured"] --> iso_fortran_env["iso_fortran_env"]
```

## Contents

- [dev_alloc_unstr](#dev-alloc-unstr)
- [dev_alloc_R8P_1D](#dev-alloc-r8p-1d)
- [dev_alloc_R8P_2D](#dev-alloc-r8p-2d)
- [dev_alloc_R8P_3D](#dev-alloc-r8p-3d)
- [dev_alloc_R8P_4D](#dev-alloc-r8p-4d)
- [dev_alloc_R8P_5D](#dev-alloc-r8p-5d)
- [dev_alloc_R8P_6D](#dev-alloc-r8p-6d)
- [dev_alloc_R8P_7D](#dev-alloc-r8p-7d)
- [dev_alloc_R4P_1D](#dev-alloc-r4p-1d)
- [dev_alloc_R4P_2D](#dev-alloc-r4p-2d)
- [dev_alloc_R4P_3D](#dev-alloc-r4p-3d)
- [dev_alloc_R4P_4D](#dev-alloc-r4p-4d)
- [dev_alloc_R4P_5D](#dev-alloc-r4p-5d)
- [dev_alloc_R4P_6D](#dev-alloc-r4p-6d)
- [dev_alloc_R4P_7D](#dev-alloc-r4p-7d)
- [dev_alloc_I8P_1D](#dev-alloc-i8p-1d)
- [dev_alloc_I8P_2D](#dev-alloc-i8p-2d)
- [dev_alloc_I8P_3D](#dev-alloc-i8p-3d)
- [dev_alloc_I8P_4D](#dev-alloc-i8p-4d)
- [dev_alloc_I8P_5D](#dev-alloc-i8p-5d)
- [dev_alloc_I8P_6D](#dev-alloc-i8p-6d)
- [dev_alloc_I8P_7D](#dev-alloc-i8p-7d)
- [dev_alloc_I4P_1D](#dev-alloc-i4p-1d)
- [dev_alloc_I4P_2D](#dev-alloc-i4p-2d)
- [dev_alloc_I4P_3D](#dev-alloc-i4p-3d)
- [dev_alloc_I4P_4D](#dev-alloc-i4p-4d)
- [dev_alloc_I4P_5D](#dev-alloc-i4p-5d)
- [dev_alloc_I4P_6D](#dev-alloc-i4p-6d)
- [dev_alloc_I4P_7D](#dev-alloc-i4p-7d)
- [dev_alloc_I2P_1D](#dev-alloc-i2p-1d)
- [dev_alloc_I2P_2D](#dev-alloc-i2p-2d)
- [dev_alloc_I2P_3D](#dev-alloc-i2p-3d)
- [dev_alloc_I2P_4D](#dev-alloc-i2p-4d)
- [dev_alloc_I2P_5D](#dev-alloc-i2p-5d)
- [dev_alloc_I2P_6D](#dev-alloc-i2p-6d)
- [dev_alloc_I2P_7D](#dev-alloc-i2p-7d)
- [dev_alloc_I1P_1D](#dev-alloc-i1p-1d)
- [dev_alloc_I1P_2D](#dev-alloc-i1p-2d)
- [dev_alloc_I1P_3D](#dev-alloc-i1p-3d)
- [dev_alloc_I1P_4D](#dev-alloc-i1p-4d)
- [dev_alloc_I1P_5D](#dev-alloc-i1p-5d)
- [dev_alloc_I1P_6D](#dev-alloc-i1p-6d)
- [dev_alloc_I1P_7D](#dev-alloc-i1p-7d)

## Interfaces

### dev_alloc_unstr

Allocate device memory, unstructured model.

**Module procedures**: [`dev_alloc_R8P_1D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r8p-1d), [`dev_alloc_R8P_2D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r8p-2d), [`dev_alloc_R8P_3D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r8p-3d), [`dev_alloc_R8P_4D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r8p-4d), [`dev_alloc_R8P_5D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r8p-5d), [`dev_alloc_R8P_6D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r8p-6d), [`dev_alloc_R8P_7D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r8p-7d), [`dev_alloc_R4P_1D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r4p-1d), [`dev_alloc_R4P_2D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r4p-2d), [`dev_alloc_R4P_3D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r4p-3d), [`dev_alloc_R4P_4D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r4p-4d), [`dev_alloc_R4P_5D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r4p-5d), [`dev_alloc_R4P_6D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r4p-6d), [`dev_alloc_R4P_7D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-r4p-7d), [`dev_alloc_I8P_1D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i8p-1d), [`dev_alloc_I8P_2D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i8p-2d), [`dev_alloc_I8P_3D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i8p-3d), [`dev_alloc_I8P_4D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i8p-4d), [`dev_alloc_I8P_5D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i8p-5d), [`dev_alloc_I8P_6D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i8p-6d), [`dev_alloc_I8P_7D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i8p-7d), [`dev_alloc_I4P_1D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i4p-1d), [`dev_alloc_I4P_2D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i4p-2d), [`dev_alloc_I4P_3D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i4p-3d), [`dev_alloc_I4P_4D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i4p-4d), [`dev_alloc_I4P_5D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i4p-5d), [`dev_alloc_I4P_6D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i4p-6d), [`dev_alloc_I4P_7D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i4p-7d), [`dev_alloc_I2P_1D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i2p-1d), [`dev_alloc_I2P_2D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i2p-2d), [`dev_alloc_I2P_3D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i2p-3d), [`dev_alloc_I2P_4D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i2p-4d), [`dev_alloc_I2P_5D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i2p-5d), [`dev_alloc_I2P_6D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i2p-6d), [`dev_alloc_I2P_7D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i2p-7d), [`dev_alloc_I1P_1D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i1p-1d), [`dev_alloc_I1P_2D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i1p-2d), [`dev_alloc_I1P_3D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i1p-3d), [`dev_alloc_I1P_4D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i1p-4d), [`dev_alloc_I1P_5D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i1p-5d), [`dev_alloc_I1P_6D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i1p-6d), [`dev_alloc_I1P_7D`](/api/src/lib/fundal_dev_alloc_unstructured#dev-alloc-i1p-7d)

## Subroutines

### dev_alloc_R8P_1D

Allocate array, R8P kind, rank 1.

```fortran
subroutine dev_alloc_R8P_1D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

### dev_alloc_R8P_2D

Allocate array, R8P kind, rank 2.

```fortran
subroutine dev_alloc_R8P_2D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

### dev_alloc_R8P_3D

Allocate array, R8P kind, rank 3.

```fortran
subroutine dev_alloc_R8P_3D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

### dev_alloc_R8P_4D

Allocate array, R8P kind, rank 4.

```fortran
subroutine dev_alloc_R8P_4D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

### dev_alloc_R8P_5D

Allocate array, R8P kind, rank 5.

```fortran
subroutine dev_alloc_R8P_5D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

### dev_alloc_R8P_6D

Allocate array, R8P kind, rank 6.

```fortran
subroutine dev_alloc_R8P_6D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

### dev_alloc_R8P_7D

Allocate array, R8P kind, rank 6.

```fortran
subroutine dev_alloc_R8P_7D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

### dev_alloc_R4P_1D

Allocate array, R4P kind, rank 1.

```fortran
subroutine dev_alloc_R4P_1D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

### dev_alloc_R4P_2D

Allocate array, R4P kind, rank 2.

```fortran
subroutine dev_alloc_R4P_2D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

### dev_alloc_R4P_3D

Allocate array, R4P kind, rank 3.

```fortran
subroutine dev_alloc_R4P_3D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

### dev_alloc_R4P_4D

Allocate array, R4P kind, rank 4.

```fortran
subroutine dev_alloc_R4P_4D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

### dev_alloc_R4P_5D

Allocate array, R4P kind, rank 5.

```fortran
subroutine dev_alloc_R4P_5D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

### dev_alloc_R4P_6D

Allocate array, R4P kind, rank 6.

```fortran
subroutine dev_alloc_R4P_6D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

### dev_alloc_R4P_7D

Allocate array, R4P kind, rank 6.

```fortran
subroutine dev_alloc_R4P_7D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout |  | Pointer to allocated memory. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

### dev_alloc_I8P_1D

Allocate array, I8P kind, rank 1.

```fortran
subroutine dev_alloc_I8P_1D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

### dev_alloc_I8P_2D

Allocate array, I8P kind, rank 2.

```fortran
subroutine dev_alloc_I8P_2D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

### dev_alloc_I8P_3D

Allocate array, I8P kind, rank 3.

```fortran
subroutine dev_alloc_I8P_3D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

### dev_alloc_I8P_4D

Allocate array, I8P kind, rank 4.

```fortran
subroutine dev_alloc_I8P_4D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

### dev_alloc_I8P_5D

Allocate array, I8P kind, rank 5.

```fortran
subroutine dev_alloc_I8P_5D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

### dev_alloc_I8P_6D

Allocate array, I8P kind, rank 6.

```fortran
subroutine dev_alloc_I8P_6D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

### dev_alloc_I8P_7D

Allocate array, I8P kind, rank 6.

```fortran
subroutine dev_alloc_I8P_7D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

### dev_alloc_I4P_1D

Allocate array, I4P kind, rank 1.

```fortran
subroutine dev_alloc_I4P_1D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

### dev_alloc_I4P_2D

Allocate array, I4P kind, rank 2.

```fortran
subroutine dev_alloc_I4P_2D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

### dev_alloc_I4P_3D

Allocate array, I4P kind, rank 3.

```fortran
subroutine dev_alloc_I4P_3D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

### dev_alloc_I4P_4D

Allocate array, I4P kind, rank 4.

```fortran
subroutine dev_alloc_I4P_4D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

### dev_alloc_I4P_5D

Allocate array, I4P kind, rank 5.

```fortran
subroutine dev_alloc_I4P_5D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

### dev_alloc_I4P_6D

Allocate array, I4P kind, rank 6.

```fortran
subroutine dev_alloc_I4P_6D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

### dev_alloc_I4P_7D

Allocate array, I4P kind, rank 6.

```fortran
subroutine dev_alloc_I4P_7D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

### dev_alloc_I2P_1D

Allocate array, I2P kind, rank 1.

```fortran
subroutine dev_alloc_I2P_1D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

### dev_alloc_I2P_2D

Allocate array, I2P kind, rank 2.

```fortran
subroutine dev_alloc_I2P_2D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

### dev_alloc_I2P_3D

Allocate array, I2P kind, rank 3.

```fortran
subroutine dev_alloc_I2P_3D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

### dev_alloc_I2P_4D

Allocate array, I2P kind, rank 4.

```fortran
subroutine dev_alloc_I2P_4D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

### dev_alloc_I2P_5D

Allocate array, I2P kind, rank 5.

```fortran
subroutine dev_alloc_I2P_5D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

### dev_alloc_I2P_6D

Allocate array, I2P kind, rank 6.

```fortran
subroutine dev_alloc_I2P_6D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

### dev_alloc_I2P_7D

Allocate array, I2P kind, rank 6.

```fortran
subroutine dev_alloc_I2P_7D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

### dev_alloc_I1P_1D

Allocate array, I1P kind, rank 1.

```fortran
subroutine dev_alloc_I1P_1D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |

### dev_alloc_I1P_2D

Allocate array, I1P kind, rank 2.

```fortran
subroutine dev_alloc_I1P_2D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |

### dev_alloc_I1P_3D

Allocate array, I1P kind, rank 3.

```fortran
subroutine dev_alloc_I1P_3D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |

### dev_alloc_I1P_4D

Allocate array, I1P kind, rank 4.

```fortran
subroutine dev_alloc_I1P_4D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |

### dev_alloc_I1P_5D

Allocate array, I1P kind, rank 5.

```fortran
subroutine dev_alloc_I1P_5D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |

### dev_alloc_I1P_6D

Allocate array, I1P kind, rank 6.

```fortran
subroutine dev_alloc_I1P_6D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |

### dev_alloc_I1P_7D

Allocate array, I1P kind, rank 6.

```fortran
subroutine dev_alloc_I1P_7D(fptr_dev, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout |  | Pointer to allocated memory. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |
