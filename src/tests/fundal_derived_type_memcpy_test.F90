!< FUNDAL, device memory copy into derived type test.

#include "fundal.H"

program fundal_derived_type_memcpy_test
!< FUNDAL, device memory copy into derived type test.

use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use fundal

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

! initialize environment global variables
myhos = dev_get_host_num()
devtype = dev_get_device_type()
call dev_set_device_num(0)
mydev = dev_get_device_num()

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
call dev_alloc(fptr_dev=dt%a_dev, ubounds=[dt%n], ierr=error)
if (error /= 0) then
   print '(A)', 'error: a_dev not allocated!'
   stop
endif
call dev_alloc(fptr_dev=dt%b_dev, ubounds=[dt%n], ierr=error)
if (error /= 0) then
   print '(A)', 'error: b_dev not allocated!'
   stop
endif
call dev_alloc_unstr(dt%a)
call dev_alloc_unstr(dt%b)

! copy host memory to device one
print '(A)', 'copy a to device'
call dev_memcpy_to_device(src=dt%a, dst=dt%a_dev)
call dev_memcpy_to_device_unstr(dt%a)

! do some operation on device
print '(A)', 'compute b on device'
!$acc parallel loop DEVICEVAR(dt%a_dev, dt%b_dev, dt%a, dt%b)
#ifdef DEV_OMP
!$omp OMPLOOP DEVICEPTR(dt%a_dev, dt%b_dev)
#else
!$omp OMPLOOP
#endif
do i = 1, dt%n
   dt%b_dev(i) = dt%a_dev(i) + 10
   dt%b(    i) = dt%a(    i) + 10
enddo

! copy dev memory to host one
print '(A)', 'copy b to host'
call dev_memcpy_from_device(src=dt%b_dev, dst=dt%b)

! check results
print '(A)', 'chek results'
do i=1, dt%n
   if (int(dt%b(i) - dt%a(i),I4P) /= 10_I4P) then
      print '(A)', 'error: something is not working...'
      stop
   endif
enddo

! copy dev memory to host one by unstructured approach
print '(A)', 'copy b to host from unstructured memory'
call dev_memcpy_from_device_unstr(dt%b)

! check results
print '(A)', 'chek results'
do i=1, dt%n
   if (int(dt%b(i) - dt%a(i),I4P) /= 10_I4P) then
      print '(A)', 'error: something is not working...'
      stop
   endif
enddo

print '(A)', 'test passed'
endprogram fundal_derived_type_memcpy_test
