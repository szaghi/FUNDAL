   subroutine DEV_ALLOC_KKP_1D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, KKP kind, rank 1.
   VARTYPE(KKP), intent(out), pointer :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(1)  !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr        !< Error status.
   integer(I4P), intent(in), optional :: dev_id      !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(1)  !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional :: init_value  !< Optional initial value.
   VARTYPE(KKP), pointer              :: fptr(:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev    !< C pointer.
   integer(I8P)                       :: sizes(1)    !< Sizes.
   integer(I4P)                       :: lbounds_(1) !< Array lower bounds, local var.
   integer(I4P)                       :: dev_id_     !< Device ID, local variable.
   integer(c_size_t)                  :: bytes       !< Bytes of memory allocated.
   integer(I4P)                       :: i1          !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = DEVALLOC(bytes, int(dev_id_, c_int))
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(1) DEVICEVAR(fptr_dev)
         !$omp OMPLOOP collapse(1) DEVICEPTR(fptr_dev)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1) = init_value
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine DEV_ALLOC_KKP_1D

   subroutine DEV_ALLOC_KKP_2D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, KKP kind, rank 2.
   VARTYPE(KKP), intent(out), pointer :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(2)    !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr          !< Error status.
   integer(I4P), intent(in), optional :: dev_id        !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(2)    !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional :: init_value    !< Optional initial value.
   VARTYPE(KKP), pointer              :: fptr(:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev      !< C pointer.
   integer(I8P)                       :: sizes(2)      !< Sizes.
   integer(I4P)                       :: lbounds_(2)   !< Array lower bounds, local var.
   integer(I4P)                       :: dev_id_       !< Device ID, local variable.
   integer(c_size_t)                  :: bytes         !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2         !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = DEVALLOC(bytes, int(dev_id_, c_int))
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(2) DEVICEVAR(fptr_dev)
         !$omp OMPLOOP collapse(2) DEVICEPTR(fptr_dev)
         do i2=lbounds_(2), ubounds(2)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1,i2) = init_value
         enddo
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine DEV_ALLOC_KKP_2D

   subroutine DEV_ALLOC_KKP_3D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, KKP kind, rank 3.
   VARTYPE(KKP), intent(out), pointer :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(3)      !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr            !< Error status.
   integer(I4P), intent(in), optional :: dev_id          !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(3)      !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional :: init_value      !< Optional initial value.
   VARTYPE(KKP), pointer              :: fptr(:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev        !< C pointer.
   integer(I8P)                       :: sizes(3)        !< Sizes.
   integer(I4P)                       :: lbounds_(3)     !< Array lower bounds, local var.
   integer(I4P)                       :: dev_id_         !< Device ID, local variable.
   integer(c_size_t)                  :: bytes           !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3        !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = DEVALLOC(bytes, int(dev_id_, c_int))
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(3) DEVICEVAR(fptr_dev)
         !$omp OMPLOOP collapse(3) DEVICEPTR(fptr_dev)
         do i3=lbounds_(3), ubounds(3)
         do i2=lbounds_(2), ubounds(2)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1,i2,i3) = init_value
         enddo
         enddo
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine DEV_ALLOC_KKP_3D

   subroutine DEV_ALLOC_KKP_4D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, KKP kind, rank 4.
   VARTYPE(KKP), intent(out), pointer :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(4)        !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr              !< Error status.
   integer(I4P), intent(in), optional :: dev_id            !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(4)        !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional :: init_value        !< Optional initial value.
   VARTYPE(KKP), pointer              :: fptr(:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev          !< C pointer.
   integer(I8P)                       :: sizes(4)          !< Sizes.
   integer(I4P)                       :: lbounds_(4)       !< Array lower bounds, local var.
   integer(I4P)                       :: dev_id_           !< Device ID, local variable.
   integer(c_size_t)                  :: bytes             !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4       !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = DEVALLOC(bytes, int(dev_id_, c_int))
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(4) DEVICEVAR(fptr_dev)
         !$omp OMPLOOP collapse(4) DEVICEPTR(fptr_dev)
         do i4=lbounds_(4), ubounds(4)
         do i3=lbounds_(3), ubounds(3)
         do i2=lbounds_(2), ubounds(2)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1,i2,i3,i4) = init_value
         enddo
         enddo
         enddo
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine DEV_ALLOC_KKP_4D

   subroutine DEV_ALLOC_KKP_5D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, KKP kind, rank 5.
   VARTYPE(KKP), intent(out), pointer :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(5)          !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                !< Error status.
   integer(I4P), intent(in), optional :: dev_id              !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(5)          !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional :: init_value          !< Optional initial value.
   VARTYPE(KKP), pointer              :: fptr(:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev            !< C pointer.
   integer(I8P)                       :: sizes(5)            !< Sizes.
   integer(I4P)                       :: lbounds_(5)         !< Array lower bounds, local var.
   integer(I4P)                       :: dev_id_             !< Device ID, local variable.
   integer(c_size_t)                  :: bytes               !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5      !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = DEVALLOC(bytes, int(dev_id_, c_int))
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(5) DEVICEVAR(fptr_dev)
         !$omp OMPLOOP collapse(5) DEVICEPTR(fptr_dev)
         do i5=lbounds_(5), ubounds(5)
         do i4=lbounds_(4), ubounds(4)
         do i3=lbounds_(3), ubounds(3)
         do i2=lbounds_(2), ubounds(2)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1,i2,i3,i4,i5) = init_value
         enddo
         enddo
         enddo
         enddo
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine DEV_ALLOC_KKP_5D

   subroutine DEV_ALLOC_KKP_6D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, KKP kind, rank 6.
   VARTYPE(KKP), intent(out), pointer :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(6)            !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                  !< Error status.
   integer(I4P), intent(in), optional :: dev_id                !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(6)            !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional :: init_value            !< Optional initial value.
   VARTYPE(KKP), pointer              :: fptr(:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev              !< C pointer.
   integer(I8P)                       :: sizes(6)              !< Sizes.
   integer(I4P)                       :: lbounds_(6)           !< Array lower bounds, local var.
   integer(I4P)                       :: dev_id_               !< Device ID, local variable.
   integer(c_size_t)                  :: bytes                 !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6     !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = DEVALLOC(bytes, int(dev_id_, c_int))
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):,lbounds_(6):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(6) DEVICEVAR(fptr_dev)
         !$omp OMPLOOP collapse(6) DEVICEPTR(fptr_dev)
         do i6=lbounds_(6), ubounds(6)
         do i5=lbounds_(5), ubounds(5)
         do i4=lbounds_(4), ubounds(4)
         do i3=lbounds_(3), ubounds(3)
         do i2=lbounds_(2), ubounds(2)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1,i2,i3,i4,i5,i6) = init_value
         enddo
         enddo
         enddo
         enddo
         enddo
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine DEV_ALLOC_KKP_6D

   subroutine DEV_ALLOC_KKP_7D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, KKP kind, rank 7.
   VARTYPE(KKP), intent(out), pointer :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(7)              !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                    !< Error status.
   integer(I4P), intent(in), optional :: dev_id                  !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(7)              !< Array lower bounds, 1 if not passed.
   VARTYPE(KKP), intent(in), optional :: init_value              !< Optional initial value.
   VARTYPE(KKP), pointer              :: fptr(:,:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev                !< C pointer.
   integer(I8P)                       :: sizes(7)                !< Sizes.
   integer(I4P)                       :: lbounds_(7)             !< Array lower bounds, local var.
   integer(I4P)                       :: dev_id_                 !< Device ID, local variable.
   integer(c_size_t)                  :: bytes                   !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6,i7    !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = DEVALLOC(bytes, int(dev_id_, c_int))
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):,lbounds_(6):,lbounds_(7):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(7) DEVICEVAR(fptr_dev)
         !$omp OMPLOOP collapse(7) DEVICEPTR(fptr_dev)
         do i7=lbounds_(7), ubounds(7)
         do i6=lbounds_(6), ubounds(6)
         do i5=lbounds_(5), ubounds(5)
         do i4=lbounds_(4), ubounds(4)
         do i3=lbounds_(3), ubounds(3)
         do i2=lbounds_(2), ubounds(2)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1,i2,i3,i4,i5,i6,i7) = init_value
         enddo
         enddo
         enddo
         enddo
         enddo
         enddo
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine DEV_ALLOC_KKP_7D
