call dev_memcpy_from_device(dst=edge(1:1), src=t_dev(first:first)) ! device -> host buffer
call dev_memcpy_from_device(dst=edge(2:2), src=t_dev(last:last))
call MPI_SENDRECV(edge(2), 1, MPI_DOUBLE_PRECISION, right, 0, ghost(1), 1, MPI_DOUBLE_PRECISION, left,  0, &
                  MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
call MPI_SENDRECV(edge(1), 1, MPI_DOUBLE_PRECISION, left,  1, ghost(2), 1, MPI_DOUBLE_PRECISION, right, 1, &
                  MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
if (left  /= MPI_PROC_NULL) call dev_memcpy_to_device(dst=t_dev(first-1:first-1), src=ghost(1:1)) ! host -> device
if (right /= MPI_PROC_NULL) call dev_memcpy_to_device(dst=t_dev(last+1:last+1),   src=ghost(2:2))
