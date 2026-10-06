---
title: 7. Production runs
---

# 7. Production runs

A production run must not silently run on the CPU, and must not hide a memory bug. This chapter adds the checks of a
production code to the solver: `heat_7 --require-device` forbids the host fallback, `heat_7 --double-free` simulates a
bug.

## No silent host fallback

<<< @/examples/snippets/heat_7-init.F90{fortran}

By default `dev_init` accepts a host fallback (no device available) with a warning on standard error, so that the same
build runs on a laptop or a CI machine. With `require_device=.true.` a fallback is an error: `dev_init` returns
`FUNDAL_ERR_NO_DEVICE` in `ierr` (without `ierr`, it stops the program). The environment can require a device without
changing the code: `ACC_DEVICE_TYPE=nvidia` (OpenACC) or `OMP_TARGET_OFFLOAD=MANDATORY` (OpenMP).

The documentation runs on the host on purpose (`ACC_DEVICE_TYPE=host`, an explicit request: no warning), so the strict
run stops:

<<< @/examples/output/heat_7-strict.txt{text}

## A strict allocation registry

FUNDAL records every structured allocation. Its policy decides what a misuse of `dev_free` without `ierr` does: `warn`
(the default) reports it and goes on, `error` stops the program, `off` disables the checks. A code under test, or a
production code that prefers a crash to a corruption, sets `error`:

<<< @/examples/snippets/heat_7-policy.F90{fortran}

`FUNDAL_REGISTRY=error` in the environment does the same without changing the code; `dev_set_registry_policy` overrides
it. The labels of the allocations appear in the reports, and the statistics count every live allocation:

<<< @/examples/snippets/heat_7-alloc.F90{fortran}

## Checked teardown

`dev_free` with `ierr` reports a misuse instead of applying the policy, and frees nothing in that case;
`dev_alloc_report` lists what is still allocated (here, nothing):

<<< @/examples/snippets/heat_7-teardown.F90{fortran}

<<< @/examples/output/heat_7.txt{text}

`running on the host: T` is `dev_is_host_fallback()`: true whenever a device build runs on the host, requested or not.

## A double free

With `--double-free` a second pointer, `alias`, points to the buffer of `t_dev`, and is freed after `t_dev`:

<<< @/examples/snippets/heat_7-double-free.F90{fortran}

<<< @/examples/output/heat_7-double-free.txt{text}

The registry no longer knows the address, so `dev_free` returns `FUNDAL_ERR_NOT_REGISTERED` and frees nothing: without
the registry, the runtime would have freed the same buffer twice.

::: warning What the registry cannot see
The registry knows addresses, not pointers. If a new allocation reuses the address of a freed buffer before the alias is
freed, the alias frees the new buffer. Nullify aliases when their target is freed.
:::

::: tip What you learned
`require_device` and `FUNDAL_ERR_NO_DEVICE`; `dev_is_host_fallback`; the registry policy (`dev_set_registry_policy`,
`FUNDAL_REGISTRY`); labels, `dev_get_alloc_stats`, `dev_alloc_report`; `dev_free` with `ierr`.
Reference: [Host fallback](/reference/devices#host-fallback), [Registry and statistics](/reference/registry),
[Errors and constants](/reference/errors).
:::

That is the whole tutorial. The [cookbook](/cookbook/) collects short recipes for everyday tasks.
