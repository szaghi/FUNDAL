   ! dev_memcpy_from_device
   subroutine DEV_MEMCPY_FROM_DEVICE_KKP_1D(dst, src)
   !< Copy array from device, KKP kind, rank 1.
   VARTYPE(KKP), intent(out), target :: dst(:) !< Destination memory (host memory).
   VARTYPE(KKP), intent(in),  target :: src(:) !< Source memory (device memory).
   integer(I4P)                      :: ierr   !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_FROM_DEVICE_KKP_1D

   subroutine DEV_MEMCPY_FROM_DEVICE_KKP_2D(dst, src)
   !< Copy array from device, KKP kind, rank 2.
   VARTYPE(KKP), intent(out), target :: dst(:,:) !< Destination memory (host memory).
   VARTYPE(KKP), intent(in),  target :: src(:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr     !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_FROM_DEVICE_KKP_2D

   subroutine DEV_MEMCPY_FROM_DEVICE_KKP_3D(dst, src)
   !< Copy array from device, KKP kind, rank 3.
   VARTYPE(KKP), intent(out), target :: dst(:,:,:) !< Destination memory (host memory).
   VARTYPE(KKP), intent(in),  target :: src(:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr       !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_FROM_DEVICE_KKP_3D

   subroutine DEV_MEMCPY_FROM_DEVICE_KKP_4D(dst, src)
   !< Copy array from device, KKP kind, rank 4.
   VARTYPE(KKP), intent(out), target :: dst(:,:,:,:) !< Destination memory (host memory).
   VARTYPE(KKP), intent(in),  target :: src(:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr         !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_FROM_DEVICE_KKP_4D

   subroutine DEV_MEMCPY_FROM_DEVICE_KKP_5D(dst, src)
   !< Copy array from device, KKP kind, rank 5.
   VARTYPE(KKP), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (host memory).
   VARTYPE(KKP), intent(in),  target :: src(:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr           !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_FROM_DEVICE_KKP_5D

   subroutine DEV_MEMCPY_FROM_DEVICE_KKP_6D(dst, src)
   !< Copy array from device, KKP kind, rank 6.
   VARTYPE(KKP), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (host memory).
   VARTYPE(KKP), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr             !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_FROM_DEVICE_KKP_6D

   subroutine DEV_MEMCPY_FROM_DEVICE_KKP_7D(dst, src)
   !< Copy array from device, KKP kind, rank 7.
   VARTYPE(KKP), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   VARTYPE(KKP), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr               !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_FROM_DEVICE_KKP_7D

   subroutine DEV_MEMCPY_FROM_DEVICE_KKP_2D_T(bb, tb, dst, src, buf)
   !< Copy array from device, KKP kind, rank 3, transposed.
   integer(I4P), intent(in)            :: bb(2,2)       !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)            :: tb(2,2)       !< Bounds of transposed array.
   VARTYPE(KKP), intent(inout), target :: dst(tb(1,1):,&
                                              tb(1,2):) !< Transposed destination memory (host memory).
   VARTYPE(KKP), intent(in),    target :: src(bb(1,1):,&
                                              bb(1,2):) !< Source memory (device memory).
   VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,&
                                              bb(1,2):) !< Buffer (host memory).
   integer(I4P)                        :: ierr          !< Error status.

   DEVMEMCPY_FROM_DEVICE(buf, src, bytes)
   call transpose_array(bb=bb, a=buf, tb=tb, t=dst)
   endsubroutine DEV_MEMCPY_FROM_DEVICE_KKP_2D_T

   subroutine DEV_MEMCPY_FROM_DEVICE_KKP_3D_T(bb, ij, tb, dst, src, buf)
   !< Copy array from device, KKP kind, rank 3, transposed.
   integer(I4P), intent(in)            :: bb(2,3)       !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)            :: ij(2)         !< 1-based index pair to swap.
   integer(I4P), intent(in)            :: tb(2,3)       !< Bounds of transposed array.
   VARTYPE(KKP), intent(inout), target :: dst(tb(1,1):,&
                                              tb(1,2):,&
                                              tb(1,3):) !< Transposed destination memory (host memory).
   VARTYPE(KKP), intent(in),    target :: src(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):) !< Source memory (device memory).
   VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):) !< Buffer (host memory).
   integer(I4P)                        :: ierr          !< Error status.

   DEVMEMCPY_FROM_DEVICE(buf, src, bytes)
   call transpose_array(bb=bb, ij=ij, a=buf, tb=tb, t=dst)
   endsubroutine DEV_MEMCPY_FROM_DEVICE_KKP_3D_T

   subroutine DEV_MEMCPY_FROM_DEVICE_KKP_4D_T(bb, ij, tb, dst, src, buf)
   !< Copy array from device, KKP kind, rank 4, transposed.
   integer(I4P), intent(in)            :: bb(2,4)       !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)            :: ij(2)         !< 1-based index pair to swap.
   integer(I4P), intent(in)            :: tb(2,4)       !< Bounds of transposed array.
   VARTYPE(KKP), intent(inout), target :: dst(tb(1,1):,&
                                              tb(1,2):,&
                                              tb(1,3):,&
                                              tb(1,4):) !< Transposed destination memory (host memory).
   VARTYPE(KKP), intent(in),    target :: src(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):) !< Source memory (device memory).
   VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):) !< Buffer (host memory).
   integer(I4P)                        :: ierr          !< Error status.

   DEVMEMCPY_FROM_DEVICE(buf, src, bytes)
   call transpose_array(bb=bb, ij=ij, a=buf, tb=tb, t=dst)
   endsubroutine DEV_MEMCPY_FROM_DEVICE_KKP_4D_T

   subroutine DEV_MEMCPY_FROM_DEVICE_KKP_5D_T(bb, ij, tb, dst, src, buf)
   !< Copy array from device, KKP kind, rank 5, transposed.
   integer(I4P), intent(in)            :: bb(2,5)       !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)            :: ij(2)         !< 1-based index pair to swap.
   integer(I4P), intent(in)            :: tb(2,5)       !< Bounds of transposed array.
   VARTYPE(KKP), intent(inout), target :: dst(tb(1,1):,&
                                              tb(1,2):,&
                                              tb(1,3):,&
                                              tb(1,4):,&
                                              tb(1,5):) !< Transposed destination memory (host memory).
   VARTYPE(KKP), intent(in),    target :: src(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):,&
                                              bb(1,5):) !< Source memory (device memory).
   VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):,&
                                              bb(1,5):) !< Buffer (host memory).
   integer(I4P)                        :: ierr          !< Error status.

   DEVMEMCPY_FROM_DEVICE(buf, src, bytes)
   call transpose_array(bb=bb, ij=ij, a=buf, tb=tb, t=dst)
   endsubroutine DEV_MEMCPY_FROM_DEVICE_KKP_5D_T

   subroutine DEV_MEMCPY_FROM_DEVICE_KKP_6D_T(bb, ij, tb, dst, src, buf)
   !< Copy array from device, KKP kind, rank 6, transposed.
   integer(I4P), intent(in)            :: bb(2,6)       !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)            :: ij(2)         !< 1-based index pair to swap.
   integer(I4P), intent(in)            :: tb(2,6)       !< Bounds of transposed array.
   VARTYPE(KKP), intent(inout), target :: dst(tb(1,1):,&
                                              tb(1,2):,&
                                              tb(1,3):,&
                                              tb(1,4):,&
                                              tb(1,5):,&
                                              tb(1,6):) !< Transposed destination memory (host memory).
   VARTYPE(KKP), intent(in),    target :: src(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):,&
                                              bb(1,5):,&
                                              bb(1,6):) !< Source memory (device memory).
   VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):,&
                                              bb(1,5):,&
                                              bb(1,6):) !< Buffer (host memory).
   integer(I4P)                        :: ierr          !< Error status.

   DEVMEMCPY_FROM_DEVICE(buf, src, bytes)
   call transpose_array(bb=bb, ij=ij, a=buf, tb=tb, t=dst)
   endsubroutine DEV_MEMCPY_FROM_DEVICE_KKP_6D_T

   subroutine DEV_MEMCPY_FROM_DEVICE_KKP_7D_T(bb, ij, tb, dst, src, buf)
   !< Copy array from device, KKP kind, rank 7, transposed.
   integer(I4P), intent(in)            :: bb(2,7)       !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)            :: ij(2)         !< 1-based index pair to swap.
   integer(I4P), intent(in)            :: tb(2,7)       !< Bounds of transposed array.
   VARTYPE(KKP), intent(inout), target :: dst(tb(1,1):,&
                                              tb(1,2):,&
                                              tb(1,3):,&
                                              tb(1,4):,&
                                              tb(1,5):,&
                                              tb(1,6):,&
                                              tb(1,7):) !< Transposed destination memory (host memory).
   VARTYPE(KKP), intent(in),    target :: src(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):,&
                                              bb(1,5):,&
                                              bb(1,6):,&
                                              bb(1,7):) !< Source memory (device memory).
   VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):,&
                                              bb(1,5):,&
                                              bb(1,6):,&
                                              bb(1,7):) !< Buffer (host memory).
   integer(I4P)                        :: ierr          !< Error status.

   DEVMEMCPY_FROM_DEVICE(buf, src, bytes)
   call transpose_array(bb=bb, ij=ij, a=buf, tb=tb, t=dst)
   endsubroutine DEV_MEMCPY_FROM_DEVICE_KKP_7D_T

   ! dev_memcpy_to_device
   subroutine DEV_MEMCPY_TO_DEVICE_KKP_1D(dst, src)
   !< Copy array to device, KKP kind, rank 1.
   VARTYPE(KKP), intent(out), target :: dst(:) !< Destination memory (device memory).
   VARTYPE(KKP), intent(in),  target :: src(:) !< Source memory (host memory).
   integer(I4P)                      :: ierr   !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_TO_DEVICE_KKP_1D

   subroutine DEV_MEMCPY_TO_DEVICE_KKP_2D(dst, src)
   !< Copy array to device, KKP kind, rank 2.
   VARTYPE(KKP), intent(out), target :: dst(:,:) !< Destination memory (device memory).
   VARTYPE(KKP), intent(in),  target :: src(:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr     !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_TO_DEVICE_KKP_2D

   subroutine DEV_MEMCPY_TO_DEVICE_KKP_3D(dst, src)
   !< Copy array to device, KKP kind, rank 3.
   VARTYPE(KKP), intent(out), target :: dst(:,:,:) !< Destination memory (device memory).
   VARTYPE(KKP), intent(in),  target :: src(:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr       !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_TO_DEVICE_KKP_3D

   subroutine DEV_MEMCPY_TO_DEVICE_KKP_4D(dst, src)
   !< Copy array to device, KKP kind, rank 4.
   VARTYPE(KKP), intent(out), target :: dst(:,:,:,:) !< Destination memory (device memory).
   VARTYPE(KKP), intent(in),  target :: src(:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr         !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_TO_DEVICE_KKP_4D

   subroutine DEV_MEMCPY_TO_DEVICE_KKP_5D(dst, src)
   !< Copy array to device, KKP kind, rank 5.
   VARTYPE(KKP), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (device memory).
   VARTYPE(KKP), intent(in),  target :: src(:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr           !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_TO_DEVICE_KKP_5D

   subroutine DEV_MEMCPY_TO_DEVICE_KKP_6D(dst, src)
   !< Copy array to device, KKP kind, rank 6.
   VARTYPE(KKP), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (device memory).
   VARTYPE(KKP), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr             !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_TO_DEVICE_KKP_6D

   subroutine DEV_MEMCPY_TO_DEVICE_KKP_7D(dst, src)
   !< Copy array to device, KKP kind, rank 7.
   VARTYPE(KKP), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   VARTYPE(KKP), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr               !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine DEV_MEMCPY_TO_DEVICE_KKP_7D

   subroutine DEV_MEMCPY_TO_DEVICE_KKP_2D_T(bb, tb, dst, src, buf)
   !< Copy array to device, KKP kind, rank 2, transposed.
   integer(I4P), intent(in)            :: bb(2,2)       !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)            :: tb(2,2)       !< Bounds of transposed array.
   VARTYPE(KKP), intent(inout), target :: dst(bb(1,1):,&
                                              bb(1,2):) !< Transposed destination memory (device memory).
   VARTYPE(KKP), intent(in),    target :: src(tb(1,1):,&
                                              tb(1,2):) !< Source memory (host memory).
   VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,&
                                              bb(1,2):) !< Buffer (host memory).
   integer(I4P)                        :: ierr          !< Error status.

   call transpose_array(bb=bb, a=src, tb=tb, t=buf)
   DEVMEMCPY_TO_DEVICE(dst, buf, bytes)
   endsubroutine DEV_MEMCPY_TO_DEVICE_KKP_2D_T

   subroutine DEV_MEMCPY_TO_DEVICE_KKP_3D_T(bb, ij, tb, dst, src, buf)
   !< Copy array to device, KKP kind, rank 3, transposed.
   integer(I4P), intent(in)            :: bb(2,3)       !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)            :: ij(2)         !< 1-based index pair to swap.
   integer(I4P), intent(in)            :: tb(2,3)       !< Bounds of transposed array.
   VARTYPE(KKP), intent(inout), target :: dst(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):) !< Transposed destination memory (device memory).
   VARTYPE(KKP), intent(in),    target :: src(tb(1,1):,&
                                              tb(1,2):,&
                                              tb(1,3):) !< Source memory (host memory).
   VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):) !< Buffer (host memory).
   integer(I4P)                        :: ierr          !< Error status.

   call transpose_array(bb=bb, ij=ij, a=src, tb=tb, t=buf)
   DEVMEMCPY_TO_DEVICE(dst, buf, bytes)
   endsubroutine DEV_MEMCPY_TO_DEVICE_KKP_3D_T 

   subroutine DEV_MEMCPY_TO_DEVICE_KKP_4D_T(bb, ij, tb, dst, src, buf)
   !< Copy array to device, KKP kind, rank 4, transposed.
   integer(I4P), intent(in)            :: bb(2,4)       !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)            :: ij(2)         !< 1-based index pair to swap.
   integer(I4P), intent(in)            :: tb(2,4)       !< Bounds of transposed array.
   VARTYPE(KKP), intent(inout), target :: dst(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):) !< Transposed destination memory (device memory).
   VARTYPE(KKP), intent(in),    target :: src(tb(1,1):,&
                                              tb(1,2):,&
                                              tb(1,3):,&
                                              tb(1,4):) !< Source memory (host memory).
   VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):) !< Buffer (host memory).
   integer(I4P)                        :: ierr          !< Error status.

   call transpose_array(bb=bb, ij=ij, a=src, tb=tb, t=buf)
   DEVMEMCPY_TO_DEVICE(dst, buf, bytes)
   endsubroutine DEV_MEMCPY_TO_DEVICE_KKP_4D_T 

   subroutine DEV_MEMCPY_TO_DEVICE_KKP_5D_T(bb, ij, tb, dst, src, buf)
   !< Copy array to device, KKP kind, rank 5, transposed.
   integer(I4P), intent(in)            :: bb(2,5)       !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)            :: ij(2)         !< 1-based index pair to swap.
   integer(I4P), intent(in)            :: tb(2,5)       !< Bounds of transposed array.
   VARTYPE(KKP), intent(inout), target :: dst(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):,&
                                              bb(1,5):) !< Transposed destination memory (device memory).
   VARTYPE(KKP), intent(in),    target :: src(tb(1,1):,&
                                              tb(1,2):,&
                                              tb(1,3):,&
                                              tb(1,4):,&
                                              tb(1,5):) !< Source memory (host memory).
   VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):,&
                                              bb(1,5):) !< Buffer (host memory).
   integer(I4P)                        :: ierr          !< Error status.

   call transpose_array(bb=bb, ij=ij, a=src, tb=tb, t=buf)
   DEVMEMCPY_TO_DEVICE(dst, buf, bytes)
   endsubroutine DEV_MEMCPY_TO_DEVICE_KKP_5D_T 

   subroutine DEV_MEMCPY_TO_DEVICE_KKP_6D_T(bb, ij, tb, dst, src, buf)
   !< Copy array to device, KKP kind, rank 6, transposed.
   integer(I4P), intent(in)            :: bb(2,6)       !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)            :: ij(2)         !< 1-based index pair to swap.
   integer(I4P), intent(in)            :: tb(2,6)       !< Bounds of transposed array.
   VARTYPE(KKP), intent(inout), target :: dst(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):,&
                                              bb(1,5):,&
                                              bb(1,6):) !< Transposed destination memory (device memory).
   VARTYPE(KKP), intent(in),    target :: src(tb(1,1):,&
                                              tb(1,2):,&
                                              tb(1,3):,&
                                              tb(1,4):,&
                                              tb(1,5):,&
                                              tb(1,6):) !< Source memory (host memory).
   VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):,&
                                              bb(1,5):,&
                                              bb(1,6):) !< Buffer (host memory).
   integer(I4P)                        :: ierr          !< Error status.

   call transpose_array(bb=bb, ij=ij, a=src, tb=tb, t=buf)
   DEVMEMCPY_TO_DEVICE(dst, buf, bytes)
   endsubroutine DEV_MEMCPY_TO_DEVICE_KKP_6D_T 

   subroutine DEV_MEMCPY_TO_DEVICE_KKP_7D_T(bb, ij, tb, dst, src, buf)
   !< Copy array to device, KKP kind, rank 7, transposed.
   integer(I4P), intent(in)            :: bb(2,7)       !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)            :: ij(2)         !< 1-based index pair to swap.
   integer(I4P), intent(in)            :: tb(2,7)       !< Bounds of transposed array.
   VARTYPE(KKP), intent(inout), target :: dst(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):,&
                                              bb(1,5):,&
                                              bb(1,6):,&
                                              bb(1,7):) !< Transposed destination memory (device memory).
   VARTYPE(KKP), intent(in),    target :: src(tb(1,1):,&
                                              tb(1,2):,&
                                              tb(1,3):,&
                                              tb(1,4):,&
                                              tb(1,5):,&
                                              tb(1,6):,&
                                              tb(1,7):) !< Source memory (host memory).
   VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,&
                                              bb(1,2):,&
                                              bb(1,3):,&
                                              bb(1,4):,&
                                              bb(1,5):,&
                                              bb(1,6):,&
                                              bb(1,7):) !< Buffer (host memory).
   integer(I4P)                        :: ierr          !< Error status.

   call transpose_array(bb=bb, ij=ij, a=src, tb=tb, t=buf)
   DEVMEMCPY_TO_DEVICE(dst, buf, bytes)
   endsubroutine DEV_MEMCPY_TO_DEVICE_KKP_7D_T 
