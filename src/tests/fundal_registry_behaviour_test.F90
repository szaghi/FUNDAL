!< FUNDAL, allocation registry behaviour test: labels, stats, report and misuse detection through ierr.

#include "fundal.H"

program fundal_registry_behaviour_test
!< FUNDAL, allocation registry behaviour test: labels, stats, report and misuse detection through ierr.
!< Every misuse is exercised with ierr present: it is reported and nothing is freed, so no invalid free is ever executed.

use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64, R8P=>real64
use            :: fundal

implicit none
real(R8P), pointer :: a(:)=>null()    !< Device array.
real(R8P), pointer :: b(:,:)=>null()  !< Device array.
real(R8P), pointer :: p(:)=>null()    !< Alias/section/foreign pointer.
real(R8P), target  :: h(8)            !< Host array (foreign memory).
integer(I8P)       :: allocs0, bytes0 !< Stats, baseline.
integer(I8P)       :: allocs, bytes   !< Stats.
integer(I4P)       :: ierr, u, ios    !< Status, unit.
character(256)     :: line            !< Report line.
logical            :: has_rho, has_u  !< Labels found in the report.

call dev_init
call dev_set_registry_policy('warn')
call dev_get_alloc_stats(allocs=allocs0, bytes=bytes0)

print '(A)', 'labels, per-device stats, report'
call dev_alloc(fptr_dev=a, ubounds=[10], ierr=ierr, label='rho') ; call check(ierr == 0, 'alloc a')
call dev_alloc(fptr_dev=b, ubounds=[4,4], ierr=ierr, label='u')  ; call check(ierr == 0, 'alloc b')
call dev_get_alloc_stats(allocs=allocs, bytes=bytes)
call check(allocs - allocs0 == 2_I8P .and. bytes - bytes0 == 26_I8P * 8_I8P, 'global stats')
call dev_get_alloc_stats(allocs=allocs, dev_id=mydev)
call check(allocs >= 2_I8P, 'per-device stats on mydev')
open(newunit=u, status='scratch')
call dev_alloc_report(unit=u)
rewind(u) ; has_rho = .false. ; has_u = .false.
do
   read(u, '(A)', iostat=ios) line ; if (ios /= 0) exit
   if (index(line, 'label="rho"') > 0) has_rho = index(line, 'bytes=80') > 0
   if (index(line, 'label="u"') > 0)   has_u = index(line, 'bytes=128') > 0
enddo
close(u)
call check(has_rho .and. has_u, 'report lists labelled allocations with their sizes')

print '(A)', 'double free (alias of a freed buffer) -> FUNDAL_ERR_NOT_REGISTERED, nothing freed'
p => a
call dev_free(a, ierr=ierr) ; call check(ierr == 0 .and. .not.associated(a), 'first free')
call dev_free(p, ierr=ierr) ; call check(ierr == FUNDAL_ERR_NOT_REGISTERED, 'double free detected')
call check(associated(p), 'pointer left untouched on error')
nullify(p)

print '(A)', 'foreign (host) pointer -> FUNDAL_ERR_NOT_REGISTERED, nothing freed'
p => h
call dev_free(p, ierr=ierr) ; call check(ierr == FUNDAL_ERR_NOT_REGISTERED, 'foreign pointer detected')
nullify(p)

print '(A)', 'section pointers -> FUNDAL_ERR_NOT_REGISTERED, the buffer stays registered'
call dev_alloc(fptr_dev=a, ubounds=[10], ierr=ierr) ; call check(ierr == 0, 'realloc a')
p => a(3:6)
call dev_free(p, ierr=ierr) ; call check(ierr == FUNDAL_ERR_NOT_REGISTERED, 'contiguous section detected')
p => a(1:10:2)
call dev_free(p, ierr=ierr) ; call check(ierr == FUNDAL_ERR_NOT_REGISTERED, 'strided section detected')
nullify(p)

print '(A)', 'dev_id mismatch -> FUNDAL_ERR_DEV_ID_MISMATCH, nothing freed'
call dev_free(a, dev_id=mydev + 1_I4P, ierr=ierr)
call check(ierr == FUNDAL_ERR_DEV_ID_MISMATCH .and. associated(a), 'mismatch detected')
call dev_free(a, dev_id=mydev, ierr=ierr) ; call check(ierr == 0 .and. .not.associated(a), 'matching dev_id frees')

print '(A)', 'dev_assign_to_device on a pointer not allocated by FUNDAL (policy error) -> FUNDAL_ERR_NOT_REGISTERED'
call dev_set_registry_policy('error')
p => h
call dev_assign_to_device(dst=p, src=h, ierr=ierr)
call check(ierr == FUNDAL_ERR_NOT_REGISTERED, 'assign reports 103, not an allocation failure')
call check(associated(p, h), 'dst left untouched')
nullify(p)
call dev_set_registry_policy('warn')

print '(A)', 'dev_error_message describes every code'
call check(index(dev_error_message(FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED), 'not allocated') > 0, 'message 101')
call check(index(dev_error_message(FUNDAL_ERR_NO_DEVICE), 'no device') > 0, 'message 102')
call check(index(dev_error_message(FUNDAL_ERR_NOT_REGISTERED), 'not allocated by FUNDAL') > 0, 'message 103')
call check(index(dev_error_message(FUNDAL_ERR_DEV_ID_MISMATCH), 'dev_id') > 0, 'message 104')
call check(dev_error_message(0) == 'no error', 'message 0')
call check(index(dev_error_message(999), '999') > 0, 'unknown code')

print '(A)', 'dev_alloc_replace keeps exactly one registered buffer'
call dev_alloc_replace(fptr_dev=a, ubounds=[5], ierr=ierr, label='r1') ; call check(ierr == 0, 'replace 1')
call dev_alloc_replace(fptr_dev=a, ubounds=[7], ierr=ierr, label='r2') ; call check(ierr == 0, 'replace 2')
call dev_free(a) ; call dev_free(b) ; call dev_free(b)
call dev_get_alloc_stats(allocs=allocs, bytes=bytes)
call check(allocs == allocs0 .and. bytes == bytes0, 'no leak, failed frees did not touch the accounting')

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
endprogram fundal_registry_behaviour_test
