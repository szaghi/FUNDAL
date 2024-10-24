!< FUNDAL, save memory status test.

#include "fundal.H"

program fundal_save_memory_status_test
!< FUNDAL, save memory status test.

use, intrinsic :: iso_fortran_env, only : I4P=>int32
use fundal

implicit none
integer(I4P), pointer :: a(:,:,:)
integer(I4P)          :: ierr

devtype = dev_get_device_type()
mydev = 0
myhos = dev_get_host_num()
call dev_set_device_num(mydev)
call dev_init
call dev_get_device_memory_info(dev_memory_avail)

call save_memory_status(file_name='device_memory_status.log', tag='entry 1 before allocate  :')
call dev_alloc(fptr_dev=a, ubounds=[100,100,100], ierr=ierr)
call save_memory_status(file_name='device_memory_status.log', tag='entry 2 after  allocate  :')
call dev_free(a)
call save_memory_status(file_name='device_memory_status.log', tag='entry 3 after  deallocate:')
endprogram fundal_save_memory_status_test
