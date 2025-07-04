   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_1D(dst, src)
   !< Assign array, KKP kind, rank 1.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:) !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_1D

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_2D(dst, src, transposed)
   !< Assign array, KKP kind, rank 2.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:)    !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:,:)    !< Source memory.
   logical,      intent(in), optional       :: transposed  !< Assign trasposed src.
   logical                                  :: transposed_ !< Assign trasposed src, local var.
   VARTYPE(KKP), allocatable                :: dstt(:,:)   !< Destination array transposed.

   if (allocated(dst)) deallocate(dst)
   transposed_ = .false. ; if (present(transposed)) transposed_ = transposed
   if (transposed_) then
      allocate(dstt(lbound(src,dim=1):ubound(src,dim=1), &
                    lbound(src,dim=2):ubound(src,dim=2)))
      call dev_memcpy_from_device(dst=dstt, src=src)
      call transpose_array(b1=[lbound(dstt,dim=1),ubound(dstt,dim=1)], &
                           b2=[lbound(dstt,dim=2),ubound(dstt,dim=2)], a=dstt, t=dst)
   else
      allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                   lbound(src,dim=2):ubound(src,dim=2)))
      call dev_memcpy_from_device(dst=dst, src=src)
   endif
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_2D

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_3D(dst, src, transposed)
   !< Assign array, KKP kind, rank 3.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:)  !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:)  !< Source memory.
   logical,      intent(in), optional       :: transposed  !< Assign trasposed src.
   logical                                  :: transposed_ !< Assign trasposed src, local var.
   VARTYPE(KKP), allocatable                :: dstt(:,:,:) !< Destination array transposed.

   if (allocated(dst)) deallocate(dst)
   transposed_ = .false. ; if (present(transposed)) transposed_ = transposed
   if (transposed_) then
      allocate(dstt(lbound(src,dim=1):ubound(src,dim=1), &
                    lbound(src,dim=2):ubound(src,dim=2), &
                    lbound(src,dim=3):ubound(src,dim=3)))
      call dev_memcpy_from_device(dst=dstt, src=src)
      call transpose_array(b1=[lbound(dstt,dim=1),ubound(dstt,dim=1)], &
                           b2=[lbound(dstt,dim=2),ubound(dstt,dim=2)], &
                           b3=[lbound(dstt,dim=3),ubound(dstt,dim=3)], &
                           a=dstt, t=dst)
   else
      allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                   lbound(src,dim=2):ubound(src,dim=2), &
                   lbound(src,dim=3):ubound(src,dim=3)))
      call dev_memcpy_from_device(dst=dst, src=src)
   endif
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_3D

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_4D(dst, src, transposed)
   !< Assign array, KKP kind, rank 4.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:,:)  !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:,:)  !< Source memory.
   logical,      intent(in), optional       :: transposed    !< Assign trasposed src.
   logical                                  :: transposed_   !< Assign trasposed src, local var.
   VARTYPE(KKP), allocatable                :: dstt(:,:,:,:) !< Destination array transposed.

   if (allocated(dst)) deallocate(dst)
   transposed_ = .false. ; if (present(transposed)) transposed_ = transposed
   if (transposed_) then
      allocate(dstt(lbound(src,dim=1):ubound(src,dim=1), &
                    lbound(src,dim=2):ubound(src,dim=2), &
                    lbound(src,dim=3):ubound(src,dim=3), &
                    lbound(src,dim=4):ubound(src,dim=4)))
      call dev_memcpy_from_device(dst=dstt, src=src)
      call transpose_array(b1=[lbound(dstt,dim=1),ubound(dstt,dim=1)], &
                           b2=[lbound(dstt,dim=2),ubound(dstt,dim=2)], &
                           b3=[lbound(dstt,dim=3),ubound(dstt,dim=3)], &
                           b4=[lbound(dstt,dim=4),ubound(dstt,dim=4)], &
                           a=dstt, t=dst)
   else
      allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                   lbound(src,dim=2):ubound(src,dim=2), &
                   lbound(src,dim=3):ubound(src,dim=3), &
                   lbound(src,dim=4):ubound(src,dim=4)))
      call dev_memcpy_from_device(dst=dst, src=src)
   endif
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_4D

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_5D(dst, src, transposed)
   !< Assign array, KKP kind, rank 5.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:,:,:)  !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:,:,:)  !< Source memory.
   logical,      intent(in), optional       :: transposed      !< Assign trasposed src.
   logical                                  :: transposed_     !< Assign trasposed src, local var.
   VARTYPE(KKP), allocatable                :: dstt(:,:,:,:,:) !< Destination array transposed.

   if (allocated(dst)) deallocate(dst)
   transposed_ = .false. ; if (present(transposed)) transposed_ = transposed
   if (transposed_) then
      allocate(dstt(lbound(src,dim=1):ubound(src,dim=1), &
                    lbound(src,dim=2):ubound(src,dim=2), &
                    lbound(src,dim=3):ubound(src,dim=3), &
                    lbound(src,dim=4):ubound(src,dim=4), &
                    lbound(src,dim=5):ubound(src,dim=5)))
      call dev_memcpy_from_device(dst=dstt, src=src)
      call transpose_array(b1=[lbound(dstt,dim=1),ubound(dstt,dim=1)], &
                           b2=[lbound(dstt,dim=2),ubound(dstt,dim=2)], &
                           b3=[lbound(dstt,dim=3),ubound(dstt,dim=3)], &
                           b4=[lbound(dstt,dim=4),ubound(dstt,dim=4)], &
                           b5=[lbound(dstt,dim=5),ubound(dstt,dim=5)], &
                           a=dstt, t=dst)
   else
      allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                   lbound(src,dim=2):ubound(src,dim=2), &
                   lbound(src,dim=3):ubound(src,dim=3), &
                   lbound(src,dim=4):ubound(src,dim=4), &
                   lbound(src,dim=5):ubound(src,dim=5)))
      call dev_memcpy_from_device(dst=dst, src=src)
   endif
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_5D

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_6D(dst, src, transposed)
   !< Assign array, KKP kind, rank 6.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:,:,:,:)  !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:,:,:,:)  !< Source memory.
   logical,      intent(in), optional       :: transposed        !< Assign trasposed src.
   logical                                  :: transposed_       !< Assign trasposed src, local var.
   VARTYPE(KKP), allocatable                :: dstt(:,:,:,:,:,:) !< Destination array transposed.

   if (allocated(dst)) deallocate(dst)
   transposed_ = .false. ; if (present(transposed)) transposed_ = transposed
   if (transposed_) then
      allocate(dstt(lbound(src,dim=1):ubound(src,dim=1), &
                    lbound(src,dim=2):ubound(src,dim=2), &
                    lbound(src,dim=3):ubound(src,dim=3), &
                    lbound(src,dim=4):ubound(src,dim=4), &
                    lbound(src,dim=5):ubound(src,dim=5), &
                    lbound(src,dim=6):ubound(src,dim=6)))
      call dev_memcpy_from_device(dst=dstt, src=src)
      call transpose_array(b1=[lbound(dstt,dim=1),ubound(dstt,dim=1)], &
                           b2=[lbound(dstt,dim=2),ubound(dstt,dim=2)], &
                           b3=[lbound(dstt,dim=3),ubound(dstt,dim=3)], &
                           b4=[lbound(dstt,dim=4),ubound(dstt,dim=4)], &
                           b5=[lbound(dstt,dim=5),ubound(dstt,dim=5)], &
                           b6=[lbound(dstt,dim=6),ubound(dstt,dim=6)], &
                           a=dstt, t=dst)
   else
      allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                   lbound(src,dim=2):ubound(src,dim=2), &
                   lbound(src,dim=3):ubound(src,dim=3), &
                   lbound(src,dim=4):ubound(src,dim=4), &
                   lbound(src,dim=5):ubound(src,dim=5), &
                   lbound(src,dim=6):ubound(src,dim=6)))
      call dev_memcpy_from_device(dst=dst, src=src)
   endif
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_6D

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_7D(dst, src, transposed)
   !< Assign array, KKP kind, rank 7.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:,:,:,:,:)  !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:,:,:,:,:)  !< Source memory.
   logical,      intent(in), optional       :: transposed          !< Assign trasposed src.
   logical                                  :: transposed_         !< Assign trasposed src, local var.
   VARTYPE(KKP), allocatable                :: dstt(:,:,:,:,:,:,:) !< Destination array transposed.

   if (allocated(dst)) deallocate(dst)
   transposed_ = .false. ; if (present(transposed)) transposed_ = transposed
   if (transposed_) then
      allocate(dstt(lbound(src,dim=1):ubound(src,dim=1), &
                    lbound(src,dim=2):ubound(src,dim=2), &
                    lbound(src,dim=3):ubound(src,dim=3), &
                    lbound(src,dim=4):ubound(src,dim=4), &
                    lbound(src,dim=5):ubound(src,dim=5), &
                    lbound(src,dim=6):ubound(src,dim=6), &
                    lbound(src,dim=7):ubound(src,dim=7)))
      call dev_memcpy_from_device(dst=dstt, src=src)
      call transpose_array(b1=[lbound(dstt,dim=1),ubound(dstt,dim=1)], &
                           b2=[lbound(dstt,dim=2),ubound(dstt,dim=2)], &
                           b3=[lbound(dstt,dim=3),ubound(dstt,dim=3)], &
                           b4=[lbound(dstt,dim=4),ubound(dstt,dim=4)], &
                           b5=[lbound(dstt,dim=5),ubound(dstt,dim=5)], &
                           b6=[lbound(dstt,dim=6),ubound(dstt,dim=6)], &
                           b7=[lbound(dstt,dim=7),ubound(dstt,dim=7)], &
                           a=dstt, t=dst)
   else
      allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                   lbound(src,dim=2):ubound(src,dim=2), &
                   lbound(src,dim=3):ubound(src,dim=3), &
                   lbound(src,dim=4):ubound(src,dim=4), &
                   lbound(src,dim=5):ubound(src,dim=5), &
                   lbound(src,dim=6):ubound(src,dim=6), &
                   lbound(src,dim=7):ubound(src,dim=7)))
      call dev_memcpy_from_device(dst=dst, src=src)
   endif
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_7D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_1D(dst, src)
   !< Assign array, KKP kind, rank 1.
   VARTYPE(KKP), intent(inout), pointer :: dst(:) !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:) !< Source memory.
   integer(I4P)                         :: ierr   !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_1D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_2D(dst, src, transposed)
   !< Assign array, KKP kind, rank 2.
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:)    !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:,:)    !< Source memory.
   logical,      intent(in), optional   :: transposed  !< Assign trasposed src.
   logical                              :: transposed_ !< Assign trasposed src, local var.
   VARTYPE(KKP), allocatable            :: srct(:,:)   !< Source array transposed.
   integer(I4P)                         :: ierr        !< Error status.

   transposed_ = .false. ; if (present(transposed)) transposed_ = transposed
   if (associated(dst)) call dev_free(dst)
   if (transposed_) then
      call transpose_array(b1=[lbound(src,dim=1),ubound(src,dim=1)], &
                           b2=[lbound(src,dim=2),ubound(src,dim=2)], a=src, t=srct)
      call dev_alloc(fptr_dev=dst, ubounds=ubound(srct), lbounds=lbound(srct), ierr=ierr)
      call dev_memcpy_to_device(dst=dst, src=srct)
   else
      call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
      call dev_memcpy_to_device(dst=dst, src=src)
   endif
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_2D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_3D(dst, src, transposed)
   !< Assign array, KKP kind, rank 3.
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:)  !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:)  !< Source memory.
   logical,      intent(in), optional   :: transposed  !< Assign trasposed src.
   logical                              :: transposed_ !< Assign trasposed src, local var.
   VARTYPE(KKP), allocatable            :: srct(:,:,:) !< Source array transposed.
   integer(I4P)                         :: ierr        !< Error status.

   transposed_ = .false. ; if (present(transposed)) transposed_ = transposed
   if (associated(dst)) call dev_free(dst)
   if (transposed_) then
      call transpose_array(b1=[lbound(src,dim=1),ubound(src,dim=1)], &
                           b2=[lbound(src,dim=2),ubound(src,dim=2)], &
                           b3=[lbound(src,dim=3),ubound(src,dim=3)], a=src, t=srct)
      call dev_alloc(fptr_dev=dst, ubounds=ubound(srct), lbounds=lbound(srct), ierr=ierr)
      call dev_memcpy_to_device(dst=dst, src=srct)
   else
      call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
      call dev_memcpy_to_device(dst=dst, src=src)
   endif
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_3D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_4D(dst, src, transposed)
   !< Assign array, KKP kind, rank 4.
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:,:)  !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:,:)  !< Source memory.
   logical,      intent(in), optional   :: transposed    !< Assign trasposed src.
   logical                              :: transposed_   !< Assign trasposed src, local var.
   VARTYPE(KKP), allocatable            :: srct(:,:,:,:) !< Source array transposed.
   integer(I4P)                         :: ierr          !< Error status.

   transposed_ = .false. ; if (present(transposed)) transposed_ = transposed
   if (associated(dst)) call dev_free(dst)
   if (transposed_) then
      call transpose_array(b1=[lbound(src,dim=1),ubound(src,dim=1)], &
                           b2=[lbound(src,dim=2),ubound(src,dim=2)], &
                           b3=[lbound(src,dim=3),ubound(src,dim=3)], &
                           b4=[lbound(src,dim=4),ubound(src,dim=4)], a=src, t=srct)
      call dev_alloc(fptr_dev=dst, ubounds=ubound(srct), lbounds=lbound(srct), ierr=ierr)
      call dev_memcpy_to_device(dst=dst, src=srct)
   else
      call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
      call dev_memcpy_to_device(dst=dst, src=src)
   endif
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_4D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_5D(dst, src, transposed)
   !< Assign array, KKP kind, rank 5.
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:,:,:)  !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:,:,:)  !< Source memory.
   logical,      intent(in), optional   :: transposed      !< Assign trasposed src.
   logical                              :: transposed_     !< Assign trasposed src, local var.
   VARTYPE(KKP), allocatable            :: srct(:,:,:,:,:) !< Source array transposed.
   integer(I4P)                         :: ierr            !< Error status.

   transposed_ = .false. ; if (present(transposed)) transposed_ = transposed
   if (associated(dst)) call dev_free(dst)
   if (transposed_) then
      call transpose_array(b1=[lbound(src,dim=1),ubound(src,dim=1)], &
                           b2=[lbound(src,dim=2),ubound(src,dim=2)], &
                           b3=[lbound(src,dim=3),ubound(src,dim=3)], &
                           b4=[lbound(src,dim=4),ubound(src,dim=4)], &
                           b5=[lbound(src,dim=5),ubound(src,dim=5)], a=src, t=srct)
      call dev_alloc(fptr_dev=dst, ubounds=ubound(srct), lbounds=lbound(srct), ierr=ierr)
      call dev_memcpy_to_device(dst=dst, src=srct)
   else
      call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
      call dev_memcpy_to_device(dst=dst, src=src)
   endif
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_5D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_6D(dst, src, transposed)
   !< Assign array, KKP kind, rank 6.
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:,:,:,:)  !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:,:,:,:)  !< Source memory.
   logical,      intent(in), optional   :: transposed        !< Assign trasposed src.
   logical                              :: transposed_       !< Assign trasposed src, local var.
   VARTYPE(KKP), allocatable            :: srct(:,:,:,:,:,:) !< Source array transposed.
   integer(I4P)                         :: ierr              !< Error status.

   transposed_ = .false. ; if (present(transposed)) transposed_ = transposed
   if (associated(dst)) call dev_free(dst)
   if (transposed_) then
      call transpose_array(b1=[lbound(src,dim=1),ubound(src,dim=1)], &
                           b2=[lbound(src,dim=2),ubound(src,dim=2)], &
                           b3=[lbound(src,dim=3),ubound(src,dim=3)], &
                           b4=[lbound(src,dim=4),ubound(src,dim=4)], &
                           b5=[lbound(src,dim=5),ubound(src,dim=5)], &
                           b6=[lbound(src,dim=6),ubound(src,dim=6)], a=src, t=srct)
      call dev_alloc(fptr_dev=dst, ubounds=ubound(srct), lbounds=lbound(srct), ierr=ierr)
      call dev_memcpy_to_device(dst=dst, src=srct)
   else
      call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
      call dev_memcpy_to_device(dst=dst, src=src)
   endif
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_6D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_7D(dst, src, transposed)
   !< Assign array, KKP kind, rank 7.
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:,:,:,:,:)  !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:,:,:,:,:)  !< Source memory.
   logical,      intent(in), optional   :: transposed          !< Assign trasposed src.
   logical                              :: transposed_         !< Assign trasposed src, local var.
   VARTYPE(KKP), allocatable            :: srct(:,:,:,:,:,:,:) !< Source array transposed.
   integer(I4P)                         :: ierr                !< Error status.

   transposed_ = .false. ; if (present(transposed)) transposed_ = transposed
   if (associated(dst)) call dev_free(dst)
   if (transposed_) then
      call transpose_array(b1=[lbound(src,dim=1),ubound(src,dim=1)], &
                           b2=[lbound(src,dim=2),ubound(src,dim=2)], &
                           b3=[lbound(src,dim=3),ubound(src,dim=3)], &
                           b4=[lbound(src,dim=4),ubound(src,dim=4)], &
                           b5=[lbound(src,dim=5),ubound(src,dim=5)], &
                           b6=[lbound(src,dim=6),ubound(src,dim=6)], &
                           b7=[lbound(src,dim=7),ubound(src,dim=7)], a=src, t=srct)
      call dev_alloc(fptr_dev=dst, ubounds=ubound(srct), lbounds=lbound(srct), ierr=ierr)
      call dev_memcpy_to_device(dst=dst, src=srct)
   else
      call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
      call dev_memcpy_to_device(dst=dst, src=src)
   endif
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_7D
