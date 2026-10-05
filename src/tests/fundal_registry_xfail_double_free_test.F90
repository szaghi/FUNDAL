!< FUNDAL, allocation registry expected-failure test: a double free under policy error must error stop.

program fundal_registry_xfail_double_free_test
!< FUNDAL, allocation registry expected-failure test: a double free under policy error must error stop.
!< The name contains "_xfail_": the test runner requires a non-zero exit status. The second dev_free is detected by the
!< registry before any free is executed, so no invalid free ever happens.

use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal

implicit none
real(R8P), pointer :: a(:)=>null() !< Device array.
real(R8P), pointer :: p(:)=>null() !< Alias of a.
integer(I4P)       :: ierr         !< Status.

call dev_init
call dev_set_registry_policy('error')
call dev_alloc(fptr_dev=a, ubounds=[4], ierr=ierr)
p => a
call dev_free(a)
call dev_free(p) ! double free: must error stop here
print '(A)', 'error: double free not detected'
endprogram fundal_registry_xfail_double_free_test
