---
title: Debugging
---

# Debugging

[[toc]]

## Check where the run happens

Find out whether a device build is running on the host.

<<< @/examples/snippets/debugging-fallback.F90{fortran}

<<< @/examples/output/debugging-fallback.txt{text}

The documentation runs on the host on purpose. On a GPU node, `T` means that the device is not visible (driver,
`CUDA_VISIBLE_DEVICES`, a GPU-less build of the compiler runtime): `dev_init` also writes a warning on standard error,
unless the host was requested.

## Find a leaked allocation

Label the allocations and list the live ones at teardown.

<<< @/examples/snippets/debugging-leak.F90{fortran}

<<< @/examples/output/debugging-leak.txt{text}

The address (shown here as a placeholder) changes from run to run; labels are truncated to 32 characters.

## Catch a double free

Free through `ierr` to get an error code instead of a second free.

<<< @/examples/snippets/debugging-double-free.F90{fortran}

<<< @/examples/output/debugging-double-free.txt{text}

::: warning
Without `ierr`, the default policy (`warn`) writes a warning and then frees the pointer as FUNDAL did before the
registry existed: a real double free, which may crash the runtime. Use `ierr` or the `error` policy.
:::

## A dev_id that contradicts the buffer

`dev_free` frees a buffer on the device where it was allocated; a `dev_id` that says otherwise is reported.

<<< @/examples/snippets/debugging-dev-id.F90{fortran}

<<< @/examples/output/debugging-dev-id.txt{text}

## Make misuse fatal without changing the code

Set `FUNDAL_REGISTRY=error`: a misuse of `dev_free` without `ierr` stops the program with an error.

<<< @/examples/snippets/debugging-misuse.F90{fortran}

<<< @/examples/output/debugging-policy.txt{text}

The message (`FUNDAL error: dev_free: pointer not allocated by FUNDAL ...`) goes to standard error. `dev_set_registry_policy`
in the code takes precedence over the variable.

## Debug kernels on a GPU

| Tool | Use |
|---|---|
| `nvfortran -Minfo=accel` | which loops became kernels, and what data they move |
| `NV_ACC_NOTIFY=3` | trace kernel launches and data transfers (nvfortran) |
| `NV_ACC_DEBUG=1` | verbose OpenACC runtime output (nvfortran) |
| `compute-sanitizer ./program` | out-of-bounds and illegal accesses on NVIDIA GPUs |
| `gfortran -fcheck=all -g` | bounds checking on the host: runs the kernels on the host, catches indexing errors |
| `OMP_TARGET_OFFLOAD=MANDATORY` | OpenMP: fail instead of running the kernels on the host |
