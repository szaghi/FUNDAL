call mpih%initialize(do_mpi_init=.true., do_device_init=.true.) ! MPI_Init, then dev_init(local_rank=...)
first = mpih%myrank * n / mpih%procs_number + 1                   ! this rank owns the cells first:last
last  = (mpih%myrank + 1) * n / mpih%procs_number
left  = mpih%myrank - 1 ; if (mpih%myrank == 0) left = MPI_PROC_NULL
right = mpih%myrank + 1 ; if (mpih%myrank == mpih%procs_number - 1) right = MPI_PROC_NULL
