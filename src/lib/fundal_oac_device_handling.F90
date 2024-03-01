!< FUNDAL, device handling module, OpenACC backend.
module fundal_oac_device_handling
!< FUNDAL, device handling module, OpenACC backend.
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: openacc,         only : acc_get_device_num,       &
                                          acc_get_num_devices,      &
                                          acc_get_property,         &
                                          acc_set_device_num,       &
                                          acc_device_nvidia,        &
                                          acc_device_host,          &
                                          acc_property_memory,      &
                                          acc_property_free_memory, &
                                          acc_property_name,        &
                                          acc_property_vendor,      &
                                          acc_property_driver

implicit none
private
public :: oac_get_device_num
public :: oac_get_host_num
public :: oac_get_num_devices
public :: oac_get_property_string
public :: oac_set_device_num

contains
   function oac_get_device_num() result(device_num)
   !< Return the value of current device ID for the current thread.
   !< Note: currently only nvidia devices are supported.
   integer(I4P) :: device_num !< Device ID for current thread.

   device_num = acc_get_device_num(acc_device_nvidia)
   endfunction oac_get_device_num

   function oac_get_host_num() result(host_num)
   !< Return the value of current host ID for the current thread.
   integer(I4P) :: host_num !< Device ID for current thread.

   host_num = acc_get_device_num(acc_device_host)
   endfunction oac_get_host_num

   function oac_get_num_devices() result(devices_number)
   !< Return the number of available (non host) devices.
   !< Note: currently only nvidia devices are supported.
   integer(I4P) :: devices_number !< Devices number.

   devices_number = acc_get_num_devices(acc_device_nvidia)
   endfunction oac_get_num_devices

   subroutine oac_get_property_string(dev_num, string, prefix, memory)
   !< Return the value of a device-property for the specified device.
   !< Note: currently only nvidia devices are supported.
   integer, value,                  intent(in)            :: dev_num  !< Device ID.
   character(*),                    intent(out)           :: string   !< Stringified device property.
   character(*),                    intent(in),  optional :: prefix   !< String prefix.
   integer(I8P),                    intent(out), optional :: memory   !< Device memory.
   character(:), allocatable                              :: prefix_  !< String prefix, local var.
   character(99)                                          :: string_  !< Local string buffer.
   integer(I8P)                                           :: memory_  !< Device memory, local var.

   prefix_ = '' ; if (present(prefix)) prefix_ = prefix
   string = ''
   memory_ = acc_get_property(dev_num, acc_device_nvidia, acc_property_memory)
   write(string_,'(I16)') memory_
   if (present(memory)) memory = memory_
   string = trim(string)//prefix_//'memory     : '//trim(adjustl(string_))//new_line('a')
   memory_ = acc_get_property(dev_num, acc_device_nvidia, acc_property_free_memory)
   write(string_,'(I16)') memory_
   string = trim(string)//prefix_//'memory free: '//trim(adjustl(string_))//new_line('a')
   call acc_get_property_string(dev_num, acc_device_nvidia, acc_property_name, string_)
   string = trim(string)//prefix_//'device name: '//trim(adjustl(string_))//new_line('a')
   call acc_get_property_string(dev_num, acc_device_nvidia, acc_property_vendor, string_)
   string = trim(string)//prefix_//'vendor     : '//trim(adjustl(string_))//new_line('a')
   call acc_get_property_string(dev_num, acc_device_nvidia, acc_property_driver, string_)
   string = trim(string)//prefix_//'driver     : '//trim(adjustl(string_))
   endsubroutine oac_get_property_string

   subroutine oac_set_device_num(dev_num)
   !< Set the runtime for the specified device type and device number.
   !< Note: currently only nvidia devices are supported.
   integer, value, intent(in) :: dev_num !< Device ID.

   call acc_set_device_num(dev_num, acc_device_nvidia)
   endsubroutine oac_set_device_num
endmodule fundal_oac_device_handling
