---
title: Installation
---

# Installation

## Requirements

- A Fortran 2008 compiler with the C preprocessor, and for a device build an OpenACC or OpenMP offload implementation:

| Compiler | Backend | Macros | Offload flags | Status |
|---|---|---|---|---|
| NVIDIA nvfortran | OpenACC | `-DDEV_OAC -DCOMPILER_NVF` | `-acc -gpu=ccXX` | maintained on NVIDIA GPUs by the authors |
| GNU gfortran | OpenACC | `-DDEV_OAC -DCOMPILER_GNU` | `-fopenacc` | tested in CI, on the host (see below) |
| Intel ifx | OpenMP | `-DDEV_OMP` | `-fiopenmp -fopenmp-targets=spir64` | maintained by the authors; ifx has no OpenACC |
| AMD amdflang | OpenMP | `-DDEV_OMP -DDEV_HIP` | `-fopenmp --offload-arch=gfxXXX`, link `-lamdhip64` | maintained by the authors |
| any of them | none (compile-time CPU mode) | `-DCOMPILER_NVF`/`-DCOMPILER_GNU` or none | none | maintained by the authors |

- A build tool: [FoBiS](https://github.com/szaghi/FoBiS) 3.8 or newer (`pip install FoBiS.py`, command `fobis`), GNU
  make, [CMake](https://cmake.org) 3.18 or newer, or [fpm](https://fpm.fortran-lang.org) 0.12 or newer.
- Optional: an MPI library with the Fortran `mpi` module, for the [MPI handler](/reference/mpi).

The continuous integration builds and runs the test suite with gfortran and the OpenACC backend only, on a machine
without a GPU: the runs happen on the host. The other builds are maintained on the authors' machines.

::: warning gfortran and OpenACC
`gfortran -fopenacc` runs the kernels on the host unless gfortran is built with an offload target (nvptx or amdgcn)
and the device runtime is installed. FUNDAL then reports a [host fallback](/reference/devices#host-fallback) at
`dev_init`. With gfortran, `DEVICEVAR` expands to `present`, which the OpenACC runtime checks against its present table:
only the host runs are tested.
:::

## Build with FoBiS

The default mode, `fundal-lib-gnu`, builds only the static library with gfortran in the compile-time CPU mode, into
`build/fobis-lib-gnu/` (`libfundal.a`, `mod/`, `obj/`); it is what `fobis build` and `scripts/install.sh` build when no
mode is given. The `fobos` file also defines one `fundal-test-*` mode per compiler and backend; each builds the library
sources and the test programs of `src/tests` into `exe/` (objects in `exe/obj/`, modules in `exe/mod/`):

```bash
git clone https://github.com/szaghi/FUNDAL && cd FUNDAL
fobis build                                 # default mode: build/fobis-lib-gnu/libfundal.a
fobis build --lmodes                        # list the modes
fobis build --mode fundal-test-oac-nvf      # nvfortran + OpenACC
fobis build --mode fundal-test-omp-ifx      # ifx + OpenMP offload
fobis build --mode fundal-test-oac-gnu      # gfortran + OpenACC
fobis build --mode fundal-test-omp-amd      # amdflang + OpenMP offload (--varset gfx90a, ... selects the GPU)
fobis build --mode fundal-test-gnu          # gfortran, compile-time CPU mode
bash scripts/run_tests.sh                   # run every program of exe/
```

The modes with `mpi` in their name (`fundal-test-oac-mpi-nvf`, ...) also build `fundal_mpih_object` and the MPI test
with the MPI wrapper. `fobis rule --ex build-run-tests-oac-nvf` (and `-omp-ifx`, `-oac-gnu`, `-omp-amd`) cleans,
builds and runs in one step. `exe/` is shared by every mode: run `fobis clean` before switching compiler or backend.

The nvfortran templates target `-gpu=cc89`; edit `fobos` (or use make, below) for another GPU.

## Build with make

The makefile builds the static library, with the same compiler templates as `fobos`, into
`build/<COMPILER>-<BACKEND>/` (`libfundal.a`, `mod/`, `obj/`):

```bash
make                                      # gfortran, compile-time CPU mode: build/gnu-none
make COMPILER=gnu BACKEND=oac             # gfortran + OpenACC: build/gnu-oac
make COMPILER=nvf BACKEND=oac GPU=cc90    # nvfortran + OpenACC for compute capability 9.0 (default cc89)
make COMPILER=ifx BACKEND=omp             # ifx + OpenMP offload (spir64)
make COMPILER=amd BACKEND=omp GPU=gfx942  # amdflang + OpenMP offload (default gfx90a), needs a ROCm environment
make COMPILER=gnu BACKEND=oac MPI=1       # also fundal_mpih_object, compiled by $(MPIFC) (default mpif90)
make COMPILER=gnu BACKEND=oac tests       # the test programs of src/tests into build/gnu-oac/tests/
make COMPILER=gnu BACKEND=oac clean       # remove build/gnu-oac
```

| Variable | Values | Default |
|---|---|---|
| `COMPILER` | `gnu`, `nvf`, `ifx`, `amd` | `gnu` |
| `BACKEND` | `none`, `oac`, `omp` | `none` |
| `GPU` | nvfortran compute capability (`cc80`, `cc89`, ...) or AMD architecture (`gfx90a`, ...) | `cc89`, `gfx90a` |
| `MPI` | `1`: build the MPI handler with `MPIFC` | `0` |
| `MPIFC` | MPI wrapper | `mpif90` (`mpiifx` for ifx) |
| `FC`, `FFLAGS` | compiler and optimization flags | from the template |

## Build with CMake

`CMakeLists.txt` builds the static library and the test programs of `src/tests`, with the same compiler templates as
`fobos`; the compiler macros (`COMPILER_GNU`, `COMPILER_NVF`) follow the compiler CMake detects:

```bash
cmake -B build                                         # compile-time CPU mode, the default compiler (gfortran)
cmake -B build -DFUNDAL_BACKEND=oac                    # gfortran + OpenACC
cmake -B build -DCMAKE_Fortran_COMPILER=nvfortran -DFUNDAL_BACKEND=oac -DFUNDAL_GPU=cc90
cmake -B build -DCMAKE_Fortran_COMPILER=ifx -DFUNDAL_BACKEND=omp
cmake -B build -DCMAKE_Fortran_COMPILER=amdflang -DFUNDAL_BACKEND=omp -DFUNDAL_GPU=gfx942
cmake -B build -DFUNDAL_BACKEND=oac -DFUNDAL_MPI=ON     # also fundal_mpih_object and the MPI test (find_package(MPI))
cmake --build build                                    # build/libfundal.a, build/mod/, build/tests/
ctest --test-dir build                                 # run the tests ("_xfail_" ones must fail)
cmake --install build --prefix $HOME/opt/fundal        # lib/, include/fundal/ (modules and fundal.H), lib/cmake/FUNDAL/
```

| Option | Values | Default |
|---|---|---|
| `FUNDAL_BACKEND` | `none`, `oac` (gfortran, nvfortran), `omp` (ifx, amdflang) | `none` |
| `FUNDAL_GPU` | nvfortran compute capability or AMD architecture | `cc89`, `gfx90a` |
| `FUNDAL_MPI` | build the MPI handler | `OFF` |
| `FUNDAL_BUILD_TESTS` | build the tests of `src/tests` | `ON` when FUNDAL is the top-level project |

`CMAKE_BUILD_TYPE` defaults to `Release`. An unsupported compiler and backend pair stops the configuration.

## Build with fpm

`fpm.toml` builds the library in the compile-time CPU mode, without the MPI handler (fpm cannot leave a file out of a
library: the macro `FUNDAL_NO_MPI` empties `fundal_mpih_object`). A backend is selected with `--flag`:

```bash
fpm build                                              # compile-time CPU mode
fpm test                                               # the tests of src/tests ("_xfail_" ones are not listed)
fpm build --flag "-DDEV_OAC -DCOMPILER_GNU -fopenacc"  # gfortran + OpenACC
fpm install --prefix $HOME/opt/fundal                  # lib/libFUNDAL.a and include/ (modules)
```

Pass the same `--flag` to every fpm command of a build (`build`, `test`, `install`): fpm keeps a separate build per flag
set. For the MPI handler use FoBiS, make or CMake.

## Use FUNDAL in your project

Whatever builds FUNDAL, your program needs three things:

1. the **module directory** of the FUNDAL build (`-I build/gnu-oac/mod`, ...) and the library (`libfundal.a`);
2. **`src/lib` on the include path**, for `fundal.H` (`-I FUNDAL/src/lib`), if your sources use the kernel macros;
3. the **same macros** FUNDAL was built with: `-DDEV_OAC` or `-DDEV_OMP` (AMD: also `-DDEV_HIP`), and with OpenACC
   `-DCOMPILER_NVF` or `-DCOMPILER_GNU`. They select the backend in `fundal.H`: a program preprocessed with other
   macros than the library gets the wrong clauses in its kernels.

For example, the programs of this documentation are built as:

```bash
make COMPILER=gnu BACKEND=oac
gfortran -cpp -DCOMPILER_GNU -DDEV_OAC -fopenacc -I src/lib -I build/gnu-oac/mod \
         quickstart.F90 build/gnu-oac/libfundal.a -o quickstart
```

and with nvfortran:

```bash
make COMPILER=nvf BACKEND=oac GPU=cc89
nvfortran -cpp -DCOMPILER_NVF -DDEV_OAC -acc -gpu=cc89 -I src/lib -module build/nvf-oac/mod \
          quickstart.F90 build/nvf-oac/libfundal.a -o quickstart
```

**CMake projects** use the installed package; `FUNDAL::fundal` carries the backend macros, the offload flags and the
include directory of `fundal.H`, so your kernels get the same backend as the library:

```cmake
find_package(FUNDAL 2 REQUIRED)            # -DCMAKE_PREFIX_PATH=$HOME/opt/fundal
add_executable(quickstart quickstart.F90)
set_target_properties(quickstart PROPERTIES Fortran_PREPROCESS ON)
target_link_libraries(quickstart PRIVATE FUNDAL::fundal)
```

`add_subdirectory(FUNDAL)` works as well (the tests are then off) and defines the same target. The variables
`FUNDAL_BACKEND` and `FUNDAL_MPI` of the package tell how it was built.

**fpm projects** declare the dependency; `fundal.H` is on the include path of the dependents:

```toml
[dependencies]
FUNDAL = { git = "https://github.com/szaghi/FUNDAL", branch = "main" }
```

This follows `main`, which always has the features of this documentation. For a fixed version, use `tag = "vX.Y.Z"`
with a [release](https://github.com/szaghi/FUNDAL/releases) (`:: tag=vX.Y.Z` in a `fobos`).

The dependency is built in the compile-time CPU mode; for a backend, pass the macros and offload flags with `--flag`
to the fpm commands of your project.

**FoBiS projects** can fetch FUNDAL as a dependency and compile its sources with their own: declare it in your `fobos`,

```ini
[dependencies]
FUNDAL = https://github.com/szaghi/FUNDAL
```

run `fobis fetch` (it clones into `.fobis_deps/FUNDAL`), and in your build mode add the macros to `preproc`,
`.fobis_deps/FUNDAL/src/lib` to `include`, and exclude what is not library: `.fobis_deps/FUNDAL/src/tests`,
`.fobis_deps/FUNDAL/src/examples`, `.fobis_deps/FUNDAL/docs` and `.fobis_deps/FUNDAL/compilers_proofs` in
`exclude_dirs`, and `fundal_mpih_object.F90` in `exclude` when you do not use MPI.

## Compiler notes

- **nvfortran**: pass the compute capability of your GPU (`-gpu=cc80` A100, `cc89` RTX 40, `cc90` H100). `-Minfo=accel`
  reports which loops became kernels.
- **amdflang**: `--offload-arch` must match the GPU (`rocminfo` shows it); the HIP runtime (`libamdhip64`) is found
  through the ROCm environment (`ROCM_PATH`, `LIBRARY_PATH`, `LD_LIBRARY_PATH`): load it before building and running.
- **ifx**: OpenMP offload to Intel GPUs through `spir64`; without an Intel GPU the kernels run on the host. ifx has no
  OpenACC, so `DEV_OAC` is not an option.
- **gfortran**: see the warning above. In the compile-time CPU mode no OpenACC or OpenMP flag is needed.
- **CPU mode with OpenMP**: in the compile-time CPU mode the `!$omp` lines become `!$omp parallel do`, so building with
  OpenMP enabled (the ifx and amdflang templates do) runs the kernels on host threads.
