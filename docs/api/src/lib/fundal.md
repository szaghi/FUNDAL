---
title: fundal
---

# fundal

> FUNDAL, Fortran UNified Device Acceleration Library.

**Source**: `src/lib/fundal.F90`

**Dependencies**

```mermaid
graph LR
  fundal["fundal"] --> fundal_dev_alloc["fundal_dev_alloc"]
  fundal["fundal"] --> fundal_dev_alloc_unstructured["fundal_dev_alloc_unstructured"]
  fundal["fundal"] --> fundal_dev_assign["fundal_dev_assign"]
  fundal["fundal"] --> fundal_dev_free["fundal_dev_free"]
  fundal["fundal"] --> fundal_dev_free_unstructured["fundal_dev_free_unstructured"]
  fundal["fundal"] --> fundal_dev_handling["fundal_dev_handling"]
  fundal["fundal"] --> fundal_dev_memcpy["fundal_dev_memcpy"]
  fundal["fundal"] --> fundal_dev_memcpy_unstructured["fundal_dev_memcpy_unstructured"]
  fundal["fundal"] --> fundal_env["fundal_env"]
  fundal["fundal"] --> iso_fortran_env["iso_fortran_env"]
```

## Contents

- [save_memory_status](#save-memory-status)

## Subroutines

### save_memory_status

Save the current device-memory status into a file.
 File is accessed in append position.

```fortran
subroutine save_memory_status(file_name, tag)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `file_name` | character(len=*) | in |  | File name. |
| `tag` | character(len=*) | in | optional | Tag of current status. |

**Call graph**

```mermaid
flowchart TD
  save_memory_status["save_memory_status"] --> dev_get_device_memory_info["dev_get_device_memory_info"]
  style save_memory_status fill:#3e63dd,stroke:#99b,stroke-width:2px
```
