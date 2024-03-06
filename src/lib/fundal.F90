!< FUNDAL, Fortran UNified Device Acceleration Library.
module fundal
!< FUNDAL, Fortran UNified Device Acceleration Library.
use            :: fundal_dev_alloc,    only : dev_alloc, FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
use            :: fundal_dev_free,     only : dev_free
use            :: fundal_dev_memcpy,   only : dev_memcpy_from_device, dev_memcpy_to_device
use            :: fundal_dev_handling, only : dev_get_device_num,      &
                                              dev_get_device_type,     &
                                              dev_get_host_num,        &
                                              dev_get_num_devices,     &
                                              dev_get_property_string, &
                                              dev_set_device_num
use            :: fundal_env,          only : local_comm, mydev, myhos, devtype

implicit none
private
! runtime memory routines
public :: dev_alloc, FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
public :: dev_free
public :: dev_memcpy_from_device
public :: dev_memcpy_to_device
! device handling routines
public :: dev_get_device_num
public :: dev_get_device_type
public :: dev_get_host_num
public :: dev_get_num_devices
public :: dev_get_property_string
public :: dev_set_device_num
! environment global variables
public :: local_comm
public :: mydev
public :: myhos
public :: devtype
endmodule fundal
