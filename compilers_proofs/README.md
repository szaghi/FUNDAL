<a name="top"></a>

# Compilers Proofs

> A loose collection of small programs that check how compilers support some device offloading features. They do not
> use FUNDAL.

### `oac` directory

OpenACC related programs.

+ `clean.sh`: remove the executables built by `compile.sh`.
+ `compile.sh`: build `test_deviceptr`, `test_present` and the two MPI programs with nvfortran/mpif90 (`-acc -gpu=cc89`).
+ `run.sh`: run them (the MPI ones with `mpirun -np 2`).
+ `test_deviceptr.f90`: memory from `acc_malloc` used in a kernel through the `deviceptr` clause.
+ `test_present.f90`: memory from `acc_malloc` used in a kernel through the `present` clause.
+ `test_deviceptr_mpi.f90`: the `deviceptr` clause on `acc_malloc` memory with several MPI processes and devices,
  Fortran version.
+ `test_deviceptr_mpi.c`: the same, C version.
+ `test_dtype-scalar.f90`: a matrix product on pointer components of a derived-type scalar, inside a `data` region.
+ `test_dtype-array.f90`: the same with an array of derived types.
+ `test_pointer_procedure.f90`: a procedure pointer used inside an OpenACC kernel (`routine` directive).
+ `test_omp_oac.f90`: OpenMP threads and OpenACC kernels in the same program (nvfortran `-mp -acc`).

FoBiS rules build the first two:

```bash
fobis rule --ex build-compilers-proofs-oac-nvf
fobis rule --ex build-compilers-proofs-oac-gnu
```
