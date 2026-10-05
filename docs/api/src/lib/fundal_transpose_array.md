---
title: fundal_transpose_array
---

# fundal_transpose_array

> FUNDAL, transpose array library.

**Source**: `src/lib/fundal_transpose_array.F90`

**Dependencies**

```mermaid
graph LR
  fundal_transpose_array["fundal_transpose_array"] --> iso_fortran_env["iso_fortran_env"]
```

## Contents

- [transpose_array_alloc](#transpose-array-alloc)
- [transpose_array](#transpose-array)
- [transpose_array_alloc_R8P_2D](#transpose-array-alloc-r8p-2d)
- [transpose_array_R8P_2D](#transpose-array-r8p-2d)
- [transpose_array_alloc_R8P_3D](#transpose-array-alloc-r8p-3d)
- [transpose_array_R8P_3D](#transpose-array-r8p-3d)
- [transpose_array_alloc_R8P_4D](#transpose-array-alloc-r8p-4d)
- [transpose_array_R8P_4D](#transpose-array-r8p-4d)
- [transpose_array_alloc_R8P_5D](#transpose-array-alloc-r8p-5d)
- [transpose_array_R8P_5D](#transpose-array-r8p-5d)
- [transpose_array_alloc_R8P_6D](#transpose-array-alloc-r8p-6d)
- [transpose_array_R8P_6D](#transpose-array-r8p-6d)
- [transpose_array_alloc_R8P_7D](#transpose-array-alloc-r8p-7d)
- [transpose_array_R8P_7D](#transpose-array-r8p-7d)
- [transpose_array_alloc_R4P_2D](#transpose-array-alloc-r4p-2d)
- [transpose_array_R4P_2D](#transpose-array-r4p-2d)
- [transpose_array_alloc_R4P_3D](#transpose-array-alloc-r4p-3d)
- [transpose_array_R4P_3D](#transpose-array-r4p-3d)
- [transpose_array_alloc_R4P_4D](#transpose-array-alloc-r4p-4d)
- [transpose_array_R4P_4D](#transpose-array-r4p-4d)
- [transpose_array_alloc_R4P_5D](#transpose-array-alloc-r4p-5d)
- [transpose_array_R4P_5D](#transpose-array-r4p-5d)
- [transpose_array_alloc_R4P_6D](#transpose-array-alloc-r4p-6d)
- [transpose_array_R4P_6D](#transpose-array-r4p-6d)
- [transpose_array_alloc_R4P_7D](#transpose-array-alloc-r4p-7d)
- [transpose_array_R4P_7D](#transpose-array-r4p-7d)
- [transpose_array_alloc_I8P_2D](#transpose-array-alloc-i8p-2d)
- [transpose_array_I8P_2D](#transpose-array-i8p-2d)
- [transpose_array_alloc_I8P_3D](#transpose-array-alloc-i8p-3d)
- [transpose_array_I8P_3D](#transpose-array-i8p-3d)
- [transpose_array_alloc_I8P_4D](#transpose-array-alloc-i8p-4d)
- [transpose_array_I8P_4D](#transpose-array-i8p-4d)
- [transpose_array_alloc_I8P_5D](#transpose-array-alloc-i8p-5d)
- [transpose_array_I8P_5D](#transpose-array-i8p-5d)
- [transpose_array_alloc_I8P_6D](#transpose-array-alloc-i8p-6d)
- [transpose_array_I8P_6D](#transpose-array-i8p-6d)
- [transpose_array_alloc_I8P_7D](#transpose-array-alloc-i8p-7d)
- [transpose_array_I8P_7D](#transpose-array-i8p-7d)
- [transpose_array_alloc_I4P_2D](#transpose-array-alloc-i4p-2d)
- [transpose_array_I4P_2D](#transpose-array-i4p-2d)
- [transpose_array_alloc_I4P_3D](#transpose-array-alloc-i4p-3d)
- [transpose_array_I4P_3D](#transpose-array-i4p-3d)
- [transpose_array_alloc_I4P_4D](#transpose-array-alloc-i4p-4d)
- [transpose_array_I4P_4D](#transpose-array-i4p-4d)
- [transpose_array_alloc_I4P_5D](#transpose-array-alloc-i4p-5d)
- [transpose_array_I4P_5D](#transpose-array-i4p-5d)
- [transpose_array_alloc_I4P_6D](#transpose-array-alloc-i4p-6d)
- [transpose_array_I4P_6D](#transpose-array-i4p-6d)
- [transpose_array_alloc_I4P_7D](#transpose-array-alloc-i4p-7d)
- [transpose_array_I4P_7D](#transpose-array-i4p-7d)
- [transpose_array_alloc_I2P_2D](#transpose-array-alloc-i2p-2d)
- [transpose_array_I2P_2D](#transpose-array-i2p-2d)
- [transpose_array_alloc_I2P_3D](#transpose-array-alloc-i2p-3d)
- [transpose_array_I2P_3D](#transpose-array-i2p-3d)
- [transpose_array_alloc_I2P_4D](#transpose-array-alloc-i2p-4d)
- [transpose_array_I2P_4D](#transpose-array-i2p-4d)
- [transpose_array_alloc_I2P_5D](#transpose-array-alloc-i2p-5d)
- [transpose_array_I2P_5D](#transpose-array-i2p-5d)
- [transpose_array_alloc_I2P_6D](#transpose-array-alloc-i2p-6d)
- [transpose_array_I2P_6D](#transpose-array-i2p-6d)
- [transpose_array_alloc_I2P_7D](#transpose-array-alloc-i2p-7d)
- [transpose_array_I2P_7D](#transpose-array-i2p-7d)
- [transpose_array_alloc_I1P_2D](#transpose-array-alloc-i1p-2d)
- [transpose_array_I1P_2D](#transpose-array-i1p-2d)
- [transpose_array_alloc_I1P_3D](#transpose-array-alloc-i1p-3d)
- [transpose_array_I1P_3D](#transpose-array-i1p-3d)
- [transpose_array_alloc_I1P_4D](#transpose-array-alloc-i1p-4d)
- [transpose_array_I1P_4D](#transpose-array-i1p-4d)
- [transpose_array_alloc_I1P_5D](#transpose-array-alloc-i1p-5d)
- [transpose_array_I1P_5D](#transpose-array-i1p-5d)
- [transpose_array_alloc_I1P_6D](#transpose-array-alloc-i1p-6d)
- [transpose_array_I1P_6D](#transpose-array-i1p-6d)
- [transpose_array_alloc_I1P_7D](#transpose-array-alloc-i1p-7d)
- [transpose_array_I1P_7D](#transpose-array-i1p-7d)

## Interfaces

### transpose_array_alloc

Transpose array.

**Module procedures**: [`transpose_array_alloc_R8P_2D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-r8p-2d), [`transpose_array_alloc_R8P_3D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-r8p-3d), [`transpose_array_alloc_R8P_4D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-r8p-4d), [`transpose_array_alloc_R8P_5D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-r8p-5d), [`transpose_array_alloc_R8P_6D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-r8p-6d), [`transpose_array_alloc_R8P_7D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-r8p-7d), [`transpose_array_alloc_R4P_2D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-r4p-2d), [`transpose_array_alloc_R4P_3D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-r4p-3d), [`transpose_array_alloc_R4P_4D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-r4p-4d), [`transpose_array_alloc_R4P_5D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-r4p-5d), [`transpose_array_alloc_R4P_6D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-r4p-6d), [`transpose_array_alloc_R4P_7D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-r4p-7d), [`transpose_array_alloc_I8P_2D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i8p-2d), [`transpose_array_alloc_I8P_3D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i8p-3d), [`transpose_array_alloc_I8P_4D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i8p-4d), [`transpose_array_alloc_I8P_5D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i8p-5d), [`transpose_array_alloc_I8P_6D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i8p-6d), [`transpose_array_alloc_I8P_7D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i8p-7d), [`transpose_array_alloc_I4P_2D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i4p-2d), [`transpose_array_alloc_I4P_3D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i4p-3d), [`transpose_array_alloc_I4P_4D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i4p-4d), [`transpose_array_alloc_I4P_5D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i4p-5d), [`transpose_array_alloc_I4P_6D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i4p-6d), [`transpose_array_alloc_I4P_7D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i4p-7d), [`transpose_array_alloc_I2P_2D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i2p-2d), [`transpose_array_alloc_I2P_3D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i2p-3d), [`transpose_array_alloc_I2P_4D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i2p-4d), [`transpose_array_alloc_I2P_5D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i2p-5d), [`transpose_array_alloc_I2P_6D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i2p-6d), [`transpose_array_alloc_I2P_7D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i2p-7d), [`transpose_array_alloc_I1P_2D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i1p-2d), [`transpose_array_alloc_I1P_3D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i1p-3d), [`transpose_array_alloc_I1P_4D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i1p-4d), [`transpose_array_alloc_I1P_5D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i1p-5d), [`transpose_array_alloc_I1P_6D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i1p-6d), [`transpose_array_alloc_I1P_7D`](/api/src/lib/fundal_transpose_array#transpose-array-alloc-i1p-7d)

### transpose_array

Transpose array (no allocation, caller supplies pre-allocated output).

**Module procedures**: [`transpose_array_R8P_2D`](/api/src/lib/fundal_transpose_array#transpose-array-r8p-2d), [`transpose_array_R8P_3D`](/api/src/lib/fundal_transpose_array#transpose-array-r8p-3d), [`transpose_array_R8P_4D`](/api/src/lib/fundal_transpose_array#transpose-array-r8p-4d), [`transpose_array_R8P_5D`](/api/src/lib/fundal_transpose_array#transpose-array-r8p-5d), [`transpose_array_R8P_6D`](/api/src/lib/fundal_transpose_array#transpose-array-r8p-6d), [`transpose_array_R8P_7D`](/api/src/lib/fundal_transpose_array#transpose-array-r8p-7d), [`transpose_array_R4P_2D`](/api/src/lib/fundal_transpose_array#transpose-array-r4p-2d), [`transpose_array_R4P_3D`](/api/src/lib/fundal_transpose_array#transpose-array-r4p-3d), [`transpose_array_R4P_4D`](/api/src/lib/fundal_transpose_array#transpose-array-r4p-4d), [`transpose_array_R4P_5D`](/api/src/lib/fundal_transpose_array#transpose-array-r4p-5d), [`transpose_array_R4P_6D`](/api/src/lib/fundal_transpose_array#transpose-array-r4p-6d), [`transpose_array_R4P_7D`](/api/src/lib/fundal_transpose_array#transpose-array-r4p-7d), [`transpose_array_I8P_2D`](/api/src/lib/fundal_transpose_array#transpose-array-i8p-2d), [`transpose_array_I8P_3D`](/api/src/lib/fundal_transpose_array#transpose-array-i8p-3d), [`transpose_array_I8P_4D`](/api/src/lib/fundal_transpose_array#transpose-array-i8p-4d), [`transpose_array_I8P_5D`](/api/src/lib/fundal_transpose_array#transpose-array-i8p-5d), [`transpose_array_I8P_6D`](/api/src/lib/fundal_transpose_array#transpose-array-i8p-6d), [`transpose_array_I8P_7D`](/api/src/lib/fundal_transpose_array#transpose-array-i8p-7d), [`transpose_array_I4P_2D`](/api/src/lib/fundal_transpose_array#transpose-array-i4p-2d), [`transpose_array_I4P_3D`](/api/src/lib/fundal_transpose_array#transpose-array-i4p-3d), [`transpose_array_I4P_4D`](/api/src/lib/fundal_transpose_array#transpose-array-i4p-4d), [`transpose_array_I4P_5D`](/api/src/lib/fundal_transpose_array#transpose-array-i4p-5d), [`transpose_array_I4P_6D`](/api/src/lib/fundal_transpose_array#transpose-array-i4p-6d), [`transpose_array_I4P_7D`](/api/src/lib/fundal_transpose_array#transpose-array-i4p-7d), [`transpose_array_I2P_2D`](/api/src/lib/fundal_transpose_array#transpose-array-i2p-2d), [`transpose_array_I2P_3D`](/api/src/lib/fundal_transpose_array#transpose-array-i2p-3d), [`transpose_array_I2P_4D`](/api/src/lib/fundal_transpose_array#transpose-array-i2p-4d), [`transpose_array_I2P_5D`](/api/src/lib/fundal_transpose_array#transpose-array-i2p-5d), [`transpose_array_I2P_6D`](/api/src/lib/fundal_transpose_array#transpose-array-i2p-6d), [`transpose_array_I2P_7D`](/api/src/lib/fundal_transpose_array#transpose-array-i2p-7d), [`transpose_array_I1P_2D`](/api/src/lib/fundal_transpose_array#transpose-array-i1p-2d), [`transpose_array_I1P_3D`](/api/src/lib/fundal_transpose_array#transpose-array-i1p-3d), [`transpose_array_I1P_4D`](/api/src/lib/fundal_transpose_array#transpose-array-i1p-4d), [`transpose_array_I1P_5D`](/api/src/lib/fundal_transpose_array#transpose-array-i1p-5d), [`transpose_array_I1P_6D`](/api/src/lib/fundal_transpose_array#transpose-array-i1p-6d), [`transpose_array_I1P_7D`](/api/src/lib/fundal_transpose_array#transpose-array-i1p-7d)

## Subroutines

### transpose_array_alloc_R8P_2D

Transpose array (kind R8P, rank 2).

```fortran
subroutine transpose_array_alloc_R8P_2D(bb, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `a` | real(kind=R8P) | in |  | Input array. |
| `t` | real(kind=R8P) | out | allocatable | Transposed array. |

### transpose_array_R8P_2D

Transpose array (kind R8P, rank 2).
 Unlike transpose_array_alloc_R8P_2D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_R8P_2D(bb, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `a` | real(kind=R8P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | real(kind=R8P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_R8P_3D

Transpose array (kind R8P, rank 3), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_R8P_3D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R8P) | in |  | Input array. |
| `t` | real(kind=R8P) | out | allocatable | Transposed array. |

### transpose_array_R8P_3D

Transpose array (kind R8P, rank 3), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_R8P_3D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_R8P_3D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R8P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | real(kind=R8P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_R8P_4D

Transpose array (kind R8P, rank 4), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_R8P_4D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R8P) | in |  | Input array. |
| `t` | real(kind=R8P) | out | allocatable | Transposed array. |

### transpose_array_R8P_4D

Transpose array (kind R8P, rank 4), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_R8P_4D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_R8P_4D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R8P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | real(kind=R8P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_R8P_5D

Transpose array (kind R8P, rank 5), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_R8P_5D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R8P) | in |  | Input array. |
| `t` | real(kind=R8P) | out | allocatable | Transposed array. |

### transpose_array_R8P_5D

Transpose array (kind R8P, rank 5), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_R8P_5D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_R8P_5D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R8P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | real(kind=R8P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_R8P_6D

Transpose array (kind R8P, rank 6), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_R8P_6D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R8P) | in |  | Input array. |
| `t` | real(kind=R8P) | out | allocatable | Transposed array. |

### transpose_array_R8P_6D

Transpose array (kind R8P, rank 6), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_R8P_6D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_R8P_6D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R8P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | real(kind=R8P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_R8P_7D

Transpose array (kind R8P, rank 7), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_R8P_7D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R8P) | in |  | Input array. |
| `t` | real(kind=R8P) | out | allocatable | Transposed array. |

### transpose_array_R8P_7D

Transpose array (kind R8P, rank 7), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_R8P_7D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_R8P_7D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R8P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | real(kind=R8P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_R4P_2D

Transpose array (kind R4P, rank 2).

```fortran
subroutine transpose_array_alloc_R4P_2D(bb, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `a` | real(kind=R4P) | in |  | Input array. |
| `t` | real(kind=R4P) | out | allocatable | Transposed array. |

### transpose_array_R4P_2D

Transpose array (kind R4P, rank 2).
 Unlike transpose_array_alloc_R4P_2D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_R4P_2D(bb, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `a` | real(kind=R4P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | real(kind=R4P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_R4P_3D

Transpose array (kind R4P, rank 3), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_R4P_3D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R4P) | in |  | Input array. |
| `t` | real(kind=R4P) | out | allocatable | Transposed array. |

### transpose_array_R4P_3D

Transpose array (kind R4P, rank 3), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_R4P_3D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_R4P_3D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R4P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | real(kind=R4P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_R4P_4D

Transpose array (kind R4P, rank 4), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_R4P_4D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R4P) | in |  | Input array. |
| `t` | real(kind=R4P) | out | allocatable | Transposed array. |

### transpose_array_R4P_4D

Transpose array (kind R4P, rank 4), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_R4P_4D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_R4P_4D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R4P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | real(kind=R4P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_R4P_5D

Transpose array (kind R4P, rank 5), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_R4P_5D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R4P) | in |  | Input array. |
| `t` | real(kind=R4P) | out | allocatable | Transposed array. |

### transpose_array_R4P_5D

Transpose array (kind R4P, rank 5), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_R4P_5D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_R4P_5D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R4P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | real(kind=R4P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_R4P_6D

Transpose array (kind R4P, rank 6), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_R4P_6D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R4P) | in |  | Input array. |
| `t` | real(kind=R4P) | out | allocatable | Transposed array. |

### transpose_array_R4P_6D

Transpose array (kind R4P, rank 6), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_R4P_6D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_R4P_6D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R4P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | real(kind=R4P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_R4P_7D

Transpose array (kind R4P, rank 7), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_R4P_7D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R4P) | in |  | Input array. |
| `t` | real(kind=R4P) | out | allocatable | Transposed array. |

### transpose_array_R4P_7D

Transpose array (kind R4P, rank 7), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_R4P_7D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_R4P_7D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | real(kind=R4P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | real(kind=R4P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I8P_2D

Transpose array (kind I8P, rank 2).

```fortran
subroutine transpose_array_alloc_I8P_2D(bb, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `a` | integer(kind=I8P) | in |  | Input array. |
| `t` | integer(kind=I8P) | out | allocatable | Transposed array. |

### transpose_array_I8P_2D

Transpose array (kind I8P, rank 2).
 Unlike transpose_array_alloc_I8P_2D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I8P_2D(bb, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `a` | integer(kind=I8P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I8P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I8P_3D

Transpose array (kind I8P, rank 3), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I8P_3D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I8P) | in |  | Input array. |
| `t` | integer(kind=I8P) | out | allocatable | Transposed array. |

### transpose_array_I8P_3D

Transpose array (kind I8P, rank 3), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I8P_3D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I8P_3D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I8P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I8P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I8P_4D

Transpose array (kind I8P, rank 4), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I8P_4D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I8P) | in |  | Input array. |
| `t` | integer(kind=I8P) | out | allocatable | Transposed array. |

### transpose_array_I8P_4D

Transpose array (kind I8P, rank 4), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I8P_4D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I8P_4D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I8P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I8P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I8P_5D

Transpose array (kind I8P, rank 5), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I8P_5D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I8P) | in |  | Input array. |
| `t` | integer(kind=I8P) | out | allocatable | Transposed array. |

### transpose_array_I8P_5D

Transpose array (kind I8P, rank 5), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I8P_5D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I8P_5D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I8P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I8P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I8P_6D

Transpose array (kind I8P, rank 6), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I8P_6D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I8P) | in |  | Input array. |
| `t` | integer(kind=I8P) | out | allocatable | Transposed array. |

### transpose_array_I8P_6D

Transpose array (kind I8P, rank 6), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I8P_6D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I8P_6D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I8P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I8P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I8P_7D

Transpose array (kind I8P, rank 7), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I8P_7D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I8P) | in |  | Input array. |
| `t` | integer(kind=I8P) | out | allocatable | Transposed array. |

### transpose_array_I8P_7D

Transpose array (kind I8P, rank 7), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I8P_7D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I8P_7D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I8P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I8P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I4P_2D

Transpose array (kind I4P, rank 2).

```fortran
subroutine transpose_array_alloc_I4P_2D(bb, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `a` | integer(kind=I4P) | in |  | Input array. |
| `t` | integer(kind=I4P) | out | allocatable | Transposed array. |

### transpose_array_I4P_2D

Transpose array (kind I4P, rank 2).
 Unlike transpose_array_alloc_I4P_2D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I4P_2D(bb, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `a` | integer(kind=I4P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I4P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I4P_3D

Transpose array (kind I4P, rank 3), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I4P_3D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I4P) | in |  | Input array. |
| `t` | integer(kind=I4P) | out | allocatable | Transposed array. |

### transpose_array_I4P_3D

Transpose array (kind I4P, rank 3), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I4P_3D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I4P_3D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I4P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I4P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I4P_4D

Transpose array (kind I4P, rank 4), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I4P_4D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I4P) | in |  | Input array. |
| `t` | integer(kind=I4P) | out | allocatable | Transposed array. |

### transpose_array_I4P_4D

Transpose array (kind I4P, rank 4), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I4P_4D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I4P_4D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I4P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I4P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I4P_5D

Transpose array (kind I4P, rank 5), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I4P_5D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I4P) | in |  | Input array. |
| `t` | integer(kind=I4P) | out | allocatable | Transposed array. |

### transpose_array_I4P_5D

Transpose array (kind I4P, rank 5), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I4P_5D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I4P_5D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I4P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I4P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I4P_6D

Transpose array (kind I4P, rank 6), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I4P_6D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I4P) | in |  | Input array. |
| `t` | integer(kind=I4P) | out | allocatable | Transposed array. |

### transpose_array_I4P_6D

Transpose array (kind I4P, rank 6), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I4P_6D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I4P_6D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I4P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I4P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I4P_7D

Transpose array (kind I4P, rank 7), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I4P_7D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I4P) | in |  | Input array. |
| `t` | integer(kind=I4P) | out | allocatable | Transposed array. |

### transpose_array_I4P_7D

Transpose array (kind I4P, rank 7), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I4P_7D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I4P_7D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I4P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I4P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I2P_2D

Transpose array (kind I2P, rank 2).

```fortran
subroutine transpose_array_alloc_I2P_2D(bb, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `a` | integer(kind=I2P) | in |  | Input array. |
| `t` | integer(kind=I2P) | out | allocatable | Transposed array. |

### transpose_array_I2P_2D

Transpose array (kind I2P, rank 2).
 Unlike transpose_array_alloc_I2P_2D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I2P_2D(bb, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `a` | integer(kind=I2P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I2P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I2P_3D

Transpose array (kind I2P, rank 3), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I2P_3D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I2P) | in |  | Input array. |
| `t` | integer(kind=I2P) | out | allocatable | Transposed array. |

### transpose_array_I2P_3D

Transpose array (kind I2P, rank 3), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I2P_3D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I2P_3D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I2P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I2P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I2P_4D

Transpose array (kind I2P, rank 4), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I2P_4D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I2P) | in |  | Input array. |
| `t` | integer(kind=I2P) | out | allocatable | Transposed array. |

### transpose_array_I2P_4D

Transpose array (kind I2P, rank 4), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I2P_4D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I2P_4D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I2P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I2P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I2P_5D

Transpose array (kind I2P, rank 5), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I2P_5D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I2P) | in |  | Input array. |
| `t` | integer(kind=I2P) | out | allocatable | Transposed array. |

### transpose_array_I2P_5D

Transpose array (kind I2P, rank 5), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I2P_5D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I2P_5D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I2P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I2P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I2P_6D

Transpose array (kind I2P, rank 6), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I2P_6D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I2P) | in |  | Input array. |
| `t` | integer(kind=I2P) | out | allocatable | Transposed array. |

### transpose_array_I2P_6D

Transpose array (kind I2P, rank 6), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I2P_6D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I2P_6D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I2P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I2P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I2P_7D

Transpose array (kind I2P, rank 7), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I2P_7D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I2P) | in |  | Input array. |
| `t` | integer(kind=I2P) | out | allocatable | Transposed array. |

### transpose_array_I2P_7D

Transpose array (kind I2P, rank 7), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I2P_7D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I2P_7D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I2P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I2P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I1P_2D

Transpose array (kind I1P, rank 2).

```fortran
subroutine transpose_array_alloc_I1P_2D(bb, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `a` | integer(kind=I1P) | in |  | Input array. |
| `t` | integer(kind=I1P) | out | allocatable | Transposed array. |

### transpose_array_I1P_2D

Transpose array (kind I1P, rank 2).
 Unlike transpose_array_alloc_I1P_2D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I1P_2D(bb, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `a` | integer(kind=I1P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I1P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I1P_3D

Transpose array (kind I1P, rank 3), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I1P_3D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I1P) | in |  | Input array. |
| `t` | integer(kind=I1P) | out | allocatable | Transposed array. |

### transpose_array_I1P_3D

Transpose array (kind I1P, rank 3), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I1P_3D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I1P_3D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I1P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I1P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I1P_4D

Transpose array (kind I1P, rank 4), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I1P_4D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I1P) | in |  | Input array. |
| `t` | integer(kind=I1P) | out | allocatable | Transposed array. |

### transpose_array_I1P_4D

Transpose array (kind I1P, rank 4), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I1P_4D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I1P_4D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I1P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I1P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I1P_5D

Transpose array (kind I1P, rank 5), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I1P_5D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I1P) | in |  | Input array. |
| `t` | integer(kind=I1P) | out | allocatable | Transposed array. |

### transpose_array_I1P_5D

Transpose array (kind I1P, rank 5), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I1P_5D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I1P_5D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I1P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I1P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I1P_6D

Transpose array (kind I1P, rank 6), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I1P_6D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I1P) | in |  | Input array. |
| `t` | integer(kind=I1P) | out | allocatable | Transposed array. |

### transpose_array_I1P_6D

Transpose array (kind I1P, rank 6), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I1P_6D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I1P_6D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I1P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I1P) | inout |  | Transposed array (pre-allocated). |

### transpose_array_alloc_I1P_7D

Transpose array (kind I1P, rank 7), swapping index positions ij(1) and ij(2).

```fortran
subroutine transpose_array_alloc_I1P_7D(bb, ij, a, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I1P) | in |  | Input array. |
| `t` | integer(kind=I1P) | out | allocatable | Transposed array. |

### transpose_array_I1P_7D

Transpose array (kind I1P, rank 7), swapping index positions ij(1) and ij(2).
 Unlike transpose_array_alloc_I1P_7D, t must be pre-allocated by the caller.

```fortran
subroutine transpose_array_I1P_7D(bb, ij, a, tb, t)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `bb` | integer(kind=I4P) | in |  | Bounds: bb(1,:)=lower, bb(2,:)=upper. |
| `ij` | integer(kind=I4P) | in |  | 1-based index pair to swap. |
| `a` | integer(kind=I1P) | in |  | Input array. |
| `tb` | integer(kind=I4P) | in |  | Bounds of transposed array. |
| `t` | integer(kind=I1P) | inout |  | Transposed array (pre-allocated). |
