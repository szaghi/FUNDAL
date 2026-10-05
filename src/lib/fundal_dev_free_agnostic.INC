   subroutine DEV_FREE_KKP_1D(fptr, dev_id, ierr)
   !< Free array from device, KKP kind, rank 1.
   !< No-op if fptr is not associated; fptr is nullified on return. The buffer is freed on the device where it lives
   !< (allocation registry); dev_id is only checked against it. See free_checked for misuse handling.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id  !< Device ID.
   integer(I4P), intent(out), optional  :: ierr    !< Error status (FUNDAL_ERR_NOT_REGISTERED/_DEV_ID_MISMATCH).
   logical                              :: freed   !< The buffer has been freed.

   if (present(ierr)) ierr = 0_I4P
   if (.not.associated(fptr)) return
   call free_checked(cptr=c_loc(fptr), contiguous=is_contiguous(fptr), freed=freed, dev_id=dev_id, ierr=ierr)
   if (freed) nullify(fptr)
   endsubroutine DEV_FREE_KKP_1D

   subroutine DEV_FREE_KKP_2D(fptr, dev_id, ierr)
   !< Free array from device, KKP kind, rank 2.
   !< No-op if fptr is not associated; fptr is nullified on return. The buffer is freed on the device where it lives
   !< (allocation registry); dev_id is only checked against it. See free_checked for misuse handling.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id    !< Device ID.
   integer(I4P), intent(out), optional  :: ierr      !< Error status (FUNDAL_ERR_NOT_REGISTERED/_DEV_ID_MISMATCH).
   logical                              :: freed     !< The buffer has been freed.

   if (present(ierr)) ierr = 0_I4P
   if (.not.associated(fptr)) return
   call free_checked(cptr=c_loc(fptr), contiguous=is_contiguous(fptr), freed=freed, dev_id=dev_id, ierr=ierr)
   if (freed) nullify(fptr)
   endsubroutine DEV_FREE_KKP_2D

   subroutine DEV_FREE_KKP_3D(fptr, dev_id, ierr)
   !< Free array from device, KKP kind, rank 3.
   !< No-op if fptr is not associated; fptr is nullified on return. The buffer is freed on the device where it lives
   !< (allocation registry); dev_id is only checked against it. See free_checked for misuse handling.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id      !< Device ID.
   integer(I4P), intent(out), optional  :: ierr        !< Error status (FUNDAL_ERR_NOT_REGISTERED/_DEV_ID_MISMATCH).
   logical                              :: freed       !< The buffer has been freed.

   if (present(ierr)) ierr = 0_I4P
   if (.not.associated(fptr)) return
   call free_checked(cptr=c_loc(fptr), contiguous=is_contiguous(fptr), freed=freed, dev_id=dev_id, ierr=ierr)
   if (freed) nullify(fptr)
   endsubroutine DEV_FREE_KKP_3D

   subroutine DEV_FREE_KKP_4D(fptr, dev_id, ierr)
   !< Free array from device, KKP kind, rank 4.
   !< No-op if fptr is not associated; fptr is nullified on return. The buffer is freed on the device where it lives
   !< (allocation registry); dev_id is only checked against it. See free_checked for misuse handling.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id        !< Device ID.
   integer(I4P), intent(out), optional  :: ierr          !< Error status (FUNDAL_ERR_NOT_REGISTERED/_DEV_ID_MISMATCH).
   logical                              :: freed         !< The buffer has been freed.

   if (present(ierr)) ierr = 0_I4P
   if (.not.associated(fptr)) return
   call free_checked(cptr=c_loc(fptr), contiguous=is_contiguous(fptr), freed=freed, dev_id=dev_id, ierr=ierr)
   if (freed) nullify(fptr)
   endsubroutine DEV_FREE_KKP_4D

   subroutine DEV_FREE_KKP_5D(fptr, dev_id, ierr)
   !< Free array from device, KKP kind, rank 5.
   !< No-op if fptr is not associated; fptr is nullified on return. The buffer is freed on the device where it lives
   !< (allocation registry); dev_id is only checked against it. See free_checked for misuse handling.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id          !< Device ID.
   integer(I4P), intent(out), optional  :: ierr            !< Error status (FUNDAL_ERR_NOT_REGISTERED/_DEV_ID_MISMATCH).
   logical                              :: freed           !< The buffer has been freed.

   if (present(ierr)) ierr = 0_I4P
   if (.not.associated(fptr)) return
   call free_checked(cptr=c_loc(fptr), contiguous=is_contiguous(fptr), freed=freed, dev_id=dev_id, ierr=ierr)
   if (freed) nullify(fptr)
   endsubroutine DEV_FREE_KKP_5D

   subroutine DEV_FREE_KKP_6D(fptr, dev_id, ierr)
   !< Free array from device, KKP kind, rank 6.
   !< No-op if fptr is not associated; fptr is nullified on return. The buffer is freed on the device where it lives
   !< (allocation registry); dev_id is only checked against it. See free_checked for misuse handling.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id            !< Device ID.
   integer(I4P), intent(out), optional  :: ierr              !< Error status (FUNDAL_ERR_NOT_REGISTERED/_DEV_ID_MISMATCH).
   logical                              :: freed             !< The buffer has been freed.

   if (present(ierr)) ierr = 0_I4P
   if (.not.associated(fptr)) return
   call free_checked(cptr=c_loc(fptr), contiguous=is_contiguous(fptr), freed=freed, dev_id=dev_id, ierr=ierr)
   if (freed) nullify(fptr)
   endsubroutine DEV_FREE_KKP_6D

   subroutine DEV_FREE_KKP_7D(fptr, dev_id, ierr)
   !< Free array from device, KKP kind, rank 7.
   !< No-op if fptr is not associated; fptr is nullified on return. The buffer is freed on the device where it lives
   !< (allocation registry); dev_id is only checked against it. See free_checked for misuse handling.
   VARTYPE(KKP), intent(inout), pointer :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id              !< Device ID.
   integer(I4P), intent(out), optional  :: ierr                !< Error status (FUNDAL_ERR_NOT_REGISTERED/_DEV_ID_MISMATCH).
   logical                              :: freed               !< The buffer has been freed.

   if (present(ierr)) ierr = 0_I4P
   if (.not.associated(fptr)) return
   call free_checked(cptr=c_loc(fptr), contiguous=is_contiguous(fptr), freed=freed, dev_id=dev_id, ierr=ierr)
   if (freed) nullify(fptr)
   endsubroutine DEV_FREE_KKP_7D
