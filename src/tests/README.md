### FUNDAL TESTS

FUNDAL is a Test-Driven project, this subdirectory contains FUNDAL tests.

+ `fundal_alloc_free_test.F90`, test allocation and free of device memory;
+ `fundal_array_access_test.F90`, test different methods to access arrays memory;
+ `fundal_derived_type_memcpy_test.F90`, test device acceleration with derived type;
+ `fundal_device_handling_test.F90`, test routines for device handling;
+ `fundal_memcpy_test.F90`, test routint for memory copy from/to device;
+ `fundal_use_test.F90`, test use FUNDAL module;
+ laplace: the *case study* proposed into the OpenACC documentation, this is used for profiling study:
  - `fundal_laplace_baseline.F90`, baseline test without device acceleration;
  - `fundal_laplace_dev_inline.F90 `, test with device acceleration, all *inline*;
  - `fundal_laplace_dev_routine.F90`, test with device acceleration, parallel loop in external module;

---
#### Build tests

To build all tests do:

##### OpenACC-NVF
```shell
FoBiS.py build -mode fundal-test-oac-nvf
```

##### OpenMP-IFX
```shell
FoBiS.py build -mode fundal-test-omp-ifx
```

##### OpenACC-GNU
```shell
FoBiS.py build -mode fundal-test-oac-gnu
```

---
#### Build and Run tests (except laplace profiling study)

To build and run all tests do:

##### OpenACC-NVF
```shell
FoBiS.py rule -ex build-run-tests-oac-nvf
```

##### OpenMP-IFX
```shell
FoBiS.py rule -ex build-run-tests-omp-ifx
```

##### OpenACC-GNU
```shell
FoBiS.py rule -ex build-run-tests-oac-gnu
```

To only run all-in-once pre-built tests  do:
```shell
./util/run_tests.sh
```

---
### Laplace iteration, profiling case study
The `./src/tests/laplace/` contains tests used for profiling FUNDAL in a more complex scenario, in particular there are:
- `fundal_laplace_baseline.F90`, baseline test without device acceleration;
- `fundal_laplace_dev_inline.F90 `, test with device acceleration, all *inline*;
- `fundal_laplace_dev_routine.F90`, test with device acceleration, parallel loop in external module;

To build laplace profiling tests do:

##### OpenACC-NVF
```shell
FoBiS.py rule -ex build-laplace-baseline-nvf
FoBiS.py rule -ex build-laplace-oac-nvf
```

##### OpenMP-IFX
```shell
FoBiS.py rule -ex build-laplace-baseline-ifx
FoBiS.py rule -ex build-laplace-omp-ifx
```

##### OpenACC-GNU
```shell
FoBiS.py rule -ex build-laplace-baseline-gnu
FoBiS.py rule -ex build-laplace-oac-gnu
```

---
### Compilers Proofs
Aside FUNDAL tests there are tests dedicated to only test compilers support for latest OpenACC/OpenMP specs. These tests are contained in
`compilers_proofs` directory. To build these proofs do:

##### OpenACC-NVF
```shell
FoBiS.py rule -ex build-compilers-proofs-oac-nvf
```

##### OpenACC-GNU
```shell
FoBiS.py rule -ex build-compilers-proofs-oac-gnu
```
