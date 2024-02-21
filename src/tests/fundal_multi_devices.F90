!< FUNDAL, multi devices test.
program fundal_multi_devices_test
!< FUNDAL, multi devices test.
use, intrinsic :: iso_fortran_env, only : I4P=>int32
use openacc
use fundal

implicit none

integer(I4P) :: devs_number !< Devices number.
integer(I4P) :: mydev       !< Current device ID.
integer(I4P) :: i           !< Counter.

do i=0,0
   call oac_set_device_num(dev_num=0, dev_type=acc_device_nvidia)
   mydev = oac_get_device_num(dev_type=acc_device_nvidia)
   print '("init device id =",i3)', mydev
enddo

devs_number = oac_get_num_devices(dev_type=acc_device_nvidia)
print '("total number of devices available =",i3)', devs_number
do i=0, devs_number - 1
   mydev = oac_get_device_num(dev_type=acc_device_nvidia)
   print '("init device id =",i3)', mydev
enddo
endprogram fundal_multi_devices_test
