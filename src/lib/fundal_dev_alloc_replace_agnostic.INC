   subroutine DEV_ALLOC_REPLACE_KKP_1D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value, label)
   !< Allocate array, KKP kind, rank 1, freeing the buffer fptr_dev is associated with, if any.
   VARTYPE(KKP), intent(inout), pointer :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I4P), intent(in)             :: ubounds(1)  !< Array upper bounds.
   integer(I4P), intent(out)            :: ierr        !< Error status.
   integer(I4P), intent(in), optional   :: dev_id      !< Device ID.
   integer(I4P), intent(in), optional   :: lbounds(1)  !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional   :: init_value  !< Optional initial value.
   character(*), intent(in), optional   :: label       !< Label of the allocation (allocation registry).
   logical                              :: freed       !< The previous buffer has been freed.

   if (associated(fptr_dev)) then
      ! free on the recorded device: dev_id is the device of the new buffer, not checked against the old one
      if (registry_policy() == FUNDAL_REGISTRY_ERROR) then
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           ierr=ierr, check_dev_id=.false.)
         if (ierr /= 0) return
      else
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           check_dev_id=.false.)
      endif
      nullify(fptr_dev)
   endif
   call dev_alloc(fptr_dev=fptr_dev, ubounds=ubounds, ierr=ierr, dev_id=dev_id, lbounds=lbounds, init_value=init_value, &
                  label=label)
   endsubroutine DEV_ALLOC_REPLACE_KKP_1D

   subroutine DEV_ALLOC_REPLACE_KKP_2D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value, label)
   !< Allocate array, KKP kind, rank 2, freeing the buffer fptr_dev is associated with, if any.
   VARTYPE(KKP), intent(inout), pointer :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)             :: ubounds(2)    !< Array upper bounds.
   integer(I4P), intent(out)            :: ierr          !< Error status.
   integer(I4P), intent(in), optional   :: dev_id        !< Device ID.
   integer(I4P), intent(in), optional   :: lbounds(2)    !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional   :: init_value    !< Optional initial value.
   character(*), intent(in), optional   :: label         !< Label of the allocation (allocation registry).
   logical                              :: freed         !< The previous buffer has been freed.

   if (associated(fptr_dev)) then
      ! free on the recorded device: dev_id is the device of the new buffer, not checked against the old one
      if (registry_policy() == FUNDAL_REGISTRY_ERROR) then
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           ierr=ierr, check_dev_id=.false.)
         if (ierr /= 0) return
      else
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           check_dev_id=.false.)
      endif
      nullify(fptr_dev)
   endif
   call dev_alloc(fptr_dev=fptr_dev, ubounds=ubounds, ierr=ierr, dev_id=dev_id, lbounds=lbounds, init_value=init_value, &
                  label=label)
   endsubroutine DEV_ALLOC_REPLACE_KKP_2D

   subroutine DEV_ALLOC_REPLACE_KKP_3D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value, label)
   !< Allocate array, KKP kind, rank 3, freeing the buffer fptr_dev is associated with, if any.
   VARTYPE(KKP), intent(inout), pointer :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)             :: ubounds(3)      !< Array upper bounds.
   integer(I4P), intent(out)            :: ierr            !< Error status.
   integer(I4P), intent(in), optional   :: dev_id          !< Device ID.
   integer(I4P), intent(in), optional   :: lbounds(3)      !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional   :: init_value      !< Optional initial value.
   character(*), intent(in), optional   :: label           !< Label of the allocation (allocation registry).
   logical                              :: freed           !< The previous buffer has been freed.

   if (associated(fptr_dev)) then
      ! free on the recorded device: dev_id is the device of the new buffer, not checked against the old one
      if (registry_policy() == FUNDAL_REGISTRY_ERROR) then
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           ierr=ierr, check_dev_id=.false.)
         if (ierr /= 0) return
      else
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           check_dev_id=.false.)
      endif
      nullify(fptr_dev)
   endif
   call dev_alloc(fptr_dev=fptr_dev, ubounds=ubounds, ierr=ierr, dev_id=dev_id, lbounds=lbounds, init_value=init_value, &
                  label=label)
   endsubroutine DEV_ALLOC_REPLACE_KKP_3D

   subroutine DEV_ALLOC_REPLACE_KKP_4D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value, label)
   !< Allocate array, KKP kind, rank 4, freeing the buffer fptr_dev is associated with, if any.
   VARTYPE(KKP), intent(inout), pointer :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)             :: ubounds(4)        !< Array upper bounds.
   integer(I4P), intent(out)            :: ierr              !< Error status.
   integer(I4P), intent(in), optional   :: dev_id            !< Device ID.
   integer(I4P), intent(in), optional   :: lbounds(4)        !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional   :: init_value        !< Optional initial value.
   character(*), intent(in), optional   :: label             !< Label of the allocation (allocation registry).
   logical                              :: freed             !< The previous buffer has been freed.

   if (associated(fptr_dev)) then
      ! free on the recorded device: dev_id is the device of the new buffer, not checked against the old one
      if (registry_policy() == FUNDAL_REGISTRY_ERROR) then
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           ierr=ierr, check_dev_id=.false.)
         if (ierr /= 0) return
      else
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           check_dev_id=.false.)
      endif
      nullify(fptr_dev)
   endif
   call dev_alloc(fptr_dev=fptr_dev, ubounds=ubounds, ierr=ierr, dev_id=dev_id, lbounds=lbounds, init_value=init_value, &
                  label=label)
   endsubroutine DEV_ALLOC_REPLACE_KKP_4D

   subroutine DEV_ALLOC_REPLACE_KKP_5D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value, label)
   !< Allocate array, KKP kind, rank 5, freeing the buffer fptr_dev is associated with, if any.
   VARTYPE(KKP), intent(inout), pointer :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)             :: ubounds(5)          !< Array upper bounds.
   integer(I4P), intent(out)            :: ierr                !< Error status.
   integer(I4P), intent(in), optional   :: dev_id              !< Device ID.
   integer(I4P), intent(in), optional   :: lbounds(5)          !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional   :: init_value          !< Optional initial value.
   character(*), intent(in), optional   :: label               !< Label of the allocation (allocation registry).
   logical                              :: freed               !< The previous buffer has been freed.

   if (associated(fptr_dev)) then
      ! free on the recorded device: dev_id is the device of the new buffer, not checked against the old one
      if (registry_policy() == FUNDAL_REGISTRY_ERROR) then
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           ierr=ierr, check_dev_id=.false.)
         if (ierr /= 0) return
      else
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           check_dev_id=.false.)
      endif
      nullify(fptr_dev)
   endif
   call dev_alloc(fptr_dev=fptr_dev, ubounds=ubounds, ierr=ierr, dev_id=dev_id, lbounds=lbounds, init_value=init_value, &
                  label=label)
   endsubroutine DEV_ALLOC_REPLACE_KKP_5D

   subroutine DEV_ALLOC_REPLACE_KKP_6D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value, label)
   !< Allocate array, KKP kind, rank 6, freeing the buffer fptr_dev is associated with, if any.
   VARTYPE(KKP), intent(inout), pointer :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)             :: ubounds(6)            !< Array upper bounds.
   integer(I4P), intent(out)            :: ierr                  !< Error status.
   integer(I4P), intent(in), optional   :: dev_id                !< Device ID.
   integer(I4P), intent(in), optional   :: lbounds(6)            !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional   :: init_value            !< Optional initial value.
   character(*), intent(in), optional   :: label                 !< Label of the allocation (allocation registry).
   logical                              :: freed                 !< The previous buffer has been freed.

   if (associated(fptr_dev)) then
      ! free on the recorded device: dev_id is the device of the new buffer, not checked against the old one
      if (registry_policy() == FUNDAL_REGISTRY_ERROR) then
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           ierr=ierr, check_dev_id=.false.)
         if (ierr /= 0) return
      else
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           check_dev_id=.false.)
      endif
      nullify(fptr_dev)
   endif
   call dev_alloc(fptr_dev=fptr_dev, ubounds=ubounds, ierr=ierr, dev_id=dev_id, lbounds=lbounds, init_value=init_value, &
                  label=label)
   endsubroutine DEV_ALLOC_REPLACE_KKP_6D

   subroutine DEV_ALLOC_REPLACE_KKP_7D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value, label)
   !< Allocate array, KKP kind, rank 7, freeing the buffer fptr_dev is associated with, if any.
   VARTYPE(KKP), intent(inout), pointer :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)             :: ubounds(7)              !< Array upper bounds.
   integer(I4P), intent(out)            :: ierr                    !< Error status.
   integer(I4P), intent(in), optional   :: dev_id                  !< Device ID.
   integer(I4P), intent(in), optional   :: lbounds(7)              !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional   :: init_value              !< Optional initial value.
   character(*), intent(in), optional   :: label                   !< Label of the allocation (allocation registry).
   logical                              :: freed                   !< The previous buffer has been freed.

   if (associated(fptr_dev)) then
      ! free on the recorded device: dev_id is the device of the new buffer, not checked against the old one
      if (registry_policy() == FUNDAL_REGISTRY_ERROR) then
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           ierr=ierr, check_dev_id=.false.)
         if (ierr /= 0) return
      else
         call free_checked(cptr=c_loc(fptr_dev), contiguous=is_contiguous(fptr_dev), freed=freed, dev_id=dev_id, &
                           check_dev_id=.false.)
      endif
      nullify(fptr_dev)
   endif
   call dev_alloc(fptr_dev=fptr_dev, ubounds=ubounds, ierr=ierr, dev_id=dev_id, lbounds=lbounds, init_value=init_value, &
                  label=label)
   endsubroutine DEV_ALLOC_REPLACE_KKP_7D
