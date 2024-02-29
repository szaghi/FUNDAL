!< FUNDAL, Fortran UNified Device Acceleration Library.
module fundal
!< FUNDAL, Fortran UNified Device Acceleration Library.
use, intrinsic :: iso_fortran_env,            only : I4P=>int32
use            :: fundal_env,                 only : local_comm, mydev, myhos
#ifdef DEV_OAC
use            :: fundal_oac_alloc,           only : dev_alloc=>oac_alloc, FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
use            :: fundal_oac_free,            only : dev_free=>oac_free
use            :: fundal_oac_memcpy,          only : dev_memcpy=>oac_memcpy,                         &
                                                     dev_memcpy_from_device=>oac_memcpy_from_device, &
                                                     dev_memcpy_to_device=>oac_memcpy_to_device
use            :: fundal_oac_device_handling, only : dev_get_device_num=>oac_get_device_num,           &
                                                     dev_get_host_num=>oac_get_host_num,               &
                                                     dev_get_num_devices=>oac_get_num_devices,         &
                                                     dev_get_property_string=>oac_get_property_string, &
                                                     dev_init_device=>oac_init_device
#elif defined DEV_OMP
use            :: fundal_omp_alloc,           only : dev_alloc=>omp_alloc, FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
use            :: fundal_omp_free,            only : dev_free=>omp_free
use            :: fundal_omp_memcpy,          only : dev_memcpy=>omp_memcpy,                         &
                                                     dev_memcpy_from_device=>omp_memcpy_from_device, &
                                                     dev_memcpy_to_device=>omp_memcpy_to_device
use            :: fundal_omp_device_handling, only : dev_get_device_num=>omp_get_device_num,           &
                                                     dev_get_host_num=>omp_get_host_num,               &
                                                     dev_get_num_devices=>omp_get_num_devices,         &
                                                     dev_get_property_string=>omp_get_property_string, &
                                                     dev_init_device=>omp_init_device
#endif

implicit none
private
! runtime memory routines
public :: dev_alloc, FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
public :: dev_free
public :: dev_memcpy
public :: dev_memcpy_from_device
public :: dev_memcpy_to_device
! devices handling routines
public :: dev_get_device_num
public :: dev_get_host_num
public :: dev_get_num_devices
public :: dev_get_property_string
public :: dev_init_device
! global variables
public :: local_comm
public :: mydev
public :: myhos
endmodule fundal
