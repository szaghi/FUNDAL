!< FUNDAL, Fortran UNified Device Acceleration Library.
module fundal
!< FUNDAL, Fortran UNified Device Acceleration Library.
use, intrinsic :: iso_c_binding
use, intrinsic :: iso_fortran_env,            only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
#ifdef _DEV_OAC
use, intrinsic :: openacc
use            :: fundal_utilities,           only : bytes_size
use            :: fundal_oac_alloc,           only : dev_alloc=>oac_alloc, FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
use            :: fundal_oac_free,            only : dev_free=>oac_free
use            :: fundal_oac_memcpy,          only : dev_memcpy_from_device=>oac_memcpy_from_device, &
                                                     dev_memcpy_to_device=>oac_memcpy_to_device
use            :: fundal_oac_device_handling, only : dev_get_device_num=>oac_get_device_num,   &
                                                     dev_get_num_devices=>oac_get_num_devices, &
                                                     dev_init_device=>oac_init_device,         &
                                                     dev_set_device_num=>oac_set_device_num
#elif defined(_DEV_OMP)
! to be implemented
#endif

implicit none

private
! runtime memory routines
public :: dev_alloc, FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
public :: dev_free
public :: dev_memcpy_from_device
public :: dev_memcpy_to_device
! devices handling routines
public :: dev_get_device_num
public :: dev_get_num_devices
public :: dev_init_device
public :: dev_set_device_num
! global variables
public :: local_comm
public :: mydev
public :: myhos

integer(kind=I4P) :: local_comm=0_I4P !< Local communicator.
integer(kind=I4P) :: mydev=0_I4P      !< Device ID.
integer(kind=I4P) :: myhos=0_I4P      !< Host ID.
endmodule fundal
