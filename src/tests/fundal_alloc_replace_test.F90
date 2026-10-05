!< FUNDAL, free-safe device memory allocation (dev_alloc_replace) and allocation accounting test.
program fundal_alloc_replace_test
!< FUNDAL, free-safe device memory allocation (dev_alloc_replace) and allocation accounting test.

use, intrinsic :: iso_fortran_env, only : I1P=>int8, I2P=>int16, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: fundal

implicit none

call dev_init
call test_R8P
call test_R4P
call test_I8P
call test_I4P
call test_I2P
call test_I1P
call test_leak_loop

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

   subroutine test_leak_loop
   !< Repeated dev_alloc_replace and dev_assign_to_device with alternating sizes must not leak.
   !< Sizes are kept small (at most 24^3 R8P, ~110 KB): the check relies on FUNDAL accounting, not on device memory size.
   integer(I4P), parameter :: N=50                 !< Loop iterations.
   real(R8P),    pointer   :: a(:,:,:)=>null()     !< Device array.
   real(R8P),    pointer   :: b(:,:,:)=>null()     !< Device array, assigned.
   real(R8P),    allocatable :: b_h(:,:,:)         !< Host array.
   integer(I4P)            :: n_                   !< Size of current iteration.
   integer(I4P)            :: i                    !< Counter.
   integer(I4P)            :: ierr                 !< Error status.
   integer(I8P)            :: allocs0, bytes0      !< Allocation stats, baseline.
   integer(I8P)            :: allocs, bytes        !< Allocation stats.

   print '(A)', 'test leak loop'
   call dev_get_alloc_stats(allocs=allocs0, bytes=bytes0)
   do i=1, N
      n_ = 16 ; if (mod(i,2) == 0) n_ = 24
      call dev_alloc_replace(fptr_dev=a, ubounds=[n_,n_,n_], ierr=ierr) ; call check(ierr==0, 'leak loop dev_alloc_replace')
      if (allocated(b_h)) deallocate(b_h)
      allocate(b_h(n_,n_,n_)) ; b_h = real(i, R8P)
      call dev_assign_to_device(dst=b, src=b_h, ierr=ierr) ; call check(ierr==0, 'leak loop dev_assign_to_device')
   enddo
   call dev_get_alloc_stats(allocs=allocs, bytes=bytes)
   call check(allocs - allocs0 == 2_I8P, 'leak loop live allocations before free')
   call check(bytes - bytes0 == 2_I8P * 24_I8P**3 * 8_I8P, 'leak loop live bytes before free')
   b_h = 0._R8P
   call dev_memcpy_from_device(src=b, dst=b_h) ; call check(all(b_h==real(N, R8P)), 'leak loop assigned value')
   call dev_free(a)
   call dev_free(b)
   call dev_get_alloc_stats(allocs=allocs, bytes=bytes)
   call check(allocs == allocs0, 'leak loop live allocations after free')
   call check(bytes  == bytes0,  'leak loop live bytes after free')
   endsubroutine test_leak_loop

#define TEST_KKP test_R8P
#define KKP R8P
#define VARTYPE real
#define ECHO_KKP 'test R8P'
#include "fundal_alloc_replace_test_agnostic.INC"

#define TEST_KKP test_R4P
#define KKP R4P
#define VARTYPE real
#define ECHO_KKP 'test R4P'
#include "fundal_alloc_replace_test_agnostic.INC"

#define TEST_KKP test_I8P
#define KKP I8P
#define VARTYPE integer
#define ECHO_KKP 'test I8P'
#include "fundal_alloc_replace_test_agnostic.INC"

#define TEST_KKP test_I4P
#define KKP I4P
#define VARTYPE integer
#define ECHO_KKP 'test I4P'
#include "fundal_alloc_replace_test_agnostic.INC"

#define TEST_KKP test_I2P
#define KKP I2P
#define VARTYPE integer
#define ECHO_KKP 'test I2P'
#include "fundal_alloc_replace_test_agnostic.INC"

#define TEST_KKP test_I1P
#define KKP I1P
#define VARTYPE integer
#define ECHO_KKP 'test I1P'
#include "fundal_alloc_replace_test_agnostic.INC"
endprogram fundal_alloc_replace_test
