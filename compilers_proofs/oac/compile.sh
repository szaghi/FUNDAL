mpif90 -acc -gpu=cc89 -fast -Minfo=all test_deviceptr_mpi.f90  -o test_deviceptr_mpi-fortran
mpicc  -acc -gpu=cc89 -fast -Minfo=all test_deviceptr_mpi.c    -o test_deviceptr_mpi-c

nvfortran -acc -gpu=cc89 -fast -Minfo=all test_deviceptr.f90 -o test_deviceptr
nvfortran -acc -gpu=cc89 -fast -Minfo=all test_present.f90   -o test_present
