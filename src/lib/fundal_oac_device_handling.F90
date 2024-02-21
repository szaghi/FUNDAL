!< FUNDAL, device handling module.
module fundal_oac_device_handling
!< FUNDAL, device handling module.
use, intrinsic :: iso_fortran_env,   only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use, intrinsic :: openacc

implicit none

private
public :: oac_get_device_num
public :: oac_get_num_devices
public :: oac_init_device
public :: oac_set_device_num

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
endmodule fundal_oac_device_handling
