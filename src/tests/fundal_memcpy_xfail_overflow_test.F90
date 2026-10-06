!< FUNDAL, expected-failure test: dev_memcpy_to_device without ierr on a range beyond the end of its allocation, policy error.

program fundal_memcpy_xfail_overflow_test
!< FUNDAL, expected-failure test: dev_memcpy_to_device without ierr on a range beyond the end of its allocation, policy error.
!< The name contains "_xfail_": the test runner requires a non-zero exit status. The registry rejects the device range
!< before anything is copied.

use, intrinsic :: iso_c_binding,   only : c_f_pointer, c_loc
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal

implicit none
real(R8P), pointer :: a(:)=>null() !< Device array.
real(R8P), pointer :: p(:)=>null() !< Pointer beyond the end of a.
real(R8P)          :: h(10)        !< Host array.
integer(I4P)       :: ierr         !< Status.

call dev_init
call dev_set_registry_policy('error')
call dev_alloc(fptr_dev=a, ubounds=[10], ierr=ierr, init_value=0._R8P)
call c_f_pointer(c_loc(a(5)), p, [10])
h = 1._R8P
call dev_memcpy_to_device(dst=p, src=h) ! no ierr: must error stop here
print '(A)', 'error: range beyond the allocation not detected'
endprogram fundal_memcpy_xfail_overflow_test
