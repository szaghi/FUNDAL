!< FUNDAL, allocation registry two-device test: a buffer is copied and freed on the device where it lives.

#include "fundal.H"

program fundal_registry_two_devices_test
!< FUNDAL, allocation registry two-device test: a buffer is copied and freed on the device where it lives.
!< Skipped (passes) unless at least two real devices are available.

use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64, R8P=>real64
use            :: fundal

implicit none
real(R8P), pointer :: a(:)=>null() !< Device array.
real(R8P)          :: h(16)        !< Host array.
integer(I8P)       :: allocs       !< Stats.
integer(I4P)       :: ierr         !< Status.

call dev_init
if (devs_number < 2 .or. dev_is_host_fallback()) then
   print '(A)', 'less than two devices available: skipped'
   print '(A)', 'test passed'
   stop
endif
call dev_set_registry_policy('error')

! allocate on device 1 (OpenACC allocates on the current device, OpenMP on dev_id)
call dev_set_device_num(1)
call dev_alloc(fptr_dev=a, ubounds=[16], ierr=ierr, dev_id=1_I4P, label='on-device-1')
call check(ierr == 0, 'alloc on device 1')
call dev_set_device_num(0)
call dev_get_alloc_stats(allocs=allocs, dev_id=1_I4P) ; call check(allocs == 1_I8P, 'recorded on device 1')
call dev_get_alloc_stats(allocs=allocs, dev_id=0_I4P) ; call check(allocs == 0_I8P, 'nothing on device 0')

! device 0 is current: copies must go to and come from device 1 (whole buffer and section)
h = 7._R8P
call dev_memcpy_to_device(dst=a, src=h, ierr=ierr) ; call check(ierr == 0, 'copy to device 1')
call dev_memcpy_to_device(dst=a(5:8), src=[-1._R8P, -1._R8P, -1._R8P, -1._R8P], ierr=ierr)
call check(ierr == 0, 'section copy to device 1')
h = 0._R8P
call dev_memcpy_from_device(dst=h, src=a, ierr=ierr) ; call check(ierr == 0, 'copy from device 1')
call check(all(h(5:8) == -1._R8P) .and. all(h(1:4) == 7._R8P) .and. all(h(9:16) == 7._R8P), 'round trip on device 1')

! device 0 is current: dev_free must free on device 1 (policy error: any misuse would stop)
call dev_free(a)
call check(.not.associated(a), 'freed')
call dev_get_alloc_stats(allocs=allocs, dev_id=1_I4P) ; call check(allocs == 0_I8P, 'device 1 released')

! dev_id that contradicts the registry is an error with ierr
call dev_set_device_num(1)
call dev_alloc(fptr_dev=a, ubounds=[16], ierr=ierr, dev_id=1_I4P)
call dev_set_device_num(0)
call dev_free(a, dev_id=0_I4P, ierr=ierr) ; call check(ierr == FUNDAL_ERR_DEV_ID_MISMATCH, 'mismatch on two devices')
call dev_free(a, dev_id=1_I4P, ierr=ierr) ; call check(ierr == 0, 'matching dev_id frees')

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
endprogram fundal_registry_two_devices_test
