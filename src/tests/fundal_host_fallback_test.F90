!< FUNDAL, host fallback test: dev_init policy (warn, require_device, MPI-path guard) on any hardware.

#include "fundal.H"

program fundal_host_fallback_test
!< FUNDAL, host fallback test: dev_init policy (warn, require_device, MPI-path guard) on any hardware.
!< The test does not assume a device: it checks that the outcome of dev_init is consistent with dev_is_host_fallback,
!< so it passes on a GPU, in host fallback (no device visible) and in the compile-time CPU mode alike.

use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal

implicit none
real(R8P), pointer :: a(:)=>null() !< Device array.
real(R8P)          :: a_h(4)       !< Host array.
integer(I4P)       :: ierr         !< Error status.
logical            :: fallback     !< Host fallback status.

! default policy: fallback allowed (unless the environment requires a device, e.g. ACC_DEVICE_TYPE/OMP_TARGET_OFFLOAD)
call dev_init(ierr=ierr)
fallback = dev_is_host_fallback()
print '(A,L1)', 'host fallback: ', fallback
call check(ierr == 0 .or. (ierr == FUNDAL_ERR_NO_DEVICE .and. fallback), 'dev_init default policy')
#if !defined DEV_OAC && !defined DEV_OMP
call check(.not.fallback, 'CPU mode is not a host fallback')
#endif
if (ierr /= 0) then
   print '(A)', 'device required by the environment and none available: policy checks done'
   print '(A)', 'test passed'
   stop
endif

! MPI path: a local rank larger than the number of devices must not crash (mod by zero with no device)
call dev_init(local_rank=3_I4P, ierr=ierr)
call check(ierr == 0, 'dev_init with local_rank')
if (devs_number > 0) call check(mydev >= 0 .and. mydev < devs_number, 'mydev in range')

! strict policy: must fail if and only if running in host fallback
call dev_init(require_device=.true., ierr=ierr)
if (fallback) then
   call check(ierr == FUNDAL_ERR_NO_DEVICE, 'require_device fails in host fallback')
else
   call check(ierr == 0, 'require_device succeeds with a device (or in CPU mode)')
endif

! after a default init the library works, on device or host
call dev_init(ierr=ierr)
call check(ierr == 0, 'dev_init after strict attempt')
call dev_alloc(fptr_dev=a, ubounds=[4], ierr=ierr, init_value=3._R8P)
call check(ierr == 0, 'dev_alloc')
call dev_memcpy_from_device(dst=a_h, src=a)
call check(all(a_h == 3._R8P), 'values')
call dev_free(a)

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
endprogram fundal_host_fallback_test
