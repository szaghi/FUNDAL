!< FUNDAL, multi devices test.
program fundal_devices_handling_test
!< FUNDAL, multi devices test.
use, intrinsic :: iso_fortran_env, only : I4P=>int32
use            :: fundal

implicit none

integer(I4P)   :: devs_number     !< Devices number.
integer(I4P)   :: i               !< Counter.
character(999) :: property_string !< Stringified device property.

myhos = dev_get_host_num()
print '("current thread host ID =",i3)', myhos
devs_number = dev_get_num_devices()
print '("total number of devices available =",i3)', devs_number
do i=1, devs_number
   mydev = dev_get_device_num()
   call dev_init_device(dev_num=mydev)
   print '("   current thread device ID       =",i3)', mydev
   call dev_get_property_string(dev_num=mydev, string=property_string, prefix='      ')
   print '("   current thread device property = ",A)', new_line('a')//trim(property_string)
enddo

print '(A)', 'test passed'
endprogram fundal_devices_handling_test
