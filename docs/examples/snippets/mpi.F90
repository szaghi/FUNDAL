#include "fundal.H"

program mpi_recipes
!< Cookbook, MPI: one recipe per command line argument.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: mpi
use            :: fundal
use            :: fundal_mpih_object
implicit none
type(mpih_object) :: mpih   ! MPI handler
character(16)     :: recipe ! recipe to run

call get_command_argument(1, recipe)
call mpih%initialize(do_mpi_init=.true., do_device_init=.true.)
select case(trim(recipe))
case('devices')
   call devices
case('allreduce')
   call allreduce
endselect
call mpih%finalize

contains
   subroutine devices
   !< One device per rank.
   integer(I4P)              :: local_rank ! rank on this node
   integer(I4P)              :: mine(3)    ! rank, local rank, device of this rank
   integer(I4P), allocatable :: table(:,:) ! the same, of every rank, on rank 0
   integer(I4P)              :: p          ! counter
   integer(I4P)              :: ierr       ! error status

   call MPI_COMM_RANK(local_comm, local_rank, ierr)     ! local_comm: the ranks of this node (set by do_device_init)
   mine = [mpih%myrank, local_rank, mydev]              ! dev_init chose mydev = mod(local_rank, devs_number)
   allocate(table(3,0:mpih%procs_number-1))
   call MPI_GATHER(mine, 3, MPI_INTEGER, table, 3, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
   if (mpih%myrank == 0) then
      do p=0, mpih%procs_number - 1
         print '(A,I0,A,I0,A,I0)', 'rank ', table(1,p), ': local rank ', table(2,p), ', device ', table(3,p)
      enddo
   endif
   endsubroutine devices

   subroutine allreduce
   !< A global sum of device results.
   integer(I4P), parameter :: n=100            ! elements per rank
   real(R8P), pointer      :: a_dev(:)=>null() ! device memory
   real(R8P)               :: local_sum        ! sum on this rank
   real(R8P)               :: global_sum       ! sum on every rank
   integer(I4P)            :: i, offset        ! counter, global index of the first element of this rank
   integer(I4P)            :: ierr             ! error status

   call dev_alloc(fptr_dev=a_dev, ubounds=[n], ierr=ierr)
   if (ierr /= 0) call mpih%abort(msg='device allocation failed')
   offset = mpih%myrank * n
   local_sum = 0._R8P
   !$acc parallel loop reduction(+:local_sum) DEVICEVAR(a_dev)
   !$omp OMPLOOP reduction(+:local_sum) DEVICEPTR(a_dev)
   do i=1, n
      a_dev(i) = real(offset + i, R8P)  ! the global numbers 1, 2, ..., n * procs
      local_sum = local_sum + a_dev(i)
   enddo
   call MPI_ALLREDUCE(local_sum, global_sum, 1, MPI_DOUBLE_PRECISION, MPI_SUM, MPI_COMM_WORLD, ierr)
   if (mpih%myrank == 0) then
      print '(A,F9.1)', 'global sum: ', global_sum
      print '(A,L1)', 'equal to m (m+1) / 2, m = n procs: ', &
         global_sum == real(n * mpih%procs_number * (n * mpih%procs_number + 1) / 2, R8P)
   endif
   call dev_free(a_dev)
   endsubroutine allreduce
endprogram mpi_recipes
