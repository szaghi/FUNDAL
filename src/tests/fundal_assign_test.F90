!< FUNDAL, device memory assign test.

#include "fundal.H"

program fundal_assign_test
!< FUNDAL, device memory assign test.

use, intrinsic :: iso_fortran_env, only : I1P=>int8, I2P=>int16, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use fundal

implicit none

integer(I4P) :: n !< Number of elements of arrays.

call dev_init
call get_n_cli
call test_R8P
call test_R4P
call test_I8P
call test_I4P
call test_I2P
call test_I1P

print '(A)', 'test passed'
contains
   subroutine get_n_cli
   !< Get n from Command Line Interface.
   character(10) :: nstr !< Number of elements of arrays, stringified.

   n = 10
   if(command_argument_count() >= 1)then
      call get_command_argument(1, nstr)
      read(nstr, *) n
      if (n <= 0) n = 10
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

   subroutine test_R8P
   !< Test R8P kind.
   real(R8P), pointer             :: a1_dev(:)=>null()             !< Array on device memory.
   real(R8P), pointer             :: a2_dev(:,:)=>null()           !< Array on device memory.
   real(R8P), pointer             :: a3_dev(:,:,:)=>null()         !< Array on device memory.
   real(R8P), pointer             :: a4_dev(:,:,:,:)=>null()       !< Array on device memory.
   real(R8P), pointer             :: a5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   real(R8P), pointer             :: a6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   real(R8P), pointer             :: a7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   real(R8P), pointer             :: b1_dev(:)=>null()             !< Array on device memory.
   real(R8P), pointer             :: b2_dev(:,:)=>null()           !< Array on device memory.
   real(R8P), pointer             :: b3_dev(:,:,:)=>null()         !< Array on device memory.
   real(R8P), pointer             :: b4_dev(:,:,:,:)=>null()       !< Array on device memory.
   real(R8P), pointer             :: b5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   real(R8P), pointer             :: b6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   real(R8P), pointer             :: b7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   real(R8P), allocatable, target :: a1(:)                         !< Array on host memory.
   real(R8P), allocatable, target :: a2(:,:)                       !< Array on host memory.
   real(R8P), allocatable, target :: a3(:,:,:)                     !< Array on host memory.
   real(R8P), allocatable, target :: a4(:,:,:,:)                   !< Array on host memory.
   real(R8P), allocatable, target :: a5(:,:,:,:,:)                 !< Array on host memory.
   real(R8P), allocatable, target :: a6(:,:,:,:,:,:)               !< Array on host memory.
   real(R8P), allocatable, target :: a7(:,:,:,:,:,:,:)             !< Array on host memory.
   real(R8P), allocatable, target :: b1(:)                         !< Array on host memory.
   real(R8P), allocatable, target :: b2(:,:)                       !< Array on host memory.
   real(R8P), allocatable, target :: b3(:,:,:)                     !< Array on host memory.
   real(R8P), allocatable, target :: b4(:,:,:,:)                   !< Array on host memory.
   real(R8P), allocatable, target :: b5(:,:,:,:,:)                 !< Array on host memory.
   real(R8P), allocatable, target :: b6(:,:,:,:,:,:)               !< Array on host memory.
   real(R8P), allocatable, target :: b7(:,:,:,:,:,:,:)             !< Array on host memory.
   integer(I4P)                   :: ierr                          !< Error status.
   integer(I4P)                   :: i1,i2,i3,i4,i5,i6,i7          !< Counter.

   print '(A)', 'test R8P'
   allocate(a1(n            ),b1(n            ),&
            a2(n,n          ),b2(n,n          ),&
            a3(n,n,n        ),b3(n,n,n        ),&
            a4(n,n,n,n      ),b4(n,n,n,n      ),&
            a5(n,n,n,n,n    ),b5(n,n,n,n,n    ),&
            a6(n,n,n,n,n,n  ),b6(n,n,n,n,n,n  ),&
            a7(n,n,n,n,n,n,n),b7(n,n,n,n,n,n,n))
   do i1= 1, n
      a1(i1) = i1
   enddo
   do i2= 1, n ; do i1= 1, n
      a2(i1,i2) = i1
   enddo ; enddo
   do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a3(i1,i2,i3) = i1
   enddo ; enddo ; enddo
   do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a4(i1,i2,i3,i4) = i1
   enddo ; enddo ; enddo ; enddo
   do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a5(i1,i2,i3,i4,i5) = i1
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6= 1, n ; do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a6(i1,i2,i3,i4,i5,i6) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7= 1, n ; do i6= 1, n ; do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a7(i1,i2,i3,i4,i5,i6,i7) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! allocate device memory
   call dev_alloc(fptr_dev=b1_dev, ubounds=[n            ],ierr=ierr);call error_print(ierr,'b1_dev')
   call dev_alloc(fptr_dev=b2_dev, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'b2_dev')
   call dev_alloc(fptr_dev=b3_dev, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'b3_dev')
   call dev_alloc(fptr_dev=b4_dev, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'b4_dev')
   call dev_alloc(fptr_dev=b5_dev, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'b5_dev')
   call dev_alloc(fptr_dev=b6_dev, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'b6_dev')
   call dev_alloc(fptr_dev=b7_dev, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'b7_dev')

   ! assign host memory to device one
   print '(A)', '    assign memory to device'
   call dev_assign_to_device(src=a1, dst=a1_dev)
   call dev_assign_to_device(src=a2, dst=a2_dev)
   call dev_assign_to_device(src=a3, dst=a3_dev)
   call dev_assign_to_device(src=a4, dst=a4_dev)
   call dev_assign_to_device(src=a5, dst=a5_dev)
   call dev_assign_to_device(src=a6, dst=a6_dev)
   call dev_assign_to_device(src=a7, dst=a7_dev)

   ! do some operation on device
   print '(A)', '    compute on device'
   !$acc parallel loop independent DEVICEVAR(a1_dev, b1_dev)
   !$omp OMPLOOP DEVICEPTR(a1_dev, b1_dev)
   do i1 = 1, n
      b1_dev(i1) = a1_dev(i1) + 10
   enddo
   !$acc parallel loop independent DEVICEVAR(a2_dev, b2_dev)
   !$omp OMPLOOP DEVICEPTR(a2_dev, b2_dev)
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b2_dev(i1,i2) = a2_dev(i1,i2) + 10
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a3_dev, b3_dev)
   !$omp OMPLOOP DEVICEPTR(a3_dev, b3_dev)
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b3_dev(i1,i2,i3) = a3_dev(i1,i2,i3) + 10
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a4_dev, b4_dev)
   !$omp OMPLOOP DEVICEPTR(a4_dev, b4_dev)
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b4_dev(i1,i2,i3,i4) = a4_dev(i1,i2,i3,i4) + 10
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a5_dev, b5_dev)
   !$omp OMPLOOP DEVICEPTR(a5_dev, b5_dev)
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b5_dev(i1,i2,i3,i4,i5) = a5_dev(i1,i2,i3,i4,i5) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a6_dev, b6_dev)
   !$omp OMPLOOP DEVICEPTR(a6_dev, b6_dev)
   do i6 = 1, n
   !$acc loop
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b6_dev(i1,i2,i3,i4,i5,i6) = a6_dev(i1,i2,i3,i4,i5,i6) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a7_dev, b7_dev)
   !$omp OMPLOOP DEVICEPTR(a7_dev, b7_dev)
   do i7 = 1, n
   !$acc loop
   do i6 = 1, n
   !$acc loop
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b7_dev(i1,i2,i3,i4,i5,i6,i7) = a7_dev(i1,i2,i3,i4,i5,i6,i7) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   ! assign device memory to host one
   print '(A)', '    assign memory from device'
   call dev_assign_from_device(src=b1_dev, dst=b1)
   call dev_assign_from_device(src=b2_dev, dst=b2)
   call dev_assign_from_device(src=b3_dev, dst=b3)
   call dev_assign_from_device(src=b4_dev, dst=b4)
   call dev_assign_from_device(src=b5_dev, dst=b5)
   call dev_assign_from_device(src=b6_dev, dst=b6)
   call dev_assign_from_device(src=b7_dev, dst=b7)
   ! check results
   print '(A)', '    chek results'
   do i1=1, n
      if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo
   do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo
   do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! assign transposed host memory to device one
   print '(A)', '    assign transposed memory to device'
   call dev_assign_to_device(src=a2, dst=a2_dev, transposed=.true.)
   ! assign device memory to host one
   print '(A)', '    assign memory from device'
   call dev_assign_from_device(src=a2_dev, dst=b2)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i2,I4P) /= 0_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   ! assign transposed device memory to host one
   print '(A)', '    assign transposed memory from device'
   call dev_assign_from_device(src=a2_dev, dst=b2, transposed=.true.)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i1,I4P) /= 0_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   !print '(A)', '    test unstructured memory'
   !call dev_alloc_unstr(a1) ; call dev_alloc_unstr(b1)
   !call dev_alloc_unstr(a2) ; call dev_alloc_unstr(b2)
   !call dev_alloc_unstr(a3) ; call dev_alloc_unstr(b3)
   !call dev_alloc_unstr(a4) ; call dev_alloc_unstr(b4)
   !call dev_alloc_unstr(a5) ; call dev_alloc_unstr(b5)
   !call dev_alloc_unstr(a6) ; call dev_alloc_unstr(b6)
   !call dev_alloc_unstr(a7) ; call dev_alloc_unstr(b7)
   !call dev_assign_to_device_unstr(a1)
   !call dev_assign_to_device_unstr(a2)
   !call dev_assign_to_device_unstr(a3)
   !call dev_assign_to_device_unstr(a4)
   !call dev_assign_to_device_unstr(a5)
   !call dev_assign_to_device_unstr(a6)
   !call dev_assign_to_device_unstr(a7)
   !! do some operation on device
   !print '(A)', '    compute on device'
   !!$acc parallel loop independent present(a1, b1)
   !do i1 = 1, n
   !   b1(i1) = a1(i1) + 10
   !enddo
   !!$acc parallel loop independent present(a2, b2)
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b2(i1,i2) = a2(i1,i2) + 10
   !enddo
   !enddo
   !!$acc parallel loop independent present(a3, b3)
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b3(i1,i2,i3) = a3(i1,i2,i3) + 10
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a4, b4)
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b4(i1,i2,i3,i4) = a4(i1,i2,i3,i4) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a5, b5)
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b5(i1,i2,i3,i4,i5) = a5(i1,i2,i3,i4,i5) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a6, b6)
   !do i6 = 1, n
   !!$acc loop
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b6(i1,i2,i3,i4,i5,i6) = a6(i1,i2,i3,i4,i5,i6) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a7, b7)
   !do i7 = 1, n
   !!$acc loop
   !do i6 = 1, n
   !!$acc loop
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b7(i1,i2,i3,i4,i5,i6,i7) = a7(i1,i2,i3,i4,i5,i6,i7) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !! assign device memory to host one
   !print '(A)', '    assign memory from device'
   !call dev_assign_from_device_unstr(b1)
   !call dev_assign_from_device_unstr(b2)
   !call dev_assign_from_device_unstr(b3)
   !call dev_assign_from_device_unstr(b4)
   !call dev_assign_from_device_unstr(b5)
   !call dev_assign_from_device_unstr(b6)
   !call dev_assign_from_device_unstr(b7)
   !! check results
   !print '(A)', '    chek results'
   !do i1=1, n
   !   if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(1):', int(b1(i1) - a1(i1),I4P)
   !      stop
   !   endif
   !enddo
   !do i2=1, n ; do i1=1, n
   !   if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(2):', int(b2(i1,i2) - a2(i1,i2),I4P)
   !      stop
   !   endif
   !enddo ; enddo
   !do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(3):', int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo
   !do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(4):', int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo
   !do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(5):', int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo
   !do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(6):', int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   !do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(7):', int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   call dev_free(a1_dev,dev_id=mydev)!; call dev_free_unstr(a1)
   call dev_free(a2_dev,dev_id=mydev)!; call dev_free_unstr(a2)
   call dev_free(a3_dev,dev_id=mydev)!; call dev_free_unstr(a3)
   call dev_free(a4_dev,dev_id=mydev)!; call dev_free_unstr(a4)
   call dev_free(a5_dev,dev_id=mydev)!; call dev_free_unstr(a5)
   call dev_free(a6_dev,dev_id=mydev)!; call dev_free_unstr(a6)
   call dev_free(a7_dev,dev_id=mydev)!; call dev_free_unstr(a7)
   call dev_free(b1_dev,dev_id=mydev)!; call dev_free_unstr(b1)
   call dev_free(b2_dev,dev_id=mydev)!; call dev_free_unstr(b2)
   call dev_free(b3_dev,dev_id=mydev)!; call dev_free_unstr(b3)
   call dev_free(b4_dev,dev_id=mydev)!; call dev_free_unstr(b4)
   call dev_free(b5_dev,dev_id=mydev)!; call dev_free_unstr(b5)
   call dev_free(b6_dev,dev_id=mydev)!; call dev_free_unstr(b6)
   call dev_free(b7_dev,dev_id=mydev)!; call dev_free_unstr(b7)
   endsubroutine test_R8P

   subroutine test_R4P
   !< Test R4P kind.
   real(R4P), pointer             :: a1_dev(:)=>null()             !< Array on device memory.
   real(R4P), pointer             :: a2_dev(:,:)=>null()           !< Array on device memory.
   real(R4P), pointer             :: a3_dev(:,:,:)=>null()         !< Array on device memory.
   real(R4P), pointer             :: a4_dev(:,:,:,:)=>null()       !< Array on device memory.
   real(R4P), pointer             :: a5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   real(R4P), pointer             :: a6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   real(R4P), pointer             :: a7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   real(R4P), pointer             :: b1_dev(:)=>null()             !< Array on device memory.
   real(R4P), pointer             :: b2_dev(:,:)=>null()           !< Array on device memory.
   real(R4P), pointer             :: b3_dev(:,:,:)=>null()         !< Array on device memory.
   real(R4P), pointer             :: b4_dev(:,:,:,:)=>null()       !< Array on device memory.
   real(R4P), pointer             :: b5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   real(R4P), pointer             :: b6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   real(R4P), pointer             :: b7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   real(R4P), allocatable, target :: a1(:)                         !< Array on host memory.
   real(R4P), allocatable, target :: a2(:,:)                       !< Array on host memory.
   real(R4P), allocatable, target :: a3(:,:,:)                     !< Array on host memory.
   real(R4P), allocatable, target :: a4(:,:,:,:)                   !< Array on host memory.
   real(R4P), allocatable, target :: a5(:,:,:,:,:)                 !< Array on host memory.
   real(R4P), allocatable, target :: a6(:,:,:,:,:,:)               !< Array on host memory.
   real(R4P), allocatable, target :: a7(:,:,:,:,:,:,:)             !< Array on host memory.
   real(R4P), allocatable, target :: b1(:)                         !< Array on host memory.
   real(R4P), allocatable, target :: b2(:,:)                       !< Array on host memory.
   real(R4P), allocatable, target :: b3(:,:,:)                     !< Array on host memory.
   real(R4P), allocatable, target :: b4(:,:,:,:)                   !< Array on host memory.
   real(R4P), allocatable, target :: b5(:,:,:,:,:)                 !< Array on host memory.
   real(R4P), allocatable, target :: b6(:,:,:,:,:,:)               !< Array on host memory.
   real(R4P), allocatable, target :: b7(:,:,:,:,:,:,:)             !< Array on host memory.
   integer(I4P)                   :: ierr                          !< Error status.
   integer(I4P)                   :: i1,i2,i3,i4,i5,i6,i7          !< Counter.

   print '(A)', 'test R4P'
   allocate(a1(n            ),b1(n            ),&
            a2(n,n          ),b2(n,n          ),&
            a3(n,n,n        ),b3(n,n,n        ),&
            a4(n,n,n,n      ),b4(n,n,n,n      ),&
            a5(n,n,n,n,n    ),b5(n,n,n,n,n    ),&
            a6(n,n,n,n,n,n  ),b6(n,n,n,n,n,n  ),&
            a7(n,n,n,n,n,n,n),b7(n,n,n,n,n,n,n))
   do i1= 1, n
      a1(i1) = i1
   enddo
   do i2= 1, n ; do i1= 1, n
      a2(i1,i2) = i1
   enddo ; enddo
   do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a3(i1,i2,i3) = i1
   enddo ; enddo ; enddo
   do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a4(i1,i2,i3,i4) = i1
   enddo ; enddo ; enddo ; enddo
   do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a5(i1,i2,i3,i4,i5) = i1
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6= 1, n ; do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a6(i1,i2,i3,i4,i5,i6) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7= 1, n ; do i6= 1, n ; do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a7(i1,i2,i3,i4,i5,i6,i7) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! allocate device memory
   call dev_alloc(fptr_dev=b1_dev, ubounds=[n            ],ierr=ierr);call error_print(ierr,'b1_dev')
   call dev_alloc(fptr_dev=b2_dev, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'b2_dev')
   call dev_alloc(fptr_dev=b3_dev, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'b3_dev')
   call dev_alloc(fptr_dev=b4_dev, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'b4_dev')
   call dev_alloc(fptr_dev=b5_dev, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'b5_dev')
   call dev_alloc(fptr_dev=b6_dev, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'b6_dev')
   call dev_alloc(fptr_dev=b7_dev, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'b7_dev')

   ! assign host memory to device one
   print '(A)', '    assign memory to device'
   call dev_assign_to_device(src=a1, dst=a1_dev)
   call dev_assign_to_device(src=a2, dst=a2_dev)
   call dev_assign_to_device(src=a3, dst=a3_dev)
   call dev_assign_to_device(src=a4, dst=a4_dev)
   call dev_assign_to_device(src=a5, dst=a5_dev)
   call dev_assign_to_device(src=a6, dst=a6_dev)
   call dev_assign_to_device(src=a7, dst=a7_dev)

   ! do some operation on device
   print '(A)', '    compute on device'
   !$acc parallel loop independent DEVICEVAR(a1_dev, b1_dev)
   !$omp OMPLOOP DEVICEPTR(a1_dev, b1_dev)
   do i1 = 1, n
      b1_dev(i1) = a1_dev(i1) + 10
   enddo
   !$acc parallel loop independent DEVICEVAR(a2_dev, b2_dev)
   !$omp OMPLOOP DEVICEPTR(a2_dev, b2_dev)
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b2_dev(i1,i2) = a2_dev(i1,i2) + 10
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a3_dev, b3_dev)
   !$omp OMPLOOP DEVICEPTR(a3_dev, b3_dev)
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b3_dev(i1,i2,i3) = a3_dev(i1,i2,i3) + 10
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a4_dev, b4_dev)
   !$omp OMPLOOP DEVICEPTR(a4_dev, b4_dev)
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b4_dev(i1,i2,i3,i4) = a4_dev(i1,i2,i3,i4) + 10
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a5_dev, b5_dev)
   !$omp OMPLOOP DEVICEPTR(a5_dev, b5_dev)
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b5_dev(i1,i2,i3,i4,i5) = a5_dev(i1,i2,i3,i4,i5) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a6_dev, b6_dev)
   !$omp OMPLOOP DEVICEPTR(a6_dev, b6_dev)
   do i6 = 1, n
   !$acc loop
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b6_dev(i1,i2,i3,i4,i5,i6) = a6_dev(i1,i2,i3,i4,i5,i6) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a7_dev, b7_dev)
   !$omp OMPLOOP DEVICEPTR(a7_dev, b7_dev)
   do i7 = 1, n
   !$acc loop
   do i6 = 1, n
   !$acc loop
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b7_dev(i1,i2,i3,i4,i5,i6,i7) = a7_dev(i1,i2,i3,i4,i5,i6,i7) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   ! assign device memory to host one
   print '(A)', '    assign memory from device'
   call dev_assign_from_device(src=b1_dev, dst=b1)
   call dev_assign_from_device(src=b2_dev, dst=b2)
   call dev_assign_from_device(src=b3_dev, dst=b3)
   call dev_assign_from_device(src=b4_dev, dst=b4)
   call dev_assign_from_device(src=b5_dev, dst=b5)
   call dev_assign_from_device(src=b6_dev, dst=b6)
   call dev_assign_from_device(src=b7_dev, dst=b7)
   ! check results
   print '(A)', '    chek results'
   do i1=1, n
      if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo
   do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo
   do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! assign transposed host memory to device one
   print '(A)', '    assign transposed memory to device'
   call dev_assign_to_device(src=a2, dst=a2_dev, transposed=.true.)
   ! assign device memory to host one
   print '(A)', '    assign memory from device'
   call dev_assign_from_device(src=a2_dev, dst=b2)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i2,I4P) /= 0_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   ! assign transposed device memory to host one
   print '(A)', '    assign transposed memory from device'
   call dev_assign_from_device(src=a2_dev, dst=b2, transposed=.true.)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i1,I4P) /= 0_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   !print '(A)', '    test unstructured memory'
   !call dev_alloc_unstr(a1) ; call dev_alloc_unstr(b1)
   !call dev_alloc_unstr(a2) ; call dev_alloc_unstr(b2)
   !call dev_alloc_unstr(a3) ; call dev_alloc_unstr(b3)
   !call dev_alloc_unstr(a4) ; call dev_alloc_unstr(b4)
   !call dev_alloc_unstr(a5) ; call dev_alloc_unstr(b5)
   !call dev_alloc_unstr(a6) ; call dev_alloc_unstr(b6)
   !call dev_alloc_unstr(a7) ; call dev_alloc_unstr(b7)
   !call dev_assign_to_device_unstr(a1)
   !call dev_assign_to_device_unstr(a2)
   !call dev_assign_to_device_unstr(a3)
   !call dev_assign_to_device_unstr(a4)
   !call dev_assign_to_device_unstr(a5)
   !call dev_assign_to_device_unstr(a6)
   !call dev_assign_to_device_unstr(a7)
   !! do some operation on device
   !print '(A)', '    compute on device'
   !!$acc parallel loop independent present(a1, b1)
   !do i1 = 1, n
   !   b1(i1) = a1(i1) + 10
   !enddo
   !!$acc parallel loop independent present(a2, b2)
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b2(i1,i2) = a2(i1,i2) + 10
   !enddo
   !enddo
   !!$acc parallel loop independent present(a3, b3)
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b3(i1,i2,i3) = a3(i1,i2,i3) + 10
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a4, b4)
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b4(i1,i2,i3,i4) = a4(i1,i2,i3,i4) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a5, b5)
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b5(i1,i2,i3,i4,i5) = a5(i1,i2,i3,i4,i5) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a6, b6)
   !do i6 = 1, n
   !!$acc loop
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b6(i1,i2,i3,i4,i5,i6) = a6(i1,i2,i3,i4,i5,i6) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a7, b7)
   !do i7 = 1, n
   !!$acc loop
   !do i6 = 1, n
   !!$acc loop
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b7(i1,i2,i3,i4,i5,i6,i7) = a7(i1,i2,i3,i4,i5,i6,i7) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !! assign device memory to host one
   !print '(A)', '    assign memory from device'
   !call dev_assign_from_device_unstr(b1)
   !call dev_assign_from_device_unstr(b2)
   !call dev_assign_from_device_unstr(b3)
   !call dev_assign_from_device_unstr(b4)
   !call dev_assign_from_device_unstr(b5)
   !call dev_assign_from_device_unstr(b6)
   !call dev_assign_from_device_unstr(b7)
   !! check results
   !print '(A)', '    chek results'
   !do i1=1, n
   !   if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(1):', int(b1(i1) - a1(i1),I4P)
   !      stop
   !   endif
   !enddo
   !do i2=1, n ; do i1=1, n
   !   if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(2):', int(b2(i1,i2) - a2(i1,i2),I4P)
   !      stop
   !   endif
   !enddo ; enddo
   !do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(3):', int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo
   !do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(4):', int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo
   !do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(5):', int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo
   !do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(6):', int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   !do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(7):', int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   call dev_free(a1_dev,dev_id=mydev)!; call dev_free_unstr(a1)
   call dev_free(a2_dev,dev_id=mydev)!; call dev_free_unstr(a2)
   call dev_free(a3_dev,dev_id=mydev)!; call dev_free_unstr(a3)
   call dev_free(a4_dev,dev_id=mydev)!; call dev_free_unstr(a4)
   call dev_free(a5_dev,dev_id=mydev)!; call dev_free_unstr(a5)
   call dev_free(a6_dev,dev_id=mydev)!; call dev_free_unstr(a6)
   call dev_free(a7_dev,dev_id=mydev)!; call dev_free_unstr(a7)
   call dev_free(b1_dev,dev_id=mydev)!; call dev_free_unstr(b1)
   call dev_free(b2_dev,dev_id=mydev)!; call dev_free_unstr(b2)
   call dev_free(b3_dev,dev_id=mydev)!; call dev_free_unstr(b3)
   call dev_free(b4_dev,dev_id=mydev)!; call dev_free_unstr(b4)
   call dev_free(b5_dev,dev_id=mydev)!; call dev_free_unstr(b5)
   call dev_free(b6_dev,dev_id=mydev)!; call dev_free_unstr(b6)
   call dev_free(b7_dev,dev_id=mydev)!; call dev_free_unstr(b7)
   endsubroutine test_R4P

   subroutine test_I8P
   !< Test I8P kind.
   integer(I8P), pointer             :: a1_dev(:)=>null()             !< Array on device memory.
   integer(I8P), pointer             :: a2_dev(:,:)=>null()           !< Array on device memory.
   integer(I8P), pointer             :: a3_dev(:,:,:)=>null()         !< Array on device memory.
   integer(I8P), pointer             :: a4_dev(:,:,:,:)=>null()       !< Array on device memory.
   integer(I8P), pointer             :: a5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   integer(I8P), pointer             :: a6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   integer(I8P), pointer             :: a7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   integer(I8P), pointer             :: b1_dev(:)=>null()             !< Array on device memory.
   integer(I8P), pointer             :: b2_dev(:,:)=>null()           !< Array on device memory.
   integer(I8P), pointer             :: b3_dev(:,:,:)=>null()         !< Array on device memory.
   integer(I8P), pointer             :: b4_dev(:,:,:,:)=>null()       !< Array on device memory.
   integer(I8P), pointer             :: b5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   integer(I8P), pointer             :: b6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   integer(I8P), pointer             :: b7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   integer(I8P), allocatable, target :: a1(:)                         !< Array on host memory.
   integer(I8P), allocatable, target :: a2(:,:)                       !< Array on host memory.
   integer(I8P), allocatable, target :: a3(:,:,:)                     !< Array on host memory.
   integer(I8P), allocatable, target :: a4(:,:,:,:)                   !< Array on host memory.
   integer(I8P), allocatable, target :: a5(:,:,:,:,:)                 !< Array on host memory.
   integer(I8P), allocatable, target :: a6(:,:,:,:,:,:)               !< Array on host memory.
   integer(I8P), allocatable, target :: a7(:,:,:,:,:,:,:)             !< Array on host memory.
   integer(I8P), allocatable, target :: b1(:)                         !< Array on host memory.
   integer(I8P), allocatable, target :: b2(:,:)                       !< Array on host memory.
   integer(I8P), allocatable, target :: b3(:,:,:)                     !< Array on host memory.
   integer(I8P), allocatable, target :: b4(:,:,:,:)                   !< Array on host memory.
   integer(I8P), allocatable, target :: b5(:,:,:,:,:)                 !< Array on host memory.
   integer(I8P), allocatable, target :: b6(:,:,:,:,:,:)               !< Array on host memory.
   integer(I8P), allocatable, target :: b7(:,:,:,:,:,:,:)             !< Array on host memory.
   integer(I4P)                      :: ierr                          !< Error status.
   integer(I4P)                      :: i1,i2,i3,i4,i5,i6,i7          !< Counter.

   print '(A)', 'test I8P'
   allocate(a1(n            ),b1(n            ),&
            a2(n,n          ),b2(n,n          ),&
            a3(n,n,n        ),b3(n,n,n        ),&
            a4(n,n,n,n      ),b4(n,n,n,n      ),&
            a5(n,n,n,n,n    ),b5(n,n,n,n,n    ),&
            a6(n,n,n,n,n,n  ),b6(n,n,n,n,n,n  ),&
            a7(n,n,n,n,n,n,n),b7(n,n,n,n,n,n,n))
   do i1= 1, n
      a1(i1) = i1
   enddo
   do i2= 1, n ; do i1= 1, n
      a2(i1,i2) = i1
   enddo ; enddo
   do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a3(i1,i2,i3) = i1
   enddo ; enddo ; enddo
   do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a4(i1,i2,i3,i4) = i1
   enddo ; enddo ; enddo ; enddo
   do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a5(i1,i2,i3,i4,i5) = i1
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6= 1, n ; do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a6(i1,i2,i3,i4,i5,i6) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7= 1, n ; do i6= 1, n ; do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a7(i1,i2,i3,i4,i5,i6,i7) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! allocate device memory
   call dev_alloc(fptr_dev=b1_dev, ubounds=[n            ],ierr=ierr);call error_print(ierr,'b1_dev')
   call dev_alloc(fptr_dev=b2_dev, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'b2_dev')
   call dev_alloc(fptr_dev=b3_dev, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'b3_dev')
   call dev_alloc(fptr_dev=b4_dev, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'b4_dev')
   call dev_alloc(fptr_dev=b5_dev, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'b5_dev')
   call dev_alloc(fptr_dev=b6_dev, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'b6_dev')
   call dev_alloc(fptr_dev=b7_dev, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'b7_dev')

   ! assign host memory to device one
   print '(A)', '    assign memory to device'
   call dev_assign_to_device(src=a1, dst=a1_dev)
   call dev_assign_to_device(src=a2, dst=a2_dev)
   call dev_assign_to_device(src=a3, dst=a3_dev)
   call dev_assign_to_device(src=a4, dst=a4_dev)
   call dev_assign_to_device(src=a5, dst=a5_dev)
   call dev_assign_to_device(src=a6, dst=a6_dev)
   call dev_assign_to_device(src=a7, dst=a7_dev)

   ! do some operation on device
   print '(A)', '    compute on device'
   !$acc parallel loop independent DEVICEVAR(a1_dev, b1_dev)
   !$omp OMPLOOP DEVICEPTR(a1_dev, b1_dev)
   do i1 = 1, n
      b1_dev(i1) = a1_dev(i1) + 10
   enddo
   !$acc parallel loop independent DEVICEVAR(a2_dev, b2_dev)
   !$omp OMPLOOP DEVICEPTR(a2_dev, b2_dev)
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b2_dev(i1,i2) = a2_dev(i1,i2) + 10
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a3_dev, b3_dev)
   !$omp OMPLOOP DEVICEPTR(a3_dev, b3_dev)
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b3_dev(i1,i2,i3) = a3_dev(i1,i2,i3) + 10
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a4_dev, b4_dev)
   !$omp OMPLOOP DEVICEPTR(a4_dev, b4_dev)
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b4_dev(i1,i2,i3,i4) = a4_dev(i1,i2,i3,i4) + 10
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a5_dev, b5_dev)
   !$omp OMPLOOP DEVICEPTR(a5_dev, b5_dev)
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b5_dev(i1,i2,i3,i4,i5) = a5_dev(i1,i2,i3,i4,i5) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a6_dev, b6_dev)
   !$omp OMPLOOP DEVICEPTR(a6_dev, b6_dev)
   do i6 = 1, n
   !$acc loop
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b6_dev(i1,i2,i3,i4,i5,i6) = a6_dev(i1,i2,i3,i4,i5,i6) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a7_dev, b7_dev)
   !$omp OMPLOOP DEVICEPTR(a7_dev, b7_dev)
   do i7 = 1, n
   !$acc loop
   do i6 = 1, n
   !$acc loop
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b7_dev(i1,i2,i3,i4,i5,i6,i7) = a7_dev(i1,i2,i3,i4,i5,i6,i7) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   ! assign device memory to host one
   print '(A)', '    assign memory from device'
   call dev_assign_from_device(src=b1_dev, dst=b1)
   call dev_assign_from_device(src=b2_dev, dst=b2)
   call dev_assign_from_device(src=b3_dev, dst=b3)
   call dev_assign_from_device(src=b4_dev, dst=b4)
   call dev_assign_from_device(src=b5_dev, dst=b5)
   call dev_assign_from_device(src=b6_dev, dst=b6)
   call dev_assign_from_device(src=b7_dev, dst=b7)
   ! check results
   print '(A)', '    chek results'
   do i1=1, n
      if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo
   do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo
   do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! assign transposed host memory to device one
   print '(A)', '    assign transposed memory to device'
   call dev_assign_to_device(src=a2, dst=a2_dev, transposed=.true.)
   ! assign device memory to host one
   print '(A)', '    assign memory from device'
   call dev_assign_from_device(src=a2_dev, dst=b2)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i2,I4P) /= 0_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   ! assign transposed device memory to host one
   print '(A)', '    assign transposed memory from device'
   call dev_assign_from_device(src=a2_dev, dst=b2, transposed=.true.)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i1,I4P) /= 0_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   !print '(A)', '    test unstructured memory'
   !call dev_alloc_unstr(a1) ; call dev_alloc_unstr(b1)
   !call dev_alloc_unstr(a2) ; call dev_alloc_unstr(b2)
   !call dev_alloc_unstr(a3) ; call dev_alloc_unstr(b3)
   !call dev_alloc_unstr(a4) ; call dev_alloc_unstr(b4)
   !call dev_alloc_unstr(a5) ; call dev_alloc_unstr(b5)
   !call dev_alloc_unstr(a6) ; call dev_alloc_unstr(b6)
   !call dev_alloc_unstr(a7) ; call dev_alloc_unstr(b7)
   !call dev_assign_to_device_unstr(a1)
   !call dev_assign_to_device_unstr(a2)
   !call dev_assign_to_device_unstr(a3)
   !call dev_assign_to_device_unstr(a4)
   !call dev_assign_to_device_unstr(a5)
   !call dev_assign_to_device_unstr(a6)
   !call dev_assign_to_device_unstr(a7)
   !! do some operation on device
   !print '(A)', '    compute on device'
   !!$acc parallel loop independent present(a1, b1)
   !do i1 = 1, n
   !   b1(i1) = a1(i1) + 10
   !enddo
   !!$acc parallel loop independent present(a2, b2)
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b2(i1,i2) = a2(i1,i2) + 10
   !enddo
   !enddo
   !!$acc parallel loop independent present(a3, b3)
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b3(i1,i2,i3) = a3(i1,i2,i3) + 10
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a4, b4)
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b4(i1,i2,i3,i4) = a4(i1,i2,i3,i4) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a5, b5)
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b5(i1,i2,i3,i4,i5) = a5(i1,i2,i3,i4,i5) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a6, b6)
   !do i6 = 1, n
   !!$acc loop
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b6(i1,i2,i3,i4,i5,i6) = a6(i1,i2,i3,i4,i5,i6) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a7, b7)
   !do i7 = 1, n
   !!$acc loop
   !do i6 = 1, n
   !!$acc loop
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b7(i1,i2,i3,i4,i5,i6,i7) = a7(i1,i2,i3,i4,i5,i6,i7) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !! assign device memory to host one
   !print '(A)', '    assign memory from device'
   !call dev_assign_from_device_unstr(b1)
   !call dev_assign_from_device_unstr(b2)
   !call dev_assign_from_device_unstr(b3)
   !call dev_assign_from_device_unstr(b4)
   !call dev_assign_from_device_unstr(b5)
   !call dev_assign_from_device_unstr(b6)
   !call dev_assign_from_device_unstr(b7)
   !! check results
   !print '(A)', '    chek results'
   !do i1=1, n
   !   if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(1):', int(b1(i1) - a1(i1),I4P)
   !      stop
   !   endif
   !enddo
   !do i2=1, n ; do i1=1, n
   !   if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(2):', int(b2(i1,i2) - a2(i1,i2),I4P)
   !      stop
   !   endif
   !enddo ; enddo
   !do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(3):', int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo
   !do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(4):', int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo
   !do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(5):', int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo
   !do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(6):', int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   !do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(7):', int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   call dev_free(a1_dev,dev_id=mydev)!; call dev_free_unstr(a1)
   call dev_free(a2_dev,dev_id=mydev)!; call dev_free_unstr(a2)
   call dev_free(a3_dev,dev_id=mydev)!; call dev_free_unstr(a3)
   call dev_free(a4_dev,dev_id=mydev)!; call dev_free_unstr(a4)
   call dev_free(a5_dev,dev_id=mydev)!; call dev_free_unstr(a5)
   call dev_free(a6_dev,dev_id=mydev)!; call dev_free_unstr(a6)
   call dev_free(a7_dev,dev_id=mydev)!; call dev_free_unstr(a7)
   call dev_free(b1_dev,dev_id=mydev)!; call dev_free_unstr(b1)
   call dev_free(b2_dev,dev_id=mydev)!; call dev_free_unstr(b2)
   call dev_free(b3_dev,dev_id=mydev)!; call dev_free_unstr(b3)
   call dev_free(b4_dev,dev_id=mydev)!; call dev_free_unstr(b4)
   call dev_free(b5_dev,dev_id=mydev)!; call dev_free_unstr(b5)
   call dev_free(b6_dev,dev_id=mydev)!; call dev_free_unstr(b6)
   call dev_free(b7_dev,dev_id=mydev)!; call dev_free_unstr(b7)
   endsubroutine test_I8P

   subroutine test_I4P
   !< Test I4P kind.
   integer(I4P), pointer             :: a1_dev(:)=>null()             !< Array on device memory.
   integer(I4P), pointer             :: a2_dev(:,:)=>null()           !< Array on device memory.
   integer(I4P), pointer             :: a3_dev(:,:,:)=>null()         !< Array on device memory.
   integer(I4P), pointer             :: a4_dev(:,:,:,:)=>null()       !< Array on device memory.
   integer(I4P), pointer             :: a5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   integer(I4P), pointer             :: a6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   integer(I4P), pointer             :: a7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   integer(I4P), pointer             :: b1_dev(:)=>null()             !< Array on device memory.
   integer(I4P), pointer             :: b2_dev(:,:)=>null()           !< Array on device memory.
   integer(I4P), pointer             :: b3_dev(:,:,:)=>null()         !< Array on device memory.
   integer(I4P), pointer             :: b4_dev(:,:,:,:)=>null()       !< Array on device memory.
   integer(I4P), pointer             :: b5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   integer(I4P), pointer             :: b6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   integer(I4P), pointer             :: b7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   integer(I4P), allocatable, target :: a1(:)                         !< Array on host memory.
   integer(I4P), allocatable, target :: a2(:,:)                       !< Array on host memory.
   integer(I4P), allocatable, target :: a3(:,:,:)                     !< Array on host memory.
   integer(I4P), allocatable, target :: a4(:,:,:,:)                   !< Array on host memory.
   integer(I4P), allocatable, target :: a5(:,:,:,:,:)                 !< Array on host memory.
   integer(I4P), allocatable, target :: a6(:,:,:,:,:,:)               !< Array on host memory.
   integer(I4P), allocatable, target :: a7(:,:,:,:,:,:,:)             !< Array on host memory.
   integer(I4P), allocatable, target :: b1(:)                         !< Array on host memory.
   integer(I4P), allocatable, target :: b2(:,:)                       !< Array on host memory.
   integer(I4P), allocatable, target :: b3(:,:,:)                     !< Array on host memory.
   integer(I4P), allocatable, target :: b4(:,:,:,:)                   !< Array on host memory.
   integer(I4P), allocatable, target :: b5(:,:,:,:,:)                 !< Array on host memory.
   integer(I4P), allocatable, target :: b6(:,:,:,:,:,:)               !< Array on host memory.
   integer(I4P), allocatable, target :: b7(:,:,:,:,:,:,:)             !< Array on host memory.
   integer(I4P)                      :: ierr                          !< Error status.
   integer(I4P)                      :: i1,i2,i3,i4,i5,i6,i7          !< Counter.

   print '(A)', 'test I4P'
   allocate(a1(n            ),b1(n            ),&
            a2(n,n          ),b2(n,n          ),&
            a3(n,n,n        ),b3(n,n,n        ),&
            a4(n,n,n,n      ),b4(n,n,n,n      ),&
            a5(n,n,n,n,n    ),b5(n,n,n,n,n    ),&
            a6(n,n,n,n,n,n  ),b6(n,n,n,n,n,n  ),&
            a7(n,n,n,n,n,n,n),b7(n,n,n,n,n,n,n))
   do i1= 1, n
      a1(i1) = i1
   enddo
   do i2= 1, n ; do i1= 1, n
      a2(i1,i2) = i1
   enddo ; enddo
   do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a3(i1,i2,i3) = i1
   enddo ; enddo ; enddo
   do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a4(i1,i2,i3,i4) = i1
   enddo ; enddo ; enddo ; enddo
   do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a5(i1,i2,i3,i4,i5) = i1
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6= 1, n ; do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a6(i1,i2,i3,i4,i5,i6) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7= 1, n ; do i6= 1, n ; do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a7(i1,i2,i3,i4,i5,i6,i7) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! allocate device memory
   call dev_alloc(fptr_dev=b1_dev, ubounds=[n            ],ierr=ierr);call error_print(ierr,'b1_dev')
   call dev_alloc(fptr_dev=b2_dev, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'b2_dev')
   call dev_alloc(fptr_dev=b3_dev, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'b3_dev')
   call dev_alloc(fptr_dev=b4_dev, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'b4_dev')
   call dev_alloc(fptr_dev=b5_dev, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'b5_dev')
   call dev_alloc(fptr_dev=b6_dev, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'b6_dev')
   call dev_alloc(fptr_dev=b7_dev, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'b7_dev')

   ! assign host memory to device one
   print '(A)', '    assign memory to device'
   call dev_assign_to_device(src=a1, dst=a1_dev)
   call dev_assign_to_device(src=a2, dst=a2_dev)
   call dev_assign_to_device(src=a3, dst=a3_dev)
   call dev_assign_to_device(src=a4, dst=a4_dev)
   call dev_assign_to_device(src=a5, dst=a5_dev)
   call dev_assign_to_device(src=a6, dst=a6_dev)
   call dev_assign_to_device(src=a7, dst=a7_dev)

   ! do some operation on device
   print '(A)', '    compute on device'
   !$acc parallel loop independent DEVICEVAR(a1_dev, b1_dev)
   !$omp OMPLOOP DEVICEPTR(a1_dev, b1_dev)
   do i1 = 1, n
      b1_dev(i1) = a1_dev(i1) + 10
   enddo
   !$acc parallel loop independent DEVICEVAR(a2_dev, b2_dev)
   !$omp OMPLOOP DEVICEPTR(a2_dev, b2_dev)
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b2_dev(i1,i2) = a2_dev(i1,i2) + 10
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a3_dev, b3_dev)
   !$omp OMPLOOP DEVICEPTR(a3_dev, b3_dev)
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b3_dev(i1,i2,i3) = a3_dev(i1,i2,i3) + 10
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a4_dev, b4_dev)
   !$omp OMPLOOP DEVICEPTR(a4_dev, b4_dev)
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b4_dev(i1,i2,i3,i4) = a4_dev(i1,i2,i3,i4) + 10
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a5_dev, b5_dev)
   !$omp OMPLOOP DEVICEPTR(a5_dev, b5_dev)
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b5_dev(i1,i2,i3,i4,i5) = a5_dev(i1,i2,i3,i4,i5) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a6_dev, b6_dev)
   !$omp OMPLOOP DEVICEPTR(a6_dev, b6_dev)
   do i6 = 1, n
   !$acc loop
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b6_dev(i1,i2,i3,i4,i5,i6) = a6_dev(i1,i2,i3,i4,i5,i6) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a7_dev, b7_dev)
   !$omp OMPLOOP DEVICEPTR(a7_dev, b7_dev)
   do i7 = 1, n
   !$acc loop
   do i6 = 1, n
   !$acc loop
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b7_dev(i1,i2,i3,i4,i5,i6,i7) = a7_dev(i1,i2,i3,i4,i5,i6,i7) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   ! assign device memory to host one
   print '(A)', '    assign memory from device'
   call dev_assign_from_device(src=b1_dev, dst=b1)
   call dev_assign_from_device(src=b2_dev, dst=b2)
   call dev_assign_from_device(src=b3_dev, dst=b3)
   call dev_assign_from_device(src=b4_dev, dst=b4)
   call dev_assign_from_device(src=b5_dev, dst=b5)
   call dev_assign_from_device(src=b6_dev, dst=b6)
   call dev_assign_from_device(src=b7_dev, dst=b7)
   ! check results
   print '(A)', '    chek results'
   do i1=1, n
      if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo
   do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo
   do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! assign transposed host memory to device one
   print '(A)', '    assign transposed memory to device'
   call dev_assign_to_device(src=a2, dst=a2_dev, transposed=.true.)
   ! assign device memory to host one
   print '(A)', '    assign memory from device'
   call dev_assign_from_device(src=a2_dev, dst=b2)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i2,I4P) /= 0_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   ! assign transposed device memory to host one
   print '(A)', '    assign transposed memory from device'
   call dev_assign_from_device(src=a2_dev, dst=b2, transposed=.true.)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i1,I4P) /= 0_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   !print '(A)', '    test unstructured memory'
   !call dev_alloc_unstr(a1) ; call dev_alloc_unstr(b1)
   !call dev_alloc_unstr(a2) ; call dev_alloc_unstr(b2)
   !call dev_alloc_unstr(a3) ; call dev_alloc_unstr(b3)
   !call dev_alloc_unstr(a4) ; call dev_alloc_unstr(b4)
   !call dev_alloc_unstr(a5) ; call dev_alloc_unstr(b5)
   !call dev_alloc_unstr(a6) ; call dev_alloc_unstr(b6)
   !call dev_alloc_unstr(a7) ; call dev_alloc_unstr(b7)
   !call dev_assign_to_device_unstr(a1)
   !call dev_assign_to_device_unstr(a2)
   !call dev_assign_to_device_unstr(a3)
   !call dev_assign_to_device_unstr(a4)
   !call dev_assign_to_device_unstr(a5)
   !call dev_assign_to_device_unstr(a6)
   !call dev_assign_to_device_unstr(a7)
   !! do some operation on device
   !print '(A)', '    compute on device'
   !!$acc parallel loop independent present(a1, b1)
   !do i1 = 1, n
   !   b1(i1) = a1(i1) + 10
   !enddo
   !!$acc parallel loop independent present(a2, b2)
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b2(i1,i2) = a2(i1,i2) + 10
   !enddo
   !enddo
   !!$acc parallel loop independent present(a3, b3)
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b3(i1,i2,i3) = a3(i1,i2,i3) + 10
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a4, b4)
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b4(i1,i2,i3,i4) = a4(i1,i2,i3,i4) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a5, b5)
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b5(i1,i2,i3,i4,i5) = a5(i1,i2,i3,i4,i5) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a6, b6)
   !do i6 = 1, n
   !!$acc loop
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b6(i1,i2,i3,i4,i5,i6) = a6(i1,i2,i3,i4,i5,i6) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a7, b7)
   !do i7 = 1, n
   !!$acc loop
   !do i6 = 1, n
   !!$acc loop
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b7(i1,i2,i3,i4,i5,i6,i7) = a7(i1,i2,i3,i4,i5,i6,i7) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !! assign device memory to host one
   !print '(A)', '    assign memory from device'
   !call dev_assign_from_device_unstr(b1)
   !call dev_assign_from_device_unstr(b2)
   !call dev_assign_from_device_unstr(b3)
   !call dev_assign_from_device_unstr(b4)
   !call dev_assign_from_device_unstr(b5)
   !call dev_assign_from_device_unstr(b6)
   !call dev_assign_from_device_unstr(b7)
   !! check results
   !print '(A)', '    chek results'
   !do i1=1, n
   !   if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(1):', int(b1(i1) - a1(i1),I4P)
   !      stop
   !   endif
   !enddo
   !do i2=1, n ; do i1=1, n
   !   if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(2):', int(b2(i1,i2) - a2(i1,i2),I4P)
   !      stop
   !   endif
   !enddo ; enddo
   !do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(3):', int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo
   !do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(4):', int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo
   !do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(5):', int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo
   !do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(6):', int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   !do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(7):', int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   call dev_free(a1_dev,dev_id=mydev)!; call dev_free_unstr(a1)
   call dev_free(a2_dev,dev_id=mydev)!; call dev_free_unstr(a2)
   call dev_free(a3_dev,dev_id=mydev)!; call dev_free_unstr(a3)
   call dev_free(a4_dev,dev_id=mydev)!; call dev_free_unstr(a4)
   call dev_free(a5_dev,dev_id=mydev)!; call dev_free_unstr(a5)
   call dev_free(a6_dev,dev_id=mydev)!; call dev_free_unstr(a6)
   call dev_free(a7_dev,dev_id=mydev)!; call dev_free_unstr(a7)
   call dev_free(b1_dev,dev_id=mydev)!; call dev_free_unstr(b1)
   call dev_free(b2_dev,dev_id=mydev)!; call dev_free_unstr(b2)
   call dev_free(b3_dev,dev_id=mydev)!; call dev_free_unstr(b3)
   call dev_free(b4_dev,dev_id=mydev)!; call dev_free_unstr(b4)
   call dev_free(b5_dev,dev_id=mydev)!; call dev_free_unstr(b5)
   call dev_free(b6_dev,dev_id=mydev)!; call dev_free_unstr(b6)
   call dev_free(b7_dev,dev_id=mydev)!; call dev_free_unstr(b7)
   endsubroutine test_I4P

   subroutine test_I2P
   !< Test I2P kind.
   integer(I2P), pointer             :: a1_dev(:)=>null()             !< Array on device memory.
   integer(I2P), pointer             :: a2_dev(:,:)=>null()           !< Array on device memory.
   integer(I2P), pointer             :: a3_dev(:,:,:)=>null()         !< Array on device memory.
   integer(I2P), pointer             :: a4_dev(:,:,:,:)=>null()       !< Array on device memory.
   integer(I2P), pointer             :: a5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   integer(I2P), pointer             :: a6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   integer(I2P), pointer             :: a7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   integer(I2P), pointer             :: b1_dev(:)=>null()             !< Array on device memory.
   integer(I2P), pointer             :: b2_dev(:,:)=>null()           !< Array on device memory.
   integer(I2P), pointer             :: b3_dev(:,:,:)=>null()         !< Array on device memory.
   integer(I2P), pointer             :: b4_dev(:,:,:,:)=>null()       !< Array on device memory.
   integer(I2P), pointer             :: b5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   integer(I2P), pointer             :: b6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   integer(I2P), pointer             :: b7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   integer(I2P), allocatable, target :: a1(:)                         !< Array on host memory.
   integer(I2P), allocatable, target :: a2(:,:)                       !< Array on host memory.
   integer(I2P), allocatable, target :: a3(:,:,:)                     !< Array on host memory.
   integer(I2P), allocatable, target :: a4(:,:,:,:)                   !< Array on host memory.
   integer(I2P), allocatable, target :: a5(:,:,:,:,:)                 !< Array on host memory.
   integer(I2P), allocatable, target :: a6(:,:,:,:,:,:)               !< Array on host memory.
   integer(I2P), allocatable, target :: a7(:,:,:,:,:,:,:)             !< Array on host memory.
   integer(I2P), allocatable, target :: b1(:)                         !< Array on host memory.
   integer(I2P), allocatable, target :: b2(:,:)                       !< Array on host memory.
   integer(I2P), allocatable, target :: b3(:,:,:)                     !< Array on host memory.
   integer(I2P), allocatable, target :: b4(:,:,:,:)                   !< Array on host memory.
   integer(I2P), allocatable, target :: b5(:,:,:,:,:)                 !< Array on host memory.
   integer(I2P), allocatable, target :: b6(:,:,:,:,:,:)               !< Array on host memory.
   integer(I2P), allocatable, target :: b7(:,:,:,:,:,:,:)             !< Array on host memory.
   integer(I4P)                      :: ierr                          !< Error status.
   integer(I4P)                      :: i1,i2,i3,i4,i5,i6,i7          !< Counter.

   print '(A)', 'test I2P'
   allocate(a1(n            ),b1(n            ),&
            a2(n,n          ),b2(n,n          ),&
            a3(n,n,n        ),b3(n,n,n        ),&
            a4(n,n,n,n      ),b4(n,n,n,n      ),&
            a5(n,n,n,n,n    ),b5(n,n,n,n,n    ),&
            a6(n,n,n,n,n,n  ),b6(n,n,n,n,n,n  ),&
            a7(n,n,n,n,n,n,n),b7(n,n,n,n,n,n,n))
   do i1= 1, n
      a1(i1) = i1
   enddo
   do i2= 1, n ; do i1= 1, n
      a2(i1,i2) = i1
   enddo ; enddo
   do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a3(i1,i2,i3) = i1
   enddo ; enddo ; enddo
   do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a4(i1,i2,i3,i4) = i1
   enddo ; enddo ; enddo ; enddo
   do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a5(i1,i2,i3,i4,i5) = i1
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6= 1, n ; do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a6(i1,i2,i3,i4,i5,i6) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7= 1, n ; do i6= 1, n ; do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a7(i1,i2,i3,i4,i5,i6,i7) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! allocate device memory
   call dev_alloc(fptr_dev=b1_dev, ubounds=[n            ],ierr=ierr);call error_print(ierr,'b1_dev')
   call dev_alloc(fptr_dev=b2_dev, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'b2_dev')
   call dev_alloc(fptr_dev=b3_dev, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'b3_dev')
   call dev_alloc(fptr_dev=b4_dev, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'b4_dev')
   call dev_alloc(fptr_dev=b5_dev, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'b5_dev')
   call dev_alloc(fptr_dev=b6_dev, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'b6_dev')
   call dev_alloc(fptr_dev=b7_dev, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'b7_dev')

   ! assign host memory to device one
   print '(A)', '    assign memory to device'
   call dev_assign_to_device(src=a1, dst=a1_dev)
   call dev_assign_to_device(src=a2, dst=a2_dev)
   call dev_assign_to_device(src=a3, dst=a3_dev)
   call dev_assign_to_device(src=a4, dst=a4_dev)
   call dev_assign_to_device(src=a5, dst=a5_dev)
   call dev_assign_to_device(src=a6, dst=a6_dev)
   call dev_assign_to_device(src=a7, dst=a7_dev)

   ! do some operation on device
   print '(A)', '    compute on device'
   !$acc parallel loop independent DEVICEVAR(a1_dev, b1_dev)
   !$omp OMPLOOP DEVICEPTR(a1_dev, b1_dev)
   do i1 = 1, n
      b1_dev(i1) = a1_dev(i1) + 10
   enddo
   !$acc parallel loop independent DEVICEVAR(a2_dev, b2_dev)
   !$omp OMPLOOP DEVICEPTR(a2_dev, b2_dev)
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b2_dev(i1,i2) = a2_dev(i1,i2) + 10
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a3_dev, b3_dev)
   !$omp OMPLOOP DEVICEPTR(a3_dev, b3_dev)
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b3_dev(i1,i2,i3) = a3_dev(i1,i2,i3) + 10
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a4_dev, b4_dev)
   !$omp OMPLOOP DEVICEPTR(a4_dev, b4_dev)
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b4_dev(i1,i2,i3,i4) = a4_dev(i1,i2,i3,i4) + 10
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a5_dev, b5_dev)
   !$omp OMPLOOP DEVICEPTR(a5_dev, b5_dev)
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b5_dev(i1,i2,i3,i4,i5) = a5_dev(i1,i2,i3,i4,i5) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a6_dev, b6_dev)
   !$omp OMPLOOP DEVICEPTR(a6_dev, b6_dev)
   do i6 = 1, n
   !$acc loop
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b6_dev(i1,i2,i3,i4,i5,i6) = a6_dev(i1,i2,i3,i4,i5,i6) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a7_dev, b7_dev)
   !$omp OMPLOOP DEVICEPTR(a7_dev, b7_dev)
   do i7 = 1, n
   !$acc loop
   do i6 = 1, n
   !$acc loop
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b7_dev(i1,i2,i3,i4,i5,i6,i7) = a7_dev(i1,i2,i3,i4,i5,i6,i7) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   ! assign device memory to host one
   print '(A)', '    assign memory from device'
   call dev_assign_from_device(src=b1_dev, dst=b1)
   call dev_assign_from_device(src=b2_dev, dst=b2)
   call dev_assign_from_device(src=b3_dev, dst=b3)
   call dev_assign_from_device(src=b4_dev, dst=b4)
   call dev_assign_from_device(src=b5_dev, dst=b5)
   call dev_assign_from_device(src=b6_dev, dst=b6)
   call dev_assign_from_device(src=b7_dev, dst=b7)
   ! check results
   print '(A)', '    chek results'
   do i1=1, n
      if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo
   do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo
   do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! assign transposed host memory to device one
   print '(A)', '    assign transposed memory to device'
   call dev_assign_to_device(src=a2, dst=a2_dev, transposed=.true.)
   ! assign device memory to host one
   print '(A)', '    assign memory from device'
   call dev_assign_from_device(src=a2_dev, dst=b2)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i2,I4P) /= 0_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   ! assign transposed device memory to host one
   print '(A)', '    assign transposed memory from device'
   call dev_assign_from_device(src=a2_dev, dst=b2, transposed=.true.)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i1,I4P) /= 0_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   !print '(A)', '    test unstructured memory'
   !call dev_alloc_unstr(a1) ; call dev_alloc_unstr(b1)
   !call dev_alloc_unstr(a2) ; call dev_alloc_unstr(b2)
   !call dev_alloc_unstr(a3) ; call dev_alloc_unstr(b3)
   !call dev_alloc_unstr(a4) ; call dev_alloc_unstr(b4)
   !call dev_alloc_unstr(a5) ; call dev_alloc_unstr(b5)
   !call dev_alloc_unstr(a6) ; call dev_alloc_unstr(b6)
   !call dev_alloc_unstr(a7) ; call dev_alloc_unstr(b7)
   !call dev_assign_to_device_unstr(a1)
   !call dev_assign_to_device_unstr(a2)
   !call dev_assign_to_device_unstr(a3)
   !call dev_assign_to_device_unstr(a4)
   !call dev_assign_to_device_unstr(a5)
   !call dev_assign_to_device_unstr(a6)
   !call dev_assign_to_device_unstr(a7)
   !! do some operation on device
   !print '(A)', '    compute on device'
   !!$acc parallel loop independent present(a1, b1)
   !do i1 = 1, n
   !   b1(i1) = a1(i1) + 10
   !enddo
   !!$acc parallel loop independent present(a2, b2)
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b2(i1,i2) = a2(i1,i2) + 10
   !enddo
   !enddo
   !!$acc parallel loop independent present(a3, b3)
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b3(i1,i2,i3) = a3(i1,i2,i3) + 10
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a4, b4)
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b4(i1,i2,i3,i4) = a4(i1,i2,i3,i4) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a5, b5)
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b5(i1,i2,i3,i4,i5) = a5(i1,i2,i3,i4,i5) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a6, b6)
   !do i6 = 1, n
   !!$acc loop
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b6(i1,i2,i3,i4,i5,i6) = a6(i1,i2,i3,i4,i5,i6) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a7, b7)
   !do i7 = 1, n
   !!$acc loop
   !do i6 = 1, n
   !!$acc loop
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b7(i1,i2,i3,i4,i5,i6,i7) = a7(i1,i2,i3,i4,i5,i6,i7) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !! assign device memory to host one
   !print '(A)', '    assign memory from device'
   !call dev_assign_from_device_unstr(b1)
   !call dev_assign_from_device_unstr(b2)
   !call dev_assign_from_device_unstr(b3)
   !call dev_assign_from_device_unstr(b4)
   !call dev_assign_from_device_unstr(b5)
   !call dev_assign_from_device_unstr(b6)
   !call dev_assign_from_device_unstr(b7)
   !! check results
   !print '(A)', '    chek results'
   !do i1=1, n
   !   if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(1):', int(b1(i1) - a1(i1),I4P)
   !      stop
   !   endif
   !enddo
   !do i2=1, n ; do i1=1, n
   !   if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(2):', int(b2(i1,i2) - a2(i1,i2),I4P)
   !      stop
   !   endif
   !enddo ; enddo
   !do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(3):', int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo
   !do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(4):', int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo
   !do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(5):', int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo
   !do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(6):', int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   !do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(7):', int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   call dev_free(a1_dev,dev_id=mydev)!; call dev_free_unstr(a1)
   call dev_free(a2_dev,dev_id=mydev)!; call dev_free_unstr(a2)
   call dev_free(a3_dev,dev_id=mydev)!; call dev_free_unstr(a3)
   call dev_free(a4_dev,dev_id=mydev)!; call dev_free_unstr(a4)
   call dev_free(a5_dev,dev_id=mydev)!; call dev_free_unstr(a5)
   call dev_free(a6_dev,dev_id=mydev)!; call dev_free_unstr(a6)
   call dev_free(a7_dev,dev_id=mydev)!; call dev_free_unstr(a7)
   call dev_free(b1_dev,dev_id=mydev)!; call dev_free_unstr(b1)
   call dev_free(b2_dev,dev_id=mydev)!; call dev_free_unstr(b2)
   call dev_free(b3_dev,dev_id=mydev)!; call dev_free_unstr(b3)
   call dev_free(b4_dev,dev_id=mydev)!; call dev_free_unstr(b4)
   call dev_free(b5_dev,dev_id=mydev)!; call dev_free_unstr(b5)
   call dev_free(b6_dev,dev_id=mydev)!; call dev_free_unstr(b6)
   call dev_free(b7_dev,dev_id=mydev)!; call dev_free_unstr(b7)
   endsubroutine test_I2P

   subroutine test_I1P
   !< Test I1P kind.
   integer(I1P), pointer             :: a1_dev(:)=>null()             !< Array on device memory.
   integer(I1P), pointer             :: a2_dev(:,:)=>null()           !< Array on device memory.
   integer(I1P), pointer             :: a3_dev(:,:,:)=>null()         !< Array on device memory.
   integer(I1P), pointer             :: a4_dev(:,:,:,:)=>null()       !< Array on device memory.
   integer(I1P), pointer             :: a5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   integer(I1P), pointer             :: a6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   integer(I1P), pointer             :: a7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   integer(I1P), pointer             :: b1_dev(:)=>null()             !< Array on device memory.
   integer(I1P), pointer             :: b2_dev(:,:)=>null()           !< Array on device memory.
   integer(I1P), pointer             :: b3_dev(:,:,:)=>null()         !< Array on device memory.
   integer(I1P), pointer             :: b4_dev(:,:,:,:)=>null()       !< Array on device memory.
   integer(I1P), pointer             :: b5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   integer(I1P), pointer             :: b6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   integer(I1P), pointer             :: b7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   integer(I1P), allocatable, target :: a1(:)                         !< Array on host memory.
   integer(I1P), allocatable, target :: a2(:,:)                       !< Array on host memory.
   integer(I1P), allocatable, target :: a3(:,:,:)                     !< Array on host memory.
   integer(I1P), allocatable, target :: a4(:,:,:,:)                   !< Array on host memory.
   integer(I1P), allocatable, target :: a5(:,:,:,:,:)                 !< Array on host memory.
   integer(I1P), allocatable, target :: a6(:,:,:,:,:,:)               !< Array on host memory.
   integer(I1P), allocatable, target :: a7(:,:,:,:,:,:,:)             !< Array on host memory.
   integer(I1P), allocatable, target :: b1(:)                         !< Array on host memory.
   integer(I1P), allocatable, target :: b2(:,:)                       !< Array on host memory.
   integer(I1P), allocatable, target :: b3(:,:,:)                     !< Array on host memory.
   integer(I1P), allocatable, target :: b4(:,:,:,:)                   !< Array on host memory.
   integer(I1P), allocatable, target :: b5(:,:,:,:,:)                 !< Array on host memory.
   integer(I1P), allocatable, target :: b6(:,:,:,:,:,:)               !< Array on host memory.
   integer(I1P), allocatable, target :: b7(:,:,:,:,:,:,:)             !< Array on host memory.
   integer(I4P)                      :: ierr                          !< Error status.
   integer(I4P)                      :: i1,i2,i3,i4,i5,i6,i7          !< Counter.

   print '(A)', 'test I1P'
   allocate(a1(n            ),b1(n            ),&
            a2(n,n          ),b2(n,n          ),&
            a3(n,n,n        ),b3(n,n,n        ),&
            a4(n,n,n,n      ),b4(n,n,n,n      ),&
            a5(n,n,n,n,n    ),b5(n,n,n,n,n    ),&
            a6(n,n,n,n,n,n  ),b6(n,n,n,n,n,n  ),&
            a7(n,n,n,n,n,n,n),b7(n,n,n,n,n,n,n))
   do i1= 1, n
      a1(i1) = i1
   enddo
   do i2= 1, n ; do i1= 1, n
      a2(i1,i2) = i1
   enddo ; enddo
   do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a3(i1,i2,i3) = i1
   enddo ; enddo ; enddo
   do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a4(i1,i2,i3,i4) = i1
   enddo ; enddo ; enddo ; enddo
   do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a5(i1,i2,i3,i4,i5) = i1
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6= 1, n ; do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a6(i1,i2,i3,i4,i5,i6) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7= 1, n ; do i6= 1, n ; do i5= 1, n ; do i4= 1, n ; do i3= 1, n ; do i2= 1, n ; do i1= 1, n
      a7(i1,i2,i3,i4,i5,i6,i7) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! allocate device memory
   call dev_alloc(fptr_dev=b1_dev, ubounds=[n            ],ierr=ierr);call error_print(ierr,'b1_dev')
   call dev_alloc(fptr_dev=b2_dev, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'b2_dev')
   call dev_alloc(fptr_dev=b3_dev, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'b3_dev')
   call dev_alloc(fptr_dev=b4_dev, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'b4_dev')
   call dev_alloc(fptr_dev=b5_dev, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'b5_dev')
   call dev_alloc(fptr_dev=b6_dev, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'b6_dev')
   call dev_alloc(fptr_dev=b7_dev, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'b7_dev')

   ! assign host memory to device one
   print '(A)', '    assign memory to device'
   call dev_assign_to_device(src=a1, dst=a1_dev)
   call dev_assign_to_device(src=a2, dst=a2_dev)
   call dev_assign_to_device(src=a3, dst=a3_dev)
   call dev_assign_to_device(src=a4, dst=a4_dev)
   call dev_assign_to_device(src=a5, dst=a5_dev)
   call dev_assign_to_device(src=a6, dst=a6_dev)
   call dev_assign_to_device(src=a7, dst=a7_dev)

   ! do some operation on device
   print '(A)', '    compute on device'
   !$acc parallel loop independent DEVICEVAR(a1_dev, b1_dev)
   !$omp OMPLOOP DEVICEPTR(a1_dev, b1_dev)
   do i1 = 1, n
      b1_dev(i1) = a1_dev(i1) + 10
   enddo
   !$acc parallel loop independent DEVICEVAR(a2_dev, b2_dev)
   !$omp OMPLOOP DEVICEPTR(a2_dev, b2_dev)
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b2_dev(i1,i2) = a2_dev(i1,i2) + 10
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a3_dev, b3_dev)
   !$omp OMPLOOP DEVICEPTR(a3_dev, b3_dev)
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b3_dev(i1,i2,i3) = a3_dev(i1,i2,i3) + 10
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a4_dev, b4_dev)
   !$omp OMPLOOP DEVICEPTR(a4_dev, b4_dev)
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b4_dev(i1,i2,i3,i4) = a4_dev(i1,i2,i3,i4) + 10
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a5_dev, b5_dev)
   !$omp OMPLOOP DEVICEPTR(a5_dev, b5_dev)
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b5_dev(i1,i2,i3,i4,i5) = a5_dev(i1,i2,i3,i4,i5) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a6_dev, b6_dev)
   !$omp OMPLOOP DEVICEPTR(a6_dev, b6_dev)
   do i6 = 1, n
   !$acc loop
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b6_dev(i1,i2,i3,i4,i5,i6) = a6_dev(i1,i2,i3,i4,i5,i6) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a7_dev, b7_dev)
   !$omp OMPLOOP DEVICEPTR(a7_dev, b7_dev)
   do i7 = 1, n
   !$acc loop
   do i6 = 1, n
   !$acc loop
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b7_dev(i1,i2,i3,i4,i5,i6,i7) = a7_dev(i1,i2,i3,i4,i5,i6,i7) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   ! assign device memory to host one
   print '(A)', '    assign memory from device'
   call dev_assign_from_device(src=b1_dev, dst=b1)
   call dev_assign_from_device(src=b2_dev, dst=b2)
   call dev_assign_from_device(src=b3_dev, dst=b3)
   call dev_assign_from_device(src=b4_dev, dst=b4)
   call dev_assign_from_device(src=b5_dev, dst=b5)
   call dev_assign_from_device(src=b6_dev, dst=b6)
   call dev_assign_from_device(src=b7_dev, dst=b7)
   ! check results
   print '(A)', '    chek results'
   do i1=1, n
      if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo
   do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo
   do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! assign transposed host memory to device one
   print '(A)', '    assign transposed memory to device'
   call dev_assign_to_device(src=a2, dst=a2_dev, transposed=.true.)
   ! assign device memory to host one
   print '(A)', '    assign memory from device'
   call dev_assign_from_device(src=a2_dev, dst=b2)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i2,I4P) /= 0_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   ! assign transposed device memory to host one
   print '(A)', '    assign transposed memory from device'
   call dev_assign_from_device(src=a2_dev, dst=b2, transposed=.true.)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i1,I4P) /= 0_I4P) then
         print '(A)', '    error: something is not working...' ; stop
      endif
   enddo ; enddo
   !print '(A)', '    test unstructured memory'
   !call dev_alloc_unstr(a1) ; call dev_alloc_unstr(b1)
   !call dev_alloc_unstr(a2) ; call dev_alloc_unstr(b2)
   !call dev_alloc_unstr(a3) ; call dev_alloc_unstr(b3)
   !call dev_alloc_unstr(a4) ; call dev_alloc_unstr(b4)
   !call dev_alloc_unstr(a5) ; call dev_alloc_unstr(b5)
   !call dev_alloc_unstr(a6) ; call dev_alloc_unstr(b6)
   !call dev_alloc_unstr(a7) ; call dev_alloc_unstr(b7)
   !call dev_assign_to_device_unstr(a1)
   !call dev_assign_to_device_unstr(a2)
   !call dev_assign_to_device_unstr(a3)
   !call dev_assign_to_device_unstr(a4)
   !call dev_assign_to_device_unstr(a5)
   !call dev_assign_to_device_unstr(a6)
   !call dev_assign_to_device_unstr(a7)
   !! do some operation on device
   !print '(A)', '    compute on device'
   !!$acc parallel loop independent present(a1, b1)
   !do i1 = 1, n
   !   b1(i1) = a1(i1) + 10
   !enddo
   !!$acc parallel loop independent present(a2, b2)
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b2(i1,i2) = a2(i1,i2) + 10
   !enddo
   !enddo
   !!$acc parallel loop independent present(a3, b3)
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b3(i1,i2,i3) = a3(i1,i2,i3) + 10
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a4, b4)
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b4(i1,i2,i3,i4) = a4(i1,i2,i3,i4) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a5, b5)
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b5(i1,i2,i3,i4,i5) = a5(i1,i2,i3,i4,i5) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a6, b6)
   !do i6 = 1, n
   !!$acc loop
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b6(i1,i2,i3,i4,i5,i6) = a6(i1,i2,i3,i4,i5,i6) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !!$acc parallel loop independent present(a7, b7)
   !do i7 = 1, n
   !!$acc loop
   !do i6 = 1, n
   !!$acc loop
   !do i5 = 1, n
   !!$acc loop
   !do i4 = 1, n
   !!$acc loop
   !do i3 = 1, n
   !!$acc loop
   !do i2 = 1, n
   !!$acc loop
   !do i1 = 1, n
   !   b7(i1,i2,i3,i4,i5,i6,i7) = a7(i1,i2,i3,i4,i5,i6,i7) + 10
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !enddo
   !! assign device memory to host one
   !print '(A)', '    assign memory from device'
   !call dev_assign_from_device_unstr(b1)
   !call dev_assign_from_device_unstr(b2)
   !call dev_assign_from_device_unstr(b3)
   !call dev_assign_from_device_unstr(b4)
   !call dev_assign_from_device_unstr(b5)
   !call dev_assign_from_device_unstr(b6)
   !call dev_assign_from_device_unstr(b7)
   !! check results
   !print '(A)', '    chek results'
   !do i1=1, n
   !   if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(1):', int(b1(i1) - a1(i1),I4P)
   !      stop
   !   endif
   !enddo
   !do i2=1, n ; do i1=1, n
   !   if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(2):', int(b2(i1,i2) - a2(i1,i2),I4P)
   !      stop
   !   endif
   !enddo ; enddo
   !do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(3):', int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo
   !do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(4):', int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo
   !do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(5):', int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo
   !do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(6):', int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   !do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
   !   if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
   !      print '(A)', '    error: something is not working...'
   !      print '(A,I3)', '    b-a(7):', int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P)
   !      stop
   !   endif
   !enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   call dev_free(a1_dev,dev_id=mydev)!; call dev_free_unstr(a1)
   call dev_free(a2_dev,dev_id=mydev)!; call dev_free_unstr(a2)
   call dev_free(a3_dev,dev_id=mydev)!; call dev_free_unstr(a3)
   call dev_free(a4_dev,dev_id=mydev)!; call dev_free_unstr(a4)
   call dev_free(a5_dev,dev_id=mydev)!; call dev_free_unstr(a5)
   call dev_free(a6_dev,dev_id=mydev)!; call dev_free_unstr(a6)
   call dev_free(a7_dev,dev_id=mydev)!; call dev_free_unstr(a7)
   call dev_free(b1_dev,dev_id=mydev)!; call dev_free_unstr(b1)
   call dev_free(b2_dev,dev_id=mydev)!; call dev_free_unstr(b2)
   call dev_free(b3_dev,dev_id=mydev)!; call dev_free_unstr(b3)
   call dev_free(b4_dev,dev_id=mydev)!; call dev_free_unstr(b4)
   call dev_free(b5_dev,dev_id=mydev)!; call dev_free_unstr(b5)
   call dev_free(b6_dev,dev_id=mydev)!; call dev_free_unstr(b6)
   call dev_free(b7_dev,dev_id=mydev)!; call dev_free_unstr(b7)
   endsubroutine test_I1P
endprogram fundal_assign_test
