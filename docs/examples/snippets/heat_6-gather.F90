allocate(t_loc(first-1:last+1))
call dev_memcpy_from_device(dst=t_loc, src=t_dev)
t = 0._R8P
t(first:last) = t_loc(first:last) ! each rank fills its cells, zero elsewhere: the sum is the whole field
call MPI_REDUCE(t, t_all, n+2, MPI_DOUBLE_PRECISION, MPI_SUM, 0, MPI_COMM_WORLD, ierr)
if (mpih%myrank == 0) then
   do p=0, mpih%procs_number - 1
      print '(A,I0,A,I0,A,I0)', 'rank ', p, ' owns the cells ', p * n / mpih%procs_number + 1, ' to ', &
                                (p + 1) * n / mpih%procs_number
   enddo
   exact = (1._R8P - 4._R8P * r * sin(pi * dx / 2._R8P)**2)**steps * [(sin(pi*i*dx), i=0, n+1)]
   exact(0) = 0._R8P ; exact(n+1) = 0._R8P
   print '(A,I0,A,F7.5)', 'temperature at the centre after ', steps, ' steps: ', t_all((n+1)/2)
   print '(A,L1)', 'equal to the exact discrete solution: ', maxval(abs(t_all - exact)) < 1.e-12_R8P
endif
