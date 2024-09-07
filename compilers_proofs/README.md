<a name="top"></a>

# Compilers Proofs

> A not organized collections of tests of compilers support to different features of device offloading.

### `aoc` directory

OpenACC related tests.

+ `clean.sh`: Bash script for cleaning directory.
+ `compile.sh`: Bash script for compiling tests.
+ `run.sh`: Bash script for running tests.
+ `test_deviceptr.f90`: Test `deviceptr` directive of `acc_malloc` variables.
+ `test_deviceptr_mpi.c`: Test `deviceptr` directive of `acc_malloc` variables with multiple MPI connected devices, C verion.
+ `test_deviceptr_mpi.f90`: Test `deviceptr` directive of `acc_malloc` variables with multiple MPI connected devices, fortran verion.
+ `test_present.f90`: Test `present` directive of `acc_malloc` variables.
