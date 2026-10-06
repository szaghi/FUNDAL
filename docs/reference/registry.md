---
title: Registry and statistics
---

# Registry and statistics

FUNDAL records every structured allocation (`dev_alloc`, `dev_alloc_replace`, `dev_assign_to_device`) in a host-side
table: base address, size in bytes, device where the buffer lives, optional label. With it

- [`dev_free`](./structured#dev-free) frees each buffer on its own device, whatever the current device;
- [`dev_memcpy_*`](./structured#copies) copy a buffer, or a contiguous section of it, on its own device, and reject a
  strided device argument or a range beyond the end of its allocation;
- `dev_free` recognizes a pointer that is not a live FUNDAL allocation (double free through an alias, a section, a
  pointer from elsewhere) and a `dev_id` that contradicts the recorded device;
- the statistics and the report are exact on every backend, host fallback and CPU mode included.

On OpenACC `acc_malloc` allocates on the current device: that is the device recorded, and a `dev_alloc(dev_id=...)`
that names another device is reported by a warning.

[[toc]]

## Policy {#policy}

What `dev_free` does on a misuse is set by a process-wide policy (for `dev_alloc_replace` and the copies see
[their rules](./structured#dev-alloc-replace), [copies](./structured#copies)):

| Policy | Misuse without `ierr` | Misuse with `ierr` |
|---|---|---|
| `warn` (default) | `FUNDAL warning: ...` on standard error, then the pre-registry behaviour (the pointer is freed) | error code, nothing freed |
| `error` | `FUNDAL error: ...` on standard error, `error stop 'FUNDAL: allocation registry misuse'` | error code, nothing freed |
| `off` | no check, no message: the pre-registry behaviour | no check, `ierr` is 0 |

The policy is read from the environment variable `FUNDAL_REGISTRY` (`off`, `warn` or `error`, any case) at the first
allocation or free, unless `dev_set_registry_policy` set it before; `dev_set_registry_policy` always overrides the
variable. The statistics and the report work under every policy.

### dev_set_registry_policy {#dev-set-registry-policy}

```fortran
subroutine dev_set_registry_policy(policy, ierr)
character(*), intent(in)            :: policy
integer(I4P), intent(out), optional :: ierr
```

| Argument | Intent | Description |
|---|---|---|
| `policy` | in | `'off'`, `'warn'` or `'error'`, any case |
| `ierr` | out, optional | 0, or 1 if the name is not valid (the policy is unchanged) |

The named constants `FUNDAL_REGISTRY_OFF` (0), `FUNDAL_REGISTRY_WARN` (1), `FUNDAL_REGISTRY_ERROR` (2) are exported for
reference; the routine takes the name.

<<< @/examples/snippets/heat_7-policy.F90{fortran}

## dev_get_alloc_stats {#dev-get-alloc-stats}

```fortran
subroutine dev_get_alloc_stats(allocs, bytes, dev_id)
integer(I8P), intent(out), optional :: allocs
integer(I8P), intent(out), optional :: bytes
integer(I4P), intent(in),  optional :: dev_id
```

| Argument | Intent | Description |
|---|---|---|
| `allocs` | out, optional | Number of live structured allocations |
| `bytes` | out, optional | Their total size [bytes] |
| `dev_id` | in, optional | Count only the allocations living on this device |

Live means allocated by `dev_alloc`/`dev_alloc_replace`/`dev_assign_to_device` and not yet freed by `dev_free`.
Unstructured mappings are not counted.

<<< @/examples/snippets/memory-stats.F90{fortran}

<<< @/examples/output/memory-stats.txt{text}

## dev_alloc_report {#dev-alloc-report}

```fortran
subroutine dev_alloc_report(unit)
integer(I4P), intent(in), optional :: unit
```

| Argument | Intent | Description |
|---|---|---|
| `unit` | in, optional | Output unit (default standard output) |

Writes one line per live allocation, in no particular order, then a summary:

| Line | Content |
|---|---|
| `FUNDAL live allocation: address=0x... bytes=N device=D label="..."` | address (16 hexadecimal digits), size, device, label (empty if none) |
| `FUNDAL live allocations: N (B bytes)` | count and total size |

<<< @/examples/snippets/debugging-leak.F90{fortran}

<<< @/examples/output/debugging-leak.txt{text}

## Limits

- The registry proves that FUNDAL asked the runtime to free each buffer, not that the runtime released it (on NVIDIA,
  `compute-sanitizer --leak-check full` checks that).
- It knows addresses, not pointers: an alias of a freed buffer whose address is reused by a later allocation frees the
  new buffer.
- Its updates are in an OpenMP `critical` section: it is thread safe only when FUNDAL is compiled with OpenMP.
