!< FUNDAL, registry-aware structured copies test: sections, strided arguments, ranges beyond an allocation, foreign memory.

#include "fundal.H"

program fundal_memcpy_registry_test
!< FUNDAL, registry-aware structured copies test: sections, strided arguments, ranges beyond an allocation, foreign memory.
!< Every misuse is exercised with ierr present: it is reported and nothing is copied, so no invalid copy is ever executed.

use, intrinsic :: iso_c_binding,   only : c_f_pointer, c_loc
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal

implicit none
real(R8P), pointer :: a(:)=>null()   !< Device array.
real(R8P), pointer :: b(:,:)=>null() !< Device array.
real(R8P), pointer :: p(:)=>null()   !< Pointer beyond the end of a.
real(R8P), target  :: h(10)          !< Host array.
real(R8P), target  :: hh(20)         !< Host array, strided use.
real(R8P)          :: c(4,3)         !< Host array.
integer(I4P)       :: ierr, i        !< Status, counter.

call dev_init
call dev_set_registry_policy('warn')
h = [(real(i, R8P), i=1, 10)]

print '(A)', 'whole buffer copies'
call dev_alloc(fptr_dev=a, ubounds=[10], ierr=ierr, init_value=0._R8P) ; call check(ierr == 0, 'alloc a')
call dev_memcpy_to_device(dst=a, src=h, ierr=ierr) ; call check(ierr == 0, 'to device')
h = 0._R8P
call dev_memcpy_from_device(dst=h, src=a, ierr=ierr) ; call check(ierr == 0, 'from device')
call check(all(h == [(real(i, R8P), i=1, 10)]), 'round trip')

print '(A)', 'contiguous sections of a buffer'
call dev_memcpy_to_device(dst=a(3:6), src=[-3._R8P, -4._R8P, -5._R8P, -6._R8P], ierr=ierr)
call check(ierr == 0, 'to device, section')
call dev_memcpy_from_device(dst=h, src=a, ierr=ierr) ; call check(ierr == 0, 'from device after section')
call check(all(h(3:6) < 0._R8P) .and. all(h(1:2) > 0._R8P) .and. all(h(7:10) > 0._R8P), 'only the section changed')
call dev_alloc(fptr_dev=b, ubounds=[4,3], ierr=ierr, init_value=1._R8P) ; call check(ierr == 0, 'alloc b')
call dev_memcpy_to_device(dst=b(:,2), src=[2._R8P, 2._R8P, 2._R8P, 2._R8P], ierr=ierr)
call check(ierr == 0, 'to device, column')
call dev_memcpy_from_device(dst=c, src=b, ierr=ierr) ; call check(ierr == 0, 'from device, matrix')
call check(all(c(:,2) == 2._R8P) .and. all(c(:,1) == 1._R8P) .and. all(c(:,3) == 1._R8P), 'only the column changed')

print '(A)', 'strided host argument: copied correctly'
hh = 0._R8P
call dev_memcpy_from_device(dst=hh(1:20:2), src=a, ierr=ierr) ; call check(ierr == 0, 'from device, strided host')
call check(all(hh(1:20:2) == h) .and. all(hh(2:20:2) == 0._R8P), 'strided host values')

#if !defined COMPILER_NVF
! nvfortran passes a strided section to an assumed-shape dummy through a contiguous temporary made by the caller (host
! code reading device memory on a GPU): the copy routine never sees the strided argument, so it cannot be detected
print '(A)', 'strided device argument -> FUNDAL_ERR_NOT_CONTIGUOUS, nothing copied'
call dev_memcpy_to_device(dst=a(1:10:2), src=[99._R8P, 99._R8P, 99._R8P, 99._R8P, 99._R8P], ierr=ierr)
call check(ierr == FUNDAL_ERR_NOT_CONTIGUOUS, 'strided device argument detected')
call dev_memcpy_from_device(dst=h, src=a, ierr=ierr)
call check(all(h /= 99._R8P), 'nothing copied')
#endif

print '(A)', 'range beyond the end of the allocation -> FUNDAL_ERR_NOT_REGISTERED, nothing copied'
call c_f_pointer(c_loc(a(5)), p, [10])
call dev_memcpy_to_device(dst=p, src=h, ierr=ierr) ; call check(ierr == FUNDAL_ERR_NOT_REGISTERED, 'overflow detected')
nullify(p)

print '(A)', 'memory not allocated by FUNDAL, policy error -> FUNDAL_ERR_NOT_REGISTERED, nothing copied'
call dev_set_registry_policy('error')
call dev_memcpy_to_device(dst=hh(1:10), src=h, ierr=ierr) ; call check(ierr == FUNDAL_ERR_NOT_REGISTERED, 'foreign memory')
call dev_set_registry_policy('warn')

print '(A)', 'dev_error_message describes the new codes'
call check(index(dev_error_message(FUNDAL_ERR_NOT_CONTIGUOUS), 'not contiguous') > 0, 'message 105')
call check(index(dev_error_message(FUNDAL_ERR_MEMCPY_FAILED), 'failed copy') > 0, 'message 106')

call dev_free(a) ; call dev_free(b)
print '(A)', 'test passed'

contains
   subroutine check(condition, msg)
   !< Stop with an error message if condition is false.
   logical,      intent(in) :: condition !< Condition to verify.
   character(*), intent(in) :: msg       !< Error message.

   if (.not.condition) then
      print '(A)', 'error: '//trim(adjustl(msg))
      error stop 1
   endif
   endsubroutine check
endprogram fundal_memcpy_registry_test
