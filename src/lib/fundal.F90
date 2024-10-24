!< FUNDAL, Fortran UNified Device Acceleration Library.
module fundal
!< FUNDAL, Fortran UNified Device Acceleration Library.
use            :: fundal_dev_alloc_unstructured,  only : dev_alloc_unstr
use            :: fundal_dev_alloc,               only : dev_alloc, FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
use            :: fundal_dev_free_unstructured,   only : dev_free_unstr
use            :: fundal_dev_free,                only : dev_free
use            :: fundal_dev_memcpy_unstructured, only : dev_memcpy_from_device_unstr, dev_memcpy_to_device_unstr
use            :: fundal_dev_memcpy,              only : dev_memcpy_from_device, dev_memcpy_to_device
use            :: fundal_dev_assign,              only : dev_assign_from_device, dev_assign_to_device
use            :: fundal_dev_handling,            only : dev_get_device_memory_info, &
                                                         dev_get_device_num,         &
                                                         dev_get_device_type,        &
                                                         dev_get_host_num,           &
                                                         dev_get_num_devices,        &
                                                         dev_get_property_string,    &
                                                         dev_init,                   &
                                                         dev_set_device_num
use            :: fundal_env,                     only : dev_memory_avail, local_comm, mydev, myhos, devtype, IDK
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64

implicit none
private
! runtime memory routines
public :: dev_alloc_unstr
public :: dev_alloc, FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
public :: dev_free_unstr
public :: dev_free
public :: dev_memcpy_from_device_unstr, dev_memcpy_to_device_unstr
public :: dev_memcpy_from_device, dev_memcpy_to_device
public :: dev_assign_from_device, dev_assign_to_device
! device handling routines
public :: dev_get_device_memory_info
public :: dev_get_device_num
public :: dev_get_device_type
public :: dev_get_host_num
public :: dev_get_num_devices
public :: dev_get_property_string
public :: dev_init
public :: dev_set_device_num
! auxiliary routines
public :: save_memory_status
! environment global variables
public :: dev_memory_avail
public :: local_comm
public :: mydev
public :: myhos
public :: devtype
public :: IDK

contains
   subroutine save_memory_status(file_name, tag)
   !< Save the current device-memory status into a file.
   !< File is accessed in append position.
   character(*), intent(in)           :: file_name           !< File name.
   character(*), intent(in), optional :: tag                 !< Tag of current status.
   character(:), allocatable          :: tag_                !< Tag of current status, local var.
   integer(I8P)                       :: mem_free, mem_total !< Process memory.
   integer(I4P)                       :: file_unit           !< File unit.

   tag_ = '' ; if (present(tag)) tag_ = trim(tag)
   call dev_get_device_memory_info(mem_free, mem_total)
   open(newunit=file_unit, file=trim(file_name), position="append")
   write(file_unit,*) tag_, mem_free, mem_total
   close(file_unit)
   endsubroutine save_memory_status
endmodule fundal
