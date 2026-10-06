!< FUNDAL, expected-failure test: dev_assign_to_device without ierr on a pointer not allocated by FUNDAL, policy error.

program fundal_assign_xfail_unregistered_test
!< FUNDAL, expected-failure test: dev_assign_to_device without ierr on a pointer not allocated by FUNDAL, policy error.
!< The name contains "_xfail_": the test runner requires a non-zero exit status. The registry rejects dst before anything is
!< freed or allocated, and the stop reports that dst was not allocated by FUNDAL (not an allocation failure).

use, intrinsic :: iso_fortran_env, only : R8P=>real64
use            :: fundal

implicit none
real(R8P), target  :: foreign(4)     !< Host memory, not allocated by FUNDAL.
real(R8P), pointer :: dst(:)=>null() !< Destination pointer.
real(R8P)          :: src(4)         !< Source.

src = 1._R8P
call dev_init
call dev_set_registry_policy('error')
dst => foreign
call dev_assign_to_device(dst=dst, src=src) ! no ierr: must error stop here
print '(A)', 'error: unregistered dst not detected'
endprogram fundal_assign_xfail_unregistered_test
