!< FUNDAL, backward compatibility test: legacy call forms and legacy behaviour under the registry policies.

#include "fundal.H"

program fundal_compat_test
!< FUNDAL, backward compatibility test: legacy call forms and legacy behaviour under the registry policies.
!< Legacy forms are written as downstream codes (e.g. ADAM) write them: positional dev_id in dev_free, dev_init with no
!< argument, positional dev_alloc. A buffer allocated outside FUNDAL with the raw backend allocator must still be freed
!< by dev_free under policies warn (with a warning) and off (silently), as before the allocation registry existed.

use, intrinsic :: iso_c_binding,   only : c_ptr, c_size_t, c_f_pointer, c_associated
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64, R8P=>real64
#if defined DEV_OMP
use            :: omp_lib,         only : omp_target_alloc
#endif
use            :: fundal

implicit none
#if defined DEV_OAC
interface
   function raw_alloc(bytes) bind(c, name="acc_malloc")
   import :: c_ptr, c_size_t
   type(c_ptr)              :: raw_alloc
   integer(c_size_t), value :: bytes
   endfunction raw_alloc
endinterface
#elif !defined DEV_OMP
interface
   function raw_alloc(bytes) bind(c, name="malloc")
   import :: c_ptr, c_size_t
   type(c_ptr)              :: raw_alloc
   integer(c_size_t), value :: bytes
   endfunction raw_alloc
endinterface
#endif
real(R8P), pointer     :: a(:)=>null()    !< Device array.
real(R8P), pointer     :: b(:,:)=>null()  !< Device array (assigned).
real(R8P), pointer     :: raw(:)=>null()  !< Buffer allocated outside FUNDAL.
real(R8P), allocatable :: h(:,:)          !< Host array.
integer(I8P)           :: allocs0, bytes0 !< Stats, baseline.
integer(I8P)           :: allocs, bytes   !< Stats.
integer(I4P)           :: ierr            !< Status.

call dev_init                                     ! legacy: no argument
call dev_get_alloc_stats(allocs=allocs0, bytes=bytes0)

print '(A)', 'legacy call forms (policy warn, the default)'
call dev_set_registry_policy('warn')
call dev_alloc(a, [8], ierr)                      ! legacy: positional
call check(ierr == 0, 'positional dev_alloc')
allocate(h(3,4)) ; h = 1._R8P
call dev_assign_to_device(dst=b, src=h)           ! legacy: no ierr
call dev_assign_to_device(dst=b, src=h)           ! re-assignment frees the previous buffer
call dev_free(a, mydev)                           ! legacy: positional dev_id, matching the recorded device
call dev_free(b, mydev)
call check(.not.associated(a) .and. .not.associated(b), 'legacy frees nullify')
call dev_get_alloc_stats(allocs=allocs, bytes=bytes)
call check(allocs == allocs0 .and. bytes == bytes0, 'legacy forms leave no live allocation')

print '(A)', 'buffer allocated outside FUNDAL, policy warn: freed as before (with a warning)'
call raw_buffer(raw)
call dev_free(raw, mydev)
call check(.not.associated(raw), 'foreign buffer freed and nullified under warn')

print '(A)', 'buffer allocated outside FUNDAL, policy off: freed as before, silently'
call dev_set_registry_policy('off')
call raw_buffer(raw)
call dev_free(raw, mydev)
call check(.not.associated(raw), 'foreign buffer freed and nullified under off')
call dev_alloc(a, [8], ierr)
call dev_free(a, mydev)
call dev_get_alloc_stats(allocs=allocs)
call check(allocs == allocs0, 'policy off still keeps the statistics')

print '(A)', 'buffer allocated outside FUNDAL, policy error with ierr: reported, not freed'
call dev_set_registry_policy('error')
call raw_buffer(raw)
call dev_free(raw, mydev, ierr)
call check(ierr == FUNDAL_ERR_NOT_REGISTERED .and. associated(raw), 'reported and left untouched')
call dev_set_registry_policy('off')
call dev_free(raw, mydev)                         ! release it the legacy way
call dev_set_registry_policy('warn')

print '(A)', 'test passed'

contains
   subroutine raw_buffer(ptr)
   !< Allocate 4 doubles with the raw backend allocator, bypassing FUNDAL (and its registry).
   real(R8P), pointer, intent(inout) :: ptr(:) !< Pointer to the buffer.
   type(c_ptr)                       :: cptr   !< C pointer.

#if defined DEV_OMP
   cptr = omp_target_alloc(int(32, c_size_t), mydev)
#else
   cptr = raw_alloc(int(32, c_size_t))
#endif
   call check(c_associated(cptr), 'raw allocation')
   call c_f_pointer(cptr, ptr, [4])
   endsubroutine raw_buffer

   subroutine check(condition, msg)
   !< Stop with an error message if condition is false.
   logical,      intent(in) :: condition !< Condition to verify.
   character(*), intent(in) :: msg       !< Error message.

   if (.not.condition) then
      print '(A)', 'error: '//trim(adjustl(msg))
      error stop 1
   endif
   endsubroutine check
endprogram fundal_compat_test
