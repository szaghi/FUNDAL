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
| `devs_number` | integer(kind=I4P) | target | Number of devices. |
| `dev_memory_avail` | integer(kind=I8P) | target | Device memory available (GB). |
| `local_comm` | integer(kind=I4P) | target | Local communicator. |
| `mydev` | integer(kind=I4P) | target | Device ID. |
| `myhos` | integer(kind=I4P) | target | Host ID. |
| `IDK` | integer | parameter | Kind parameter for device type definitio. |
| `devtype` | integer(kind=[IDK](/api/src/lib/fundal_env)) | target | OpenACC device type. |
