!< FUNDAL, MPI test.

#include "fundal.H"

program fundal_mpi_dev_alloc_test
!< FUNDAL, MPI test.

use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: mpi
use            :: fundal
use            :: fundal_mpih_object

implicit none

type(mpih_object)         :: mpih               !< MPI handler.
real(R8P), pointer        :: a00(:,:,:)=>null() !< Array on process 0.
real(R8P), pointer        :: a01(:,:,:)=>null() !< Array of process 1 on process 0, device memory.
real(R8P), pointer        :: a11(:,:,:)=>null() !< Array on process 1.
real(R8P), allocatable    :: a00_h(:,:,:)       !< Array on process 0, host memory.
real(R8P), allocatable    :: a01_h(:,:,:)       !< Array of process 1 on process 0, host memory.
real(R8P), allocatable    :: a11_h(:,:,:)       !< Array on process 1, host memory.
integer(I4P)              :: i, j, k            !< Counter.
integer(I4P), allocatable :: req_recv(:)        !< MPI request receive flags.

call mpih%initialize(do_mpi_init=.true., do_device_init=.true., verbose=.true.)
allocate(req_recv(0:mpih%procs_number-1))
req_recv = MPI_REQUEST_NULL

if (mpih%myrank == 0_I4P)  then
   call dev_alloc(fptr_dev=a00, ubounds=[1,2,3], ierr=mpih%error, init_value=0._R8P)
   call dev_alloc(fptr_dev=a01, ubounds=[1,2,3], ierr=mpih%error, init_value=0._R8P)
   allocate(a00_h(1,2,3)) ; a00_h = 0._R8P
   allocate(a01_h(1,2,3)) ; a01_h = 0._R8P
endif
if (mpih%myrank == 1_I4P) then
   call dev_alloc(fptr_dev=a11, ubounds=[1,2,3], ierr=mpih%error, init_value=0._R8P)
   allocate(a11_h(1,2,3)) ; a11_h = 0._R8P
endif

call mpih%barrier

if (mpih%myrank == 0_I4P) then
   print '(A)', mpih%myrankstr//'Device 0 prepare (on device and copy back to host) a00 array'
   !$acc parallel loop independent collapse(3) DEVICEVAR(a00)
   !$omp OMPLOOP collapse(3) DEVICEPTR(a00)
   do k=1, 3
   do j=1, 2
   do i=1, 1
      a00(i,j,k) = i * 1._R8P
   enddo
   enddo
   enddo
   call dev_memcpy_from_device(a00_h, a00)
   print '(A)', mpih%myrankstr//'a00 arrays: '
   call print_array(a=a00_h)
   print '(A)', ''
endif

call mpih%barrier

if (mpih%myrank == 1_I4P) then
   print '(A)', mpih%myrankstr//'Device 1 prepare (on device and copy back to host) a11 array'
   !$acc parallel loop independent collapse(3) DEVICEVAR(a11)
   !$omp OMPLOOP collapse(3) DEVICEPTR(a11)
   do k=1, 3
   do j=1, 2
   do i=1, 1
      a11(i,j,k) = i * 2._R8P
   enddo
   enddo
   enddo
   call dev_memcpy_from_device(a11_h, a11)
   print '(A)', mpih%myrankstr//'a11 array: '
   call print_array(a=a11_h)
   print '(A)', ''
endif

call mpih%barrier

if (mpih%myrank == 0_I4P) print '(A)', mpih%myrankstr//'test MPI send/recv by means of host memory'
if (mpih%myrank == 0_I4P) call MPI_IRECV(a01_h, 6, MPI_REAL8, 1, 100, MPI_COMM_WORLD, req_recv(1), mpih%error)
if (mpih%myrank == 1_I4P) call MPI_SEND( a11_h, 6, MPI_REAL8, 0, 100, MPI_COMM_WORLD,              mpih%error)

call mpih%barrier
if (mpih%myrank == 0_I4P) then
   a00_h = a00_h + a01_h
   print '(A,I3)', mpih%myrankstr//'maxval: ', int(maxval(a00_h),I4P)
   if (int(maxval(a00_h),I4P)==3_I4P) print '(A)', 'test passed'
   print '(A)', ''
endif

call mpih%barrier

if (mpih%myrank == 0_I4P) print '(A)', mpih%myrankstr//'test MPI send/recv by means of device memory'
if (mpih%myrank == 0_I4P) then
   call dev_memcpy_from_device(a01_h, a01)
   print '(A)', mpih%myrankstr//'a01 array before send/recv: '
   call print_array(a=a01_h)
   print '(A)', ''
endif

call mpih%barrier

!$omp target data use_device_ptr(a01,a11)
if (mpih%myrank == 1_I4P) call MPI_SEND( a11, 6, MPI_REAL8, 0, 101, MPI_COMM_WORLD,              mpih%error)
if (mpih%myrank == 0_I4P) call MPI_IRECV(a01, 6, MPI_REAL8, 1, 101, MPI_COMM_WORLD, req_recv(1), mpih%error)
call MPI_WAITALL(mpih%procs_number, req_recv, MPI_STATUSES_IGNORE, mpih%error)
!$omp end target data

call mpih%barrier

if (mpih%myrank == 0_I4P) then
   call dev_memcpy_from_device(a01_h, a01)
   print '(A)', mpih%myrankstr//'a01 array after send/recv: '
   call print_array(a=a01_h)
   print '(A)', ''
endif

call mpih%barrier

if (mpih%myrank == 0_I4P) then
   !$acc parallel loop independent collapse(3) DEVICEVAR(a00,a01)
   !$omp OMPLOOP collapse(3) DEVICEPTR(a00,a01)
   do k=1, 3
   do j=1, 2
   do i=1, 1
      a00(i,j,k) = a00(i,j,k) + a01(i,j,k)
   enddo
   enddo
   enddo
   call dev_memcpy_from_device(a00_h, a00)
   print '(A,I3)', mpih%myrankstr//'maxval: ', int(maxval(a00_h),I4P)
   if (int(maxval(a00_h),I4P)==3_I4P) print '(A)', 'test passed'
endif

call mpih%finalize

contains
   subroutine print_array(a)
   !< Pretty print array.
   real(R8P), intent(in) :: a(:,:,:) !< Input array.
   integer(I4P)          :: i,j,k    !< Counter.

   do k=lbound(a,dim=3), ubound(a,dim=3)
   do j=lbound(a,dim=2), ubound(a,dim=2)
   do i=lbound(a,dim=1), ubound(a,dim=1)
      print '(A,2(I1,1X),I1,A,I3)', mpih%myrankstr//'(i j k): (',i,j,k,'):',int(a(i,j,k))
   enddo
   enddo
   enddo
   endsubroutine print_array
endprogram fundal_mpi_dev_alloc_test
