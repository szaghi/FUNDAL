!< FUNDAL, device memory alloc test.
program fundal_alloc_free_test
!< FUNDAL, device memory alloc test.

use, intrinsic :: iso_fortran_env, only : I1P=>int8, I2P=>int16, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: fundal

implicit none

character(8), parameter :: ECHO_R8P='test R8P' !< Description message for test R8P kind.
character(8), parameter :: ECHO_R4P='test R4P' !< Description message for test R4P kind.
character(8), parameter :: ECHO_I8P='test I8P' !< Description message for test I8P kind.
character(8), parameter :: ECHO_I4P='test I4P' !< Description message for test I4P kind.
character(8), parameter :: ECHO_I2P='test I2P' !< Description message for test I2P kind.
character(8), parameter :: ECHO_I1P='test I1P' !< Description message for test I1P kind.
character(5), parameter :: FORMATRP='F12.9'    !< Format output for test RxP.
character(2), parameter :: FORMATIP='I3'       !< Format output for test IxP.

call dev_init
call test_R8P
call test_R8P(init_value=8._R8P)
call test_R4P
call test_R4P(init_value=4._R4P)
call test_I8P
call test_I8P(init_value=8_I8P)
call test_I4P
call test_I4P(init_value=4_I4P)
call test_I2P
call test_I2P(init_value=2_I2P)
call test_I1P
call test_I1P(init_value=1_I1P)

print '(A)', 'test passed'

contains
   subroutine error_print(error, msg)
   !< Print error message.
   integer(I4P), intent(in) :: error !< Error status.
   character(*), intent(in) :: msg   !< Error message.

   if (error /= 0) then
      print '(A)', 'error: '//trim(adjustl(msg))//' not allocated!'
      stop
   endif
   endsubroutine error_print

#define TEST_KKP test_R8P
#define KKP R8P
#define VARTYPE real
#define ECHO_KKP ECHO_R8P
#define FORMATKKP FORMATRP
#include "fundal_alloc_free_test_agnostic.INC"

#define TEST_KKP test_R4P
#define KKP R4P
#define VARTYPE real
#define ECHO_KKP ECHO_R4P
#define FORMATKKP FORMATRP
#include "fundal_alloc_free_test_agnostic.INC"

#define TEST_KKP test_I8P
#define KKP I8P
#define VARTYPE integer
#define ECHO_KKP ECHO_I8P
#define FORMATKKP FORMATIP
#include "fundal_alloc_free_test_agnostic.INC"

#define TEST_KKP test_I4P
#define KKP I4P
#define VARTYPE integer
#define ECHO_KKP ECHO_I4P
#define FORMATKKP FORMATIP
#include "fundal_alloc_free_test_agnostic.INC"

#define TEST_KKP test_I2P
#define KKP I2P
#define VARTYPE integer
#define ECHO_KKP ECHO_I2P
#define FORMATKKP FORMATIP
#include "fundal_alloc_free_test_agnostic.INC"

#define TEST_KKP test_I1P
#define KKP I1P
#define VARTYPE integer
#define ECHO_KKP ECHO_I1P
#define FORMATKKP FORMATIP
#include "fundal_alloc_free_test_agnostic.INC"
endprogram fundal_alloc_free_test
