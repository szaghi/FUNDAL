   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_1D(dst, src)
   !< Assign array, KKP kind, rank 1.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:) !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_1D

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_2D(dst, src)
   !< Assign array, KKP kind, rank 2.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:) !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_2D

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_3D(dst, src)
   !< Assign array, KKP kind, rank 3.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:) !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_3D

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_4D(dst, src)
   !< Assign array, KKP kind, rank 4.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:,:) !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_4D

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_5D(dst, src)
   !< Assign array, KKP kind, rank 5.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:,:,:) !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_5D

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_6D(dst, src)
   !< Assign array, KKP kind, rank 6.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:,:,:,:) !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_6D

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_7D(dst, src)
   !< Assign array, KKP kind, rank 7.
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:,:,:,:,:) !< Assign memory.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6), &
                lbound(src,dim=7):ubound(src,dim=7)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_7D

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_2D_T(dst, src, ij)
   !< Assign transposed array from device (kind KKP, rank 2), swapping index positions ij(1) and ij(2).
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:)  !< Transposed host destination.
   VARTYPE(KKP), intent(in)                 :: src(:,:)  !< Source device array.
   integer(I4P), intent(in)                 :: ij(2)     !< 1-based index pair to swap.
   VARTYPE(KKP), allocatable                :: dstt(:,:) !< Intermediate host buffer.
   integer(I4P)                             :: bb(2,2)   !< Bounds of src.

   if (allocated(dst)) deallocate(dst)
   bb(:,1) = [lbound(src,dim=1), ubound(src,dim=1)]
   bb(:,2) = [lbound(src,dim=2), ubound(src,dim=2)]
   allocate(dstt(bb(1,1):bb(2,1), bb(1,2):bb(2,2)))
   call dev_memcpy_from_device(dst=dstt, src=src)
   call transpose_array(bb=bb, a=dstt, t=dst)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_2D_T

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_3D_T(dst, src, ij)
   !< Assign transposed array from device (kind KKP, rank 3), swapping index positions ij(1) and ij(2).
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:)  !< Transposed host destination.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:)  !< Source device array.
   integer(I4P), intent(in)                 :: ij(2)       !< 1-based index pair to swap.
   VARTYPE(KKP), allocatable                :: dstt(:,:,:) !< Intermediate host buffer.
   integer(I4P)                             :: bb(2,3)     !< Bounds of src.

   if (allocated(dst)) deallocate(dst)
   bb(:,1) = [lbound(src,dim=1), ubound(src,dim=1)]
   bb(:,2) = [lbound(src,dim=2), ubound(src,dim=2)]
   bb(:,3) = [lbound(src,dim=3), ubound(src,dim=3)]
   allocate(dstt(bb(1,1):bb(2,1), bb(1,2):bb(2,2), bb(1,3):bb(2,3)))
   call dev_memcpy_from_device(dst=dstt, src=src)
   call transpose_array(bb=bb, ij=ij, a=dstt, t=dst)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_3D_T

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_4D_T(dst, src, ij)
   !< Assign transposed array from device (kind KKP, rank 4), swapping index positions ij(1) and ij(2).
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:,:)  !< Transposed host destination.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:,:)  !< Source device array.
   integer(I4P), intent(in)                 :: ij(2)         !< 1-based index pair to swap.
   VARTYPE(KKP), allocatable                :: dstt(:,:,:,:) !< Intermediate host buffer.
   integer(I4P)                             :: bb(2,4)       !< Bounds of src.

   if (allocated(dst)) deallocate(dst)
   bb(:,1) = [lbound(src,dim=1), ubound(src,dim=1)]
   bb(:,2) = [lbound(src,dim=2), ubound(src,dim=2)]
   bb(:,3) = [lbound(src,dim=3), ubound(src,dim=3)]
   bb(:,4) = [lbound(src,dim=4), ubound(src,dim=4)]
   allocate(dstt(bb(1,1):bb(2,1), bb(1,2):bb(2,2), bb(1,3):bb(2,3), bb(1,4):bb(2,4)))
   call dev_memcpy_from_device(dst=dstt, src=src)
   call transpose_array(bb=bb, ij=ij, a=dstt, t=dst)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_4D_T

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_5D_T(dst, src, ij)
   !< Assign transposed array from device (kind KKP, rank 5), swapping index positions ij(1) and ij(2).
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:,:,:)  !< Transposed host destination.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:,:,:)  !< Source device array.
   integer(I4P), intent(in)                 :: ij(2)           !< 1-based index pair to swap.
   VARTYPE(KKP), allocatable                :: dstt(:,:,:,:,:) !< Intermediate host buffer.
   integer(I4P)                             :: bb(2,5)         !< Bounds of src.

   if (allocated(dst)) deallocate(dst)
   bb(:,1) = [lbound(src,dim=1), ubound(src,dim=1)]
   bb(:,2) = [lbound(src,dim=2), ubound(src,dim=2)]
   bb(:,3) = [lbound(src,dim=3), ubound(src,dim=3)]
   bb(:,4) = [lbound(src,dim=4), ubound(src,dim=4)]
   bb(:,5) = [lbound(src,dim=5), ubound(src,dim=5)]
   allocate(dstt(bb(1,1):bb(2,1), bb(1,2):bb(2,2), bb(1,3):bb(2,3), &
                 bb(1,4):bb(2,4), bb(1,5):bb(2,5)))
   call dev_memcpy_from_device(dst=dstt, src=src)
   call transpose_array(bb=bb, ij=ij, a=dstt, t=dst)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_5D_T

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_6D_T(dst, src, ij)
   !< Assign transposed array from device (kind KKP, rank 6), swapping index positions ij(1) and ij(2).
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:,:,:,:)  !< Transposed host destination.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:,:,:,:)  !< Source device array.
   integer(I4P), intent(in)                 :: ij(2)             !< 1-based index pair to swap.
   VARTYPE(KKP), allocatable                :: dstt(:,:,:,:,:,:) !< Intermediate host buffer.
   integer(I4P)                             :: bb(2,6)           !< Bounds of src.

   if (allocated(dst)) deallocate(dst)
   bb(:,1) = [lbound(src,dim=1), ubound(src,dim=1)]
   bb(:,2) = [lbound(src,dim=2), ubound(src,dim=2)]
   bb(:,3) = [lbound(src,dim=3), ubound(src,dim=3)]
   bb(:,4) = [lbound(src,dim=4), ubound(src,dim=4)]
   bb(:,5) = [lbound(src,dim=5), ubound(src,dim=5)]
   bb(:,6) = [lbound(src,dim=6), ubound(src,dim=6)]
   allocate(dstt(bb(1,1):bb(2,1), bb(1,2):bb(2,2), bb(1,3):bb(2,3), &
                 bb(1,4):bb(2,4), bb(1,5):bb(2,5), bb(1,6):bb(2,6)))
   call dev_memcpy_from_device(dst=dstt, src=src)
   call transpose_array(bb=bb, ij=ij, a=dstt, t=dst)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_6D_T

   subroutine DEV_ASSIGN_FROM_DEVICE_KKP_7D_T(dst, src, ij)
   !< Assign transposed array from device (kind KKP, rank 7), swapping index positions ij(1) and ij(2).
   VARTYPE(KKP), intent(inout), allocatable :: dst(:,:,:,:,:,:,:)  !< Transposed host destination.
   VARTYPE(KKP), intent(in)                 :: src(:,:,:,:,:,:,:)  !< Source device array.
   integer(I4P), intent(in)                 :: ij(2)               !< 1-based index pair to swap.
   VARTYPE(KKP), allocatable                :: dstt(:,:,:,:,:,:,:) !< Intermediate host buffer.
   integer(I4P)                             :: bb(2,7)             !< Bounds of src.

   if (allocated(dst)) deallocate(dst)
   bb(:,1) = [lbound(src,dim=1), ubound(src,dim=1)]
   bb(:,2) = [lbound(src,dim=2), ubound(src,dim=2)]
   bb(:,3) = [lbound(src,dim=3), ubound(src,dim=3)]
   bb(:,4) = [lbound(src,dim=4), ubound(src,dim=4)]
   bb(:,5) = [lbound(src,dim=5), ubound(src,dim=5)]
   bb(:,6) = [lbound(src,dim=6), ubound(src,dim=6)]
   bb(:,7) = [lbound(src,dim=7), ubound(src,dim=7)]
   allocate(dstt(bb(1,1):bb(2,1), bb(1,2):bb(2,2), bb(1,3):bb(2,3), bb(1,4):bb(2,4), &
                 bb(1,5):bb(2,5), bb(1,6):bb(2,6), bb(1,7):bb(2,7)))
   call dev_memcpy_from_device(dst=dstt, src=src)
   call transpose_array(bb=bb, ij=ij, a=dstt, t=dst)
   endsubroutine DEV_ASSIGN_FROM_DEVICE_KKP_7D_T

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_1D(dst, src)
   !< Assign array, KKP kind, rank 1.
   VARTYPE(KKP), intent(inout), pointer :: dst(:) !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:) !< Source memory.
   integer(I4P)                         :: ierr   !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_1D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_2D(dst, src)
   !< Assign array, KKP kind, rank 2.
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:) !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:,:) !< Source memory.
   integer(I4P)                         :: ierr     !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_2D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_3D(dst, src)
   !< Assign array, KKP kind, rank 3.
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:) !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:) !< Source memory.
   integer(I4P)                         :: ierr       !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_3D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_4D(dst, src)
   !< Assign array, KKP kind, rank 4.
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:,:) !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr         !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_4D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_5D(dst, src)
   !< Assign array, KKP kind, rank 5.
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:,:,:) !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr           !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_5D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_6D(dst, src)
   !< Assign array, KKP kind, rank 6.
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:,:,:,:) !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr             !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_6D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_7D(dst, src)
   !< Assign array, KKP kind, rank 7.
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:,:,:,:,:) !< Pointer to assign memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr               !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_7D

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_2D_T(dst, src, ij)
   !< Assign transposed array to device (kind KKP, rank 2), swapping index positions ij(1) and ij(2).
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:)  !< Pointer to device memory.
   VARTYPE(KKP), intent(in)             :: src(:,:)  !< Source host array.
   integer(I4P), intent(in)             :: ij(2)     !< 1-based index pair to swap (always [1,2] for rank 2).
   VARTYPE(KKP), allocatable            :: srct(:,:) !< Transposed source.
   integer(I4P)                         :: bb(2,2)   !< Bounds of src.
   integer(I4P)                         :: ierr      !< Error status.

   bb(:,1) = [lbound(src,dim=1), ubound(src,dim=1)]
   bb(:,2) = [lbound(src,dim=2), ubound(src,dim=2)]
   if (associated(dst)) call dev_free(dst)
   call transpose_array(bb=bb, a=src, t=srct)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(srct), lbounds=lbound(srct), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=srct)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_2D_T

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_3D_T(dst, src, ij)
   !< Assign transposed array to device (kind KKP, rank 3), swapping index positions ij(1) and ij(2).
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:)  !< Pointer to device memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:)  !< Source host array.
   integer(I4P), intent(in)             :: ij(2)       !< 1-based index pair to swap.
   VARTYPE(KKP), allocatable            :: srct(:,:,:) !< Transposed source.
   integer(I4P)                         :: bb(2,3)     !< Bounds of src.
   integer(I4P)                         :: ierr        !< Error status.

   bb(:,1) = [lbound(src,dim=1), ubound(src,dim=1)]
   bb(:,2) = [lbound(src,dim=2), ubound(src,dim=2)]
   bb(:,3) = [lbound(src,dim=3), ubound(src,dim=3)]
   if (associated(dst)) call dev_free(dst)
   call transpose_array(bb=bb, ij=ij, a=src, t=srct)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(srct), lbounds=lbound(srct), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=srct)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_3D_T

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_4D_T(dst, src, ij)
   !< Assign transposed array to device (kind KKP, rank 4), swapping index positions ij(1) and ij(2).
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:,:)  !< Pointer to device memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:,:)  !< Source host array.
   integer(I4P), intent(in)             :: ij(2)         !< 1-based index pair to swap.
   VARTYPE(KKP), allocatable            :: srct(:,:,:,:) !< Transposed source.
   integer(I4P)                         :: bb(2,4)       !< Bounds of src.
   integer(I4P)                         :: ierr          !< Error status.

   bb(:,1) = [lbound(src,dim=1), ubound(src,dim=1)]
   bb(:,2) = [lbound(src,dim=2), ubound(src,dim=2)]
   bb(:,3) = [lbound(src,dim=3), ubound(src,dim=3)]
   bb(:,4) = [lbound(src,dim=4), ubound(src,dim=4)]
   if (associated(dst)) call dev_free(dst)
   call transpose_array(bb=bb, ij=ij, a=src, t=srct)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(srct), lbounds=lbound(srct), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=srct)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_4D_T

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_5D_T(dst, src, ij)
   !< Assign transposed array to device (kind KKP, rank 5), swapping index positions ij(1) and ij(2).
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:,:,:)  !< Pointer to device memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:,:,:)  !< Source host array.
   integer(I4P), intent(in)             :: ij(2)           !< 1-based index pair to swap.
   VARTYPE(KKP), allocatable            :: srct(:,:,:,:,:) !< Transposed source.
   integer(I4P)                         :: bb(2,5)         !< Bounds of src.
   integer(I4P)                         :: ierr            !< Error status.

   bb(:,1) = [lbound(src,dim=1), ubound(src,dim=1)]
   bb(:,2) = [lbound(src,dim=2), ubound(src,dim=2)]
   bb(:,3) = [lbound(src,dim=3), ubound(src,dim=3)]
   bb(:,4) = [lbound(src,dim=4), ubound(src,dim=4)]
   bb(:,5) = [lbound(src,dim=5), ubound(src,dim=5)]
   if (associated(dst)) call dev_free(dst)
   call transpose_array(bb=bb, ij=ij, a=src, t=srct)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(srct), lbounds=lbound(srct), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=srct)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_5D_T

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_6D_T(dst, src, ij)
   !< Assign transposed array to device (kind KKP, rank 6), swapping index positions ij(1) and ij(2).
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:,:,:,:)  !< Pointer to device memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:,:,:,:)  !< Source host array.
   integer(I4P), intent(in)             :: ij(2)             !< 1-based index pair to swap.
   VARTYPE(KKP), allocatable            :: srct(:,:,:,:,:,:) !< Transposed source.
   integer(I4P)                         :: bb(2,6)           !< Bounds of src.
   integer(I4P)                         :: ierr              !< Error status.

   bb(:,1) = [lbound(src,dim=1), ubound(src,dim=1)]
   bb(:,2) = [lbound(src,dim=2), ubound(src,dim=2)]
   bb(:,3) = [lbound(src,dim=3), ubound(src,dim=3)]
   bb(:,4) = [lbound(src,dim=4), ubound(src,dim=4)]
   bb(:,5) = [lbound(src,dim=5), ubound(src,dim=5)]
   bb(:,6) = [lbound(src,dim=6), ubound(src,dim=6)]
   if (associated(dst)) call dev_free(dst)
   call transpose_array(bb=bb, ij=ij, a=src, t=srct)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(srct), lbounds=lbound(srct), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=srct)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_6D_T

   subroutine DEV_ASSIGN_TO_DEVICE_KKP_7D_T(dst, src, ij)
   !< Assign transposed array to device (kind KKP, rank 7), swapping index positions ij(1) and ij(2).
   VARTYPE(KKP), intent(inout), pointer :: dst(:,:,:,:,:,:,:)  !< Pointer to device memory.
   VARTYPE(KKP), intent(in)             :: src(:,:,:,:,:,:,:)  !< Source host array.
   integer(I4P), intent(in)             :: ij(2)               !< 1-based index pair to swap.
   VARTYPE(KKP), allocatable            :: srct(:,:,:,:,:,:,:) !< Transposed source.
   integer(I4P)                         :: bb(2,7)             !< Bounds of src.
   integer(I4P)                         :: ierr                !< Error status.

   bb(:,1) = [lbound(src,dim=1), ubound(src,dim=1)]
   bb(:,2) = [lbound(src,dim=2), ubound(src,dim=2)]
   bb(:,3) = [lbound(src,dim=3), ubound(src,dim=3)]
   bb(:,4) = [lbound(src,dim=4), ubound(src,dim=4)]
   bb(:,5) = [lbound(src,dim=5), ubound(src,dim=5)]
   bb(:,6) = [lbound(src,dim=6), ubound(src,dim=6)]
   bb(:,7) = [lbound(src,dim=7), ubound(src,dim=7)]
   if (associated(dst)) call dev_free(dst)
   call transpose_array(bb=bb, ij=ij, a=src, t=srct)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(srct), lbounds=lbound(srct), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=srct)
   endsubroutine DEV_ASSIGN_TO_DEVICE_KKP_7D_T
