local_sum = 0._R8P
!$acc parallel loop reduction(+:local_sum) DEVICEVAR(a_dev)
!$omp OMPLOOP reduction(+:local_sum) DEVICEPTR(a_dev)
do i=1, n
   a_dev(i) = real(offset + i, R8P)  ! the global numbers 1, 2, ..., n * procs
   local_sum = local_sum + a_dev(i)
enddo
call MPI_ALLREDUCE(local_sum, global_sum, 1, MPI_DOUBLE_PRECISION, MPI_SUM, MPI_COMM_WORLD, ierr)
