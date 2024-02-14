!< OAFML, device memory copy into derived type test.
program oafml_derived_type_memcpy_test
!< OAFML, device memory copy into derived type test.

use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use oafml

implicit none

type :: dt_object
   integer(I4P)           :: n =1000          !< Number of elements of arrays.
   real(R8P), pointer     :: a_dev(:)=>null() !< Array on device memory.
   real(R8P), pointer     :: b_dev(:)=>null() !< Array on device memory.
   real(R8P), allocatable :: a(:)             !< Array on host memory.
   real(R8P), allocatable :: b(:)             !< Array on host memory.
endtype dt_object

type(dt_object) :: dt    !< Derived type containing both host and device memory.
integer(I4P)    :: error !< Error status.
character(10)   :: nstr  !< Number of elements of arrays, stringified.
integer(I4P)    :: i     !< Counter.

! get arrays dimension
if (command_argument_count() >= 1) then
   call get_command_argument(1, nstr)
   read(nstr, *) dt%n
   if (dt%n <= 0) dt%n = 1000
endif

! allocate host memory and initialize it
allocate(dt%a(dt%n), dt%b(dt%n))
do i = 1, dt%n
   dt%a(i) = i
enddo

! allocate device memory
call oac_alloc(fptr_dev=dt%a_dev, ubounds=[dt%n], ierr=error)
if (error /= 0) then
   print*, 'error: a_dev not allocated!'
   stop
endif
call oac_alloc(fptr_dev=dt%b_dev, ubounds=[dt%n], ierr=error)
if (error /= 0) then
   print*, 'error: b_dev not allocated!'
   stop
endif

! copy host memory to device one
print*, 'copy a to a_dev'
call oac_memcpy_to_device(fptr_src=dt%a, fptr_dst=dt%a_dev)

! do some operation on device
print*, 'compute b_dev on device'
!$acc parallel loop deviceptr(dt%a_dev, dt%b_dev)
do i = 1, dt%n
   dt%b_dev(i) = dt%a_dev(i) + 10
enddo

! copy dev memory to host one
print*, 'copy b_dev to b'
call oac_memcpy_from_device(fptr_src=dt%b_dev, fptr_dst=dt%b)

! check results
print*, 'chek results'
do i=1, dt%n
   if ((dt%b(i) - dt%a(i)) /= 10) then
      print*, 'error: something is not working...'
      stop
   endif
enddo
print*, 'no errors happen'
endprogram oafml_derived_type_memcpy_test
