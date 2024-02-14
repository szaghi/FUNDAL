!< OAFML, device memory copy test.
program oafml_memcpy_test
!< OAFML, device memory copy test.

use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use oafml

implicit none

real(R8P), pointer             :: a_dev(:)=>null() !< Array on device memory.
real(R8P), pointer             :: b_dev(:)=>null() !< Array on device memory.
real(R8P), allocatable, target :: a(:)             !< Array on host memory.
real(R8P), allocatable, target :: b(:)             !< Array on host memory.
integer(I4P)                   :: error            !< Error status.
integer(I4P)                   :: n                !< Number of elements of arrays.
character(10)                  :: nstr             !< Number of elements of arrays, stringified.
integer(I4P)                   :: i                !< Counter.

! get arrays dimension
n = 1000
if(command_argument_count() >= 1)then
   call get_command_argument(1, nstr)
   read(nstr, *) n
   if (n <= 0) n = 1000
endif

! allocate host memory and initialize it
allocate(a(n), b(n))
do i = 1, n
   a(i) = i
enddo

! allocate device memory
call oac_alloc(fptr_dev=a_dev, ubounds=[n], ierr=error)
if (error /= 0) then
   print*, 'error: a_dev not allocated!'
   stop
endif
call oac_alloc(fptr_dev=b_dev, ubounds=[n], ierr=error)
if (error /= 0) then
   print*, 'error: b_dev not allocated!'
   stop
endif

! copy host memory to device one
print*, 'copy a to a_dev'
call oac_memcpy_to_device(fptr_src=a, fptr_dst=a_dev)

! do some operation on device
print*, 'compute b_dev on device'
!$acc parallel loop deviceptr(a_dev, b_dev)
do i = 1, n
   b_dev(i) = a_dev(i) + 10
enddo

! copy dev memory to host one
print*, 'copy b_dev to b'
call oac_memcpy_from_device(fptr_src=b_dev, fptr_dst=b)

! check results
print*, 'chek results'
do i=1, n
   if ((b(i) - a(i)) /= 10) then
      print*, 'error: something is not working...'
      stop
   endif
enddo
print*, 'no errors happen'
endprogram oafml_memcpy_test
