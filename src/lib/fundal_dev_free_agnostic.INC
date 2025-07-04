   subroutine DEV_FREE_KKP_1D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 1.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id  !< Device ID.
   integer(I4P)                         :: dev_id_ !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_1D

   subroutine DEV_FREE_KKP_2D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 2.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id    !< Device ID.
   integer(I4P)                         :: dev_id_   !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_2D

   subroutine DEV_FREE_KKP_3D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 3.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id      !< Device ID.
   integer(I4P)                         :: dev_id_     !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_3D

   subroutine DEV_FREE_KKP_4D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 4.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id        !< Device ID.
   integer(I4P)                         :: dev_id_       !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_4D

   subroutine DEV_FREE_KKP_5D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 5.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id          !< Device ID.
   integer(I4P)                         :: dev_id_         !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_5D

   subroutine DEV_FREE_KKP_6D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 6.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id            !< Device ID.
   integer(I4P)                         :: dev_id_           !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_6D

   subroutine DEV_FREE_KKP_7D(fptr, dev_id)
   !< Free array from device, KKP kind, rank 7.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id              !< Device ID.
   integer(I4P)                         :: dev_id_             !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine DEV_FREE_KKP_7D
