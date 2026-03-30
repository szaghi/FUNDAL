   subroutine TEST_KKP
   !< Test KKP kind: transposed copy from device, lower bounds -2.
   VARTYPE(KKP), pointer             :: a2_dev(:,:)=>null()             !< Source on device memory.
   VARTYPE(KKP), pointer             :: a3_dev(:,:,:)=>null()           !< Source on device memory.
   VARTYPE(KKP), pointer             :: a4_dev(:,:,:,:)=>null()         !< Source on device memory.
   VARTYPE(KKP), pointer             :: a5_dev(:,:,:,:,:)=>null()       !< Source on device memory.
   VARTYPE(KKP), pointer             :: a6_dev(:,:,:,:,:,:)=>null()     !< Source on device memory.
   VARTYPE(KKP), pointer             :: a7_dev(:,:,:,:,:,:,:)=>null()   !< Source on device memory.
   VARTYPE(KKP), pointer             :: b2_dev(:,:)=>null()             !< Result on device memory.
   VARTYPE(KKP), pointer             :: b3_dev(:,:,:)=>null()           !< Result on device memory.
   VARTYPE(KKP), pointer             :: b4_dev(:,:,:,:)=>null()         !< Result on device memory.
   VARTYPE(KKP), pointer             :: b5_dev(:,:,:,:,:)=>null()       !< Result on device memory.
   VARTYPE(KKP), pointer             :: b6_dev(:,:,:,:,:,:)=>null()     !< Result on device memory.
   VARTYPE(KKP), pointer             :: b7_dev(:,:,:,:,:,:,:)=>null()   !< Result on device memory.
   VARTYPE(KKP), allocatable, target :: a2(:,:)                         !< Source on host memory.
   VARTYPE(KKP), allocatable, target :: a3(:,:,:)                       !< Source on host memory.
   VARTYPE(KKP), allocatable, target :: a4(:,:,:,:)                     !< Source on host memory.
   VARTYPE(KKP), allocatable, target :: a5(:,:,:,:,:)                   !< Source on host memory.
   VARTYPE(KKP), allocatable, target :: a6(:,:,:,:,:,:)                 !< Source on host memory.
   VARTYPE(KKP), allocatable, target :: a7(:,:,:,:,:,:,:)               !< Source on host memory.
   VARTYPE(KKP), allocatable, target :: buf2(:,:)                       !< Buffer (same shape as device).
   VARTYPE(KKP), allocatable, target :: buf3(:,:,:)                     !< Buffer (same shape as device).
   VARTYPE(KKP), allocatable, target :: buf4(:,:,:,:)                   !< Buffer (same shape as device).
   VARTYPE(KKP), allocatable, target :: buf5(:,:,:,:,:)                 !< Buffer (same shape as device).
   VARTYPE(KKP), allocatable, target :: buf6(:,:,:,:,:,:)               !< Buffer (same shape as device).
   VARTYPE(KKP), allocatable, target :: buf7(:,:,:,:,:,:,:)             !< Buffer (same shape as device).
   VARTYPE(KKP), allocatable, target :: t2(:,:)                         !< Transposed result on host.
   VARTYPE(KKP), allocatable, target :: t3(:,:,:)                       !< Transposed result on host.
   VARTYPE(KKP), allocatable, target :: t4(:,:,:,:)                     !< Transposed result on host.
   VARTYPE(KKP), allocatable, target :: t5(:,:,:,:,:)                   !< Transposed result on host.
   VARTYPE(KKP), allocatable, target :: t6(:,:,:,:,:,:)                 !< Transposed result on host.
   VARTYPE(KKP), allocatable, target :: t7(:,:,:,:,:,:,:)               !< Transposed result on host.
   integer(I4P)                      :: bb2(2,2)                        !< Bounds of 2D device arrays.
   integer(I4P)                      :: bb3(2,3)                        !< Bounds of 3D device arrays.
   integer(I4P)                      :: bb4(2,4)                        !< Bounds of 4D device arrays.
   integer(I4P)                      :: bb5(2,5)                        !< Bounds of 5D device arrays.
   integer(I4P)                      :: bb6(2,6)                        !< Bounds of 6D device arrays.
   integer(I4P)                      :: bb7(2,7)                        !< Bounds of 7D device arrays.
   integer(I4P)                      :: tb2(2,2)                        !< Bounds of transposed 2D host array.
   integer(I4P)                      :: tb3(2,3)                        !< Bounds of transposed 3D host array.
   integer(I4P)                      :: tb4(2,4)                        !< Bounds of transposed 4D host array.
   integer(I4P)                      :: tb5(2,5)                        !< Bounds of transposed 5D host array.
   integer(I4P)                      :: tb6(2,6)                        !< Bounds of transposed 6D host array.
   integer(I4P)                      :: tb7(2,7)                        !< Bounds of transposed 7D host array.
   integer(I4P)                      :: ij(2)                           !< Dimension pair to swap (3D-7D).
   integer(I4P)                      :: ierr                            !< Error status.
   integer(I4P)                      :: i1,i2,i3,i4,i5,i6,i7           !< Counter.

   print '(A)', ECHO_KKP

   ! All device arrays have bounds -2:n in every dimension.
   ! Transpose swaps dims 1 and 2 (ij=[1,2]).
   ! Since all dims are equal (-2:n), the transposed bounds tb == bb.
   ij = [1_I4P, 2_I4P]
   bb2(1,:) = -2_I4P ; bb2(2,:) = n ; tb2 = bb2
   bb3(1,:) = -2_I4P ; bb3(2,:) = n ; tb3 = bb3
   bb4(1,:) = -2_I4P ; bb4(2,:) = n ; tb4 = bb4
   bb5(1,:) = -2_I4P ; bb5(2,:) = n ; tb5 = bb5
   bb6(1,:) = -2_I4P ; bb6(2,:) = n ; tb6 = bb6
   bb7(1,:) = -2_I4P ; bb7(2,:) = n ; tb7 = bb7

   ! Allocate host arrays
   allocate(a2(-2:n,-2:n), buf2(-2:n,-2:n), t2(-2:n,-2:n))
   allocate(a3(-2:n,-2:n,-2:n), buf3(-2:n,-2:n,-2:n), t3(-2:n,-2:n,-2:n))
   allocate(a4(-2:n,-2:n,-2:n,-2:n), buf4(-2:n,-2:n,-2:n,-2:n), t4(-2:n,-2:n,-2:n,-2:n))
   allocate(a5(-2:n,-2:n,-2:n,-2:n,-2:n), buf5(-2:n,-2:n,-2:n,-2:n,-2:n), t5(-2:n,-2:n,-2:n,-2:n,-2:n))
   allocate(a6(-2:n,-2:n,-2:n,-2:n,-2:n,-2:n), buf6(-2:n,-2:n,-2:n,-2:n,-2:n,-2:n), t6(-2:n,-2:n,-2:n,-2:n,-2:n,-2:n))
   allocate(a7(-2:n,-2:n,-2:n,-2:n,-2:n,-2:n,-2:n), buf7(-2:n,-2:n,-2:n,-2:n,-2:n,-2:n,-2:n), t7(-2:n,-2:n,-2:n,-2:n,-2:n,-2:n,-2:n))

   ! Initialize source arrays: value = first index i1
   do i2=-2, n ; do i1=-2, n
      a2(i1,i2) = i1
   enddo ; enddo
   do i3=-2, n ; do i2=-2, n ; do i1=-2, n
      a3(i1,i2,i3) = i1
   enddo ; enddo ; enddo
   do i4=-2, n ; do i3=-2, n ; do i2=-2, n ; do i1=-2, n
      a4(i1,i2,i3,i4) = i1
   enddo ; enddo ; enddo ; enddo
   do i5=-2, n ; do i4=-2, n ; do i3=-2, n ; do i2=-2, n ; do i1=-2, n
      a5(i1,i2,i3,i4,i5) = i1
   enddo ; enddo ; enddo ; enddo ; enddo
   do i6=-2, n ; do i5=-2, n ; do i4=-2, n ; do i3=-2, n ; do i2=-2, n ; do i1=-2, n
      a6(i1,i2,i3,i4,i5,i6) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   do i7=-2, n ; do i6=-2, n ; do i5=-2, n ; do i4=-2, n ; do i3=-2, n ; do i2=-2, n ; do i1=-2, n
      a7(i1,i2,i3,i4,i5,i6,i7) = i1
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo

   ! Allocate device memory
   call dev_alloc(fptr_dev=a2_dev, ubounds=[n,n          ], lbounds=[-2_I4P,-2_I4P                                   ], ierr=ierr)
   call error_print(ierr,'a2_dev not allocated')
   call dev_alloc(fptr_dev=a3_dev, ubounds=[n,n,n        ], lbounds=[-2_I4P,-2_I4P,-2_I4P                            ], ierr=ierr)
   call error_print(ierr,'a3_dev not allocated')
   call dev_alloc(fptr_dev=a4_dev, ubounds=[n,n,n,n      ], lbounds=[-2_I4P,-2_I4P,-2_I4P,-2_I4P                     ], ierr=ierr)
   call error_print(ierr,'a4_dev not allocated')
   call dev_alloc(fptr_dev=a5_dev, ubounds=[n,n,n,n,n    ], lbounds=[-2_I4P,-2_I4P,-2_I4P,-2_I4P,-2_I4P              ], ierr=ierr)
   call error_print(ierr,'a5_dev not allocated')
   call dev_alloc(fptr_dev=a6_dev, ubounds=[n,n,n,n,n,n  ], lbounds=[-2_I4P,-2_I4P,-2_I4P,-2_I4P,-2_I4P,-2_I4P       ], ierr=ierr)
   call error_print(ierr,'a6_dev not allocated')
   call dev_alloc(fptr_dev=a7_dev, ubounds=[n,n,n,n,n,n,n], lbounds=[-2_I4P,-2_I4P,-2_I4P,-2_I4P,-2_I4P,-2_I4P,-2_I4P], ierr=ierr)
   call error_print(ierr,'a7_dev not allocated')
   call dev_alloc(fptr_dev=b2_dev, ubounds=[n,n          ], lbounds=[-2_I4P,-2_I4P                                   ], ierr=ierr)
   call error_print(ierr,'b2_dev not allocated')
   call dev_alloc(fptr_dev=b3_dev, ubounds=[n,n,n        ], lbounds=[-2_I4P,-2_I4P,-2_I4P                            ], ierr=ierr)
   call error_print(ierr,'b3_dev not allocated')
   call dev_alloc(fptr_dev=b4_dev, ubounds=[n,n,n,n      ], lbounds=[-2_I4P,-2_I4P,-2_I4P,-2_I4P                     ], ierr=ierr)
   call error_print(ierr,'b4_dev not allocated')
   call dev_alloc(fptr_dev=b5_dev, ubounds=[n,n,n,n,n    ], lbounds=[-2_I4P,-2_I4P,-2_I4P,-2_I4P,-2_I4P              ], ierr=ierr)
   call error_print(ierr,'b5_dev not allocated')
   call dev_alloc(fptr_dev=b6_dev, ubounds=[n,n,n,n,n,n  ], lbounds=[-2_I4P,-2_I4P,-2_I4P,-2_I4P,-2_I4P,-2_I4P       ], ierr=ierr)
   call error_print(ierr,'b6_dev not allocated')
   call dev_alloc(fptr_dev=b7_dev, ubounds=[n,n,n,n,n,n,n], lbounds=[-2_I4P,-2_I4P,-2_I4P,-2_I4P,-2_I4P,-2_I4P,-2_I4P], ierr=ierr)
   call error_print(ierr,'b7_dev not allocated')

   ! Copy host -> device
   print '(A)', '    copy memory to device'
   call dev_memcpy_to_device(src=a2, dst=a2_dev)
   call dev_memcpy_to_device(src=a3, dst=a3_dev)
   call dev_memcpy_to_device(src=a4, dst=a4_dev)
   call dev_memcpy_to_device(src=a5, dst=a5_dev)
   call dev_memcpy_to_device(src=a6, dst=a6_dev)
   call dev_memcpy_to_device(src=a7, dst=a7_dev)

   ! Compute on device (add 10)
   print '(A)', '    compute on device'
   !$acc parallel loop independent DEVICEVAR(a2_dev, b2_dev)
   !$omp OMPLOOP DEVICEPTR(a2_dev, b2_dev)
   do i2=-2, n
   !$acc loop
   do i1=-2, n
      b2_dev(i1,i2) = a2_dev(i1,i2) + 10
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a3_dev, b3_dev)
   !$omp OMPLOOP DEVICEPTR(a3_dev, b3_dev)
   do i3=-2, n
   !$acc loop
   do i2=-2, n
   !$acc loop
   do i1=-2, n
      b3_dev(i1,i2,i3) = a3_dev(i1,i2,i3) + 10
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a4_dev, b4_dev)
   !$omp OMPLOOP DEVICEPTR(a4_dev, b4_dev)
   do i4=-2, n
   !$acc loop
   do i3=-2, n
   !$acc loop
   do i2=-2, n
   !$acc loop
   do i1=-2, n
      b4_dev(i1,i2,i3,i4) = a4_dev(i1,i2,i3,i4) + 10
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a5_dev, b5_dev)
   !$omp OMPLOOP DEVICEPTR(a5_dev, b5_dev)
   do i5=-2, n
   !$acc loop
   do i4=-2, n
   !$acc loop
   do i3=-2, n
   !$acc loop
   do i2=-2, n
   !$acc loop
   do i1=-2, n
      b5_dev(i1,i2,i3,i4,i5) = a5_dev(i1,i2,i3,i4,i5) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a6_dev, b6_dev)
   !$omp OMPLOOP DEVICEPTR(a6_dev, b6_dev)
   do i6=-2, n
   !$acc loop
   do i5=-2, n
   !$acc loop
   do i4=-2, n
   !$acc loop
   do i3=-2, n
   !$acc loop
   do i2=-2, n
   !$acc loop
   do i1=-2, n
      b6_dev(i1,i2,i3,i4,i5,i6) = a6_dev(i1,i2,i3,i4,i5,i6) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   !$acc parallel loop independent DEVICEVAR(a7_dev, b7_dev)
   !$omp OMPLOOP DEVICEPTR(a7_dev, b7_dev)
   do i7=-2, n
   !$acc loop
   do i6=-2, n
   !$acc loop
   do i5=-2, n
   !$acc loop
   do i4=-2, n
   !$acc loop
   do i3=-2, n
   !$acc loop
   do i2=-2, n
   !$acc loop
   do i1=-2, n
      b7_dev(i1,i2,i3,i4,i5,i6,i7) = a7_dev(i1,i2,i3,i4,i5,i6,i7) + 10
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo

   ! Transposed copy from device to host: b_dev(i1,i2,...) -> t(i2,i1,...)
   print '(A)', '    copy memory from device (transposed)'
   call dev_memcpy_from_device(bb=bb2,        tb=tb2, dst=t2, src=b2_dev, buf=buf2)
   call dev_memcpy_from_device(bb=bb3, ij=ij, tb=tb3, dst=t3, src=b3_dev, buf=buf3)
   call dev_memcpy_from_device(bb=bb4, ij=ij, tb=tb4, dst=t4, src=b4_dev, buf=buf4)
   call dev_memcpy_from_device(bb=bb5, ij=ij, tb=tb5, dst=t5, src=b5_dev, buf=buf5)
   call dev_memcpy_from_device(bb=bb6, ij=ij, tb=tb6, dst=t6, src=b6_dev, buf=buf6)
   call dev_memcpy_from_device(bb=bb7, ij=ij, tb=tb7, dst=t7, src=b7_dev, buf=buf7)

   ! Check results: transpose swaps dims 1 and 2, so t(i2,i1,...) = b_dev(i1,i2,...) = a(i1,i2,...) + 10
   print '(A)', '    check results'
   do i2=-2, n ; do i1=-2, n
      if (int(t2(i2,i1) - a2(i1,i2), I4P) /= 10_I4P) then
         print '(A)', '    error: rank 2 transposed memcpy incorrect' ; stop
      endif
   enddo ; enddo
   if (lbound(t2,1) /= -2) call error_print(1_I4P,'t2 lower bound dim 1 is not -2')
   if (lbound(t2,2) /= -2) call error_print(1_I4P,'t2 lower bound dim 2 is not -2')
   do i3=-2, n ; do i2=-2, n ; do i1=-2, n
      if (int(t3(i2,i1,i3) - a3(i1,i2,i3), I4P) /= 10_I4P) then
         print '(A)', '    error: rank 3 transposed memcpy incorrect' ; stop
      endif
   enddo ; enddo ; enddo
   if (lbound(t3,1) /= -2) call error_print(1_I4P,'t3 lower bound dim 1 is not -2')
   if (lbound(t3,2) /= -2) call error_print(1_I4P,'t3 lower bound dim 2 is not -2')
   if (lbound(t3,3) /= -2) call error_print(1_I4P,'t3 lower bound dim 3 is not -2')
   do i4=-2, n ; do i3=-2, n ; do i2=-2, n ; do i1=-2, n
      if (int(t4(i2,i1,i3,i4) - a4(i1,i2,i3,i4), I4P) /= 10_I4P) then
         print '(A)', '    error: rank 4 transposed memcpy incorrect' ; stop
      endif
   enddo ; enddo ; enddo ; enddo
   if (lbound(t4,1) /= -2) call error_print(1_I4P,'t4 lower bound dim 1 is not -2')
   if (lbound(t4,2) /= -2) call error_print(1_I4P,'t4 lower bound dim 2 is not -2')
   if (lbound(t4,3) /= -2) call error_print(1_I4P,'t4 lower bound dim 3 is not -2')
   if (lbound(t4,4) /= -2) call error_print(1_I4P,'t4 lower bound dim 4 is not -2')
   do i5=-2, n ; do i4=-2, n ; do i3=-2, n ; do i2=-2, n ; do i1=-2, n
      if (int(t5(i2,i1,i3,i4,i5) - a5(i1,i2,i3,i4,i5), I4P) /= 10_I4P) then
         print '(A)', '    error: rank 5 transposed memcpy incorrect' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo
   if (lbound(t5,1) /= -2) call error_print(1_I4P,'t5 lower bound dim 1 is not -2')
   if (lbound(t5,2) /= -2) call error_print(1_I4P,'t5 lower bound dim 2 is not -2')
   if (lbound(t5,3) /= -2) call error_print(1_I4P,'t5 lower bound dim 3 is not -2')
   if (lbound(t5,4) /= -2) call error_print(1_I4P,'t5 lower bound dim 4 is not -2')
   if (lbound(t5,5) /= -2) call error_print(1_I4P,'t5 lower bound dim 5 is not -2')
   do i6=-2, n ; do i5=-2, n ; do i4=-2, n ; do i3=-2, n ; do i2=-2, n ; do i1=-2, n
      if (int(t6(i2,i1,i3,i4,i5,i6) - a6(i1,i2,i3,i4,i5,i6), I4P) /= 10_I4P) then
         print '(A)', '    error: rank 6 transposed memcpy incorrect' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   if (lbound(t6,1) /= -2) call error_print(1_I4P,'t6 lower bound dim 1 is not -2')
   if (lbound(t6,2) /= -2) call error_print(1_I4P,'t6 lower bound dim 2 is not -2')
   if (lbound(t6,3) /= -2) call error_print(1_I4P,'t6 lower bound dim 3 is not -2')
   if (lbound(t6,4) /= -2) call error_print(1_I4P,'t6 lower bound dim 4 is not -2')
   if (lbound(t6,5) /= -2) call error_print(1_I4P,'t6 lower bound dim 5 is not -2')
   if (lbound(t6,6) /= -2) call error_print(1_I4P,'t6 lower bound dim 6 is not -2')
   do i7=-2, n ; do i6=-2, n ; do i5=-2, n ; do i4=-2, n ; do i3=-2, n ; do i2=-2, n ; do i1=-2, n
      if (int(t7(i2,i1,i3,i4,i5,i6,i7) - a7(i1,i2,i3,i4,i5,i6,i7), I4P) /= 10_I4P) then
         print '(A)', '    error: rank 7 transposed memcpy incorrect' ; stop
      endif
   enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   if (lbound(t7,1) /= -2) call error_print(1_I4P,'t7 lower bound dim 1 is not -2')
   if (lbound(t7,2) /= -2) call error_print(1_I4P,'t7 lower bound dim 2 is not -2')
   if (lbound(t7,3) /= -2) call error_print(1_I4P,'t7 lower bound dim 3 is not -2')
   if (lbound(t7,4) /= -2) call error_print(1_I4P,'t7 lower bound dim 4 is not -2')
   if (lbound(t7,5) /= -2) call error_print(1_I4P,'t7 lower bound dim 5 is not -2')
   if (lbound(t7,6) /= -2) call error_print(1_I4P,'t7 lower bound dim 6 is not -2')
   if (lbound(t7,7) /= -2) call error_print(1_I4P,'t7 lower bound dim 7 is not -2')

   call dev_free(a2_dev, dev_id=mydev) ; call dev_free(b2_dev, dev_id=mydev)
   call dev_free(a3_dev, dev_id=mydev) ; call dev_free(b3_dev, dev_id=mydev)
   call dev_free(a4_dev, dev_id=mydev) ; call dev_free(b4_dev, dev_id=mydev)
   call dev_free(a5_dev, dev_id=mydev) ; call dev_free(b5_dev, dev_id=mydev)
   call dev_free(a6_dev, dev_id=mydev) ; call dev_free(b6_dev, dev_id=mydev)
   call dev_free(a7_dev, dev_id=mydev) ; call dev_free(b7_dev, dev_id=mydev)
   endsubroutine TEST_KKP
