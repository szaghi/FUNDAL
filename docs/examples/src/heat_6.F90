!run heat_6 mpirun --oversubscribe -np 2 heat_6
#include "fundal.H"

program heat_6
!< Tutorial, chapter 6: several devices with MPI, one per rank, halo exchange through host buffers.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: mpi
use            :: fundal
use            :: fundal_mpih_object
implicit none
integer(I4P), parameter :: n=15             ! interior cells of the whole domain
integer(I4P), parameter :: steps=50         ! time steps
real(R8P),    parameter :: r=0.25_R8P       ! alpha*dt/dx**2
real(R8P),    parameter :: pi=acos(-1._R8P) ! pi
real(R8P),    parameter :: dx=1._R8P/(n+1)  ! cell size
type(mpih_object)       :: mpih             ! MPI handler
real(R8P), pointer      :: t_dev(:)=>null() ! temperature of this rank (global indexes), on the device
real(R8P), pointer      :: tn_dev(:)=>null()! temperature at the next step, on the device
real(R8P), pointer      :: swap(:)=>null()  ! pointer swap
real(R8P), allocatable  :: t_loc(:)         ! temperature of this rank, on the host
real(R8P)               :: t(0:n+1)         ! whole temperature, on the host
real(R8P)               :: t_all(0:n+1)     ! whole temperature, gathered on rank 0
real(R8P)               :: exact(0:n+1)     ! exact solution of the discrete problem
real(R8P)               :: edge(2)          ! first and last cell of this rank, sent to the neighbours
real(R8P)               :: ghost(2)         ! ghost cells received from the neighbours
integer(I4P)            :: first, last      ! cells of this rank
integer(I4P)            :: left, right      ! neighbour ranks (MPI_PROC_NULL at the physical boundaries)
integer(I4P)            :: i, s, p          ! counters
integer(I4P)            :: ierr             ! error status

!region init
call mpih%initialize(do_mpi_init=.true., do_device_init=.true.) ! MPI_Init, then dev_init(local_rank=...)
first = mpih%myrank * n / mpih%procs_number + 1                   ! this rank owns the cells first:last
last  = (mpih%myrank + 1) * n / mpih%procs_number
left  = mpih%myrank - 1 ; if (mpih%myrank == 0) left = MPI_PROC_NULL
right = mpih%myrank + 1 ; if (mpih%myrank == mpih%procs_number - 1) right = MPI_PROC_NULL
!endregion init
!region alloc
call dev_alloc(fptr_dev=t_dev,  lbounds=[first-1], ubounds=[last+1], ierr=ierr, init_value=0._R8P, label='t')
if (ierr /= 0) call mpih%abort(msg='device allocation failed')
call dev_alloc(fptr_dev=tn_dev, lbounds=[first-1], ubounds=[last+1], ierr=ierr, init_value=0._R8P, label='tn')
if (ierr /= 0) call mpih%abort(msg='device allocation failed')
t = [(sin(pi*i*dx), i=0, n+1)]
t(0) = 0._R8P ; t(n+1) = 0._R8P
call dev_memcpy_to_device(dst=t_dev, src=t(first-1:last+1)) ! only the cells of this rank, and its ghosts
!endregion alloc

do s=1, steps
   !region halo
   call dev_memcpy_from_device(dst=edge(1:1), src=t_dev(first:first)) ! device -> host buffer
   call dev_memcpy_from_device(dst=edge(2:2), src=t_dev(last:last))
   call MPI_SENDRECV(edge(2), 1, MPI_DOUBLE_PRECISION, right, 0, ghost(1), 1, MPI_DOUBLE_PRECISION, left,  0, &
                     MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
   call MPI_SENDRECV(edge(1), 1, MPI_DOUBLE_PRECISION, left,  1, ghost(2), 1, MPI_DOUBLE_PRECISION, right, 1, &
                     MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
   if (left  /= MPI_PROC_NULL) call dev_memcpy_to_device(dst=t_dev(first-1:first-1), src=ghost(1:1)) ! host -> device
   if (right /= MPI_PROC_NULL) call dev_memcpy_to_device(dst=t_dev(last+1:last+1),   src=ghost(2:2))
   !endregion halo
   !$acc parallel loop DEVICEVAR(t_dev, tn_dev)
   !$omp OMPLOOP DEVICEPTR(t_dev, tn_dev)
   do i=first, last
      tn_dev(i) = t_dev(i) + r * (t_dev(i-1) - 2._R8P * t_dev(i) + t_dev(i+1))
   enddo
   swap => t_dev ; t_dev => tn_dev ; tn_dev => swap
enddo

!region gather
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
!endregion gather
call dev_free(t_dev)
call dev_free(tn_dev)
call mpih%finalize
endprogram heat_6
