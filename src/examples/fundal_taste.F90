#include "../lib/fundal.H"

program fundal_taste
!< FUNDAL, a taste: allocate on the device, copy, run a kernel, copy back, check, free.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64 ! portable kinds
use            :: fundal                                          ! FUNDAL library

implicit none
real(R8P), pointer     :: a_dev(:,:,:)=>null() ! device memory
real(R8P), allocatable :: b_hos(:,:,:)         ! host   memory
integer(I4P)           :: ierr                 ! error status
integer(I4P)           :: i, j, k              ! counter

! initialize the device (falls back to the host, with a warning, if there is none)
call dev_init

! allocate device memory, custom bounds
call dev_alloc(fptr_dev=a_dev, lbounds=[-1,-2,-3], ubounds=[1,2,3], ierr=ierr)
if (ierr /= 0) error stop 'fundal_taste: '//dev_error_message(ierr)

! allocate and set host memory
allocate(b_hos(-1:1,-2:2,-3:3))
b_hos = -3._R8P

! copy to device
call dev_memcpy_to_device(dst=a_dev, src=b_hos)

! work on device
!$acc parallel loop independent DEVICEVAR(a_dev) collapse(3)
!$omp OMPLOOP collapse(3) DEVICEPTR(a_dev)
do k=-3,3
  do j=-2,2
    do i=-1,1
       a_dev(i,j,k) = a_dev(i,j,k) / 2._R8P
    enddo
  enddo
enddo

! copy from device
call dev_memcpy_from_device(dst=b_hos, src=a_dev)

! check results
if (any(b_hos /= -1.5_R8P)) error stop 'fundal_taste: wrong result'
print '(A,F5.2)', 'every element halved on the device: ', b_hos(0,0,0)

! free device and host memory
call dev_free(a_dev)
deallocate(b_hos)
endprogram fundal_taste
