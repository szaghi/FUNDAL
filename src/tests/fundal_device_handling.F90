!< FUNDAL, multi devices test.
program fundal_devices_handling_test
!< FUNDAL, multi devices test.
use, intrinsic :: iso_fortran_env, only : I4P=>int32
use            :: openacc
use            :: fundal

implicit none

integer(I4P)   :: devs_number     !< Devices number.
integer(I4P)   :: i               !< Counter.
character(999) :: property_string !< Stringified device property.

myhos = dev_get_device_num(dev_type=acc_device_host)
print '("current thread host ID =",i3)', myhos
devs_number = dev_get_num_devices(dev_type=acc_device_nvidia)
print '("total number of devices available =",i3)', devs_number
do i=1, devs_number
   mydev = dev_get_device_num(dev_type=acc_device_nvidia)
   call dev_init_device(dev_num=mydev, dev_type=acc_device_nvidia)
   print '("   current thread device ID       =",i3)', mydev
   call dev_get_property_string(dev_num=mydev, dev_type=acc_device_nvidia, string=property_string, prefix='      ')
   print '("   current thread device property = ",A)', new_line('a')//trim(property_string)
enddo

endprogram fundal_devices_handling_test
