!< FUNDAL, use device memory in external routine test.

#include "fundal.H"

module fundal_routine_definition
!< FUNDAL, use device memory in external routine test.
!< External routine module definition.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64

implicit none
private
public :: do_work

contains
   subroutine do_work(n, a)
   !< Do work on device memory
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
   endsubroutine do_work
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

call do_work(n=n, a=a)

call dev_memcpy_from_device(fptr_dst=b, fptr_src=a)

if ((int(minval(b),I4P)/=-n**2).or.(int(maxval(b),I4P)/=n**3)) print '(A)', 'error: result is wrong'

call dev_free(A,mydev)
deallocate(b)

print '(A)', 'test passed'
endprogram fundal_external_routine_test
