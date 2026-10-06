# FUNDAL tests

Every top-level program of this directory is a test. The `*_agnostic.INC` files hold the kind/rank-generic bodies that
some tests include.

| Test | What it checks |
|---|---|
| `fundal_alloc_free_test` | `dev_alloc`/`dev_free` for every kind and rank, zero live allocations at the end |
| `fundal_alloc_replace_test` | `dev_alloc_replace`: bounds, values, exact allocation counters, a replace/assign loop |
| `fundal_array_access_test` | kernels with different loop orders and collapse depths on rank-4 device arrays (prints timings) |
| `fundal_assign_test` | `dev_assign_to_device`/`dev_assign_from_device` for every kind and rank |
| `fundal_assign_lb_test` | the lower-bounds-first `dev_assign_*` forms, lower bound -2 |
| `fundal_assign_xfail_unregistered_test` | expected failure: `dev_assign_to_device` on a pointer not allocated by FUNDAL, policy `error` |
| `fundal_compat_test` | legacy call forms and legacy behaviour under the registry policies |
| `fundal_derived_type_memcpy_test` | device arrays as components of a derived type, kernel in a procedure |
| `fundal_device_handling_test` | device queries: selects each device in turn and prints its properties |
| `fundal_external_routine_test` | kernels in procedures: structured (`DEVICEVAR`) and unstructured (`present`) arrays |
| `fundal_host_fallback_test` | `dev_init` policy: fallback warning, `require_device`, `local_rank` without devices |
| `fundal_memcpy_registry_test` | registry-aware copies: sections, strided host and device arguments, a range beyond the allocation, foreign memory |
| `fundal_memcpy_test` | `dev_memcpy_to_device`/`dev_memcpy_from_device` for every kind and rank |
| `fundal_memcpy_transposed_test` | transposed copies, lower bound -2 |
| `fundal_memcpy_xfail_overflow_test` | expected failure: a copy beyond the end of its allocation under policy `error` must `error stop` |
| `fundal_registry_test` | the allocation registry itself, range lookups included (host only, no device memory) |
| `fundal_registry_behaviour_test` | labels, statistics, report, misuse detection through `ierr` |
| `fundal_registry_two_devices_test` | a buffer copied and freed on the device where it lives (skipped with fewer than two devices) |
| `fundal_registry_xfail_double_free_test` | expected failure: a double free under policy `error` must `error stop` |
| `fundal_save_memory_status_test` | `save_memory_status` |
| `fundal_use_test` | `use fundal` compiles and links |

Subdirectories:

- `mpi/fundal_mpi_dev_alloc_test.F90`: device memory and MPI transfers on 2 ranks, through `mpih_object`; built only by
  the `mpi` modes (`fundal-test-oac-mpi-nvf`, `-oac-mpi-gnu`, `-omp-mpi-ifx`, `-omp-mpi-amd`).
- `laplace/`: a profiling case study (the Laplace example of the OpenACC documentation): `fundal_laplace_baseline`
  (serial), `fundal_laplace_dev_inline` (kernels inline), `fundal_laplace_dev_routine` (kernels in a module).
- `precision/`: a WENO5 mixed-precision benchmark, see its [README](precision/README.md).

## Build

```bash
fobis build --lmodes                       # the modes
fobis build --mode fundal-test-oac-nvf     # nvfortran + OpenACC
fobis build --mode fundal-test-omp-ifx     # ifx + OpenMP offload
fobis build --mode fundal-test-oac-gnu     # gfortran + OpenACC
fobis build --mode fundal-test-omp-amd     # amdflang + OpenMP offload
fobis build --mode fundal-test-gnu         # gfortran, compile-time CPU mode
```

The test programs go to `exe/`. Every non-MPI mode excludes `mpi/`; `fundal-test-oac-gnu` (used by CI for coverage)
also excludes `laplace/` and `precision/`, which are too slow in an unoptimized, instrumented host build. `exe/` is
shared: `fobis clean` before switching mode.

Without FoBiS: `make COMPILER=gnu BACKEND=oac tests` builds the top-level tests (not `laplace/`, `precision/`, `mpi/`)
into `build/gnu-oac/tests/`.

## Run

```bash
bash scripts/run_tests.sh                  # every program of exe/
fobis rule --ex run-tests                  # the same
fobis rule --ex build-run-tests-oac-nvf    # clean, build and run (also -omp-ifx, -oac-gnu, -omp-amd)
```

`scripts/run_tests.sh` runs every executable of `exe/`, those with `mpi` in their name under `mpirun -np 2` (`--np N`
changes it), and reports:

- a regular test **passes** when it exits with status 0 and, if a `<name>.result` file exists, prints its content
  (leading and trailing blanks ignored). The text `test passed` the tests print is not checked;
- a test with `_xfail_` in its name is an **expected failure**: it passes when it exits with a non-zero status.

The script exits with the number of failures. Several older tests end with a plain `stop` (exit status 0) when a check
fails: read their output, or fix them to `error stop`. New tests should `error stop` on any failure.

## Laplace case study

```bash
fobis rule --ex build-laplace-baseline-nvf && fobis rule --ex build-laplace-oac-nvf
fobis rule --ex build-laplace-baseline-gnu && fobis rule --ex build-laplace-oac-gnu
fobis rule --ex build-laplace-baseline-ifx && fobis rule --ex build-laplace-omp-ifx
fobis rule --ex build-laplace-baseline-amd && fobis rule --ex build-laplace-omp-amd
```

Each rule cleans `exe/` first, so build and run one variant at a time.

## Compiler proofs

`compilers_proofs/` holds standalone programs that check compiler support for offloading features (see its
[README](../../compilers_proofs/README.md)):

```bash
fobis rule --ex build-compilers-proofs-oac-nvf
fobis rule --ex build-compilers-proofs-oac-gnu
```
