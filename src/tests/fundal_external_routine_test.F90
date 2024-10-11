!< FUNDAL, use device memory in external routine test.

#include "fundal.H"

module fundal_routine_definition
!< FUNDAL, use device memory in external routine test.
!< External routine module definition.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64

implicit none
private
public :: do_work_ptr
public :: do_work_unstr

contains
   subroutine do_work_ptr(n, a)
   !< Do work on device memory, pointer approach.
   integer(I4P), intent(in)            :: n        !< Array dimension.
   real(R8P),    intent(inout), target :: a(0:,0:) !< Array.
   integer(I4P)                        :: i, j     !< Counter.

   !$acc parallel loop collapse(2) DEVICEVAR(a)
   !$omp OMPLOOP collapse(2) DEVICEVAR(a)
   do j=0,n
      do i=0,n
         a(i,j) = 1._R8P * (i**3 - j**2)
      enddo
   enddo
   endsubroutine do_work_ptr

   subroutine do_work_unstr(n, a)
   !< Do work on device memory, unstructured approach.
   integer(I4P), intent(in)            :: n        !< Array dimension.
   real(R8P),    intent(inout), target :: a(0:,0:) !< Array.
   integer(I4P)                        :: i, j     !< Counter.

   !$acc parallel loop collapse(2) present(a)
   !$omp OMPLOOP collapse(2) DEVICEVAR(a)
   do j=0,n
      do i=0,n
         a(i,j) = 1._R8P * (i**3 - j**2)
      enddo
   enddo
   endsubroutine do_work_unstr
endmodule fundal_routine_definition

program fundal_external_routine_test
!< FUNDAL, use device memory in external routine test.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal
use            :: fundal_routine_definition

integer(I4P), parameter :: n=128  !< Array dimension.
real(R8P), pointer      :: a(:,:) !< Array on device memory.
real(R8P), allocatable  :: b(:,:) !< Array on host   memory.

! initialize environment global variables
myhos = dev_get_host_num()
devtype = dev_get_device_type()
call dev_set_device_num(0)
mydev = dev_get_device_num()

call dev_alloc(fptr_dev=a,lbounds=[0,0],ubounds=[n,n],ierr=ierr,init_value=0._R8P)
allocate(b(0:n,0:n))

print '(A)', 'test pointer approach'
call do_work_ptr(n=n, a=a)

call dev_memcpy_from_device(dst=b, src=a)

if ((int(minval(b),I4P)/=-n**2).or.(int(maxval(b),I4P)/=n**3)) then
   print '(A)', 'error: result is wrong'
   stop
endif

call dev_free(A,mydev)

print '(A)', 'test unstructured approach'
call dev_alloc_unstr(fptr_dev=b,init_value=0._R8P)

call do_work_unstr(n=n, a=b)

call dev_memcpy_from_device_unstr(b)

if ((int(minval(b),I4P)/=-n**2).or.(int(maxval(b),I4P)/=n**3)) then
   print '(A)', 'error: result is wrong'
   stop
endif

deallocate(b)

print '(A)', 'test passed'
endprogram fundal_external_routine_test
