---
title: Upgrading
---

# Upgrading

What changes for a program, release by release, newest first. New optional arguments are always appended: existing
calls compile unchanged. The full list of commits is in the [changelog](./changelog).

## Unreleased

- **`dev_set_device_num` updates `mydev`** in every backend, so after `call dev_set_device_num(1)` OpenMP allocates and
  copies on device 1, as OpenACC already did (before, OpenMP kept using the old `mydev`). The usual
  `mydev = dev_get_device_num()` after the call is now redundant and harmless. On OpenMP the routine is no longer a
  rename of `omp_set_default_device`: `dev_set_device_num(dev_num=1)` now compiles, the OpenMP keyword `device_num=`
  does not.

## 2.1.4 and 2.1.5

- **CMake and fpm builds.** `CMakeLists.txt` builds the library and the tests (`-DFUNDAL_BACKEND=none|oac|omp`,
  `-DFUNDAL_GPU`, `-DFUNDAL_MPI=ON`) and installs a package: `find_package(FUNDAL)` and link `FUNDAL::fundal`, which
  carries the backend macros and offload flags. `fpm.toml` builds the library in the compile-time CPU mode (a backend
  through `--flag`), without the MPI handler. See [Installation](/guide/install#build-with-cmake). Nothing changes for
  FoBiS and make builds.
- 2.1.5 shortens test source lines over 132 columns, which gfortran 13 rejects (the CMake build compiles the tests).

## 2.1.3

- **make builds FUNDAL again.** The makefile was a stale export that could not build the current sources. It now
  mirrors the fobos templates: `make COMPILER=gnu|nvf|ifx|amd BACKEND=none|oac|omp [GPU=...] [MPI=1]`, output in
  `build/<COMPILER>-<BACKEND>/` (`libfundal.a`, `mod/`), never in FoBiS's `exe/`. See [Installation](/guide/install#build-with-make).
- **`FUNDAL_DEVICE_HOST` and `FUNDAL_DEVICE_GPU` are exported**, and defined in every build: compare the result of
  `dev_get_device_type` on OpenMP with them instead of 0 and 1.
- **`mpih_object%initialize(..., require_device)`**: the new optional argument is passed to `dev_init`, so an MPI code
  can forbid the host fallback on every rank.
- **`dev_error_message(ierr)`** (new) returns the description of an error code. The codes 101-104 are now defined in
  one place (`fundal_env`) and re-exported under the same names: existing `use` statements are unaffected.
- **`dev_assign_to_device` without `ierr` reports the actual error.** Under policy `error`, a `dst` not allocated by
  FUNDAL (code 103: nothing is freed or allocated) stopped with "failed to allocate device memory"; it now prints
  `FUNDAL error: dev_assign_to_device: <description>` and stops with `FUNDAL: dev_assign_to_device failed`.
- **Tests exit non-zero on failure.** Several tests ended a failed check with a plain `stop` (exit status 0), so the
  test runner and CI counted them as passed; they now use `error stop 1`.
- fobos: the AMD and Intel laplace rules are now `build-laplace-omp-amd` and `build-laplace-omp-ifx`, the `[modes]` list
  matches the defined modes, and every rule uses the double-dash `fobis` CLI.

## 2.1.2

The **allocation registry**: every structured allocation is recorded (address, size, device, label).

- `dev_free` frees a buffer on the device where it was allocated. Before, OpenACC freed on the *current* device, which
  was undefined behaviour when another device was current; OpenMP freed on `dev_id`.
- `dev_free` detects misuse: a pointer that is not a live FUNDAL allocation (double free through an alias, section,
  foreign pointer) and a `dev_id` that contradicts the recorded device. **Behaviour change**: under the default policy
  (`warn`) a misuse now writes a `FUNDAL warning` on standard error, then behaves as before. `FUNDAL_REGISTRY=off`
  restores the old behaviour and output exactly; `FUNDAL_REGISTRY=error` makes misuse fatal.
- `dev_free(fptr, dev_id, ierr)`: new optional `ierr` returns `FUNDAL_ERR_NOT_REGISTERED` or
  `FUNDAL_ERR_DEV_ID_MISMATCH` and frees nothing in that case.
- `dev_alloc`/`dev_alloc_replace`: new optional `label`. On OpenACC a `dev_id` different from the current device is
  reported by a warning (it was silently ignored).
- `dev_alloc_replace` no longer requires the new buffer on the device of the old one: `dev_id` is the device of the new
  buffer. Under the policy `error`, freeing an unknown pointer returns `FUNDAL_ERR_NOT_REGISTERED` in `ierr`.
- New: `dev_alloc_report`, `dev_set_registry_policy`, `dev_get_alloc_stats(..., dev_id)`, the constants
  `FUNDAL_REGISTRY_*`, `FUNDAL_ERR_NOT_REGISTERED`, `FUNDAL_ERR_DEV_ID_MISMATCH`.

See [Registry and statistics](/reference/registry).

## 2.1.1

The **host fallback is explicit**.

- `dev_init(local_rank, require_device, ierr)`: new optional `require_device` and `ierr`.
- **Behaviour change**: a device build that finds no device writes a warning on standard error (once), and
  `dev_is_host_fallback()` (new) returns `.true.`. With `require_device=.true.`, a non-host `ACC_DEVICE_TYPE` or
  `OMP_TARGET_OFFLOAD=MANDATORY`, `dev_init` now fails instead of running on the host: `FUNDAL_ERR_NO_DEVICE` in `ierr`,
  `error stop` without it. Jobs that set these variables on GPU-less nodes stop at `dev_init`.
- `ACC_DEVICE_TYPE=host` and `OMP_TARGET_OFFLOAD=DISABLED` request the host explicitly: no warning.
- `dev_init` can be called twice under gfortran (OpenACC is initialized once); on OpenMP, `dev_init(local_rank=...)`
  with no device no longer divides by zero. The CPU-mode `dev_init` takes the same arguments.

See [Host fallback](/reference/devices#host-fallback).

## 2.1.0

- **`dev_alloc_replace`** (new): frees an associated pointer, then allocates. `dev_alloc` keeps pointer-`allocate`
  semantics: calling it on an associated pointer leaks its buffer.
- **`dev_get_alloc_stats`** (new): live structured allocations and bytes, on every backend.
- **`dev_assign_to_device(dst, src, ierr)`**: new optional `ierr`; it now reallocates through `dev_alloc_replace`, and an
  allocation failure is an `error stop` without `ierr` (it used to write through a null pointer).
- `dev_free` on a disassociated pointer is a no-op.
- `dev_memory_total` (new global): total device memory. `dev_memory_avail` is, and was, the **free** memory at
  `dev_init`; size problems from the total.
- OpenMP: `dev_init` now selects the device (it did nothing) and takes `local_rank`; `dev_get_device_type` returns the
  host/GPU distinction; with `DEV_HIP` (AMD) the device memory and properties come from the HIP runtime.
- Transposed copies: `dev_memcpy_from_device` with bounds (`bb`, `tb`) and a host buffer; the argument order of the
  transposition inside the transposed copies was fixed.
- `bytes_size` no longer overflows for arrays of more than 2³¹-1 elements.
