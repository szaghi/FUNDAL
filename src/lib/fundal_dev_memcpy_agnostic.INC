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
