!< FUNDAL, device handling module.

#include "fundal.H"

module fundal_dev_handling
!< FUNDAL, device handling module.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64
#if defined DEV_OAC
use            :: openacc,         only :                      acc_get_device_num,       &
                                          dev_get_device_type=>acc_get_device_type,      &
                                                               acc_get_num_devices,      &
                                                               acc_get_property,         &
                                                               acc_get_property_string,  &
                                                               acc_init,                 &
                                                               acc_set_device_num,       &
                                                               acc_device_nvidia,        &
                                                               acc_device_host,          &
                                                               acc_property_memory,      &
                                                               acc_property_free_memory, &
                                                               acc_property_name,        &
                                                               acc_property_vendor,      &
                                                               acc_property_driver
#elif defined DEV_OMP
use            :: omp_lib,         only : dev_get_device_num =>omp_get_default_device, &
                                          dev_get_host_num   =>omp_get_initial_device, &
                                          dev_get_num_devices=>omp_get_num_devices,    &
                                          dev_set_device_num =>omp_set_default_device
#endif
use            :: fundal_env,      only : devtype

implicit none
private
public :: dev_get_device_num
public :: dev_get_device_type
public :: dev_get_host_num
public :: dev_get_num_devices
public :: dev_get_property_string
public :: dev_init
public :: dev_set_device_num

contains
#if defined DEV_OAC
   function dev_get_device_num() result(device_num)
   !< Return the value of current device ID for the current thread.
   !< Note: the device type environment global variable, devtype, must be set before use this routine. By default it is seto to
   !< acc_device_default.
   integer(I4P) :: device_num !< Device ID for current thread.

   device_num = acc_get_device_num(devtype)
   endfunction dev_get_device_num

   function dev_get_host_num() result(host_num)
   !< Return the value of current host ID for the current thread.
   integer(I4P) :: host_num !< Device ID for current thread.

   host_num = acc_get_device_num(acc_device_host)
   endfunction dev_get_host_num

   function dev_get_num_devices() result(devices_number)
   !< Return the number of available (non host) devices.
   !< Note: the device type environment global variable, devtype, must be set before use this routine. By default it is seto to
   !< acc_device_default.
   integer(I4P) :: devices_number !< Devices number.

   devices_number = acc_get_num_devices(devtype)
   endfunction dev_get_num_devices

   subroutine dev_get_property_string(dev_num, string, prefix, memory)
   !< Return the value of a device-property for the specified device.
   !< Note: the device type environment global variable, devtype, must be set before use this routine. By default it is seto to
   !< acc_device_default.
   integer, value,                  intent(in)            :: dev_num  !< Device ID.
   character(*),                    intent(out)           :: string   !< Stringified device property.
   character(*),                    intent(in),  optional :: prefix   !< String prefix.
   integer(I8P),                    intent(out), optional :: memory   !< Device memory.
   character(:), allocatable                              :: prefix_  !< String prefix, local var.
   character(99)                                          :: string_  !< Local string buffer.
   integer(I8P)                                           :: memory_  !< Device memory, local var.

   prefix_ = '' ; if (present(prefix)) prefix_ = prefix
   string = ''
   memory_ = acc_get_property(dev_num, devtype, acc_property_memory)
   write(string_,'(I16)') memory_
   if (present(memory)) memory = memory_
   string = trim(string)//prefix_//'memory     : '//trim(adjustl(string_))//new_line('a')
   memory_ = acc_get_property(dev_num, devtype, acc_property_free_memory)
   write(string_,'(I16)') memory_
   string = trim(string)//prefix_//'memory free: '//trim(adjustl(string_))//new_line('a')
   call acc_get_property_string(dev_num, devtype, acc_property_name, string_)
   string = trim(string)//prefix_//'device name: '//trim(adjustl(string_))//new_line('a')
   call acc_get_property_string(dev_num, devtype, acc_property_vendor, string_)
   string = trim(string)//prefix_//'vendor     : '//trim(adjustl(string_))//new_line('a')
   call acc_get_property_string(dev_num, devtype, acc_property_driver, string_)
   string = trim(string)//prefix_//'driver     : '//trim(adjustl(string_))
   endsubroutine dev_get_property_string

   subroutine dev_init()
   !< Initialize device.

   call acc_init(devtype)
   endsubroutine dev_init

   subroutine dev_set_device_num(dev_num)
   !< Set the runtime for the specified device type and device number.
   !< Note: the device type environment global variable, devtype, must be set before use this routine. By default it is seto to
   !< acc_device_default.
   integer, value, intent(in) :: dev_num !< Device ID.

   call acc_set_device_num(dev_num, devtype)
   endsubroutine dev_set_device_num
#elif defined DEV_OMP
   function dev_get_device_type() result(devtype)
   !< Return the device type.
   !< Note: OpenMP does not provide such a runtime routine, added only for seamless unified API.
   integer(I4P) :: devtype !< Device type.

   devtype = 0_I4P
   endfunction dev_get_device_type

   subroutine dev_get_property_string(dev_num, string, prefix, memory)
   !< Return the value of a device-property for the specified device.
   !< Note: OpenMP does not provide such a runtime routine, added only for seamless unified API.
   integer, value,      intent(in)            :: dev_num  !< Device ID.
   character(*),        intent(out)           :: string   !< Stringified device property.
   character(*),        intent(in),  optional :: prefix   !< String prefix.
   integer(I8P),        intent(out), optional :: memory   !< Device memory.
   character(:), allocatable                  :: prefix_  !< String prefix, local var.

   prefix_ = '' ; if (present(prefix)) prefix_ = prefix
   string = prefix_
   if (present(memory)) memory = 0_I8P
   endsubroutine dev_get_property_string

   subroutine dev_init()
   !< Initialize device.
   !< Note: OpenMP does not provide such a runtime routine, added only for seamless unified API.

   endsubroutine dev_init
#else
   function dev_get_device_num() result(device_num)
   !< Return the value of current device ID for the current thread.
   !< Note: host fallback does not provide such a runtime routine, added only for seamless unified API.
   integer(I4P) :: device_num !< Device ID for current thread.

   device_num = 0_I4P
   endfunction dev_get_device_num

   function dev_get_device_type() result(devtype)
   !< Return the device type.
   !< Note: host fallback does not provide such a runtime routine, added only for seamless unified API.
   integer(I4P) :: devtype !< Device type.

   devtype = 0_I4P
   endfunction dev_get_device_type

   function dev_get_host_num() result(host_num)
   !< Return the value of current host ID for the current thread.
   !< Note: host fallback does not provide such a runtime routine, added only for seamless unified API.
   integer(I4P) :: host_num !< Device ID for current thread.

   host_num = 0_I4P
   endfunction dev_get_host_num

   function dev_get_num_devices() result(devices_number)
   !< Return the number of available (non host) devices.
   !< Note: host fallback does not provide such a runtime routine, added only for seamless unified API.
   integer(I4P) :: devices_number !< Devices number.

   devices_number = 1_I4P
   endfunction dev_get_num_devices

   subroutine dev_get_property_string(dev_num, string, prefix, memory)
   !< Return the value of a device-property for the specified device.
   !< Note: host fallback does not provide such a runtime routine, added only for seamless unified API.
   integer, value,      intent(in)            :: dev_num  !< Device ID.
   character(*),        intent(out)           :: string   !< Stringified device property.
   character(*),        intent(in),  optional :: prefix   !< String prefix.
   integer(I8P),        intent(out), optional :: memory   !< Device memory.
   character(:), allocatable                  :: prefix_  !< String prefix, local var.

   prefix_ = '' ; if (present(prefix)) prefix_ = prefix
   string = prefix_
   if (present(memory)) memory = 0_I8P
   endsubroutine dev_get_property_string

   subroutine dev_set_device_num(dev_num)
   !< Set the runtime for the specified device type and device number.
   !< Note: host fallback does not provide such a runtime routine, added only for seamless unified API.
   integer, value, intent(in) :: dev_num !< Device ID.
   endsubroutine dev_set_device_num
#endif
endmodule fundal_dev_handling
