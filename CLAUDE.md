# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**FUNDAL** (Fortran UNified Device Acceleration Library) is a pure Fortran library providing a unified API for GPU/accelerated device memory management using either OpenACC or OpenMP backends. Users write code against a single API; the backend is selected at compile time via C preprocessor macros.

## Build System

The primary build tool is **FoBiS.py** (Fortran Build System). A `makefile` is also available as an alternative.

### Common build commands

```bash
# Build all tests for a specific compiler/backend combination
FoBiS.py build -mode fundal-test-oac-nvf    # NVIDIA nvfortran + OpenACC
FoBiS.py build -mode fundal-test-omp-ifx    # Intel IFX + OpenMP
FoBiS.py build -mode fundal-test-oac-gnu    # GNU gfortran + OpenACC
FoBiS.py build -mode fundal-test-omp-amd    # AMD Flang + OpenMP

# Clean build artifacts
FoBiS.py clean -mode fundal-test-oac-nvf

# List all available modes
FoBiS.py build --help
```

Build output goes to `exe/`, module files to `mod/`, object files to `exe/obj/`.

### Running tests

```bash
# Run all pre-built tests (checks for "test passed" in output)
./utils/run_tests.sh

# Build and run tests in one step
FoBiS.py rule -ex build-run-tests-oac-nvf
FoBiS.py rule -ex build-run-tests-omp-ifx
FoBiS.py rule -ex build-run-tests-oac-gnu
FoBiS.py rule -ex build-run-tests-omp-amd

# Run just the pre-built tests without rebuilding
FoBiS.py rule -ex run-tests
```

Each test executable in `exe/` prints "test passed" to stdout on success. MPI tests are run with `mpirun -np 2`.

### Documentation

```bash
FoBiS.py rule -ex makedoc    # Generate API docs (FORMAL + VitePress)
FoBiS.py rule -ex deldoc     # Clean documentation artifacts
```

## Architecture

### Backend abstraction via C preprocessor

The core abstraction mechanism is in `src/lib/fundal.H`. Compile-time macros select the backend:

- `DEV_OAC` — enables OpenACC (uses `acc_malloc`, `acc_free`, etc.)
- `DEV_OMP` — enables OpenMP (uses `omp_target_alloc`, `omp_target_free`, etc.)
- Neither — fallback CPU-only mode

Compiler identity macros (`COMPILER_NVF`, `COMPILER_GNU`) handle compiler-specific workarounds.

### Source layout

```
src/lib/        - Library modules
src/tests/      - Test programs
src/examples/   - Minimal usage examples
compilers_proofs/ - Standalone tests verifying compiler feature support
```

### Module hierarchy

`fundal.F90` is the single public-facing module. It re-exports everything from the implementation modules:

- `fundal_dev_alloc.F90` / `fundal_dev_alloc_unstructured.F90` — device memory allocation
- `fundal_dev_free.F90` / `fundal_dev_free_unstructured.F90` — deallocation
- `fundal_dev_memcpy.F90` / `fundal_dev_memcpy_unstructured.F90` — host↔device transfers
- `fundal_dev_assign.F90` — assignment-style copy (reallocates on size change)
- `fundal_dev_handling.F90` — device init, query, selection
- `fundal_env.F90` — global state (`mydev`, `devtype`, `devs_number`, etc.)
- `fundal_mpih_object.F90` — MPI handler class for multi-device scenarios

### Two memory models

- **Structured**: purely device-allocated memory, returned as Fortran pointers (`dev_alloc`, `dev_free`, `dev_memcpy_*`)
- **Unstructured**: host allocatable arrays mapped to device (`dev_alloc_unstr`, `dev_free_unstr`, `dev_memcpy_*_unstr`)

### Preprocessor-based generics

Type/rank combinations are generated via `.INC` include files that are `#include`-d inside module `contains` sections. This avoids repetitive boilerplate. Supported numeric kinds: `R8P`, `R4P`, `I8P`, `I4P`, `I2P`, `I1P`. Supported array ranks: 1–7.

### fobos build modes

The `fobos` file uses template inheritance to avoid duplication. A mode like `fundal-test-oac-nvf` extends `template-oac-nvf` (compiler flags) and `template-base` (directory layout). When adding a new mode or compiler, follow the existing template pattern.
