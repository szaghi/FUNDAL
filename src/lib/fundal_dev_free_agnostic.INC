   subroutine DEV_FREE_KKP_1D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 1.
   !< No-op if fptr is not associated; fptr is nullified on return.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id  !< Device ID.
   integer(I4P)                         :: dev_id_ !< Device ID, local var.

   if (.not.associated(fptr)) return
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   !$omp atomic update
   dev_allocs_live = dev_allocs_live - 1_I8P
   !$omp atomic update
   dev_bytes_live = dev_bytes_live - size(fptr, kind=I8P) * (storage_size(fptr, kind=I8P) / 8_I8P)
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_1D

   subroutine DEV_FREE_KKP_2D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 2.
   !< No-op if fptr is not associated; fptr is nullified on return.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id    !< Device ID.
   integer(I4P)                         :: dev_id_   !< Device ID, local var.

   if (.not.associated(fptr)) return
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   !$omp atomic update
   dev_allocs_live = dev_allocs_live - 1_I8P
   !$omp atomic update
   dev_bytes_live = dev_bytes_live - size(fptr, kind=I8P) * (storage_size(fptr, kind=I8P) / 8_I8P)
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_2D

   subroutine DEV_FREE_KKP_3D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 3.
   !< No-op if fptr is not associated; fptr is nullified on return.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id      !< Device ID.
   integer(I4P)                         :: dev_id_     !< Device ID, local var.

   if (.not.associated(fptr)) return
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   !$omp atomic update
   dev_allocs_live = dev_allocs_live - 1_I8P
   !$omp atomic update
   dev_bytes_live = dev_bytes_live - size(fptr, kind=I8P) * (storage_size(fptr, kind=I8P) / 8_I8P)
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_3D

   subroutine DEV_FREE_KKP_4D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 4.
   !< No-op if fptr is not associated; fptr is nullified on return.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id        !< Device ID.
   integer(I4P)                         :: dev_id_       !< Device ID, local var.

   if (.not.associated(fptr)) return
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   !$omp atomic update
   dev_allocs_live = dev_allocs_live - 1_I8P
   !$omp atomic update
   dev_bytes_live = dev_bytes_live - size(fptr, kind=I8P) * (storage_size(fptr, kind=I8P) / 8_I8P)
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_4D

   subroutine DEV_FREE_KKP_5D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 5.
   !< No-op if fptr is not associated; fptr is nullified on return.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id          !< Device ID.
   integer(I4P)                         :: dev_id_         !< Device ID, local var.

   if (.not.associated(fptr)) return
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   !$omp atomic update
   dev_allocs_live = dev_allocs_live - 1_I8P
   !$omp atomic update
   dev_bytes_live = dev_bytes_live - size(fptr, kind=I8P) * (storage_size(fptr, kind=I8P) / 8_I8P)
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_5D

   subroutine DEV_FREE_KKP_6D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 6.
   !< No-op if fptr is not associated; fptr is nullified on return.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id            !< Device ID.
   integer(I4P)                         :: dev_id_           !< Device ID, local var.

   if (.not.associated(fptr)) return
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   !$omp atomic update
   dev_allocs_live = dev_allocs_live - 1_I8P
   !$omp atomic update
   dev_bytes_live = dev_bytes_live - size(fptr, kind=I8P) * (storage_size(fptr, kind=I8P) / 8_I8P)
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_6D

   subroutine DEV_FREE_KKP_7D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 7.
   !< No-op if fptr is not associated; fptr is nullified on return.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id              !< Device ID.
   integer(I4P)                         :: dev_id_             !< Device ID, local var.

   if (.not.associated(fptr)) return
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   !$omp atomic update
   dev_allocs_live = dev_allocs_live - 1_I8P
   !$omp atomic update
   dev_bytes_live = dev_bytes_live - size(fptr, kind=I8P) * (storage_size(fptr, kind=I8P) / 8_I8P)
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_7D
