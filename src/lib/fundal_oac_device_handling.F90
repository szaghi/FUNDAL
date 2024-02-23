!< FUNDAL, device handling module.
module fundal_oac_device_handling
!< FUNDAL, device handling module.
use, intrinsic :: iso_fortran_env,   only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: openacc

implicit none
private
public :: oac_get_device_num
public :: oac_get_num_devices
public :: oac_get_property_string
public :: oac_init_device

contains
   function oac_get_device_num(dev_type) result(device_num)
   !< Return the value of current device ID for the current thread.
   integer(acc_device_kind) :: dev_type   !< Device type.
   integer(I4P)             :: device_num !< Device ID for current thread.

   device_num = acc_get_device_num(dev_type)
   endfunction oac_get_device_num

   function oac_get_num_devices(dev_type) result(devices_number)
   !< Return the number of available devices of the given type.
   integer(acc_device_kind), intent(in) :: dev_type       !< Devices type.
   integer(I4P)                         :: devices_number !< Devices number.

   devices_number = acc_get_num_devices(dev_type)
   endfunction oac_get_num_devices

   subroutine oac_get_property_string(dev_num, dev_type, string, prefix, memory)
   !< Return the value of a device-property for the specified device
   integer, value,                  intent(in)            :: dev_num  !< Device ID.
   integer(acc_device_kind), value, intent(in)            :: dev_type !< Device type.
   character(*),                    intent(out)           :: string   !< Stringified device property.
   character(*),                    intent(in),  optional :: prefix   !< String prefix.
   integer(I8P),                    intent(out), optional :: memory   !< Device memory.
   character(:), allocatable                              :: prefix_  !< String prefix, local var.
   character(99)                                          :: string_  !< Local string buffer.
   integer(I8P)                                           :: memory_  !< Device memory, local var.

   prefix_ = '' ; if (present(prefix)) prefix_ = prefix
   string = ''
   memory_ = acc_get_property(dev_num, dev_type, acc_property_memory)
   write(string_,'(I16)') memory_
   if (present(memory)) memory = memory_
   string = trim(string)//prefix_//'memory     : '//trim(adjustl(string_))//new_line('a')
   memory_ = acc_get_property(dev_num, dev_type, acc_property_free_memory)
   write(string_,'(I16)') memory_
   string = trim(string)//prefix_//'memory free: '//trim(adjustl(string_))//new_line('a')
   call acc_get_property_string(dev_num, dev_type, acc_property_name, string_)
   string = trim(string)//prefix_//'device name: '//trim(adjustl(string_))//new_line('a')
   call acc_get_property_string(dev_num, dev_type, acc_property_vendor, string_)
   string = trim(string)//prefix_//'vendor     : '//trim(adjustl(string_))//new_line('a')
   call acc_get_property_string(dev_num, dev_type, acc_property_driver, string_)
   string = trim(string)//prefix_//'driver     : '//trim(adjustl(string_))
   endsubroutine oac_get_property_string

   subroutine oac_init_device(dev_num, dev_type)
   !< initialize the runtime for the specified device type and device number.
   !< This can be used to isolate any initialization cost from the computational cost.
   integer, value,                  intent(in) :: dev_num  !< Device ID.
   integer(acc_device_kind), value, intent(in) :: dev_type !< Device type.

   call acc_init_device(dev_num, dev_type)
   endsubroutine oac_init_device
endmodule fundal_oac_device_handling
