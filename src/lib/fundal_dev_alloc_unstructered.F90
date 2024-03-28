!< FUNDAL, memory allocation routines module, unstructured model.

#include "fundal.H"

module fundal_dev_alloc_unstructured
!< FUNDAL, memory allocation routines module, unstructured model.
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64

implicit none
private
public :: dev_alloc_unstr

interface dev_alloc_unstr
   !< Allocate device memory, unstructured model.
   module procedure dev_alloc_R8P_1D,&
                    dev_alloc_R8P_2D,&
                    dev_alloc_R8P_3D,&
                    dev_alloc_R8P_4D,&
                    dev_alloc_R8P_5D,&
                    dev_alloc_R8P_6D,&
                    dev_alloc_R8P_7D,&
                    dev_alloc_R4P_1D,&
                    dev_alloc_R4P_2D,&
                    dev_alloc_R4P_3D,&
                    dev_alloc_R4P_4D,&
                    dev_alloc_R4P_5D,&
                    dev_alloc_R4P_6D,&
                    dev_alloc_R4P_7D,&
                    dev_alloc_I8P_1D,&
                    dev_alloc_I8P_2D,&
                    dev_alloc_I8P_3D,&
                    dev_alloc_I8P_4D,&
                    dev_alloc_I8P_5D,&
                    dev_alloc_I8P_6D,&
                    dev_alloc_I8P_7D,&
                    dev_alloc_I4P_1D,&
                    dev_alloc_I4P_2D,&
                    dev_alloc_I4P_3D,&
                    dev_alloc_I4P_4D,&
                    dev_alloc_I4P_5D,&
                    dev_alloc_I4P_6D,&
                    dev_alloc_I4P_7D,&
                    dev_alloc_I1P_1D,&
                    dev_alloc_I1P_2D,&
                    dev_alloc_I1P_3D,&
                    dev_alloc_I1P_4D,&
                    dev_alloc_I1P_5D,&
                    dev_alloc_I1P_6D,&
                    dev_alloc_I1P_7D
endinterface dev_alloc_unstr

contains
   subroutine dev_alloc_R8P_1D(fptr_dev, init_value)
   !< Allocate array, R8P kind, rank 1.
   real(R8P), intent(inout)        :: fptr_dev(:) !< Pointer to allocated memory.
   real(R8P), intent(in), optional :: init_value  !< Optional initial value.
   integer(I8P)                    :: bounds(1,2) !< Bounds.
   integer(I4P)                    :: i1          !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(1) present(fptr_dev)
      !$omp OMPLOOP collapse(1) DEVICEVAR(fptr_dev)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1) = init_value
      enddo
   endif
   endsubroutine dev_alloc_R8P_1D

   subroutine dev_alloc_R8P_2D(fptr_dev, init_value)
   !< Allocate array, R8P kind, rank 2.
   real(R8P), intent(inout)        :: fptr_dev(:,:) !< Pointer to allocated memory.
   real(R8P), intent(in), optional :: init_value    !< Optional initial value.
   integer(I8P)                    :: bounds(2,2)   !< Bounds.
   integer(I4P)                    :: i1,i2         !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(2) present(fptr_dev)
      !$omp OMPLOOP collapse(2) DEVICEVAR(fptr_dev)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2) = init_value
      enddo
      enddo
   endif
   endsubroutine dev_alloc_R8P_2D

   subroutine dev_alloc_R8P_3D(fptr_dev, init_value)
   !< Allocate array, R8P kind, rank 3.
   real(R8P), intent(inout)        :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   real(R8P), intent(in), optional :: init_value      !< Optional initial value.
   integer(I8P)                    :: bounds(3,2)     !< Bounds.
   integer(I4P)                    :: i1,i2,i3        !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(3) present(fptr_dev)
      !$omp OMPLOOP collapse(3) DEVICEVAR(fptr_dev)
      do i3=bounds(3,1), bounds(3,2)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2,i3) = init_value
      enddo
      enddo
      enddo
   endif
   endsubroutine dev_alloc_R8P_3D

   subroutine dev_alloc_R8P_4D(fptr_dev, init_value)
   !< Allocate array, R8P kind, rank 4.
   real(R8P), intent(inout)        :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   real(R8P), intent(in), optional :: init_value        !< Optional initial value.
   integer(I8P)                    :: bounds(4,2)       !< Bounds.
   integer(I4P)                    :: i1,i2,i3,i4       !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(4) present(fptr_dev)
      !$omp OMPLOOP collapse(4) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R8P_4D

   subroutine dev_alloc_R8P_5D(fptr_dev, init_value)
   !< Allocate array, R8P kind, rank 5.
   real(R8P), intent(inout)        :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   real(R8P), intent(in), optional :: init_value          !< Optional initial value.
   integer(I8P)                    :: bounds(5,2)         !< Bounds.
   integer(I4P)                    :: i1,i2,i3,i4,i5      !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(5) present(fptr_dev)
      !$omp OMPLOOP collapse(5) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R8P_5D

   subroutine dev_alloc_R8P_6D(fptr_dev, init_value)
   !< Allocate array, R8P kind, rank 6.
   real(R8P), intent(inout)        :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   real(R8P), intent(in), optional :: init_value            !< Optional initial value.
   integer(I8P)                    :: bounds(6,2)           !< Bounds.
   integer(I4P)                    :: i1,i2,i3,i4,i5,i6     !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(6) present(fptr_dev)
      !$omp OMPLOOP collapse(6) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R8P_6D

   subroutine dev_alloc_R8P_7D(fptr_dev, init_value)
   !< Allocate array, R8P kind, rank 6.
   real(R8P), intent(inout)        :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   real(R8P), intent(in), optional :: init_value              !< Optional initial value.
   integer(I8P)                    :: bounds(7,2)             !< Bounds.
   integer(I4P)                    :: i1,i2,i3,i4,i5,i6,i7    !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(7) present(fptr_dev)
      !$omp OMPLOOP collapse(7) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R8P_7D

   subroutine dev_alloc_R4P_1D(fptr_dev, init_value)
   !< Allocate array, R4P kind, rank 1.
   real(R4P), intent(inout)        :: fptr_dev(:) !< Pointer to allocated memory.
   real(R4P), intent(in), optional :: init_value  !< Optional initial value.
   integer(I8P)                    :: bounds(1,2) !< Bounds.
   integer(I4P)                    :: i1          !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(1) present(fptr_dev)
      !$omp OMPLOOP collapse(1) DEVICEVAR(fptr_dev)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1) = init_value
      enddo
   endif
   endsubroutine dev_alloc_R4P_1D

   subroutine dev_alloc_R4P_2D(fptr_dev, init_value)
   !< Allocate array, R4P kind, rank 2.
   real(R4P), intent(inout)        :: fptr_dev(:,:) !< Pointer to allocated memory.
   real(R4P), intent(in), optional :: init_value    !< Optional initial value.
   integer(I8P)                    :: bounds(2,2)   !< Bounds.
   integer(I4P)                    :: i1,i2         !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(2) present(fptr_dev)
      !$omp OMPLOOP collapse(2) DEVICEVAR(fptr_dev)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2) = init_value
      enddo
      enddo
   endif
   endsubroutine dev_alloc_R4P_2D

   subroutine dev_alloc_R4P_3D(fptr_dev, init_value)
   !< Allocate array, R4P kind, rank 3.
   real(R4P), intent(inout)        :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   real(R4P), intent(in), optional :: init_value      !< Optional initial value.
   integer(I8P)                    :: bounds(3,2)     !< Bounds.
   integer(I4P)                    :: i1,i2,i3        !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(3) present(fptr_dev)
      !$omp OMPLOOP collapse(3) DEVICEVAR(fptr_dev)
      do i3=bounds(3,1), bounds(3,2)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2,i3) = init_value
      enddo
      enddo
      enddo
   endif
   endsubroutine dev_alloc_R4P_3D

   subroutine dev_alloc_R4P_4D(fptr_dev, init_value)
   !< Allocate array, R4P kind, rank 4.
   real(R4P), intent(inout)        :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   real(R4P), intent(in), optional :: init_value        !< Optional initial value.
   integer(I8P)                    :: bounds(4,2)       !< Bounds.
   integer(I4P)                    :: i1,i2,i3,i4       !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(4) present(fptr_dev)
      !$omp OMPLOOP collapse(4) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R4P_4D

   subroutine dev_alloc_R4P_5D(fptr_dev, init_value)
   !< Allocate array, R4P kind, rank 5.
   real(R4P), intent(inout)        :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   real(R4P), intent(in), optional :: init_value          !< Optional initial value.
   integer(I8P)                    :: bounds(5,2)         !< Bounds.
   integer(I4P)                    :: i1,i2,i3,i4,i5      !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(5) present(fptr_dev)
      !$omp OMPLOOP collapse(5) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R4P_5D

   subroutine dev_alloc_R4P_6D(fptr_dev, init_value)
   !< Allocate array, R4P kind, rank 6.
   real(R4P), intent(inout)        :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   real(R4P), intent(in), optional :: init_value            !< Optional initial value.
   integer(I8P)                    :: bounds(6,2)             !< Bounds.
   integer(I4P)                    :: i1,i2,i3,i4,i5,i6     !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(6) present(fptr_dev)
      !$omp OMPLOOP collapse(6) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R4P_6D

   subroutine dev_alloc_R4P_7D(fptr_dev, init_value)
   !< Allocate array, R4P kind, rank 6.
   real(R4P), intent(inout)        :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   real(R4P), intent(in), optional :: init_value              !< Optional initial value.
   integer(I8P)                    :: bounds(7,2)             !< Bounds.
   integer(I4P)                    :: i1,i2,i3,i4,i5,i6,i7    !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(7) present(fptr_dev)
      !$omp OMPLOOP collapse(7) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R4P_7D

   subroutine dev_alloc_I8P_1D(fptr_dev, init_value)
   !< Allocate array, I8P kind, rank 1.
   integer(I8P), intent(inout)        :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I8P), intent(in), optional :: init_value  !< Optional initial value.
   integer(I8P)                       :: bounds(1,2) !< Bounds.
   integer(I4P)                       :: i1          !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(1) present(fptr_dev)
      !$omp OMPLOOP collapse(1) DEVICEVAR(fptr_dev)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1) = init_value
      enddo
   endif
   endsubroutine dev_alloc_I8P_1D

   subroutine dev_alloc_I8P_2D(fptr_dev, init_value)
   !< Allocate array, I8P kind, rank 2.
   integer(I8P), intent(inout)        :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I8P), intent(in), optional :: init_value    !< Optional initial value.
   integer(I8P)                       :: bounds(2,2)   !< Bounds.
   integer(I4P)                       :: i1,i2         !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(2) present(fptr_dev)
      !$omp OMPLOOP collapse(2) DEVICEVAR(fptr_dev)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2) = init_value
      enddo
      enddo
   endif
   endsubroutine dev_alloc_I8P_2D

   subroutine dev_alloc_I8P_3D(fptr_dev, init_value)
   !< Allocate array, I8P kind, rank 3.
   integer(I8P), intent(inout)        :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I8P), intent(in), optional :: init_value      !< Optional initial value.
   integer(I8P)                       :: bounds(3,2)     !< Bounds.
   integer(I4P)                       :: i1,i2,i3        !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(3) present(fptr_dev)
      !$omp OMPLOOP collapse(3) DEVICEVAR(fptr_dev)
      do i3=bounds(3,1), bounds(3,2)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2,i3) = init_value
      enddo
      enddo
      enddo
   endif
   endsubroutine dev_alloc_I8P_3D

   subroutine dev_alloc_I8P_4D(fptr_dev, init_value)
   !< Allocate array, I8P kind, rank 4.
   integer(I8P), intent(inout)        :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I8P), intent(in), optional :: init_value        !< Optional initial value.
   integer(I8P)                       :: bounds(4,2)       !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4       !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(4) present(fptr_dev)
      !$omp OMPLOOP collapse(4) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I8P_4D

   subroutine dev_alloc_I8P_5D(fptr_dev, init_value)
   !< Allocate array, I8P kind, rank 5.
   integer(I8P), intent(inout)        :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I8P), intent(in), optional :: init_value          !< Optional initial value.
   integer(I8P)                       :: bounds(5,2)         !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4,i5      !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(5) present(fptr_dev)
      !$omp OMPLOOP collapse(5) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I8P_5D

   subroutine dev_alloc_I8P_6D(fptr_dev, init_value)
   !< Allocate array, I8P kind, rank 6.
   integer(I8P), intent(inout)        :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I8P), intent(in), optional :: init_value            !< Optional initial value.
   integer(I8P)                       :: bounds(6,2)           !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6     !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(6) present(fptr_dev)
      !$omp OMPLOOP collapse(6) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I8P_6D

   subroutine dev_alloc_I8P_7D(fptr_dev, init_value)
   !< Allocate array, I8P kind, rank 6.
   integer(I8P), intent(inout)        :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I8P), intent(in), optional :: init_value              !< Optional initial value.
   integer(I8P)                       :: bounds(7,2)             !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6,i7    !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(7) present(fptr_dev)
      !$omp OMPLOOP collapse(7) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I8P_7D

   subroutine dev_alloc_I4P_1D(fptr_dev, init_value)
   !< Allocate array, I4P kind, rank 1.
   integer(I4P), intent(inout)        :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I4P), intent(in), optional :: init_value  !< Optional initial value.
   integer(I8P)                       :: bounds(1,2) !< Bounds.
   integer(I4P)                       :: i1          !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(1) present(fptr_dev)
      !$omp OMPLOOP collapse(1) DEVICEVAR(fptr_dev)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1) = init_value
      enddo
   endif
   endsubroutine dev_alloc_I4P_1D

   subroutine dev_alloc_I4P_2D(fptr_dev, init_value)
   !< Allocate array, I4P kind, rank 2.
   integer(I4P), intent(inout)        :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in), optional :: init_value    !< Optional initial value.
   integer(I8P)                       :: bounds(2,2)   !< Bounds.
   integer(I4P)                       :: i1,i2         !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(2) present(fptr_dev)
      !$omp OMPLOOP collapse(2) DEVICEVAR(fptr_dev)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2) = init_value
      enddo
      enddo
   endif
   endsubroutine dev_alloc_I4P_2D

   subroutine dev_alloc_I4P_3D(fptr_dev, init_value)
   !< Allocate array, I4P kind, rank 3.
   integer(I4P), intent(inout)        :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in), optional :: init_value      !< Optional initial value.
   integer(I8P)                       :: bounds(3,2)     !< Bounds.
   integer(I4P)                       :: i1,i2,i3        !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(3) present(fptr_dev)
      !$omp OMPLOOP collapse(3) DEVICEVAR(fptr_dev)
      do i3=bounds(3,1), bounds(3,2)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2,i3) = init_value
      enddo
      enddo
      enddo
   endif
   endsubroutine dev_alloc_I4P_3D

   subroutine dev_alloc_I4P_4D(fptr_dev, init_value)
   !< Allocate array, I4P kind, rank 4.
   integer(I4P), intent(inout)        :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in), optional :: init_value        !< Optional initial value.
   integer(I8P)                       :: bounds(4,2)       !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4       !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(4) present(fptr_dev)
      !$omp OMPLOOP collapse(4) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I4P_4D

   subroutine dev_alloc_I4P_5D(fptr_dev, init_value)
   !< Allocate array, I4P kind, rank 5.
   integer(I4P), intent(inout)        :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in), optional :: init_value          !< Optional initial value.
   integer(I8P)                       :: bounds(5,2)         !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4,i5      !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(5) present(fptr_dev)
      !$omp OMPLOOP collapse(5) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I4P_5D

   subroutine dev_alloc_I4P_6D(fptr_dev, init_value)
   !< Allocate array, I4P kind, rank 6.
   integer(I4P), intent(inout)        :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in), optional :: init_value            !< Optional initial value.
   integer(I8P)                       :: bounds(6,2)           !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6     !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(6) present(fptr_dev)
      !$omp OMPLOOP collapse(6) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I4P_6D

   subroutine dev_alloc_I4P_7D(fptr_dev, init_value)
   !< Allocate array, I4P kind, rank 6.
   integer(I4P), intent(inout)        :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in), optional :: init_value              !< Optional initial value.
   integer(I8P)                       :: bounds(7,2)             !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6,i7    !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(7) present(fptr_dev)
      !$omp OMPLOOP collapse(7) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I4P_7D

   subroutine dev_alloc_I1P_1D(fptr_dev, init_value)
   !< Allocate array, I1P kind, rank 1.
   integer(I1P), intent(inout)        :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I1P), intent(in), optional :: init_value  !< Optional initial value.
   integer(I8P)                       :: bounds(1,2) !< Bounds.
   integer(I4P)                       :: i1          !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(1) present(fptr_dev)
      !$omp OMPLOOP collapse(1) DEVICEVAR(fptr_dev)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1) = init_value
      enddo
   endif
   endsubroutine dev_alloc_I1P_1D

   subroutine dev_alloc_I1P_2D(fptr_dev, init_value)
   !< Allocate array, I1P kind, rank 2.
   integer(I1P), intent(inout)        :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I1P), intent(in), optional :: init_value    !< Optional initial value.
   integer(I8P)                       :: bounds(2,2)   !< Bounds.
   integer(I4P)                       :: i1,i2         !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(2) present(fptr_dev)
      !$omp OMPLOOP collapse(2) DEVICEVAR(fptr_dev)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2) = init_value
      enddo
      enddo
   endif
   endsubroutine dev_alloc_I1P_2D

   subroutine dev_alloc_I1P_3D(fptr_dev, init_value)
   !< Allocate array, I1P kind, rank 3.
   integer(I1P), intent(inout)        :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I1P), intent(in), optional :: init_value      !< Optional initial value.
   integer(I8P)                       :: bounds(3,2)     !< Bounds.
   integer(I4P)                       :: i1,i2,i3        !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(3) present(fptr_dev)
      !$omp OMPLOOP collapse(3) DEVICEVAR(fptr_dev)
      do i3=bounds(3,1), bounds(3,2)
      do i2=bounds(2,1), bounds(2,2)
      do i1=bounds(1,1), bounds(1,2)
         fptr_dev(i1,i2,i3) = init_value
      enddo
      enddo
      enddo
   endif
   endsubroutine dev_alloc_I1P_3D

   subroutine dev_alloc_I1P_4D(fptr_dev, init_value)
   !< Allocate array, I1P kind, rank 4.
   integer(I1P), intent(inout)        :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I1P), intent(in), optional :: init_value        !< Optional initial value.
   integer(I8P)                       :: bounds(4,2)       !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4       !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(4) present(fptr_dev)
      !$omp OMPLOOP collapse(4) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I1P_4D

   subroutine dev_alloc_I1P_5D(fptr_dev, init_value)
   !< Allocate array, I1P kind, rank 5.
   integer(I1P), intent(inout)        :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I1P), intent(in), optional :: init_value          !< Optional initial value.
   integer(I8P)                       :: bounds(5,2)         !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4,i5      !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(5) present(fptr_dev)
      !$omp OMPLOOP collapse(5) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I1P_5D

   subroutine dev_alloc_I1P_6D(fptr_dev, init_value)
   !< Allocate array, I1P kind, rank 6.
   integer(I1P), intent(inout)        :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I1P), intent(in), optional :: init_value            !< Optional initial value.
   integer(I8P)                       :: bounds(6,2)           !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6     !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(6) present(fptr_dev)
      !$omp OMPLOOP collapse(6) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I1P_6D

   subroutine dev_alloc_I1P_7D(fptr_dev, init_value)
   !< Allocate array, I1P kind, rank 6.
   integer(I1P), intent(inout)        :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I1P), intent(in), optional :: init_value              !< Optional initial value.
   integer(I8P)                       :: bounds(7,2)             !< Bounds.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6,i7    !< Counter.

   !$acc enter data create(fptr_dev)
   !$omp target enter data map(alloc:fptr_dev)
   if (present(init_value)) then
      bounds(:,1) = lbound(fptr_dev) ; bounds(:,2) = ubound(fptr_dev)
      !$acc parallel loop collapse(7) present(fptr_dev)
      !$omp OMPLOOP collapse(7) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I1P_7D
endmodule fundal_dev_alloc_unstructured
