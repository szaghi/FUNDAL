#include "fundal.H"

program quickstart
!< A first FUNDAL program: device memory, copies, a kernel.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal
implicit none
integer(I4P), parameter :: n=8              ! array size
real(R8P), pointer      :: a_dev(:)=>null() ! device memory
real(R8P)               :: a(n)             ! host memory
integer(I4P)            :: i                ! counter
integer(I4P)            :: ierr             ! error status

call dev_init                                          ! select the device
call dev_alloc(fptr_dev=a_dev, ubounds=[n], ierr=ierr) ! allocate on the device
if (ierr /= 0) error stop 'device allocation failed'
a = [(real(i, R8P), i=1, n)]
call dev_memcpy_to_device(dst=a_dev, src=a)            ! host -> device

!$acc parallel loop DEVICEVAR(a_dev)
!$omp OMPLOOP DEVICEPTR(a_dev)
do i=1, n                                              ! a kernel, on the device
   a_dev(i) = 2._R8P * a_dev(i)
enddo

call dev_memcpy_from_device(dst=a, src=a_dev)          ! device -> host
call dev_free(a_dev)                                   ! release the device memory
print '(A,*(F5.1))', 'a:', a
print '(A,L1)', 'doubled on the device: ', all(a == [(2._R8P * i, i=1, n)])
endprogram quickstart
