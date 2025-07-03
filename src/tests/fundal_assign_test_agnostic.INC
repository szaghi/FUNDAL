   subroutine TEST_KKP
   !< Test KKP kind.
   VARTYPE(KKP), pointer             :: a1_dev(:)=>null()             !< Array on device memory.
   VARTYPE(KKP), pointer             :: a2_dev(:,:)=>null()           !< Array on device memory.
   VARTYPE(KKP), pointer             :: a3_dev(:,:,:)=>null()         !< Array on device memory.
   VARTYPE(KKP), pointer             :: a4_dev(:,:,:,:)=>null()       !< Array on device memory.
   VARTYPE(KKP), pointer             :: a5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   VARTYPE(KKP), pointer             :: a6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   VARTYPE(KKP), pointer             :: a7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   VARTYPE(KKP), pointer             :: b1_dev(:)=>null()             !< Array on device memory.
   VARTYPE(KKP), pointer             :: b2_dev(:,:)=>null()           !< Array on device memory.
   VARTYPE(KKP), pointer             :: b3_dev(:,:,:)=>null()         !< Array on device memory.
   VARTYPE(KKP), pointer             :: b4_dev(:,:,:,:)=>null()       !< Array on device memory.
   VARTYPE(KKP), pointer             :: b5_dev(:,:,:,:,:)=>null()     !< Array on device memory.
   VARTYPE(KKP), pointer             :: b6_dev(:,:,:,:,:,:)=>null()   !< Array on device memory.
   VARTYPE(KKP), pointer             :: b7_dev(:,:,:,:,:,:,:)=>null() !< Array on device memory.
   VARTYPE(KKP), allocatable, target :: a1(:)                         !< Array on host memory.
   VARTYPE(KKP), allocatable, target :: a2(:,:)                       !< Array on host memory.
   VARTYPE(KKP), allocatable, target :: a3(:,:,:)                     !< Array on host memory.
   VARTYPE(KKP), allocatable, target :: a4(:,:,:,:)                   !< Array on host memory.
   VARTYPE(KKP), allocatable, target :: a5(:,:,:,:,:)                 !< Array on host memory.
   VARTYPE(KKP), allocatable, target :: a6(:,:,:,:,:,:)               !< Array on host memory.
   VARTYPE(KKP), allocatable, target :: a7(:,:,:,:,:,:,:)             !< Array on host memory.
   VARTYPE(KKP), allocatable, target :: b1(:)                         !< Array on host memory.
   VARTYPE(KKP), allocatable, target :: b2(:,:)                       !< Array on host memory.
   VARTYPE(KKP), allocatable, target :: b3(:,:,:)                     !< Array on host memory.
   VARTYPE(KKP), allocatable, target :: b4(:,:,:,:)                   !< Array on host memory.
   VARTYPE(KKP), allocatable, target :: b5(:,:,:,:,:)                 !< Array on host memory.
   VARTYPE(KKP), allocatable, target :: b6(:,:,:,:,:,:)               !< Array on host memory.
   VARTYPE(KKP), allocatable, target :: b7(:,:,:,:,:,:,:)             !< Array on host memory.
   integer(I4P)                      :: ierr                          !< Error status.
   integer(I4P)                      :: i1,i2,i3,i4,i5,i6,i7          !< Counter.

   print '(A)', ECHO_KKP
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
   call dev_alloc(fptr_dev=b1_dev, ubounds=[n            ],ierr=ierr);call error_print(ierr,'b1_dev not allocated')
   call dev_alloc(fptr_dev=b2_dev, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'b2_dev not allocated')
   call dev_alloc(fptr_dev=b3_dev, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'b3_dev not allocated')
   call dev_alloc(fptr_dev=b4_dev, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'b4_dev not allocated')
   call dev_alloc(fptr_dev=b5_dev, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'b5_dev not allocated')
   call dev_alloc(fptr_dev=b6_dev, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'b6_dev not allocated')
   call dev_alloc(fptr_dev=b7_dev, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'b7_dev not allocated')

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
      if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) call error_print(1_I4P,'assign b1_dev failed')
   enddo
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) call error_print(1_I4P,'assign b2_dev failed')
   enddo ; enddo
   do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) call error_print(1_I4P,'assign b3_dev failed')
   enddo ; enddo ; enddo
   do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) call error_print(1_I4P,'assign b4_dev failed')
   enddo ; enddo ; enddo ; enddo
   do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) call error_print(1_I4P,'assign b5_dev failed')
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) call error_print(1_I4P,'assign b6_dev failed')
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) call error_print(1_I4P,'assign b7_dev failed')
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! assign transposed host memory to device one
   print '(A)', '    assign transposed memory to device'
   call dev_assign_to_device(src=a2, dst=a2_dev, transposed=.true.)
   call dev_assign_to_device(src=a3, dst=a3_dev, transposed=.true.)
   call dev_assign_to_device(src=a4, dst=a4_dev, transposed=.true.)
   call dev_assign_to_device(src=a5, dst=a5_dev, transposed=.true.)
   call dev_assign_to_device(src=a6, dst=a6_dev, transposed=.true.)
   call dev_assign_to_device(src=a7, dst=a7_dev, transposed=.true.)
   call dev_assign_from_device(src=a2_dev, dst=b2)
   call dev_assign_from_device(src=a3_dev, dst=b3)
   call dev_assign_from_device(src=a4_dev, dst=b4)
   call dev_assign_from_device(src=a5_dev, dst=b5)
   call dev_assign_from_device(src=a6_dev, dst=b6)
   call dev_assign_from_device(src=a7_dev, dst=b7)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i2,I4P) /= 0_I4P) call error_print(1_I4P,'assign a2 transposed failed')
   enddo ; enddo
   do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b3(i1,i2,i3) - i3,I4P) /= 0_I4P) call error_print(1_I4P,'assign a3 transposed failed')
   enddo ; enddo ; enddo
   do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b4(i1,i2,i3,i4) - i4,I4P) /= 0_I4P) call error_print(1_I4P,'assign a4 transposed failed')
   enddo ; enddo ; enddo ; enddo
   do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b5(i1,i2,i3,i4,i5) - i5,I4P) /= 0_I4P) call error_print(1_I4P,'assign a5 transposed failed')
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b6(i1,i2,i3,i4,i5,i6) - i6,I4P) /= 0_I4P) call error_print(1_I4P,'assign a6 transposed failed')
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b7(i1,i2,i3,i4,i5,i6,i7) - i7,I4P) /= 0_I4P) call error_print(1_I4P,'assign a7 transposed failed')
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   ! assign transposed device memory to host one
   print '(A)', '    assign transposed memory from device'
   call dev_assign_from_device(src=a2_dev, dst=b2, transposed=.true.)
   call dev_assign_from_device(src=a3_dev, dst=b3, transposed=.true.)
   call dev_assign_from_device(src=a4_dev, dst=b4, transposed=.true.)
   call dev_assign_from_device(src=a5_dev, dst=b5, transposed=.true.)
   call dev_assign_from_device(src=a6_dev, dst=b6, transposed=.true.)
   call dev_assign_from_device(src=a7_dev, dst=b7, transposed=.true.)
   print '(A)', '    chek transposed results'
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - i1,I4P) /= 0_I4P) call error_print(1_I4P,'assign a2_dev transposed failed')
   enddo ; enddo
   do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b3(i1,i2,i3) - i1,I4P) /= 0_I4P) call error_print(1_I4P,'assign a3_dev transposed failed')
   enddo ; enddo ; enddo
   do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b4(i1,i2,i3,i4) - i1,I4P) /= 0_I4P) call error_print(1_I4P,'assign a4_dev transposed failed')
   enddo ; enddo ; enddo ; enddo
   do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b5(i1,i2,i3,i4,i5) - i1,I4P) /= 0_I4P) call error_print(1_I4P,'assign a5_dev transposed failed')
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b6(i1,i2,i3,i4,i5,i6) - i1,I4P) /= 0_I4P) call error_print(1_I4P,'assign a6_dev transposed failed')
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b7(i1,i2,i3,i4,i5,i6,i7) - i1,I4P) /= 0_I4P) call error_print(1_I4P,'assign a7_dev transposed failed')
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   call dev_free(a1_dev,dev_id=mydev)
   call dev_free(a2_dev,dev_id=mydev)
   call dev_free(a3_dev,dev_id=mydev)
   call dev_free(a4_dev,dev_id=mydev)
   call dev_free(a5_dev,dev_id=mydev)
   call dev_free(a6_dev,dev_id=mydev)
   call dev_free(a7_dev,dev_id=mydev)
   call dev_free(b1_dev,dev_id=mydev)
   call dev_free(b2_dev,dev_id=mydev)
   call dev_free(b3_dev,dev_id=mydev)
   call dev_free(b4_dev,dev_id=mydev)
   call dev_free(b5_dev,dev_id=mydev)
   call dev_free(b6_dev,dev_id=mydev)
   call dev_free(b7_dev,dev_id=mydev)
   endsubroutine TEST_KKP
