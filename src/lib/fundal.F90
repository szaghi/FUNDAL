!< FUNDAL, Fortran UNified Device Acceleration Library.
module fundal
!< FUNDAL, runtime memory library module.
use, intrinsic :: iso_c_binding
use, intrinsic :: iso_fortran_env,   only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
#ifdef _DEV_OAC
use, intrinsic :: openacc
use            :: fundal_oac_alloc,  only : dev_alloc=>oac_alloc, FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
use            :: fundal_oac_free,   only : dev_free=>oac_free
use            :: fundal_oac_memcpy, only : dev_memcpy_from_device=>oac_memcpy_from_device, &
                                            dev_memcpy_to_device=>oac_memcpy_to_device
#elif defined(_DEV_OMP)
! to be implemented
#endif
use            :: fundal_utilities,  only : bytes_size

implicit none

private
! runtime memory routines
public :: dev_alloc, FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
public :: dev_free
public :: dev_memcpy_from_device
public :: dev_memcpy_to_device
! devices handling routines
public :: oac_get_device_num
public :: oac_get_num_devices
public :: oac_init_device
public :: oac_set_device_num
! global variables

integer(kind=I4P) :: local_comm=0_I4P !< Local communicator.
integer(kind=I4P) :: mydev=0_I4P      !< Device ID.
integer(kind=I4P) :: myhos=0_I4P      !< Host ID.

interface
   function oac_get_device_num(dev_type) bind(c, name="acc_get_device_num")
   use, intrinsic :: iso_fortran_env, only : I4P=>int32
   use openacc
   implicit none
   integer(I4P)             :: oac_get_device_num
   integer(acc_device_kind) :: dev_type
   endfunction oac_get_device_num

   function oac_get_num_devices(dev_type) bind(c, name="acc_get_num_devices")
   use, intrinsic :: iso_fortran_env, only : I4P=>int32
   use openacc
   implicit none
   integer(I4P)             :: oac_get_num_devices
   integer(acc_device_kind) :: dev_type
   endfunction oac_get_num_devices

   subroutine oac_init_device(dev_num, dev_type) bind(c, name="acc_init_device")
   use, intrinsic :: iso_fortran_env, only : I4P=>int32
   use openacc
   implicit none
   integer(I4P)             :: dev_num
   integer(acc_device_kind) :: dev_type
   endsubroutine oac_init_device

   subroutine oac_set_device_num(dev_num, dev_type) bind(c, name="acc_set_device_num")
   use, intrinsic :: iso_fortran_env, only : I4P=>int32
   use openacc
   implicit none
   integer(I4P)             :: dev_num
   integer(acc_device_kind) :: dev_type
   endsubroutine oac_set_device_num
endinterface

! contains

endmodule fundal
