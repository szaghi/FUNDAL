!< FUNDAL, device handling module, OpenMP backend.
module fundal_omp_device_handling
!< FUNDAL, device handling module, OpenMP backend.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64
use            :: omp_lib

implicit none
private
public :: omp_get_device_num
public :: omp_get_host_num
public :: omp_get_num_devices
public :: omp_get_property_string
public :: omp_init_device

contains
   function omp_get_host_num() result(host_num)
   !< Return the value of current host ID for the current thread.
   integer(I4P) :: host_num !< Device ID for current thread.

   host_num = omp_get_initial_device()
   endfunction omp_get_host_num

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

   subroutine omp_init_device(dev_num)
   !< initialize the runtime for the specified device type and device number.
   !< This can be used to isolate any initialization cost from the computational cost.
   !< Note: OpenMP does not provide such a runtime routine, this is added only for seamless unified API with OpenACC purposes.
   integer, value, intent(in) :: dev_num  !< Device ID.
   endsubroutine omp_init_device
endmodule fundal_omp_device_handling
