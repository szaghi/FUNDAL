!< FUNDAL, memory allocation routines module.

#include "fundal.H"

#if defined DEV_OAC
#   define DEVALLOC(b, d) acc_malloc_f(b)
#elif defined DEV_OMP
#   define DEVALLOC(b, d) omp_target_alloc(b, d)
#else
#   define DEVALLOC(b, d) malloc_f(b)
#endif

module fundal_dev_alloc
!< FUNDAL, memory allocation routines module.
use, intrinsic :: iso_c_binding,   only : c_size_t, c_ptr, c_associated, c_f_pointer
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: DEVMODULE
use            :: fundal_env
use            :: fundal_utilities

implicit none
private
public :: dev_alloc
public :: FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED

integer(I4P), parameter :: FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED=101 !< Error flag, not allocated device memory.

interface dev_alloc
   !< Allocate device memory OpenACC backend.
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
endinterface dev_alloc

#ifdef DEV_OAC
interface
   ! interface to C runtime routines
   function acc_malloc_f(total_byte_dim) bind(c, name="acc_malloc")
   use iso_c_binding, only : c_ptr, c_size_t
   implicit none
   type(c_ptr)                          :: acc_malloc_f
   integer(c_size_t), value, intent(in) :: total_byte_dim
   endfunction acc_malloc_f
endinterface
#else
interface
   ! interface to C runtime routines
   function malloc_f(total_byte_dim) bind(c, name="malloc")
   use iso_c_binding, only : c_ptr, c_size_t
   implicit none
   type(c_ptr)                          :: malloc_f
   integer(c_size_t), value, intent(in) :: total_byte_dim
   endfunction malloc_f
endinterface
#endif

contains
   subroutine dev_alloc_R8P_1D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R8P kind, rank 1.
   real(R8P),    intent(out), pointer :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(1)  !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr        !< Error status.
   integer(I4P), intent(in), optional :: dev_id      !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(1)  !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value  !< Optional initial value.
   real(R8P), pointer                 :: fptr(:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(1) DEVICEVAR(fptr_dev)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1) = init_value
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine dev_alloc_R8P_1D

   subroutine dev_alloc_R8P_2D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R8P kind, rank 2.
   real(R8P),    intent(out), pointer :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(2)    !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr          !< Error status.
   integer(I4P), intent(in), optional :: dev_id        !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(2)    !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value    !< Optional initial value.
   real(R8P), pointer                 :: fptr(:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(2) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R8P_2D

   subroutine dev_alloc_R8P_3D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R8P kind, rank 3.
   real(R8P),    intent(out), pointer :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(3)      !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr            !< Error status.
   integer(I4P), intent(in), optional :: dev_id          !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(3)      !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value      !< Optional initial value.
   real(R8P), pointer                 :: fptr(:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(3) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R8P_3D

   subroutine dev_alloc_R8P_4D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R8P kind, rank 4.
   real(R8P),    intent(out), pointer :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(4)        !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr              !< Error status.
   integer(I4P), intent(in), optional :: dev_id            !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(4)        !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value        !< Optional initial value.
   real(R8P), pointer                 :: fptr(:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(4) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R8P_4D

   subroutine dev_alloc_R8P_5D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R8P kind, rank 5.
   real(R8P),    intent(out), pointer :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(5)          !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                !< Error status.
   integer(I4P), intent(in), optional :: dev_id              !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(5)          !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value          !< Optional initial value.
   real(R8P), pointer                 :: fptr(:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(5) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R8P_5D

   subroutine dev_alloc_R8P_6D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R8P kind, rank 6.
   real(R8P),    intent(out), pointer :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(6)            !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                  !< Error status.
   integer(I4P), intent(in), optional :: dev_id                !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(6)            !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value            !< Optional initial value.
   real(R8P), pointer                 :: fptr(:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(6) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R8P_6D

   subroutine dev_alloc_R8P_7D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R8P kind, rank 7.
   real(R8P),    intent(out), pointer :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(7)              !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                    !< Error status.
   integer(I4P), intent(in), optional :: dev_id                  !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(7)              !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value              !< Optional initial value.
   real(R8P), pointer                 :: fptr(:,:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(7) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R8P_7D

   subroutine dev_alloc_R4P_1D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R4P kind, rank 1.
   real(R4P),    intent(out), pointer :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(1)  !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr        !< Error status.
   integer(I4P), intent(in), optional :: dev_id      !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(1)  !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value  !< Optional initial value.
   real(R4P), pointer                 :: fptr(:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(1) DEVICEVAR(fptr_dev)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1) = init_value
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine dev_alloc_R4P_1D

   subroutine dev_alloc_R4P_2D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R4P kind, rank 2.
   real(R4P),    intent(out), pointer :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(2)    !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr          !< Error status.
   integer(I4P), intent(in), optional :: dev_id        !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(2)    !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value    !< Optional initial value.
   real(R4P), pointer                 :: fptr(:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(2) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R4P_2D

   subroutine dev_alloc_R4P_3D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R4P kind, rank 3.
   real(R4P),    intent(out), pointer :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(3)      !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr            !< Error status.
   integer(I4P), intent(in), optional :: dev_id          !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(3)      !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value      !< Optional initial value.
   real(R4P), pointer                 :: fptr(:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(3) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R4P_3D

   subroutine dev_alloc_R4P_4D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R4P kind, rank 4.
   real(R4P),    intent(out), pointer :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(4)        !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr              !< Error status.
   integer(I4P), intent(in), optional :: dev_id            !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(4)        !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value        !< Optional initial value.
   real(R4P), pointer                 :: fptr(:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(4) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R4P_4D

   subroutine dev_alloc_R4P_5D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R4P kind, rank 5.
   real(R4P),    intent(out), pointer :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(5)          !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                !< Error status.
   integer(I4P), intent(in), optional :: dev_id              !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(5)          !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value          !< Optional initial value.
   real(R4P), pointer                 :: fptr(:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(5) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R4P_5D

   subroutine dev_alloc_R4P_6D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R4P kind, rank 6.
   real(R4P),    intent(out), pointer :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(6)            !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                  !< Error status.
   integer(I4P), intent(in), optional :: dev_id                !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(6)            !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value            !< Optional initial value.
   real(R4P), pointer                 :: fptr(:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(6) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R4P_6D

   subroutine dev_alloc_R4P_7D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, R4P kind, rank 7.
   real(R4P),    intent(out), pointer :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(7)              !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                    !< Error status.
   integer(I4P), intent(in), optional :: dev_id                  !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(7)              !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value              !< Optional initial value.
   real(R4P), pointer                 :: fptr(:,:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(7) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_R4P_7D

   subroutine dev_alloc_I8P_1D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I8P kind, rank 1.
   integer(I8P), intent(out), pointer :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(1)  !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr        !< Error status.
   integer(I4P), intent(in), optional :: dev_id      !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(1)  !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value  !< Optional initial value.
   integer(I8P), pointer              :: fptr(:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(1) DEVICEVAR(fptr_dev)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1) = init_value
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine dev_alloc_I8P_1D

   subroutine dev_alloc_I8P_2D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I8P kind, rank 2.
   integer(I8P), intent(out), pointer :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(2)    !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr          !< Error status.
   integer(I4P), intent(in), optional :: dev_id        !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(2)    !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value    !< Optional initial value.
   integer(I8P), pointer              :: fptr(:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(2) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I8P_2D

   subroutine dev_alloc_I8P_3D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I8P kind, rank 3.
   integer(I8P), intent(out), pointer :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(3)      !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr            !< Error status.
   integer(I4P), intent(in), optional :: dev_id          !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(3)      !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value      !< Optional initial value.
   integer(I8P), pointer              :: fptr(:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(3) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I8P_3D

   subroutine dev_alloc_I8P_4D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I8P kind, rank 4.
   integer(I8P), intent(out), pointer :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(4)        !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr              !< Error status.
   integer(I4P), intent(in), optional :: dev_id            !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(4)        !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value        !< Optional initial value.
   integer(I8P), pointer              :: fptr(:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(4) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I8P_4D

   subroutine dev_alloc_I8P_5D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I8P kind, rank 5.
   integer(I8P), intent(out), pointer :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(5)          !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                !< Error status.
   integer(I4P), intent(in), optional :: dev_id              !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(5)          !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value          !< Optional initial value.
   integer(I8P), pointer              :: fptr(:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(5) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I8P_5D

   subroutine dev_alloc_I8P_6D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I8P kind, rank 6.
   integer(I8P), intent(out), pointer :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(6)            !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                  !< Error status.
   integer(I4P), intent(in), optional :: dev_id                !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(6)            !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value            !< Optional initial value.
   integer(I8P), pointer              :: fptr(:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(6) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I8P_6D

   subroutine dev_alloc_I8P_7D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I8P kind, rank 7.
   integer(I8P), intent(out), pointer :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(7)              !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                    !< Error status.
   integer(I4P), intent(in), optional :: dev_id                  !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(7)              !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value              !< Optional initial value.
   integer(I8P), pointer              :: fptr(:,:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(7) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I8P_7D

   subroutine dev_alloc_I4P_1D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I4P kind, rank 1.
   integer(I4P), intent(out), pointer :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(1)  !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr        !< Error status.
   integer(I4P), intent(in), optional :: dev_id      !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(1)  !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value  !< Optional initial value.
   integer(I4P), pointer              :: fptr(:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(1) DEVICEVAR(fptr_dev)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1) = init_value
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine dev_alloc_I4P_1D

   subroutine dev_alloc_I4P_2D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I4P kind, rank 2.
   integer(I4P), intent(out), pointer :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(2)    !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr          !< Error status.
   integer(I4P), intent(in), optional :: dev_id        !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(2)    !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value    !< Optional initial value.
   integer(I4P), pointer              :: fptr(:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(2) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I4P_2D

   subroutine dev_alloc_I4P_3D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I4P kind, rank 3.
   integer(I4P), intent(out), pointer :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(3)      !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr            !< Error status.
   integer(I4P), intent(in), optional :: dev_id          !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(3)      !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value      !< Optional initial value.
   integer(I4P), pointer              :: fptr(:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(3) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I4P_3D

   subroutine dev_alloc_I4P_4D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I4P kind, rank 4.
   integer(I4P), intent(out), pointer :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(4)        !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr              !< Error status.
   integer(I4P), intent(in), optional :: dev_id            !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(4)        !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value        !< Optional initial value.
   integer(I4P), pointer              :: fptr(:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(4) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I4P_4D

   subroutine dev_alloc_I4P_5D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I4P kind, rank 5.
   integer(I4P), intent(out), pointer :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(5)          !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                !< Error status.
   integer(I4P), intent(in), optional :: dev_id              !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(5)          !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value          !< Optional initial value.
   integer(I4P), pointer              :: fptr(:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(5) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I4P_5D

   subroutine dev_alloc_I4P_6D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I4P kind, rank 6.
   integer(I4P), intent(out), pointer :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(6)            !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                  !< Error status.
   integer(I4P), intent(in), optional :: dev_id                !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(6)            !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value            !< Optional initial value.
   integer(I4P), pointer              :: fptr(:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(6) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I4P_6D

   subroutine dev_alloc_I4P_7D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I4P kind, rank 7.
   integer(I4P), intent(out), pointer :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(7)              !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                    !< Error status.
   integer(I4P), intent(in), optional :: dev_id                  !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(7)              !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value              !< Optional initial value.
   integer(I4P), pointer              :: fptr(:,:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(7) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I4P_7D

   subroutine dev_alloc_I1P_1D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I1P kind, rank 1.
   integer(I1P), intent(out), pointer :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(1)  !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr        !< Error status.
   integer(I4P), intent(in), optional :: dev_id      !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(1)  !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value  !< Optional initial value.
   integer(I1P), pointer              :: fptr(:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(1) DEVICEVAR(fptr_dev)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1) = init_value
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine dev_alloc_I1P_1D

   subroutine dev_alloc_I1P_2D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I1P kind, rank 2.
   integer(I1P), intent(out), pointer :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(2)    !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr          !< Error status.
   integer(I4P), intent(in), optional :: dev_id        !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(2)    !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value    !< Optional initial value.
   integer(I1P), pointer              :: fptr(:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(2) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I1P_2D

   subroutine dev_alloc_I1P_3D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I1P kind, rank 3.
   integer(I1P), intent(out), pointer :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(3)      !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr            !< Error status.
   integer(I4P), intent(in), optional :: dev_id          !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(3)      !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value      !< Optional initial value.
   integer(I1P), pointer              :: fptr(:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(3) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I1P_3D

   subroutine dev_alloc_I1P_4D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I1P kind, rank 4.
   integer(I1P), intent(out), pointer :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(4)        !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr              !< Error status.
   integer(I4P), intent(in), optional :: dev_id            !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(4)        !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value        !< Optional initial value.
   integer(I1P), pointer              :: fptr(:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(4) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I1P_4D

   subroutine dev_alloc_I1P_5D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I1P kind, rank 5.
   integer(I1P), intent(out), pointer :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(5)          !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                !< Error status.
   integer(I4P), intent(in), optional :: dev_id              !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(5)          !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value          !< Optional initial value.
   integer(I1P), pointer              :: fptr(:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(5) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I1P_5D

   subroutine dev_alloc_I1P_6D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I1P kind, rank 6.
   integer(I1P), intent(out), pointer :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(6)            !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                  !< Error status.
   integer(I4P), intent(in), optional :: dev_id                !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(6)            !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value            !< Optional initial value.
   integer(I1P), pointer              :: fptr(:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(6) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I1P_6D

   subroutine dev_alloc_I1P_7D(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value)
   !< Allocate array, I1P kind, rank 7.
   integer(I1P), intent(out), pointer :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(7)              !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                    !< Error status.
   integer(I4P), intent(in), optional :: dev_id                  !< Device ID (not used, necessary for unified OpenMP API).
   integer(I4P), intent(in), optional :: lbounds(7)              !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value              !< Optional initial value.
   integer(I1P), pointer              :: fptr(:,:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
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
         !$omp OMPLOOP collapse(7) DEVICEVAR(fptr_dev)
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
   endsubroutine dev_alloc_I1P_7D
endmodule fundal_dev_alloc
