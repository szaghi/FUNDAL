!< FUNDAL, array access test.

#include "fundal.H"

program fundal_array_access_test
!< FUNDAL, array access test.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use fundal

implicit none

real(R8P)              :: tictoc(2)              !< Tic Toc timing.
real(R8P), pointer     :: a_dev(:,:,:,:)=>null() !< Array on device memory.
real(R8P), pointer     :: b_dev(:,:,:,:)=>null() !< Array on device memory.
real(R8P), pointer     :: c_dev(:,:,:,:)=>null() !< Array on device memory.
real(R8P), allocatable :: a(:,:,:,:)             !< Array on host memory.
real(R8P), allocatable :: b(:,:,:,:)             !< Array on host memory.
real(R8P), allocatable :: c(:,:,:,:)             !< Array on host memory.
integer(I4P)           :: n1,n2,n3,n4            !< Sizes.
integer(I4P)           :: i1,i2,i3,i4            !< Counter.
integer(I4P)           :: ierr                   !< Error status.

! initialize environment global variables
myhos = dev_get_host_num()
devtype = dev_get_device_type()
call dev_set_device_num(0)
mydev = dev_get_device_num()

call get_n_cli
print '("n1,n2,n3,n4 = ",4I5)', n1,n2,n3,n4

! allocate device memory
call dev_alloc(fptr_dev=a_dev, ubounds=[n1,n2,n3,n4],ierr=ierr);call error_print(ierr,'a_dev')
call dev_alloc(fptr_dev=b_dev, ubounds=[n1,n2,n3,n4],ierr=ierr);call error_print(ierr,'b_dev')
call dev_alloc(fptr_dev=c_dev, ubounds=[n1,n2,n3,n4],ierr=ierr);call error_print(ierr,'c_dev')

! allocate host memory
allocate(a(n1,n2,n3,n4))
allocate(b(n1,n2,n3,n4))
allocate(c(n1,n2,n3,n4))

! initialize data on device
!$acc parallel loop independent collapse(4) DEVICEVAR(a_dev,b_dev)
!$omp OMPLOOP collapse(4) DEVICEPTR(a_dev,b_dev)
do i4=1, n4
do i3=1, n3
do i2=1, n2
do i1=1, n1
   a_dev(i1,i2,i3,i4) = i1*i2*i3*i4/2.3_R8P
   b_dev(i1,i2,i3,i4) = (i1+i2+i3+i4)*7.1_R8P
enddo
enddo
enddo
enddo

! initialize data on host
do i4=1, n4
do i3=1, n3
do i2=1, n2
do i1=1, n1
   a(i1,i2,i3,i4) = i1*i2*i3*i4/2.3_R8P
   b(i1,i2,i3,i4) = (i1+i2+i3+i4)*7.1_R8P
enddo
enddo
enddo
enddo

! profile device
print '(A)', 'device timing'
call cpu_time(tictoc(1))
!$acc parallel loop independent collapse(4) DEVICEVAR(a_dev,b_dev,c_dev)
!$omp OMPLOOP collapse(4) DEVICEPTR(a_dev,b_dev,c_dev)
do i4=1, n4
do i3=1, n3
do i2=1, n2
do i1=1, n1
   c_dev(i1,i2,i3,i4) = sqrt(a_dev(i1,i2,i3,i4) * b_dev(i1,i2,i3,i4)**3)
enddo
enddo
enddo
enddo
call cpu_time(tictoc(2))
print '("i4,i3,i2,i1-collapse(4) order time = ",f12.9," seconds.")', (tictoc(2) - tictoc(1))

call cpu_time(tictoc(1))
!$acc parallel loop independent collapse(4) DEVICEVAR(a_dev,b_dev,c_dev)
!$omp OMPLOOP collapse(4) DEVICEPTR(a_dev,b_dev,c_dev)
do i1=1, n1
do i2=1, n2
do i3=1, n3
do i4=1, n4
   c_dev(i1,i2,i3,i4) = sqrt(a_dev(i1,i2,i3,i4) * b_dev(i1,i2,i3,i4)**3)
enddo
enddo
enddo
enddo
call cpu_time(tictoc(2))
print '("i1,i2,i3,i4-collapse(4) order time = ",f12.9," seconds.")', (tictoc(2) - tictoc(1))

call cpu_time(tictoc(1))
!$acc parallel loop independent collapse(3) DEVICEVAR(a_dev,b_dev,c_dev)
!$omp OMPLOOP collapse(3) DEVICEPTR(a_dev,b_dev,c_dev)
do i3=1, n3
do i2=1, n2
do i1=1, n1
!$acc loop
do i4=1, n4
   c_dev(i1,i2,i3,i4) = sqrt(a_dev(i1,i2,i3,i4) * b_dev(i1,i2,i3,i4)**3)
enddo
enddo
enddo
enddo
call cpu_time(tictoc(2))
print '("i3,i2,i1,i4-collapse(3) order time = ",f12.9," seconds.")', (tictoc(2) - tictoc(1))

call cpu_time(tictoc(1))
!$acc parallel loop independent collapse(3) DEVICEVAR(a_dev,b_dev,c_dev)
!$omp OMPLOOP collapse(3) DEVICEPTR(a_dev,b_dev,c_dev)
do i1=1, n1
do i2=1, n2
do i3=1, n3
!$acc loop
do i4=1, n4
   c_dev(i1,i2,i3,i4) = sqrt(a_dev(i1,i2,i3,i4) * b_dev(i1,i2,i3,i4)**3)
enddo
enddo
enddo
enddo
call cpu_time(tictoc(2))
print '("i1,i2,i3,i4-collapse(3) order time = ",f12.9," seconds.")', (tictoc(2) - tictoc(1))

! profile unstructured approach
print '(A)', 'device unstructured timing'
call dev_alloc_unstr(a)
call dev_alloc_unstr(b)
call dev_alloc_unstr(c)
call cpu_time(tictoc(1))
!$acc parallel loop independent collapse(4) present(a,b,c)
!$omp OMPLOOP collapse(4) DEVICEVAR(a,b,c)
do i4=1, n4
do i3=1, n3
do i2=1, n2
do i1=1, n1
   c(i1,i2,i3,i4) = sqrt(a(i1,i2,i3,i4) * b(i1,i2,i3,i4)**3)
enddo
enddo
enddo
enddo
call cpu_time(tictoc(2))
call dev_free_unstr(a)
call dev_free_unstr(b)
call dev_free_unstr(c)
print '("i4,i3,i2,i1-collapse(4) order time = ",f12.9," seconds.")', (tictoc(2) - tictoc(1))

! profile host for comparison
print '(A)', 'host timing'
call cpu_time(tictoc(1))
do i4=1, n4
do i3=1, n3
do i2=1, n2
do i1=1, n1
   c(i1,i2,i3,i4) = sqrt(a(i1,i2,i3,i4) * b(i1,i2,i3,i4)**3)
enddo
enddo
enddo
enddo
call cpu_time(tictoc(2))
print '("i4,i3,i2,i1 order time = ",f12.9," seconds.")', (tictoc(2) - tictoc(1))

print '(A)', 'test passed'

contains
   subroutine get_n_cli
   !< Get n1,n2,n3,n4 from Command Line Interface.
   character(1000) :: nstr !< Number of elements of arrays, stringified.

   n1 = 128
   n2 = 128
   n3 = 128
   n4 = 6
   if(command_argument_count() >= 1)then
      call get_command_argument(1, nstr)
      read(nstr, *) n1,n2,n3,n4
   endif
   endsubroutine get_n_cli

   subroutine error_print(error, msg)
   !< Print error message.
   integer(I4P), intent(in) :: error !< Error status.
   character(*), intent(in) :: msg   !< Error message.

   if (error /= 0) then
      print '(A)', 'error: '//trim(adjustl(msg))//' not allocated!'
      stop
   endif
   endsubroutine error_print
endprogram fundal_array_access_test
