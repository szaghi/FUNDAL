call MPI_COMM_RANK(local_comm, local_rank, ierr)     ! local_comm: the ranks of this node (set by do_device_init)
mine = [mpih%myrank, local_rank, mydev]              ! dev_init chose mydev = mod(local_rank, devs_number)
allocate(table(3,0:mpih%procs_number-1))
call MPI_GATHER(mine, 3, MPI_INTEGER, table, 3, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
if (mpih%myrank == 0) then
   do p=0, mpih%procs_number - 1
      print '(A,I0,A,I0,A,I0)', 'rank ', table(1,p), ': local rank ', table(2,p), ', device ', table(3,p)
   enddo
endif
