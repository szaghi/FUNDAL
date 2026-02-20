---
title: fundal_dev_memcpy
---

# fundal_dev_memcpy

> FUNDAL, memory copy routines module.

**Source**: `src/lib/fundal_dev_memcpy.F90`

**Dependencies**

```mermaid
graph LR
  fundal_dev_memcpy["fundal_dev_memcpy"] --> fundal_env["fundal_env"]
  fundal_dev_memcpy["fundal_dev_memcpy"] --> fundal_utilities["fundal_utilities"]
  fundal_dev_memcpy["fundal_dev_memcpy"] --> iso_c_binding["iso_c_binding"]
  fundal_dev_memcpy["fundal_dev_memcpy"] --> iso_fortran_env["iso_fortran_env"]
  fundal_dev_memcpy["fundal_dev_memcpy"] --> omp_lib["omp_lib"]
```

## Contents

- [dev_memcpy_from_device](#dev-memcpy-from-device)
- [dev_memcpy_to_device](#dev-memcpy-to-device)
- [dev_memcpy_from_device_R8P_1D](#dev-memcpy-from-device-r8p-1d)
- [dev_memcpy_from_device_R8P_2D](#dev-memcpy-from-device-r8p-2d)
- [dev_memcpy_from_device_R8P_3D](#dev-memcpy-from-device-r8p-3d)
- [dev_memcpy_from_device_R8P_4D](#dev-memcpy-from-device-r8p-4d)
- [dev_memcpy_from_device_R8P_5D](#dev-memcpy-from-device-r8p-5d)
- [dev_memcpy_from_device_R8P_6D](#dev-memcpy-from-device-r8p-6d)
- [dev_memcpy_from_device_R8P_7D](#dev-memcpy-from-device-r8p-7d)
- [dev_memcpy_to_device_R8P_1D](#dev-memcpy-to-device-r8p-1d)
- [dev_memcpy_to_device_R8P_2D](#dev-memcpy-to-device-r8p-2d)
- [dev_memcpy_to_device_R8P_3D](#dev-memcpy-to-device-r8p-3d)
- [dev_memcpy_to_device_R8P_4D](#dev-memcpy-to-device-r8p-4d)
- [dev_memcpy_to_device_R8P_5D](#dev-memcpy-to-device-r8p-5d)
- [dev_memcpy_to_device_R8P_6D](#dev-memcpy-to-device-r8p-6d)
- [dev_memcpy_to_device_R8P_7D](#dev-memcpy-to-device-r8p-7d)
- [dev_memcpy_from_device_R4P_1D](#dev-memcpy-from-device-r4p-1d)
- [dev_memcpy_from_device_R4P_2D](#dev-memcpy-from-device-r4p-2d)
- [dev_memcpy_from_device_R4P_3D](#dev-memcpy-from-device-r4p-3d)
- [dev_memcpy_from_device_R4P_4D](#dev-memcpy-from-device-r4p-4d)
- [dev_memcpy_from_device_R4P_5D](#dev-memcpy-from-device-r4p-5d)
- [dev_memcpy_from_device_R4P_6D](#dev-memcpy-from-device-r4p-6d)
- [dev_memcpy_from_device_R4P_7D](#dev-memcpy-from-device-r4p-7d)
- [dev_memcpy_to_device_R4P_1D](#dev-memcpy-to-device-r4p-1d)
- [dev_memcpy_to_device_R4P_2D](#dev-memcpy-to-device-r4p-2d)
- [dev_memcpy_to_device_R4P_3D](#dev-memcpy-to-device-r4p-3d)
- [dev_memcpy_to_device_R4P_4D](#dev-memcpy-to-device-r4p-4d)
- [dev_memcpy_to_device_R4P_5D](#dev-memcpy-to-device-r4p-5d)
- [dev_memcpy_to_device_R4P_6D](#dev-memcpy-to-device-r4p-6d)
- [dev_memcpy_to_device_R4P_7D](#dev-memcpy-to-device-r4p-7d)
- [dev_memcpy_from_device_I8P_1D](#dev-memcpy-from-device-i8p-1d)
- [dev_memcpy_from_device_I8P_2D](#dev-memcpy-from-device-i8p-2d)
- [dev_memcpy_from_device_I8P_3D](#dev-memcpy-from-device-i8p-3d)
- [dev_memcpy_from_device_I8P_4D](#dev-memcpy-from-device-i8p-4d)
- [dev_memcpy_from_device_I8P_5D](#dev-memcpy-from-device-i8p-5d)
- [dev_memcpy_from_device_I8P_6D](#dev-memcpy-from-device-i8p-6d)
- [dev_memcpy_from_device_I8P_7D](#dev-memcpy-from-device-i8p-7d)
- [dev_memcpy_to_device_I8P_1D](#dev-memcpy-to-device-i8p-1d)
- [dev_memcpy_to_device_I8P_2D](#dev-memcpy-to-device-i8p-2d)
- [dev_memcpy_to_device_I8P_3D](#dev-memcpy-to-device-i8p-3d)
- [dev_memcpy_to_device_I8P_4D](#dev-memcpy-to-device-i8p-4d)
- [dev_memcpy_to_device_I8P_5D](#dev-memcpy-to-device-i8p-5d)
- [dev_memcpy_to_device_I8P_6D](#dev-memcpy-to-device-i8p-6d)
- [dev_memcpy_to_device_I8P_7D](#dev-memcpy-to-device-i8p-7d)
- [dev_memcpy_from_device_I4P_1D](#dev-memcpy-from-device-i4p-1d)
- [dev_memcpy_from_device_I4P_2D](#dev-memcpy-from-device-i4p-2d)
- [dev_memcpy_from_device_I4P_3D](#dev-memcpy-from-device-i4p-3d)
- [dev_memcpy_from_device_I4P_4D](#dev-memcpy-from-device-i4p-4d)
- [dev_memcpy_from_device_I4P_5D](#dev-memcpy-from-device-i4p-5d)
- [dev_memcpy_from_device_I4P_6D](#dev-memcpy-from-device-i4p-6d)
- [dev_memcpy_from_device_I4P_7D](#dev-memcpy-from-device-i4p-7d)
- [dev_memcpy_to_device_I4P_1D](#dev-memcpy-to-device-i4p-1d)
- [dev_memcpy_to_device_I4P_2D](#dev-memcpy-to-device-i4p-2d)
- [dev_memcpy_to_device_I4P_3D](#dev-memcpy-to-device-i4p-3d)
- [dev_memcpy_to_device_I4P_4D](#dev-memcpy-to-device-i4p-4d)
- [dev_memcpy_to_device_I4P_5D](#dev-memcpy-to-device-i4p-5d)
- [dev_memcpy_to_device_I4P_6D](#dev-memcpy-to-device-i4p-6d)
- [dev_memcpy_to_device_I4P_7D](#dev-memcpy-to-device-i4p-7d)
- [dev_memcpy_from_device_I2P_1D](#dev-memcpy-from-device-i2p-1d)
- [dev_memcpy_from_device_I2P_2D](#dev-memcpy-from-device-i2p-2d)
- [dev_memcpy_from_device_I2P_3D](#dev-memcpy-from-device-i2p-3d)
- [dev_memcpy_from_device_I2P_4D](#dev-memcpy-from-device-i2p-4d)
- [dev_memcpy_from_device_I2P_5D](#dev-memcpy-from-device-i2p-5d)
- [dev_memcpy_from_device_I2P_6D](#dev-memcpy-from-device-i2p-6d)
- [dev_memcpy_from_device_I2P_7D](#dev-memcpy-from-device-i2p-7d)
- [dev_memcpy_to_device_I2P_1D](#dev-memcpy-to-device-i2p-1d)
- [dev_memcpy_to_device_I2P_2D](#dev-memcpy-to-device-i2p-2d)
- [dev_memcpy_to_device_I2P_3D](#dev-memcpy-to-device-i2p-3d)
- [dev_memcpy_to_device_I2P_4D](#dev-memcpy-to-device-i2p-4d)
- [dev_memcpy_to_device_I2P_5D](#dev-memcpy-to-device-i2p-5d)
- [dev_memcpy_to_device_I2P_6D](#dev-memcpy-to-device-i2p-6d)
- [dev_memcpy_to_device_I2P_7D](#dev-memcpy-to-device-i2p-7d)
- [dev_memcpy_from_device_I1P_1D](#dev-memcpy-from-device-i1p-1d)
- [dev_memcpy_from_device_I1P_2D](#dev-memcpy-from-device-i1p-2d)
- [dev_memcpy_from_device_I1P_3D](#dev-memcpy-from-device-i1p-3d)
- [dev_memcpy_from_device_I1P_4D](#dev-memcpy-from-device-i1p-4d)
- [dev_memcpy_from_device_I1P_5D](#dev-memcpy-from-device-i1p-5d)
- [dev_memcpy_from_device_I1P_6D](#dev-memcpy-from-device-i1p-6d)
- [dev_memcpy_from_device_I1P_7D](#dev-memcpy-from-device-i1p-7d)
- [dev_memcpy_to_device_I1P_1D](#dev-memcpy-to-device-i1p-1d)
- [dev_memcpy_to_device_I1P_2D](#dev-memcpy-to-device-i1p-2d)
- [dev_memcpy_to_device_I1P_3D](#dev-memcpy-to-device-i1p-3d)
- [dev_memcpy_to_device_I1P_4D](#dev-memcpy-to-device-i1p-4d)
- [dev_memcpy_to_device_I1P_5D](#dev-memcpy-to-device-i1p-5d)
- [dev_memcpy_to_device_I1P_6D](#dev-memcpy-to-device-i1p-6d)
- [dev_memcpy_to_device_I1P_7D](#dev-memcpy-to-device-i1p-7d)

## Interfaces

### dev_memcpy_from_device

Copy memory from device.

**Module procedures**: [`dev_memcpy_from_device_R8P_1D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r8p-1d), [`dev_memcpy_from_device_R8P_2D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r8p-2d), [`dev_memcpy_from_device_R8P_3D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r8p-3d), [`dev_memcpy_from_device_R8P_4D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r8p-4d), [`dev_memcpy_from_device_R8P_5D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r8p-5d), [`dev_memcpy_from_device_R8P_6D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r8p-6d), [`dev_memcpy_from_device_R8P_7D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r8p-7d), [`dev_memcpy_from_device_R4P_1D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r4p-1d), [`dev_memcpy_from_device_R4P_2D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r4p-2d), [`dev_memcpy_from_device_R4P_3D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r4p-3d), [`dev_memcpy_from_device_R4P_4D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r4p-4d), [`dev_memcpy_from_device_R4P_5D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r4p-5d), [`dev_memcpy_from_device_R4P_6D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r4p-6d), [`dev_memcpy_from_device_R4P_7D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-r4p-7d), [`dev_memcpy_from_device_I8P_1D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i8p-1d), [`dev_memcpy_from_device_I8P_2D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i8p-2d), [`dev_memcpy_from_device_I8P_3D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i8p-3d), [`dev_memcpy_from_device_I8P_4D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i8p-4d), [`dev_memcpy_from_device_I8P_5D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i8p-5d), [`dev_memcpy_from_device_I8P_6D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i8p-6d), [`dev_memcpy_from_device_I8P_7D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i8p-7d), [`dev_memcpy_from_device_I4P_1D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i4p-1d), [`dev_memcpy_from_device_I4P_2D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i4p-2d), [`dev_memcpy_from_device_I4P_3D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i4p-3d), [`dev_memcpy_from_device_I4P_4D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i4p-4d), [`dev_memcpy_from_device_I4P_5D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i4p-5d), [`dev_memcpy_from_device_I4P_6D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i4p-6d), [`dev_memcpy_from_device_I4P_7D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i4p-7d), [`dev_memcpy_from_device_I2P_1D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i2p-1d), [`dev_memcpy_from_device_I2P_2D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i2p-2d), [`dev_memcpy_from_device_I2P_3D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i2p-3d), [`dev_memcpy_from_device_I2P_4D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i2p-4d), [`dev_memcpy_from_device_I2P_5D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i2p-5d), [`dev_memcpy_from_device_I2P_6D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i2p-6d), [`dev_memcpy_from_device_I2P_7D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i2p-7d), [`dev_memcpy_from_device_I1P_1D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i1p-1d), [`dev_memcpy_from_device_I1P_2D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i1p-2d), [`dev_memcpy_from_device_I1P_3D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i1p-3d), [`dev_memcpy_from_device_I1P_4D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i1p-4d), [`dev_memcpy_from_device_I1P_5D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i1p-5d), [`dev_memcpy_from_device_I1P_6D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i1p-6d), [`dev_memcpy_from_device_I1P_7D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-from-device-i1p-7d)

### dev_memcpy_to_device

Copy memory to device.

**Module procedures**: [`dev_memcpy_to_device_R8P_1D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r8p-1d), [`dev_memcpy_to_device_R8P_2D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r8p-2d), [`dev_memcpy_to_device_R8P_3D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r8p-3d), [`dev_memcpy_to_device_R8P_4D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r8p-4d), [`dev_memcpy_to_device_R8P_5D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r8p-5d), [`dev_memcpy_to_device_R8P_6D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r8p-6d), [`dev_memcpy_to_device_R8P_7D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r8p-7d), [`dev_memcpy_to_device_R4P_1D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r4p-1d), [`dev_memcpy_to_device_R4P_2D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r4p-2d), [`dev_memcpy_to_device_R4P_3D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r4p-3d), [`dev_memcpy_to_device_R4P_4D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r4p-4d), [`dev_memcpy_to_device_R4P_5D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r4p-5d), [`dev_memcpy_to_device_R4P_6D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r4p-6d), [`dev_memcpy_to_device_R4P_7D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-r4p-7d), [`dev_memcpy_to_device_I8P_1D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i8p-1d), [`dev_memcpy_to_device_I8P_2D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i8p-2d), [`dev_memcpy_to_device_I8P_3D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i8p-3d), [`dev_memcpy_to_device_I8P_4D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i8p-4d), [`dev_memcpy_to_device_I8P_5D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i8p-5d), [`dev_memcpy_to_device_I8P_6D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i8p-6d), [`dev_memcpy_to_device_I8P_7D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i8p-7d), [`dev_memcpy_to_device_I4P_1D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i4p-1d), [`dev_memcpy_to_device_I4P_2D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i4p-2d), [`dev_memcpy_to_device_I4P_3D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i4p-3d), [`dev_memcpy_to_device_I4P_4D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i4p-4d), [`dev_memcpy_to_device_I4P_5D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i4p-5d), [`dev_memcpy_to_device_I4P_6D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i4p-6d), [`dev_memcpy_to_device_I4P_7D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i4p-7d), [`dev_memcpy_to_device_I2P_1D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i2p-1d), [`dev_memcpy_to_device_I2P_2D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i2p-2d), [`dev_memcpy_to_device_I2P_3D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i2p-3d), [`dev_memcpy_to_device_I2P_4D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i2p-4d), [`dev_memcpy_to_device_I2P_5D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i2p-5d), [`dev_memcpy_to_device_I2P_6D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i2p-6d), [`dev_memcpy_to_device_I2P_7D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i2p-7d), [`dev_memcpy_to_device_I1P_1D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i1p-1d), [`dev_memcpy_to_device_I1P_2D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i1p-2d), [`dev_memcpy_to_device_I1P_3D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i1p-3d), [`dev_memcpy_to_device_I1P_4D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i1p-4d), [`dev_memcpy_to_device_I1P_5D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i1p-5d), [`dev_memcpy_to_device_I1P_6D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i1p-6d), [`dev_memcpy_to_device_I1P_7D`](/api/src/lib/fundal_dev_memcpy_unstructured#dev-memcpy-to-device-i1p-7d)

## Subroutines

### dev_memcpy_from_device_R8P_1D

Copy array from device, R8P kind, rank 1.

```fortran
subroutine dev_memcpy_from_device_R8P_1D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R8P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_R8P_2D

Copy array from device, R8P kind, rank 2.

```fortran
subroutine dev_memcpy_from_device_R8P_2D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R8P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_R8P_3D

Copy array from device, R8P kind, rank 3.

```fortran
subroutine dev_memcpy_from_device_R8P_3D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R8P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_R8P_4D

Copy array from device, R8P kind, rank 4.

```fortran
subroutine dev_memcpy_from_device_R8P_4D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R8P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_R8P_5D

Copy array from device, R8P kind, rank 5.

```fortran
subroutine dev_memcpy_from_device_R8P_5D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R8P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_R8P_6D

Copy array from device, R8P kind, rank 6.

```fortran
subroutine dev_memcpy_from_device_R8P_6D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R8P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_R8P_7D

Copy array from device, R8P kind, rank 7.

```fortran
subroutine dev_memcpy_from_device_R8P_7D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R8P) | in | target | Source memory (device memory). |

### dev_memcpy_to_device_R8P_1D

Copy array to device, R8P kind, rank 1.

```fortran
subroutine dev_memcpy_to_device_R8P_1D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R8P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_R8P_2D

Copy array to device, R8P kind, rank 2.

```fortran
subroutine dev_memcpy_to_device_R8P_2D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R8P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_R8P_3D

Copy array to device, R8P kind, rank 3.

```fortran
subroutine dev_memcpy_to_device_R8P_3D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R8P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_R8P_4D

Copy array to device, R8P kind, rank 4.

```fortran
subroutine dev_memcpy_to_device_R8P_4D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R8P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_R8P_5D

Copy array to device, R8P kind, rank 5.

```fortran
subroutine dev_memcpy_to_device_R8P_5D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R8P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_R8P_6D

Copy array to device, R8P kind, rank 6.

```fortran
subroutine dev_memcpy_to_device_R8P_6D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R8P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_R8P_7D

Copy array to device, R8P kind, rank 7.

```fortran
subroutine dev_memcpy_to_device_R8P_7D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R8P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R8P) | in | target | Source memory (host memory). |

### dev_memcpy_from_device_R4P_1D

Copy array from device, R4P kind, rank 1.

```fortran
subroutine dev_memcpy_from_device_R4P_1D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R4P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_R4P_2D

Copy array from device, R4P kind, rank 2.

```fortran
subroutine dev_memcpy_from_device_R4P_2D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R4P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_R4P_3D

Copy array from device, R4P kind, rank 3.

```fortran
subroutine dev_memcpy_from_device_R4P_3D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R4P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_R4P_4D

Copy array from device, R4P kind, rank 4.

```fortran
subroutine dev_memcpy_from_device_R4P_4D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R4P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_R4P_5D

Copy array from device, R4P kind, rank 5.

```fortran
subroutine dev_memcpy_from_device_R4P_5D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R4P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_R4P_6D

Copy array from device, R4P kind, rank 6.

```fortran
subroutine dev_memcpy_from_device_R4P_6D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R4P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_R4P_7D

Copy array from device, R4P kind, rank 7.

```fortran
subroutine dev_memcpy_from_device_R4P_7D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (host memory). |
| `src` | real(kind=R4P) | in | target | Source memory (device memory). |

### dev_memcpy_to_device_R4P_1D

Copy array to device, R4P kind, rank 1.

```fortran
subroutine dev_memcpy_to_device_R4P_1D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R4P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_R4P_2D

Copy array to device, R4P kind, rank 2.

```fortran
subroutine dev_memcpy_to_device_R4P_2D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R4P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_R4P_3D

Copy array to device, R4P kind, rank 3.

```fortran
subroutine dev_memcpy_to_device_R4P_3D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R4P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_R4P_4D

Copy array to device, R4P kind, rank 4.

```fortran
subroutine dev_memcpy_to_device_R4P_4D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R4P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_R4P_5D

Copy array to device, R4P kind, rank 5.

```fortran
subroutine dev_memcpy_to_device_R4P_5D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R4P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_R4P_6D

Copy array to device, R4P kind, rank 6.

```fortran
subroutine dev_memcpy_to_device_R4P_6D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R4P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_R4P_7D

Copy array to device, R4P kind, rank 7.

```fortran
subroutine dev_memcpy_to_device_R4P_7D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | real(kind=R4P) | out | target | Destination memory (device memory). |
| `src` | real(kind=R4P) | in | target | Source memory (host memory). |

### dev_memcpy_from_device_I8P_1D

Copy array from device, I8P kind, rank 1.

```fortran
subroutine dev_memcpy_from_device_I8P_1D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I8P_2D

Copy array from device, I8P kind, rank 2.

```fortran
subroutine dev_memcpy_from_device_I8P_2D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I8P_3D

Copy array from device, I8P kind, rank 3.

```fortran
subroutine dev_memcpy_from_device_I8P_3D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I8P_4D

Copy array from device, I8P kind, rank 4.

```fortran
subroutine dev_memcpy_from_device_I8P_4D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I8P_5D

Copy array from device, I8P kind, rank 5.

```fortran
subroutine dev_memcpy_from_device_I8P_5D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I8P_6D

Copy array from device, I8P kind, rank 6.

```fortran
subroutine dev_memcpy_from_device_I8P_6D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I8P_7D

Copy array from device, I8P kind, rank 7.

```fortran
subroutine dev_memcpy_from_device_I8P_7D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (device memory). |

### dev_memcpy_to_device_I8P_1D

Copy array to device, I8P kind, rank 1.

```fortran
subroutine dev_memcpy_to_device_I8P_1D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I8P_2D

Copy array to device, I8P kind, rank 2.

```fortran
subroutine dev_memcpy_to_device_I8P_2D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I8P_3D

Copy array to device, I8P kind, rank 3.

```fortran
subroutine dev_memcpy_to_device_I8P_3D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I8P_4D

Copy array to device, I8P kind, rank 4.

```fortran
subroutine dev_memcpy_to_device_I8P_4D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I8P_5D

Copy array to device, I8P kind, rank 5.

```fortran
subroutine dev_memcpy_to_device_I8P_5D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I8P_6D

Copy array to device, I8P kind, rank 6.

```fortran
subroutine dev_memcpy_to_device_I8P_6D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I8P_7D

Copy array to device, I8P kind, rank 7.

```fortran
subroutine dev_memcpy_to_device_I8P_7D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I8P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I8P) | in | target | Source memory (host memory). |

### dev_memcpy_from_device_I4P_1D

Copy array from device, I4P kind, rank 1.

```fortran
subroutine dev_memcpy_from_device_I4P_1D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I4P_2D

Copy array from device, I4P kind, rank 2.

```fortran
subroutine dev_memcpy_from_device_I4P_2D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I4P_3D

Copy array from device, I4P kind, rank 3.

```fortran
subroutine dev_memcpy_from_device_I4P_3D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I4P_4D

Copy array from device, I4P kind, rank 4.

```fortran
subroutine dev_memcpy_from_device_I4P_4D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I4P_5D

Copy array from device, I4P kind, rank 5.

```fortran
subroutine dev_memcpy_from_device_I4P_5D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I4P_6D

Copy array from device, I4P kind, rank 6.

```fortran
subroutine dev_memcpy_from_device_I4P_6D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I4P_7D

Copy array from device, I4P kind, rank 7.

```fortran
subroutine dev_memcpy_from_device_I4P_7D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (device memory). |

### dev_memcpy_to_device_I4P_1D

Copy array to device, I4P kind, rank 1.

```fortran
subroutine dev_memcpy_to_device_I4P_1D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I4P_2D

Copy array to device, I4P kind, rank 2.

```fortran
subroutine dev_memcpy_to_device_I4P_2D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I4P_3D

Copy array to device, I4P kind, rank 3.

```fortran
subroutine dev_memcpy_to_device_I4P_3D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I4P_4D

Copy array to device, I4P kind, rank 4.

```fortran
subroutine dev_memcpy_to_device_I4P_4D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I4P_5D

Copy array to device, I4P kind, rank 5.

```fortran
subroutine dev_memcpy_to_device_I4P_5D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I4P_6D

Copy array to device, I4P kind, rank 6.

```fortran
subroutine dev_memcpy_to_device_I4P_6D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I4P_7D

Copy array to device, I4P kind, rank 7.

```fortran
subroutine dev_memcpy_to_device_I4P_7D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I4P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I4P) | in | target | Source memory (host memory). |

### dev_memcpy_from_device_I2P_1D

Copy array from device, I2P kind, rank 1.

```fortran
subroutine dev_memcpy_from_device_I2P_1D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I2P_2D

Copy array from device, I2P kind, rank 2.

```fortran
subroutine dev_memcpy_from_device_I2P_2D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I2P_3D

Copy array from device, I2P kind, rank 3.

```fortran
subroutine dev_memcpy_from_device_I2P_3D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I2P_4D

Copy array from device, I2P kind, rank 4.

```fortran
subroutine dev_memcpy_from_device_I2P_4D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I2P_5D

Copy array from device, I2P kind, rank 5.

```fortran
subroutine dev_memcpy_from_device_I2P_5D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I2P_6D

Copy array from device, I2P kind, rank 6.

```fortran
subroutine dev_memcpy_from_device_I2P_6D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I2P_7D

Copy array from device, I2P kind, rank 7.

```fortran
subroutine dev_memcpy_from_device_I2P_7D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (device memory). |

### dev_memcpy_to_device_I2P_1D

Copy array to device, I2P kind, rank 1.

```fortran
subroutine dev_memcpy_to_device_I2P_1D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I2P_2D

Copy array to device, I2P kind, rank 2.

```fortran
subroutine dev_memcpy_to_device_I2P_2D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I2P_3D

Copy array to device, I2P kind, rank 3.

```fortran
subroutine dev_memcpy_to_device_I2P_3D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I2P_4D

Copy array to device, I2P kind, rank 4.

```fortran
subroutine dev_memcpy_to_device_I2P_4D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I2P_5D

Copy array to device, I2P kind, rank 5.

```fortran
subroutine dev_memcpy_to_device_I2P_5D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I2P_6D

Copy array to device, I2P kind, rank 6.

```fortran
subroutine dev_memcpy_to_device_I2P_6D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I2P_7D

Copy array to device, I2P kind, rank 7.

```fortran
subroutine dev_memcpy_to_device_I2P_7D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I2P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I2P) | in | target | Source memory (host memory). |

### dev_memcpy_from_device_I1P_1D

Copy array from device, I1P kind, rank 1.

```fortran
subroutine dev_memcpy_from_device_I1P_1D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I1P_2D

Copy array from device, I1P kind, rank 2.

```fortran
subroutine dev_memcpy_from_device_I1P_2D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I1P_3D

Copy array from device, I1P kind, rank 3.

```fortran
subroutine dev_memcpy_from_device_I1P_3D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I1P_4D

Copy array from device, I1P kind, rank 4.

```fortran
subroutine dev_memcpy_from_device_I1P_4D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I1P_5D

Copy array from device, I1P kind, rank 5.

```fortran
subroutine dev_memcpy_from_device_I1P_5D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I1P_6D

Copy array from device, I1P kind, rank 6.

```fortran
subroutine dev_memcpy_from_device_I1P_6D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (device memory). |

### dev_memcpy_from_device_I1P_7D

Copy array from device, I1P kind, rank 7.

```fortran
subroutine dev_memcpy_from_device_I1P_7D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (host memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (device memory). |

### dev_memcpy_to_device_I1P_1D

Copy array to device, I1P kind, rank 1.

```fortran
subroutine dev_memcpy_to_device_I1P_1D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I1P_2D

Copy array to device, I1P kind, rank 2.

```fortran
subroutine dev_memcpy_to_device_I1P_2D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I1P_3D

Copy array to device, I1P kind, rank 3.

```fortran
subroutine dev_memcpy_to_device_I1P_3D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I1P_4D

Copy array to device, I1P kind, rank 4.

```fortran
subroutine dev_memcpy_to_device_I1P_4D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I1P_5D

Copy array to device, I1P kind, rank 5.

```fortran
subroutine dev_memcpy_to_device_I1P_5D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I1P_6D

Copy array to device, I1P kind, rank 6.

```fortran
subroutine dev_memcpy_to_device_I1P_6D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (host memory). |

### dev_memcpy_to_device_I1P_7D

Copy array to device, I1P kind, rank 7.

```fortran
subroutine dev_memcpy_to_device_I1P_7D(dst, src)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dst` | integer(kind=I1P) | out | target | Destination memory (device memory). |
| `src` | integer(kind=I1P) | in | target | Source memory (host memory). |
