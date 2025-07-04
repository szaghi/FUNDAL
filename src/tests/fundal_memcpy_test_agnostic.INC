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
   call dev_alloc(fptr_dev=a1_dev, ubounds=[n            ],ierr=ierr);call error_print(ierr,'a1_dev')
   call dev_alloc(fptr_dev=a2_dev, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'a2_dev')
   call dev_alloc(fptr_dev=a3_dev, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'a3_dev')
   call dev_alloc(fptr_dev=a4_dev, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'a4_dev')
   call dev_alloc(fptr_dev=a5_dev, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'a5_dev')
   call dev_alloc(fptr_dev=a6_dev, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'a6_dev')
   call dev_alloc(fptr_dev=a7_dev, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'a7_dev')
   call dev_alloc(fptr_dev=b1_dev, ubounds=[n            ],ierr=ierr);call error_print(ierr,'b1_dev')
   call dev_alloc(fptr_dev=b2_dev, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'b2_dev')
   call dev_alloc(fptr_dev=b3_dev, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'b3_dev')
   call dev_alloc(fptr_dev=b4_dev, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'b4_dev')
   call dev_alloc(fptr_dev=b5_dev, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'b5_dev')
   call dev_alloc(fptr_dev=b6_dev, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'b6_dev')
   call dev_alloc(fptr_dev=b7_dev, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'b7_dev')

   ! copy host memory to device one
   print '(A)', '    copy memory to device'
   call dev_memcpy_to_device(src=a1, dst=a1_dev)
   call dev_memcpy_to_device(src=a2, dst=a2_dev)
   call dev_memcpy_to_device(src=a3, dst=a3_dev)
   call dev_memcpy_to_device(src=a4, dst=a4_dev)
   call dev_memcpy_to_device(src=a5, dst=a5_dev)
   call dev_memcpy_to_device(src=a6, dst=a6_dev)
   call dev_memcpy_to_device(src=a7, dst=a7_dev)

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
   ! copy device memory to host one
   print '(A)', '    copy memory from device'
   call dev_memcpy_from_device(src=b1_dev, dst=b1)
   call dev_memcpy_from_device(src=b2_dev, dst=b2)
   call dev_memcpy_from_device(src=b3_dev, dst=b3)
   call dev_memcpy_from_device(src=b4_dev, dst=b4)
   call dev_memcpy_from_device(src=b5_dev, dst=b5)
   call dev_memcpy_from_device(src=b6_dev, dst=b6)
   call dev_memcpy_from_device(src=b7_dev, dst=b7)
   ! check results
   print '(A)', '    check results'
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
   print '(A)', '    test unstructured memory'
   call dev_alloc_unstr(a1) ; call dev_alloc_unstr(b1)
   call dev_alloc_unstr(a2) ; call dev_alloc_unstr(b2)
   call dev_alloc_unstr(a3) ; call dev_alloc_unstr(b3)
   call dev_alloc_unstr(a4) ; call dev_alloc_unstr(b4)
   call dev_alloc_unstr(a5) ; call dev_alloc_unstr(b5)
   call dev_alloc_unstr(a6) ; call dev_alloc_unstr(b6)
   call dev_alloc_unstr(a7) ; call dev_alloc_unstr(b7)
   call dev_memcpy_to_device_unstr(a1)
   call dev_memcpy_to_device_unstr(a2)
   call dev_memcpy_to_device_unstr(a3)
   call dev_memcpy_to_device_unstr(a4)
   call dev_memcpy_to_device_unstr(a5)
   call dev_memcpy_to_device_unstr(a6)
   call dev_memcpy_to_device_unstr(a7)
   ! do some operation on device
   print '(A)', '    compute on device'
   !$acc parallel loop independent present(a1, b1)
   !$omp OMPLOOP
   do i1 = 1, n
      b1(i1) = a1(i1) + 10
   enddo
   !$acc parallel loop independent present(a2, b2)
   !$omp OMPLOOP
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b2(i1,i2) = a2(i1,i2) + 10
   enddo
   enddo
   !$acc parallel loop independent present(a3, b3)
   !$omp OMPLOOP
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b3(i1,i2,i3) = a3(i1,i2,i3) + 10
   enddo
   enddo
   enddo
   !$acc parallel loop independent present(a4, b4)
   !$omp OMPLOOP
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b4(i1,i2,i3,i4) = a4(i1,i2,i3,i4) + 10
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent present(a5, b5)
   !$omp OMPLOOP
   do i5 = 1, n
   !$acc loop
   do i4 = 1, n
   !$acc loop
   do i3 = 1, n
   !$acc loop
   do i2 = 1, n
   !$acc loop
   do i1 = 1, n
      b5(i1,i2,i3,i4,i5) = a5(i1,i2,i3,i4,i5) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent present(a6, b6)
   !$omp OMPLOOP
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
      b6(i1,i2,i3,i4,i5,i6) = a6(i1,i2,i3,i4,i5,i6) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent present(a7, b7)
   !$omp OMPLOOP
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
      b7(i1,i2,i3,i4,i5,i6,i7) = a7(i1,i2,i3,i4,i5,i6,i7) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   ! copy device memory to host one
   print '(A)', '    copy memory from device'
   call dev_memcpy_from_device_unstr(b1)
   call dev_memcpy_from_device_unstr(b2)
   call dev_memcpy_from_device_unstr(b3)
   call dev_memcpy_from_device_unstr(b4)
   call dev_memcpy_from_device_unstr(b5)
   call dev_memcpy_from_device_unstr(b6)
   call dev_memcpy_from_device_unstr(b7)
   ! check results
   print '(A)', '    chek results'
   do i1=1, n
      if (int(b1(i1) - a1(i1),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...'
         print '(A,I3)', '    b-a(1):', int(b1(i1) - a1(i1),I4P)
         stop
      endif
   enddo
   do i2=1, n ; do i1=1, n
      if (int(b2(i1,i2) - a2(i1,i2),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...'
         print '(A,I3)', '    b-a(2):', int(b2(i1,i2) - a2(i1,i2),I4P)
         stop
      endif
   enddo ; enddo
   do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...'
         print '(A,I3)', '    b-a(3):', int(b3(i1,i2,i3) - a3(i1,i2,i3),I4P)
         stop
      endif
   enddo ; enddo ; enddo
   do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...'
         print '(A,I3)', '    b-a(4):', int(b4(i1,i2,i3,i4) - a4(i1,i2,i3,i4),I4P)
         stop
      endif
   enddo ; enddo ; enddo ; enddo
   do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...'
         print '(A,I3)', '    b-a(5):', int(b5(i1,i2,i3,i4,i5) - a5(i1,i2,i3,i4,i5),I4P)
         stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...'
         print '(A,I3)', '    b-a(6):', int(b6(i1,i2,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6),I4P)
         stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7=1, n ; do i6=1, n ; do i5=1, n ; do i4=1, n ; do i3=1, n ; do i2=1, n ; do i1=1, n
      if (int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
         print '(A)', '    error: something is not working...'
         print '(A,I3)', '    b-a(7):', int(b7(i1,i2,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7),I4P)
         stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   call dev_free(a1_dev,dev_id=mydev) ; call dev_free_unstr(a1)
   call dev_free(a2_dev,dev_id=mydev) ; call dev_free_unstr(a2)
   call dev_free(a3_dev,dev_id=mydev) ; call dev_free_unstr(a3)
   call dev_free(a4_dev,dev_id=mydev) ; call dev_free_unstr(a4)
   call dev_free(a5_dev,dev_id=mydev) ; call dev_free_unstr(a5)
   call dev_free(a6_dev,dev_id=mydev) ; call dev_free_unstr(a6)
   call dev_free(a7_dev,dev_id=mydev) ; call dev_free_unstr(a7)
   call dev_free(b1_dev,dev_id=mydev) ; call dev_free_unstr(b1)
   call dev_free(b2_dev,dev_id=mydev) ; call dev_free_unstr(b2)
   call dev_free(b3_dev,dev_id=mydev) ; call dev_free_unstr(b3)
   call dev_free(b4_dev,dev_id=mydev) ; call dev_free_unstr(b4)
   call dev_free(b5_dev,dev_id=mydev) ; call dev_free_unstr(b5)
   call dev_free(b6_dev,dev_id=mydev) ; call dev_free_unstr(b6)
   call dev_free(b7_dev,dev_id=mydev) ; call dev_free_unstr(b7)
   endsubroutine TEST_KKP
