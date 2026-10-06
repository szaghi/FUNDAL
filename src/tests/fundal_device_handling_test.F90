!< FUNDAL, multi devices test.
program fundal_devices_handling_test
!< FUNDAL, multi devices test.
use, intrinsic :: iso_fortran_env, only : I4P=>int32
use            :: fundal

implicit none

integer(I4P)   :: i               !< Counter.
character(999) :: property_string !< Stringified device property.

devtype = dev_get_device_type()
myhos = dev_get_host_num()
print '("current thread host ID =",i3)', myhos
devs_number = dev_get_num_devices()
print '("total number of devices available =",i3)', devs_number
do i=0, devs_number - 1
   call dev_set_device_num(i)
   if (mydev /= i .or. mydev /= dev_get_device_num()) then
      print '("error: mydev=",i3," does not follow dev_set_device_num(",i3,")")', mydev, i
      error stop 1
   endif
   print '("   current thread device ID       =",i3)', mydev
   call dev_get_property_string(dev_num=mydev, string=property_string, prefix='      ')
   print '("   current thread device property = ",A)', new_line('a')//trim(property_string)
enddo

call dev_set_device_num(dev_num=0) ! keyword accepted by every backend
if (mydev /= 0) then
   print '(A)', 'error: mydev does not follow dev_set_device_num(dev_num=0)'
   error stop 1
endif

print '(A)', 'test passed'
endprogram fundal_devices_handling_test
