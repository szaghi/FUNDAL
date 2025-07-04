   subroutine DEV_ALLOC_KKP_1D(fptr_dev, init_value)
   !< Allocate array, KKP kind, rank 1.
   VARTYPE(KKP), intent(inout)        :: fptr_dev(:) !< Pointer to allocated memory.
   VARTYPE(KKP), intent(in), optional :: init_value  !< Optional initial value.
   integer(I8P)                       :: bounds(1,2) !< Bounds.
   integer(I4P)                       :: i1          !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(1) present(fptr_dev)
      !$omp OMPLOOP collapse(1)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1) = init_value
      enddo
   endif
   endsubroutine DEV_ALLOC_KKP_1D

   subroutine DEV_ALLOC_KKP_2D(fptr_dev, init_value)
   !< Allocate array, KKP kind, rank 2.
   VARTYPE(KKP), intent(inout)        :: fptr_dev(:,:) !< Pointer to allocated memory.
   VARTYPE(KKP), intent(in), optional :: init_value    !< Optional initial value.
   integer(I8P)                       :: bounds(2,2)   !< Bounds.
   integer(I4P)                       :: i1,i2         !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(2) present(fptr_dev)
      !$omp OMPLOOP collapse(2)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2) = init_value
      enddo
      enddo
   endif
   endsubroutine DEV_ALLOC_KKP_2D

   subroutine DEV_ALLOC_KKP_3D(fptr_dev, init_value)
   !< Allocate array, KKP kind, rank 3.
   VARTYPE(KKP), intent(inout)        :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   VARTYPE(KKP), intent(in), optional :: init_value      !< Optional initial value.
   integer(I8P)                       :: bounds(3,2)     !< Bounds.
   integer(I4P)                       :: i1,i2,i3        !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(3) present(fptr_dev)
      !$omp OMPLOOP collapse(3)
      do i3=bounds(3,1), bounds(3,2)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2,i3) = init_value
      enddo
      enddo
      enddo
   endif
   endsubroutine DEV_ALLOC_KKP_3D

   subroutine DEV_ALLOC_KKP_4D(fptr_dev, init_value)
   !< Allocate array, KKP kind, rank 4.
   VARTYPE(KKP), intent(inout)        :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   VARTYPE(KKP), intent(in), optional :: init_value        !< Optional initial value.
   integer(I8P)                       :: bounds(4,2)       !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4       !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(4) present(fptr_dev)
      !$omp OMPLOOP collapse(4)
      do i4=bounds(4,1), bounds(4,2)
      do i3=bounds(3,1), bounds(3,2)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2,i3,i4) = init_value
      enddo
      enddo
      enddo
      enddo
   endif
   endsubroutine DEV_ALLOC_KKP_4D

   subroutine DEV_ALLOC_KKP_5D(fptr_dev, init_value)
   !< Allocate array, KKP kind, rank 5.
   VARTYPE(KKP), intent(inout)        :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   VARTYPE(KKP), intent(in), optional :: init_value          !< Optional initial value.
   integer(I8P)                       :: bounds(5,2)         !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4,i5      !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(5) present(fptr_dev)
      !$omp OMPLOOP collapse(5)
      do i5=bounds(5,1), bounds(5,2)
      do i4=bounds(4,1), bounds(4,2)
      do i3=bounds(3,1), bounds(3,2)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2,i3,i4,i5) = init_value
      enddo
      enddo
      enddo
      enddo
      enddo
   endif
   endsubroutine DEV_ALLOC_KKP_5D

   subroutine DEV_ALLOC_KKP_6D(fptr_dev, init_value)
   !< Allocate array, KKP kind, rank 6.
   VARTYPE(KKP), intent(inout)        :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   VARTYPE(KKP), intent(in), optional :: init_value            !< Optional initial value.
   integer(I8P)                       :: bounds(6,2)           !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6     !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(6) present(fptr_dev)
      !$omp OMPLOOP collapse(6)
      do i6=bounds(6,1), bounds(6,2)
      do i5=bounds(5,1), bounds(5,2)
      do i4=bounds(4,1), bounds(4,2)
      do i3=bounds(3,1), bounds(3,2)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2,i3,i4,i5,i6) = init_value
      enddo
      enddo
      enddo
      enddo
      enddo
      enddo
   endif
   endsubroutine DEV_ALLOC_KKP_6D

   subroutine DEV_ALLOC_KKP_7D(fptr_dev, init_value)
   !< Allocate array, KKP kind, rank 6.
   VARTYPE(KKP), intent(inout)        :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   VARTYPE(KKP), intent(in), optional :: init_value              !< Optional initial value.
   integer(I8P)                       :: bounds(7,2)             !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6,i7    !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(7) present(fptr_dev)
      !$omp OMPLOOP collapse(7)
      do i7=bounds(7,1), bounds(7,2)
      do i6=bounds(6,1), bounds(6,2)
      do i5=bounds(5,1), bounds(5,2)
      do i4=bounds(4,1), bounds(4,2)
      do i3=bounds(3,1), bounds(3,2)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2,i3,i4,i5,i6,i7) = init_value
      enddo
      enddo
      enddo
      enddo
      enddo
      enddo
      enddo
   endif
   endsubroutine DEV_ALLOC_KKP_7D
