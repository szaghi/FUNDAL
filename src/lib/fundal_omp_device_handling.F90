!< FUNDAL, device handling module, OpenMP backend.
module fundal_omp_device_handling
!< FUNDAL, device handling module, OpenMP backend.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64
use            :: omp_lib,         only : omp_get_default_device,omp_get_initial_device,omp_get_num_devices,omp_set_default_device

implicit none
private
public :: omp_get_default_device  ! dev_get_device_num
public :: omp_get_device_type     ! dev_get_device_type
public :: omp_get_initial_device  ! dev_get_host_num
public :: omp_get_num_devices     ! dev_get_num_devices
public :: omp_get_property_string ! dev_get_property_string
public :: omp_set_default_device  ! dev_set_device_num

contains
   function omp_get_device_type() result(devtype)
   !< Return the device type.
   !< Note: OpenMP does not provide such a runtime routine, this is added only for seamless unified API with OpenACC purposes.
   integer(I4P) :: devtype !< Device type.

   devtype = 0_I4P
   endfunction omp_get_device_type

   subroutine omp_get_property_string(dev_num, string, prefix, memory)
   !< Return the value of a device-property for the specified device.
   !< Note: OpenMP does not provide such a runtime routine, this is added only for seamless unified API with OpenACC purposes.
   integer, value,      intent(in)            :: dev_num  !< Device ID.
   character(*),        intent(out)           :: string   !< Stringified device property.
   character(*),        intent(in),  optional :: prefix   !< String prefix.
   integer(I8P),        intent(out), optional :: memory   !< Device memory.
   character(:), allocatable                  :: prefix_  !< String prefix, local var.

   prefix_ = '' ; if (present(prefix)) prefix_ = prefix
   string = prefix_
   if (present(memory)) memory = 0_I8P
   endsubroutine omp_get_property_string
endmodule fundal_omp_device_handling
