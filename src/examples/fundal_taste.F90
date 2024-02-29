program fundal_taste
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64 ! portable kinds
use            :: fundal                                          ! FUNDAL library

implicit none
real(R8P), pointer :: a_dev(:,:,:)=>null() ! device memory
real(R8P), pointer :: b_hos(:,:,:)=>null() ! host   memory
integer(I4P)       :: ierr                 ! error status
integer(I4P)       :: i, j, k              ! counter

! initialize device
myhos = dev_get_host_num()          ! get host ID
mydev = dev_get_device_num()        ! get device ID
call dev_init_device(dev_num=mydev) ! initialize device

! allocate device memory
call dev_alloc(fptr_dev=a_dev,lbounds=[-1,-2,-3],ubounds=[1,2,3],ierr=ierr,dev_id=mydev)

! allocate host memory
allocate(b_hos(-1:1,-2:2,-3:3))

! set host memory
b_hos = -3._R8P

! copy to device
call dev_memcpy_to_device(fptr_dst=a_dev, fptr_src=b_hos)

! work on device
!$acc parallel loop independent deviceptr(a_dev) collapse(3)
!$omp target teams distribute parallel do collapse(3) has_device_addr(a_dev)
do k=-3,3
  do j=-2,2
    do i=-1,1
       a_dev(i,j,k) = a_dev(i,j,k) / 2._R8P
    enddo
  enddo
enddo

! copy from device
call dev_memcpy_from_device(fptr_dst=b_hos, fptr_src=a_dev)

! check results
print*, b_hos
endprogram fundal_taste
