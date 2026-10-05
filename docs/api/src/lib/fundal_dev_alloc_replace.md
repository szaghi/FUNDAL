---
title: fundal_dev_alloc_replace
---

# fundal_dev_alloc_replace

> FUNDAL, memory (re)allocation routines module: free-safe allocation of device memory.

**Source**: `src/lib/fundal_dev_alloc_replace.F90`

**Dependencies**

```mermaid
graph LR
  fundal_dev_alloc_replace["fundal_dev_alloc_replace"] --> fundal_dev_alloc["fundal_dev_alloc"]
  fundal_dev_alloc_replace["fundal_dev_alloc_replace"] --> fundal_dev_free["fundal_dev_free"]
  fundal_dev_alloc_replace["fundal_dev_alloc_replace"] --> iso_fortran_env["iso_fortran_env"]
```

## Contents

- [dev_alloc_replace](#dev-alloc-replace)
- [dev_alloc_replace_R8P_1D](#dev-alloc-replace-r8p-1d)
- [dev_alloc_replace_R8P_2D](#dev-alloc-replace-r8p-2d)
- [dev_alloc_replace_R8P_3D](#dev-alloc-replace-r8p-3d)
- [dev_alloc_replace_R8P_4D](#dev-alloc-replace-r8p-4d)
- [dev_alloc_replace_R8P_5D](#dev-alloc-replace-r8p-5d)
- [dev_alloc_replace_R8P_6D](#dev-alloc-replace-r8p-6d)
- [dev_alloc_replace_R8P_7D](#dev-alloc-replace-r8p-7d)
- [dev_alloc_replace_R4P_1D](#dev-alloc-replace-r4p-1d)
- [dev_alloc_replace_R4P_2D](#dev-alloc-replace-r4p-2d)
- [dev_alloc_replace_R4P_3D](#dev-alloc-replace-r4p-3d)
- [dev_alloc_replace_R4P_4D](#dev-alloc-replace-r4p-4d)
- [dev_alloc_replace_R4P_5D](#dev-alloc-replace-r4p-5d)
- [dev_alloc_replace_R4P_6D](#dev-alloc-replace-r4p-6d)
- [dev_alloc_replace_R4P_7D](#dev-alloc-replace-r4p-7d)
- [dev_alloc_replace_I8P_1D](#dev-alloc-replace-i8p-1d)
- [dev_alloc_replace_I8P_2D](#dev-alloc-replace-i8p-2d)
- [dev_alloc_replace_I8P_3D](#dev-alloc-replace-i8p-3d)
- [dev_alloc_replace_I8P_4D](#dev-alloc-replace-i8p-4d)
- [dev_alloc_replace_I8P_5D](#dev-alloc-replace-i8p-5d)
- [dev_alloc_replace_I8P_6D](#dev-alloc-replace-i8p-6d)
- [dev_alloc_replace_I8P_7D](#dev-alloc-replace-i8p-7d)
- [dev_alloc_replace_I4P_1D](#dev-alloc-replace-i4p-1d)
- [dev_alloc_replace_I4P_2D](#dev-alloc-replace-i4p-2d)
- [dev_alloc_replace_I4P_3D](#dev-alloc-replace-i4p-3d)
- [dev_alloc_replace_I4P_4D](#dev-alloc-replace-i4p-4d)
- [dev_alloc_replace_I4P_5D](#dev-alloc-replace-i4p-5d)
- [dev_alloc_replace_I4P_6D](#dev-alloc-replace-i4p-6d)
- [dev_alloc_replace_I4P_7D](#dev-alloc-replace-i4p-7d)
- [dev_alloc_replace_I2P_1D](#dev-alloc-replace-i2p-1d)
- [dev_alloc_replace_I2P_2D](#dev-alloc-replace-i2p-2d)
- [dev_alloc_replace_I2P_3D](#dev-alloc-replace-i2p-3d)
- [dev_alloc_replace_I2P_4D](#dev-alloc-replace-i2p-4d)
- [dev_alloc_replace_I2P_5D](#dev-alloc-replace-i2p-5d)
- [dev_alloc_replace_I2P_6D](#dev-alloc-replace-i2p-6d)
- [dev_alloc_replace_I2P_7D](#dev-alloc-replace-i2p-7d)
- [dev_alloc_replace_I1P_1D](#dev-alloc-replace-i1p-1d)
- [dev_alloc_replace_I1P_2D](#dev-alloc-replace-i1p-2d)
- [dev_alloc_replace_I1P_3D](#dev-alloc-replace-i1p-3d)
- [dev_alloc_replace_I1P_4D](#dev-alloc-replace-i1p-4d)
- [dev_alloc_replace_I1P_5D](#dev-alloc-replace-i1p-5d)
- [dev_alloc_replace_I1P_6D](#dev-alloc-replace-i1p-6d)
- [dev_alloc_replace_I1P_7D](#dev-alloc-replace-i1p-7d)

## Interfaces

### dev_alloc_replace

Allocate device memory, freeing the buffer the pointer is associated with, if any.
 an existing buffer must have been allocated on the same dev_id.

**Module procedures**: [`dev_alloc_replace_R8P_1D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r8p-1d), [`dev_alloc_replace_R8P_2D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r8p-2d), [`dev_alloc_replace_R8P_3D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r8p-3d), [`dev_alloc_replace_R8P_4D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r8p-4d), [`dev_alloc_replace_R8P_5D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r8p-5d), [`dev_alloc_replace_R8P_6D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r8p-6d), [`dev_alloc_replace_R8P_7D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r8p-7d), [`dev_alloc_replace_R4P_1D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r4p-1d), [`dev_alloc_replace_R4P_2D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r4p-2d), [`dev_alloc_replace_R4P_3D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r4p-3d), [`dev_alloc_replace_R4P_4D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r4p-4d), [`dev_alloc_replace_R4P_5D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r4p-5d), [`dev_alloc_replace_R4P_6D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r4p-6d), [`dev_alloc_replace_R4P_7D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-r4p-7d), [`dev_alloc_replace_I8P_1D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i8p-1d), [`dev_alloc_replace_I8P_2D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i8p-2d), [`dev_alloc_replace_I8P_3D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i8p-3d), [`dev_alloc_replace_I8P_4D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i8p-4d), [`dev_alloc_replace_I8P_5D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i8p-5d), [`dev_alloc_replace_I8P_6D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i8p-6d), [`dev_alloc_replace_I8P_7D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i8p-7d), [`dev_alloc_replace_I4P_1D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i4p-1d), [`dev_alloc_replace_I4P_2D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i4p-2d), [`dev_alloc_replace_I4P_3D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i4p-3d), [`dev_alloc_replace_I4P_4D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i4p-4d), [`dev_alloc_replace_I4P_5D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i4p-5d), [`dev_alloc_replace_I4P_6D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i4p-6d), [`dev_alloc_replace_I4P_7D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i4p-7d), [`dev_alloc_replace_I2P_1D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i2p-1d), [`dev_alloc_replace_I2P_2D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i2p-2d), [`dev_alloc_replace_I2P_3D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i2p-3d), [`dev_alloc_replace_I2P_4D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i2p-4d), [`dev_alloc_replace_I2P_5D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i2p-5d), [`dev_alloc_replace_I2P_6D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i2p-6d), [`dev_alloc_replace_I2P_7D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i2p-7d), [`dev_alloc_replace_I1P_1D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i1p-1d), [`dev_alloc_replace_I1P_2D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i1p-2d), [`dev_alloc_replace_I1P_3D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i1p-3d), [`dev_alloc_replace_I1P_4D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i1p-4d), [`dev_alloc_replace_I1P_5D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i1p-5d), [`dev_alloc_replace_I1P_6D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i1p-6d), [`dev_alloc_replace_I1P_7D`](/api/src/lib/fundal_dev_alloc_replace#dev-alloc-replace-i1p-7d)

## Subroutines

### dev_alloc_replace_R8P_1D

Allocate array, R8P kind, rank 1, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R8P_1D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R8P_1D["dev_alloc_replace_R8P_1D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R8P_1D["dev_alloc_replace_R8P_1D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R8P_1D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_R8P_2D

Allocate array, R8P kind, rank 2, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R8P_2D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R8P_2D["dev_alloc_replace_R8P_2D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R8P_2D["dev_alloc_replace_R8P_2D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R8P_2D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_R8P_3D

Allocate array, R8P kind, rank 3, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R8P_3D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R8P_3D["dev_alloc_replace_R8P_3D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R8P_3D["dev_alloc_replace_R8P_3D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R8P_3D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_R8P_4D

Allocate array, R8P kind, rank 4, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R8P_4D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R8P_4D["dev_alloc_replace_R8P_4D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R8P_4D["dev_alloc_replace_R8P_4D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R8P_4D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_R8P_5D

Allocate array, R8P kind, rank 5, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R8P_5D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R8P_5D["dev_alloc_replace_R8P_5D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R8P_5D["dev_alloc_replace_R8P_5D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R8P_5D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_R8P_6D

Allocate array, R8P kind, rank 6, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R8P_6D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R8P_6D["dev_alloc_replace_R8P_6D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R8P_6D["dev_alloc_replace_R8P_6D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R8P_6D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_R8P_7D

Allocate array, R8P kind, rank 7, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R8P_7D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R8P_7D["dev_alloc_replace_R8P_7D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R8P_7D["dev_alloc_replace_R8P_7D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R8P_7D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_R4P_1D

Allocate array, R4P kind, rank 1, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R4P_1D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R4P_1D["dev_alloc_replace_R4P_1D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R4P_1D["dev_alloc_replace_R4P_1D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R4P_1D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_R4P_2D

Allocate array, R4P kind, rank 2, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R4P_2D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R4P_2D["dev_alloc_replace_R4P_2D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R4P_2D["dev_alloc_replace_R4P_2D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R4P_2D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_R4P_3D

Allocate array, R4P kind, rank 3, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R4P_3D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R4P_3D["dev_alloc_replace_R4P_3D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R4P_3D["dev_alloc_replace_R4P_3D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R4P_3D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_R4P_4D

Allocate array, R4P kind, rank 4, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R4P_4D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R4P_4D["dev_alloc_replace_R4P_4D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R4P_4D["dev_alloc_replace_R4P_4D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R4P_4D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_R4P_5D

Allocate array, R4P kind, rank 5, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R4P_5D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R4P_5D["dev_alloc_replace_R4P_5D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R4P_5D["dev_alloc_replace_R4P_5D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R4P_5D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_R4P_6D

Allocate array, R4P kind, rank 6, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R4P_6D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R4P_6D["dev_alloc_replace_R4P_6D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R4P_6D["dev_alloc_replace_R4P_6D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R4P_6D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_R4P_7D

Allocate array, R4P kind, rank 7, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_R4P_7D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | real(kind=R4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | real(kind=R4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_R4P_7D["dev_alloc_replace_R4P_7D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_R4P_7D["dev_alloc_replace_R4P_7D"] --> dev_free["dev_free"]
  style dev_alloc_replace_R4P_7D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I8P_1D

Allocate array, I8P kind, rank 1, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I8P_1D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I8P_1D["dev_alloc_replace_I8P_1D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I8P_1D["dev_alloc_replace_I8P_1D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I8P_1D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I8P_2D

Allocate array, I8P kind, rank 2, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I8P_2D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I8P_2D["dev_alloc_replace_I8P_2D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I8P_2D["dev_alloc_replace_I8P_2D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I8P_2D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I8P_3D

Allocate array, I8P kind, rank 3, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I8P_3D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I8P_3D["dev_alloc_replace_I8P_3D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I8P_3D["dev_alloc_replace_I8P_3D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I8P_3D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I8P_4D

Allocate array, I8P kind, rank 4, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I8P_4D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I8P_4D["dev_alloc_replace_I8P_4D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I8P_4D["dev_alloc_replace_I8P_4D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I8P_4D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I8P_5D

Allocate array, I8P kind, rank 5, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I8P_5D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I8P_5D["dev_alloc_replace_I8P_5D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I8P_5D["dev_alloc_replace_I8P_5D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I8P_5D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I8P_6D

Allocate array, I8P kind, rank 6, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I8P_6D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I8P_6D["dev_alloc_replace_I8P_6D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I8P_6D["dev_alloc_replace_I8P_6D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I8P_6D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I8P_7D

Allocate array, I8P kind, rank 7, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I8P_7D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I8P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I8P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I8P_7D["dev_alloc_replace_I8P_7D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I8P_7D["dev_alloc_replace_I8P_7D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I8P_7D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I4P_1D

Allocate array, I4P kind, rank 1, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I4P_1D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I4P_1D["dev_alloc_replace_I4P_1D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I4P_1D["dev_alloc_replace_I4P_1D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I4P_1D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I4P_2D

Allocate array, I4P kind, rank 2, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I4P_2D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I4P_2D["dev_alloc_replace_I4P_2D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I4P_2D["dev_alloc_replace_I4P_2D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I4P_2D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I4P_3D

Allocate array, I4P kind, rank 3, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I4P_3D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I4P_3D["dev_alloc_replace_I4P_3D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I4P_3D["dev_alloc_replace_I4P_3D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I4P_3D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I4P_4D

Allocate array, I4P kind, rank 4, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I4P_4D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I4P_4D["dev_alloc_replace_I4P_4D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I4P_4D["dev_alloc_replace_I4P_4D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I4P_4D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I4P_5D

Allocate array, I4P kind, rank 5, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I4P_5D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I4P_5D["dev_alloc_replace_I4P_5D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I4P_5D["dev_alloc_replace_I4P_5D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I4P_5D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I4P_6D

Allocate array, I4P kind, rank 6, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I4P_6D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I4P_6D["dev_alloc_replace_I4P_6D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I4P_6D["dev_alloc_replace_I4P_6D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I4P_6D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I4P_7D

Allocate array, I4P kind, rank 7, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I4P_7D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I4P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I4P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I4P_7D["dev_alloc_replace_I4P_7D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I4P_7D["dev_alloc_replace_I4P_7D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I4P_7D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I2P_1D

Allocate array, I2P kind, rank 1, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I2P_1D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I2P_1D["dev_alloc_replace_I2P_1D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I2P_1D["dev_alloc_replace_I2P_1D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I2P_1D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I2P_2D

Allocate array, I2P kind, rank 2, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I2P_2D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I2P_2D["dev_alloc_replace_I2P_2D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I2P_2D["dev_alloc_replace_I2P_2D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I2P_2D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I2P_3D

Allocate array, I2P kind, rank 3, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I2P_3D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I2P_3D["dev_alloc_replace_I2P_3D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I2P_3D["dev_alloc_replace_I2P_3D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I2P_3D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I2P_4D

Allocate array, I2P kind, rank 4, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I2P_4D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I2P_4D["dev_alloc_replace_I2P_4D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I2P_4D["dev_alloc_replace_I2P_4D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I2P_4D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I2P_5D

Allocate array, I2P kind, rank 5, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I2P_5D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I2P_5D["dev_alloc_replace_I2P_5D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I2P_5D["dev_alloc_replace_I2P_5D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I2P_5D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I2P_6D

Allocate array, I2P kind, rank 6, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I2P_6D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I2P_6D["dev_alloc_replace_I2P_6D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I2P_6D["dev_alloc_replace_I2P_6D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I2P_6D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I2P_7D

Allocate array, I2P kind, rank 7, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I2P_7D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I2P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I2P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I2P_7D["dev_alloc_replace_I2P_7D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I2P_7D["dev_alloc_replace_I2P_7D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I2P_7D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I1P_1D

Allocate array, I1P kind, rank 1, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I1P_1D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I1P_1D["dev_alloc_replace_I1P_1D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I1P_1D["dev_alloc_replace_I1P_1D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I1P_1D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I1P_2D

Allocate array, I1P kind, rank 2, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I1P_2D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I1P_2D["dev_alloc_replace_I1P_2D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I1P_2D["dev_alloc_replace_I1P_2D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I1P_2D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I1P_3D

Allocate array, I1P kind, rank 3, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I1P_3D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I1P_3D["dev_alloc_replace_I1P_3D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I1P_3D["dev_alloc_replace_I1P_3D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I1P_3D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I1P_4D

Allocate array, I1P kind, rank 4, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I1P_4D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I1P_4D["dev_alloc_replace_I1P_4D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I1P_4D["dev_alloc_replace_I1P_4D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I1P_4D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I1P_5D

Allocate array, I1P kind, rank 5, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I1P_5D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I1P_5D["dev_alloc_replace_I1P_5D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I1P_5D["dev_alloc_replace_I1P_5D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I1P_5D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I1P_6D

Allocate array, I1P kind, rank 6, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I1P_6D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I1P_6D["dev_alloc_replace_I1P_6D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I1P_6D["dev_alloc_replace_I1P_6D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I1P_6D fill:#3e63dd,stroke:#99b,stroke-width:2px
```

### dev_alloc_replace_I1P_7D

Allocate array, I1P kind, rank 7, freeing the buffer fptr_dev is associated with, if any.

```fortran
subroutine dev_alloc_replace_I1P_7D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `fptr_dev` | integer(kind=I1P) | inout | pointer | Pointer to allocated memory. |
| `ubounds` | integer(kind=I4P) | in |  | Array upper bounds. |
| `ierr` | integer(kind=I4P) | out |  | Error status. |
| `dev_id` | integer(kind=I4P) | in | optional | Device ID. |
| `lbounds` | integer(kind=I4P) | in | optional | Array lower bounds, 1 if not passed. |
| `init_value` | integer(kind=I1P) | in | optional | Optional initial value. |

**Call graph**

```mermaid
flowchart TD
  dev_alloc_replace_I1P_7D["dev_alloc_replace_I1P_7D"] --> dev_alloc["dev_alloc"]
  dev_alloc_replace_I1P_7D["dev_alloc_replace_I1P_7D"] --> dev_free["dev_free"]
  style dev_alloc_replace_I1P_7D fill:#3e63dd,stroke:#99b,stroke-width:2px
```
