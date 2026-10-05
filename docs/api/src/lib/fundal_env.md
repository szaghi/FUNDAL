---
title: fundal_env
---

# fundal_env

> FUNDAL, environment global module.

**Source**: `src/lib/fundal_env.F90`

**Dependencies**

```mermaid
graph LR
  fundal_env["fundal_env"] --> iso_fortran_env["iso_fortran_env"]
```

## Variables

| Name | Type | Attributes | Description |
|------|------|------------|-------------|
| `dev_allocs_live` | integer(kind=I8P) | target | Live structured device allocations (dev_alloc not yet dev_free-d). |
| `dev_bytes_live` | integer(kind=I8P) | target | Bytes of live structured device allocations. |
| `devs_number` | integer(kind=I4P) | target | Number of devices. |
| `dev_memory_avail` | integer(kind=I8P) | target | Device memory FREE at init (bytes). |
| `dev_memory_total` | integer(kind=I8P) | target | Device memory TOTAL, a machine property (bytes). |
| `local_comm` | integer(kind=I4P) | target | Local communicator. |
| `mydev` | integer(kind=I4P) | target | Device ID. |
| `myhos` | integer(kind=I4P) | target | Host ID. |
| `IDK` | integer | parameter | Kind parameter for device type definitio. |
| `devtype` | integer(kind=[IDK](/api/src/lib/fundal_env)) | target | Device type. |
| `FUNDAL_DEVICE_HOST` | integer(kind=I4P) | parameter | Device type: host (no offload device available). |
| `FUNDAL_DEVICE_GPU` | integer(kind=I4P) | parameter | Device type: accelerator/GPU offload device. |
