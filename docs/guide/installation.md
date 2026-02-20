---
title: Installation
---

# Installation

## Prerequisites

A Fortran compiler with OpenACC or OpenMP device-offloading support:

| Compiler | Backend | Minimum version |
|----------|---------|----------------|
| NVIDIA nvfortran | OpenACC | 12.3 |
| Intel IFX | OpenMP | 2024.0.2 |
| GNU gfortran | OpenACC (partial) | 13.1 |
| AMD Flang | OpenMP | — |

[FoBiS.py](https://github.com/szaghi/FoBiS) is the recommended build tool:

```bash
pip install FoBiS.py
```

## Download

```bash
git clone https://github.com/szaghi/FUNDAL.git
cd FUNDAL
```

Library sources are in `src/lib/`. Tests are in `src/tests/`. Build output goes to `exe/`.

## Build Tests

### OpenACC — NVIDIA nvfortran

```bash
FoBiS.py build -mode fundal-test-oac-nvf
```

### OpenMP — Intel IFX

```bash
FoBiS.py build -mode fundal-test-omp-ifx
```

### OpenACC — GNU gfortran

```bash
FoBiS.py build -mode fundal-test-oac-gnu
```

### OpenMP — AMD Flang

```bash
FoBiS.py build -mode fundal-test-omp-amd
```

After building, `exe/` contains the test executables:

```
exe/
├── fundal_alloc_free_test
├── fundal_array_access_test
├── fundal_derived_type_memcpy_test
├── fundal_device_handling_test
├── fundal_memcpy_test
└── fundal_use_test
```

## Running Tests

Each test executable runs without arguments. A successful run prints `test passed`.

```bash
# Run all pre-built tests
utils/run_tests.sh

# Run pre-built tests via FoBiS.py
FoBiS.py rule -ex run-tests
```

To build and run in a single step:

```bash
FoBiS.py rule -ex build-run-tests-oac-nvf   # NVIDIA nvfortran + OpenACC
FoBiS.py rule -ex build-run-tests-omp-ifx   # Intel IFX + OpenMP
FoBiS.py rule -ex build-run-tests-oac-gnu   # GNU gfortran + OpenACC
FoBiS.py rule -ex build-run-tests-omp-amd   # AMD Flang + OpenMP
```

For more detailed information on the test suite and Laplace profiling case studies see [`src/tests/README.md`](https://github.com/szaghi/FUNDAL/blob/main/src/tests/README.md).
