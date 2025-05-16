!< FUNDAL, save memory status test.

#include "fundal.H"

program fundal_save_memory_status_test
!< FUNDAL, save memory status test.

use, intrinsic :: iso_fortran_env, only : I4P=>int32
use fundal

implicit none
integer(I4P), pointer :: a(:,:,:)
integer(I4P)          :: ierr
logical               :: does_exist

call dev_init
call save_memory_status(file_name='device_memory_status.log', tag='entry 1 before allocate  :')
call dev_alloc(fptr_dev=a, ubounds=[100,100,100], ierr=ierr)
call save_memory_status(file_name='device_memory_status.log', tag='entry 2 after  allocate  :')
call dev_free(a)
call save_memory_status(file_name='device_memory_status.log', tag='entry 3 after  deallocate:')
does_exist = .false.
inquire(file='device_memory_status.log', exist=does_exist)
if (does_exist) then
   print '(A)', 'test passed'
else
   print '(A)', 'error: something is not working...'
endif
endprogram fundal_save_memory_status_test
