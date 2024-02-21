!< FUNDAL, runtime memory library module.
module fundal
!< FUNDAL, runtime memory library module.
use openacc
use, intrinsic :: iso_c_binding
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64

implicit none

private
public :: oac_alloc
public :: oac_free
public :: oac_get_device_num
public :: oac_get_num_devices
public :: oac_init_device
public :: oac_memcpy_from_device
public :: oac_memcpy_to_device
public :: oac_set_device_num

integer(I4P), parameter, public :: FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED=101 !< Error flag, not allocated device memory.

interface
   ! public
   function oac_get_device_num(dev_type) bind(c, name="acc_get_device_num")
   use, intrinsic :: iso_fortran_env, only : I4P=>int32
   use openacc
   implicit none
   integer(I4P)             :: oac_get_device_num
   integer(acc_device_kind) :: dev_type
   endfunction oac_get_device_num

   function oac_get_num_devices(dev_type) bind(c, name="acc_get_num_devices")
   use, intrinsic :: iso_fortran_env, only : I4P=>int32
   use openacc
   implicit none
   integer(I4P)             :: oac_get_num_devices
   integer(acc_device_kind) :: dev_type
   endfunction oac_get_num_devices

   subroutine oac_init_device(dev_num, dev_type) bind(c, name="acc_init_device")
   use, intrinsic :: iso_fortran_env, only : I4P=>int32
   use openacc
   implicit none
   integer(I4P)             :: dev_num
   integer(acc_device_kind) :: dev_type
   endsubroutine oac_init_device

   subroutine oac_set_device_num(dev_num, dev_type) bind(c, name="acc_set_device_num")
   use, intrinsic :: iso_fortran_env, only : I4P=>int32
   use openacc
   implicit none
   integer(I4P)             :: dev_num
   integer(acc_device_kind) :: dev_type
   endsubroutine oac_set_device_num

   ! private
   ! interface to C runtime routines
   subroutine acc_free_f(dev_ptr) bind(c, name="acc_free")
   use iso_c_binding, only : c_ptr
   implicit none
   type(c_ptr), value :: dev_ptr
   endsubroutine acc_free_f

   function acc_malloc_f(total_byte_dim) bind(c, name="acc_malloc")
   use iso_c_binding, only : c_ptr, c_size_t
   implicit none
   type(c_ptr)                          :: acc_malloc_f
   integer(c_size_t), value, intent(in) :: total_byte_dim
   endfunction acc_malloc_f

   subroutine acc_memcpy_to_device_f(dev_ptr, host_ptr, total_byte_dim) bind(c, name="acc_memcpy_to_device")
   use iso_c_binding, only : c_ptr, c_size_t
   implicit none
   type(c_ptr),       value :: dev_ptr
   type(c_ptr),       value :: host_ptr
   integer(c_size_t), value :: total_byte_dim
   endsubroutine acc_memcpy_to_device_f

   subroutine acc_memcpy_from_device_f(host_ptr, dev_ptr, total_byte_dim) bind(c, name="acc_memcpy_from_device")
   use iso_c_binding, only : c_ptr, c_size_t
   implicit none
   type(c_ptr),       value :: host_ptr
   type(c_ptr),       value :: dev_ptr
   integer(c_size_t), value :: total_byte_dim
   endsubroutine acc_memcpy_from_device_f
endinterface

interface oac_alloc
   !< Allocate device memory.
   module procedure oac_alloc_R8P_1D,&
                    oac_alloc_R8P_2D,&
                    oac_alloc_R8P_3D,&
                    oac_alloc_R8P_4D,&
                    oac_alloc_R8P_5D,&
                    oac_alloc_R8P_6D,&
                    oac_alloc_R8P_7D,&
                    oac_alloc_R4P_1D,&
                    oac_alloc_R4P_2D,&
                    oac_alloc_R4P_3D,&
                    oac_alloc_R4P_4D,&
                    oac_alloc_R4P_5D,&
                    oac_alloc_R4P_6D,&
                    oac_alloc_R4P_7D,&
                    oac_alloc_I8P_1D,&
                    oac_alloc_I8P_2D,&
                    oac_alloc_I8P_3D,&
                    oac_alloc_I8P_4D,&
                    oac_alloc_I8P_5D,&
                    oac_alloc_I8P_6D,&
                    oac_alloc_I8P_7D,&
                    oac_alloc_I4P_1D,&
                    oac_alloc_I4P_2D,&
                    oac_alloc_I4P_3D,&
                    oac_alloc_I4P_4D,&
                    oac_alloc_I4P_5D,&
                    oac_alloc_I4P_6D,&
                    oac_alloc_I4P_7D,&
                    oac_alloc_I1P_1D,&
                    oac_alloc_I1P_2D,&
                    oac_alloc_I1P_3D,&
                    oac_alloc_I1P_4D,&
                    oac_alloc_I1P_5D,&
                    oac_alloc_I1P_6D,&
                    oac_alloc_I1P_7D
endinterface oac_alloc

interface oac_free
   !< Copy memory from device.
   module procedure oac_free_R8P_1D,&
                    oac_free_R8P_2D,&
                    oac_free_R8P_3D,&
                    oac_free_R8P_4D,&
                    oac_free_R8P_5D,&
                    oac_free_R8P_6D,&
                    oac_free_R8P_7D,&
                    oac_free_R4P_1D,&
                    oac_free_R4P_2D,&
                    oac_free_R4P_3D,&
                    oac_free_R4P_4D,&
                    oac_free_R4P_5D,&
                    oac_free_R4P_6D,&
                    oac_free_R4P_7D,&
                    oac_free_I8P_1D,&
                    oac_free_I8P_2D,&
                    oac_free_I8P_3D,&
                    oac_free_I8P_4D,&
                    oac_free_I8P_5D,&
                    oac_free_I8P_6D,&
                    oac_free_I8P_7D,&
                    oac_free_I4P_1D,&
                    oac_free_I4P_2D,&
                    oac_free_I4P_3D,&
                    oac_free_I4P_4D,&
                    oac_free_I4P_5D,&
                    oac_free_I4P_6D,&
                    oac_free_I4P_7D,&
                    oac_free_I1P_1D,&
                    oac_free_I1P_2D,&
                    oac_free_I1P_3D,&
                    oac_free_I1P_4D,&
                    oac_free_I1P_5D,&
                    oac_free_I1P_6D,&
                    oac_free_I1P_7D
endinterface oac_free

interface oac_memcpy_from_device
   !< Copy memory from device.
   module procedure oac_memcpy_from_device_R8P_1D,&
                    oac_memcpy_from_device_R8P_2D,&
                    oac_memcpy_from_device_R8P_3D,&
                    oac_memcpy_from_device_R8P_4D,&
                    oac_memcpy_from_device_R8P_5D,&
                    oac_memcpy_from_device_R8P_6D,&
                    oac_memcpy_from_device_R8P_7D,&
                    oac_memcpy_from_device_R4P_1D,&
                    oac_memcpy_from_device_R4P_2D,&
                    oac_memcpy_from_device_R4P_3D,&
                    oac_memcpy_from_device_R4P_4D,&
                    oac_memcpy_from_device_R4P_5D,&
                    oac_memcpy_from_device_R4P_6D,&
                    oac_memcpy_from_device_R4P_7D,&
                    oac_memcpy_from_device_I8P_1D,&
                    oac_memcpy_from_device_I8P_2D,&
                    oac_memcpy_from_device_I8P_3D,&
                    oac_memcpy_from_device_I8P_4D,&
                    oac_memcpy_from_device_I8P_5D,&
                    oac_memcpy_from_device_I8P_6D,&
                    oac_memcpy_from_device_I8P_7D,&
                    oac_memcpy_from_device_I4P_1D,&
                    oac_memcpy_from_device_I4P_2D,&
                    oac_memcpy_from_device_I4P_3D,&
                    oac_memcpy_from_device_I4P_4D,&
                    oac_memcpy_from_device_I4P_5D,&
                    oac_memcpy_from_device_I4P_6D,&
                    oac_memcpy_from_device_I4P_7D,&
                    oac_memcpy_from_device_I1P_1D,&
                    oac_memcpy_from_device_I1P_2D,&
                    oac_memcpy_from_device_I1P_3D,&
                    oac_memcpy_from_device_I1P_4D,&
                    oac_memcpy_from_device_I1P_5D,&
                    oac_memcpy_from_device_I1P_6D,&
                    oac_memcpy_from_device_I1P_7D
endinterface oac_memcpy_from_device

interface oac_memcpy_to_device
   !< Copy memory to device.
   module procedure oac_memcpy_to_device_R8P_1D,&
                    oac_memcpy_to_device_R8P_2D,&
                    oac_memcpy_to_device_R8P_3D,&
                    oac_memcpy_to_device_R8P_4D,&
                    oac_memcpy_to_device_R8P_5D,&
                    oac_memcpy_to_device_R8P_6D,&
                    oac_memcpy_to_device_R8P_7D,&
                    oac_memcpy_to_device_R4P_1D,&
                    oac_memcpy_to_device_R4P_2D,&
                    oac_memcpy_to_device_R4P_3D,&
                    oac_memcpy_to_device_R4P_4D,&
                    oac_memcpy_to_device_R4P_5D,&
                    oac_memcpy_to_device_R4P_6D,&
                    oac_memcpy_to_device_R4P_7D,&
                    oac_memcpy_to_device_I8P_1D,&
                    oac_memcpy_to_device_I8P_2D,&
                    oac_memcpy_to_device_I8P_3D,&
                    oac_memcpy_to_device_I8P_4D,&
                    oac_memcpy_to_device_I8P_5D,&
                    oac_memcpy_to_device_I8P_6D,&
                    oac_memcpy_to_device_I8P_7D,&
                    oac_memcpy_to_device_I4P_1D,&
                    oac_memcpy_to_device_I4P_2D,&
                    oac_memcpy_to_device_I4P_3D,&
                    oac_memcpy_to_device_I4P_4D,&
                    oac_memcpy_to_device_I4P_5D,&
                    oac_memcpy_to_device_I4P_6D,&
                    oac_memcpy_to_device_I4P_7D,&
                    oac_memcpy_to_device_I1P_1D,&
                    oac_memcpy_to_device_I1P_2D,&
                    oac_memcpy_to_device_I1P_3D,&
                    oac_memcpy_to_device_I1P_4D,&
                    oac_memcpy_to_device_I1P_5D,&
                    oac_memcpy_to_device_I1P_6D,&
                    oac_memcpy_to_device_I1P_7D
endinterface oac_memcpy_to_device

interface bytes_size
   !< Return bytes size of input array.
   module procedure bytes_size_R8P_1D,&
                    bytes_size_R8P_2D,&
                    bytes_size_R8P_3D,&
                    bytes_size_R8P_4D,&
                    bytes_size_R8P_5D,&
                    bytes_size_R8P_6D,&
                    bytes_size_R8P_7D,&
                    bytes_size_R4P_1D,&
                    bytes_size_R4P_2D,&
                    bytes_size_R4P_3D,&
                    bytes_size_R4P_4D,&
                    bytes_size_R4P_5D,&
                    bytes_size_R4P_6D,&
                    bytes_size_R4P_7D,&
                    bytes_size_I8P_1D,&
                    bytes_size_I8P_2D,&
                    bytes_size_I8P_3D,&
                    bytes_size_I8P_4D,&
                    bytes_size_I8P_5D,&
                    bytes_size_I8P_6D,&
                    bytes_size_I8P_7D,&
                    bytes_size_I4P_1D,&
                    bytes_size_I4P_2D,&
                    bytes_size_I4P_3D,&
                    bytes_size_I4P_4D,&
                    bytes_size_I4P_5D,&
                    bytes_size_I4P_6D,&
                    bytes_size_I4P_7D,&
                    bytes_size_I1P_1D,&
                    bytes_size_I1P_2D,&
                    bytes_size_I1P_3D,&
                    bytes_size_I1P_4D,&
                    bytes_size_I1P_5D,&
                    bytes_size_I1P_6D,&
                    bytes_size_I1P_7D
endinterface bytes_size

contains
   ! OpeanACC runtime memory rutines
   ! acc_malloc
   subroutine oac_alloc_R8P_1D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R8P kind, rank 1.
   real(R8P),    intent(out), pointer :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(1)  !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr        !< Error status.
   integer(I4P), intent(in), optional :: lbounds(1)  !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value  !< Optional initial value.
   real(R8P), pointer                 :: fptr(:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev    !< C pointer.
   integer(I8P)                       :: sizes(1)    !< Sizes.
   integer(I4P)                       :: lbounds_(1) !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes       !< Bytes of memory allocated.
   integer(I4P)                       :: i1          !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(1) deviceptr(fptr_dev)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1) = init_value
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine oac_alloc_R8P_1D

   subroutine oac_alloc_R8P_2D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R8P kind, rank 2.
   real(R8P),    intent(out), pointer :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(2)    !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr          !< Error status.
   integer(I4P), intent(in), optional :: lbounds(2)    !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value    !< Optional initial value.
   real(R8P), pointer                 :: fptr(:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev      !< C pointer.
   integer(I8P)                       :: sizes(2)      !< Sizes.
   integer(I4P)                       :: lbounds_(2)   !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes         !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2         !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(2) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_R8P_2D

   subroutine oac_alloc_R8P_3D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R8P kind, rank 3.
   real(R8P),    intent(out), pointer :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(3)      !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr            !< Error status.
   integer(I4P), intent(in), optional :: lbounds(3)      !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value      !< Optional initial value.
   real(R8P), pointer                 :: fptr(:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev        !< C pointer.
   integer(I8P)                       :: sizes(3)        !< Sizes.
   integer(I4P)                       :: lbounds_(3)     !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes           !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3        !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(3) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_R8P_3D

   subroutine oac_alloc_R8P_4D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R8P kind, rank 4.
   real(R8P),    intent(out), pointer :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(4)        !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr              !< Error status.
   integer(I4P), intent(in), optional :: lbounds(4)        !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value        !< Optional initial value.
   real(R8P), pointer                 :: fptr(:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev          !< C pointer.
   integer(I8P)                       :: sizes(4)          !< Sizes.
   integer(I4P)                       :: lbounds_(4)       !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes             !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4       !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(4) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_R8P_4D

   subroutine oac_alloc_R8P_5D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R8P kind, rank 5.
   real(R8P),    intent(out), pointer :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(5)          !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                !< Error status.
   integer(I4P), intent(in), optional :: lbounds(5)          !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value          !< Optional initial value.
   real(R8P), pointer                 :: fptr(:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev            !< C pointer.
   integer(I8P)                       :: sizes(5)            !< Sizes.
   integer(I4P)                       :: lbounds_(5)         !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes               !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5      !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(5) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_R8P_5D

   subroutine oac_alloc_R8P_6D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R8P kind, rank 6.
   real(R8P),    intent(out), pointer :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(6)            !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                  !< Error status.
   integer(I4P), intent(in), optional :: lbounds(6)            !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value            !< Optional initial value.
   real(R8P), pointer                 :: fptr(:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev              !< C pointer.
   integer(I8P)                       :: sizes(6)              !< Sizes.
   integer(I4P)                       :: lbounds_(6)           !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes                 !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6     !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):,lbounds_(6):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(6) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_R8P_6D

   subroutine oac_alloc_R8P_7D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R8P kind, rank 7.
   real(R8P),    intent(out), pointer :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(7)              !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                    !< Error status.
   integer(I4P), intent(in), optional :: lbounds(7)              !< Array lower bounds, 1 if not passed.
   real(R8P),    intent(in), optional :: init_value              !< Optional initial value.
   real(R8P), pointer                 :: fptr(:,:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev                !< C pointer.
   integer(I8P)                       :: sizes(7)                !< Sizes.
   integer(I4P)                       :: lbounds_(7)             !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes                   !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6,i7    !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):,lbounds_(6):,lbounds_(7):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(7) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_R8P_7D

   subroutine oac_alloc_R4P_1D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R4P kind, rank 1.
   real(R4P),    intent(out), pointer :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(1)  !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr        !< Error status.
   integer(I4P), intent(in), optional :: lbounds(1)  !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value  !< Optional initial value.
   real(R4P), pointer                 :: fptr(:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev    !< C pointer.
   integer(I8P)                       :: sizes(1)    !< Sizes.
   integer(I4P)                       :: lbounds_(1) !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes       !< Bytes of memory allocated.
   integer(I4P)                       :: i1          !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(1) deviceptr(fptr_dev)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1) = init_value
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine oac_alloc_R4P_1D

   subroutine oac_alloc_R4P_2D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R4P kind, rank 2.
   real(R4P),    intent(out), pointer :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(2)    !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr          !< Error status.
   integer(I4P), intent(in), optional :: lbounds(2)    !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value    !< Optional initial value.
   real(R4P), pointer                 :: fptr(:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev      !< C pointer.
   integer(I8P)                       :: sizes(2)      !< Sizes.
   integer(I4P)                       :: lbounds_(2)   !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes         !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2         !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(2) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_R4P_2D

   subroutine oac_alloc_R4P_3D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R4P kind, rank 3.
   real(R4P),    intent(out), pointer :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(3)      !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr            !< Error status.
   integer(I4P), intent(in), optional :: lbounds(3)      !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value      !< Optional initial value.
   real(R4P), pointer                 :: fptr(:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev        !< C pointer.
   integer(I8P)                       :: sizes(3)        !< Sizes.
   integer(I4P)                       :: lbounds_(3)     !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes           !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3        !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(3) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_R4P_3D

   subroutine oac_alloc_R4P_4D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R4P kind, rank 4.
   real(R4P),    intent(out), pointer :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(4)        !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr              !< Error status.
   integer(I4P), intent(in), optional :: lbounds(4)        !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value        !< Optional initial value.
   real(R4P), pointer                 :: fptr(:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev          !< C pointer.
   integer(I8P)                       :: sizes(4)          !< Sizes.
   integer(I4P)                       :: lbounds_(4)       !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes             !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4       !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(4) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_R4P_4D

   subroutine oac_alloc_R4P_5D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R4P kind, rank 5.
   real(R4P),    intent(out), pointer :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(5)          !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                !< Error status.
   integer(I4P), intent(in), optional :: lbounds(5)          !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value          !< Optional initial value.
   real(R4P), pointer                 :: fptr(:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev            !< C pointer.
   integer(I8P)                       :: sizes(5)            !< Sizes.
   integer(I4P)                       :: lbounds_(5)         !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes               !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5      !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(5) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_R4P_5D

   subroutine oac_alloc_R4P_6D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R4P kind, rank 6.
   real(R4P),    intent(out), pointer :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(6)            !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                  !< Error status.
   integer(I4P), intent(in), optional :: lbounds(6)            !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value            !< Optional initial value.
   real(R4P), pointer                 :: fptr(:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev              !< C pointer.
   integer(I8P)                       :: sizes(6)              !< Sizes.
   integer(I4P)                       :: lbounds_(6)           !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes                 !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6     !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):,lbounds_(6):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(6) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_R4P_6D

   subroutine oac_alloc_R4P_7D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, R4P kind, rank 7.
   real(R4P),    intent(out), pointer :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(7)              !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                    !< Error status.
   integer(I4P), intent(in), optional :: lbounds(7)              !< Array lower bounds, 1 if not passed.
   real(R4P),    intent(in), optional :: init_value              !< Optional initial value.
   real(R4P), pointer                 :: fptr(:,:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev                !< C pointer.
   integer(I8P)                       :: sizes(7)                !< Sizes.
   integer(I4P)                       :: lbounds_(7)             !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes                   !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6,i7    !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):,lbounds_(6):,lbounds_(7):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(7) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_R4P_7D

   subroutine oac_alloc_I8P_1D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I8P kind, rank 1.
   integer(I8P), intent(out), pointer :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(1)  !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr        !< Error status.
   integer(I4P), intent(in), optional :: lbounds(1)  !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value  !< Optional initial value.
   integer(I8P), pointer              :: fptr(:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev    !< C pointer.
   integer(I8P)                       :: sizes(1)    !< Sizes.
   integer(I4P)                       :: lbounds_(1) !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes       !< Bytes of memory allocated.
   integer(I4P)                       :: i1          !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(1) deviceptr(fptr_dev)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1) = init_value
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine oac_alloc_I8P_1D

   subroutine oac_alloc_I8P_2D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I8P kind, rank 2.
   integer(I8P), intent(out), pointer :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(2)    !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr          !< Error status.
   integer(I4P), intent(in), optional :: lbounds(2)    !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value    !< Optional initial value.
   integer(I8P), pointer              :: fptr(:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev      !< C pointer.
   integer(I8P)                       :: sizes(2)      !< Sizes.
   integer(I4P)                       :: lbounds_(2)   !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes         !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2         !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(2) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I8P_2D

   subroutine oac_alloc_I8P_3D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I8P kind, rank 3.
   integer(I8P), intent(out), pointer :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(3)      !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr            !< Error status.
   integer(I4P), intent(in), optional :: lbounds(3)      !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value      !< Optional initial value.
   integer(I8P), pointer              :: fptr(:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev        !< C pointer.
   integer(I8P)                       :: sizes(3)        !< Sizes.
   integer(I4P)                       :: lbounds_(3)     !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes           !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3        !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(3) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I8P_3D

   subroutine oac_alloc_I8P_4D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I8P kind, rank 4.
   integer(I8P), intent(out), pointer :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(4)        !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr              !< Error status.
   integer(I4P), intent(in), optional :: lbounds(4)        !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value        !< Optional initial value.
   integer(I8P), pointer              :: fptr(:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev          !< C pointer.
   integer(I8P)                       :: sizes(4)          !< Sizes.
   integer(I4P)                       :: lbounds_(4)       !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes             !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4       !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(4) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I8P_4D

   subroutine oac_alloc_I8P_5D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I8P kind, rank 5.
   integer(I8P), intent(out), pointer :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(5)          !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                !< Error status.
   integer(I4P), intent(in), optional :: lbounds(5)          !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value          !< Optional initial value.
   integer(I8P), pointer              :: fptr(:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev            !< C pointer.
   integer(I8P)                       :: sizes(5)            !< Sizes.
   integer(I4P)                       :: lbounds_(5)         !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes               !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5      !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(5) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I8P_5D

   subroutine oac_alloc_I8P_6D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I8P kind, rank 6.
   integer(I8P), intent(out), pointer :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(6)            !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                  !< Error status.
   integer(I4P), intent(in), optional :: lbounds(6)            !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value            !< Optional initial value.
   integer(I8P), pointer              :: fptr(:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev              !< C pointer.
   integer(I8P)                       :: sizes(6)              !< Sizes.
   integer(I4P)                       :: lbounds_(6)           !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes                 !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6     !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):,lbounds_(6):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(6) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I8P_6D

   subroutine oac_alloc_I8P_7D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I8P kind, rank 7.
   integer(I8P), intent(out), pointer :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(7)              !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                    !< Error status.
   integer(I4P), intent(in), optional :: lbounds(7)              !< Array lower bounds, 1 if not passed.
   integer(I8P), intent(in), optional :: init_value              !< Optional initial value.
   integer(I8P), pointer              :: fptr(:,:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev                !< C pointer.
   integer(I8P)                       :: sizes(7)                !< Sizes.
   integer(I4P)                       :: lbounds_(7)             !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes                   !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6,i7    !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):,lbounds_(6):,lbounds_(7):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(7) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I8P_7D

   subroutine oac_alloc_I4P_1D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I4P kind, rank 1.
   integer(I4P), intent(out), pointer :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(1)  !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr        !< Error status.
   integer(I4P), intent(in), optional :: lbounds(1)  !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value  !< Optional initial value.
   integer(I4P), pointer              :: fptr(:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev    !< C pointer.
   integer(I8P)                       :: sizes(1)    !< Sizes.
   integer(I4P)                       :: lbounds_(1) !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes       !< Bytes of memory allocated.
   integer(I4P)                       :: i1          !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(1) deviceptr(fptr_dev)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1) = init_value
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine oac_alloc_I4P_1D

   subroutine oac_alloc_I4P_2D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I4P kind, rank 2.
   integer(I4P), intent(out), pointer :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(2)    !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr          !< Error status.
   integer(I4P), intent(in), optional :: lbounds(2)    !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value    !< Optional initial value.
   integer(I4P), pointer              :: fptr(:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev      !< C pointer.
   integer(I8P)                       :: sizes(2)      !< Sizes.
   integer(I4P)                       :: lbounds_(2)   !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes         !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2         !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(2) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I4P_2D

   subroutine oac_alloc_I4P_3D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I4P kind, rank 3.
   integer(I4P), intent(out), pointer :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(3)      !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr            !< Error status.
   integer(I4P), intent(in), optional :: lbounds(3)      !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value      !< Optional initial value.
   integer(I4P), pointer              :: fptr(:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev        !< C pointer.
   integer(I8P)                       :: sizes(3)        !< Sizes.
   integer(I4P)                       :: lbounds_(3)     !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes           !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3        !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(3) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I4P_3D

   subroutine oac_alloc_I4P_4D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I4P kind, rank 4.
   integer(I4P), intent(out), pointer :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(4)        !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr              !< Error status.
   integer(I4P), intent(in), optional :: lbounds(4)        !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value        !< Optional initial value.
   integer(I4P), pointer              :: fptr(:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev          !< C pointer.
   integer(I8P)                       :: sizes(4)          !< Sizes.
   integer(I4P)                       :: lbounds_(4)       !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes             !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4       !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(4) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I4P_4D

   subroutine oac_alloc_I4P_5D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I4P kind, rank 5.
   integer(I4P), intent(out), pointer :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(5)          !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                !< Error status.
   integer(I4P), intent(in), optional :: lbounds(5)          !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value          !< Optional initial value.
   integer(I4P), pointer              :: fptr(:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev            !< C pointer.
   integer(I8P)                       :: sizes(5)            !< Sizes.
   integer(I4P)                       :: lbounds_(5)         !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes               !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5      !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(5) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I4P_5D

   subroutine oac_alloc_I4P_6D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I4P kind, rank 6.
   integer(I4P), intent(out), pointer :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(6)            !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                  !< Error status.
   integer(I4P), intent(in), optional :: lbounds(6)            !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value            !< Optional initial value.
   integer(I4P), pointer              :: fptr(:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev              !< C pointer.
   integer(I8P)                       :: sizes(6)              !< Sizes.
   integer(I4P)                       :: lbounds_(6)           !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes                 !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6     !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):,lbounds_(6):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(6) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I4P_6D

   subroutine oac_alloc_I4P_7D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I4P kind, rank 7.
   integer(I4P), intent(out), pointer :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(7)              !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                    !< Error status.
   integer(I4P), intent(in), optional :: lbounds(7)              !< Array lower bounds, 1 if not passed.
   integer(I4P), intent(in), optional :: init_value              !< Optional initial value.
   integer(I4P), pointer              :: fptr(:,:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev                !< C pointer.
   integer(I8P)                       :: sizes(7)                !< Sizes.
   integer(I4P)                       :: lbounds_(7)             !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes                   !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6,i7    !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):,lbounds_(6):,lbounds_(7):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(7) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I4P_7D

   subroutine oac_alloc_I1P_1D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I1P kind, rank 1.
   integer(I1P), intent(out), pointer :: fptr_dev(:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(1)  !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr        !< Error status.
   integer(I4P), intent(in), optional :: lbounds(1)  !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value  !< Optional initial value.
   integer(I1P), pointer              :: fptr(:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev    !< C pointer.
   integer(I8P)                       :: sizes(1)    !< Sizes.
   integer(I4P)                       :: lbounds_(1) !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes       !< Bytes of memory allocated.
   integer(I4P)                       :: i1          !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(1) deviceptr(fptr_dev)
         do i1=lbounds_(1), ubounds(1)
            fptr_dev(i1) = init_value
         enddo
      endif
   else
      fptr_dev => null()
      ierr = FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine oac_alloc_I1P_1D

   subroutine oac_alloc_I1P_2D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I1P kind, rank 2.
   integer(I1P), intent(out), pointer :: fptr_dev(:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(2)    !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr          !< Error status.
   integer(I4P), intent(in), optional :: lbounds(2)    !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value    !< Optional initial value.
   integer(I1P), pointer              :: fptr(:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev      !< C pointer.
   integer(I8P)                       :: sizes(2)      !< Sizes.
   integer(I4P)                       :: lbounds_(2)   !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes         !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2         !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(2) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I1P_2D

   subroutine oac_alloc_I1P_3D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I1P kind, rank 3.
   integer(I1P), intent(out), pointer :: fptr_dev(:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(3)      !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr            !< Error status.
   integer(I4P), intent(in), optional :: lbounds(3)      !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value      !< Optional initial value.
   integer(I1P), pointer              :: fptr(:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev        !< C pointer.
   integer(I8P)                       :: sizes(3)        !< Sizes.
   integer(I4P)                       :: lbounds_(3)     !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes           !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3        !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(3) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I1P_3D

   subroutine oac_alloc_I1P_4D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I1P kind, rank 4.
   integer(I1P), intent(out), pointer :: fptr_dev(:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(4)        !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr              !< Error status.
   integer(I4P), intent(in), optional :: lbounds(4)        !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value        !< Optional initial value.
   integer(I1P), pointer              :: fptr(:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev          !< C pointer.
   integer(I8P)                       :: sizes(4)          !< Sizes.
   integer(I4P)                       :: lbounds_(4)       !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes             !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4       !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(4) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I1P_4D

   subroutine oac_alloc_I1P_5D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I1P kind, rank 5.
   integer(I1P), intent(out), pointer :: fptr_dev(:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(5)          !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                !< Error status.
   integer(I4P), intent(in), optional :: lbounds(5)          !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value          !< Optional initial value.
   integer(I1P), pointer              :: fptr(:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev            !< C pointer.
   integer(I8P)                       :: sizes(5)            !< Sizes.
   integer(I4P)                       :: lbounds_(5)         !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes               !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5      !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(5) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I1P_5D

   subroutine oac_alloc_I1P_6D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I1P kind, rank 6.
   integer(I1P), intent(out), pointer :: fptr_dev(:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(6)            !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                  !< Error status.
   integer(I4P), intent(in), optional :: lbounds(6)            !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value            !< Optional initial value.
   integer(I1P), pointer              :: fptr(:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev              !< C pointer.
   integer(I8P)                       :: sizes(6)              !< Sizes.
   integer(I4P)                       :: lbounds_(6)           !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes                 !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6     !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):,lbounds_(6):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(6) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I1P_6D

   subroutine oac_alloc_I1P_7D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, I1P kind, rank 7.
   integer(I1P), intent(out), pointer :: fptr_dev(:,:,:,:,:,:,:) !< Pointer to allocated memory.
   integer(I4P), intent(in)           :: ubounds(7)              !< Array upper bounds.
   integer(I4P), intent(out)          :: ierr                    !< Error status.
   integer(I4P), intent(in), optional :: lbounds(7)              !< Array lower bounds, 1 if not passed.
   integer(I1P), intent(in), optional :: init_value              !< Optional initial value.
   integer(I1P), pointer              :: fptr(:,:,:,:,:,:,:)     !< Fortran pointer with lbounds=1.
   type(c_ptr)                        :: cptr_dev                !< C pointer.
   integer(I8P)                       :: sizes(7)                !< Sizes.
   integer(I4P)                       :: lbounds_(7)             !< Array lower bounds, local var.
   integer(c_size_t)                  :: bytes                   !< Bytes of memory allocated.
   integer(I4P)                       :: i1,i2,i3,i4,i5,i6,i7    !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = bytes_size(a=fptr_dev,sizes=sizes)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):,lbounds_(2):,lbounds_(3):,lbounds_(4):,lbounds_(5):,lbounds_(6):,lbounds_(7):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(7) deviceptr(fptr_dev)
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
   endsubroutine oac_alloc_I1P_7D

   ! acc_free
   subroutine oac_free_R8P_1D(fptr)
   !< Free real array from device, R8P kind, rank 1.
   real(R8P), intent(in), target :: fptr(:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R8P_1D

   subroutine oac_free_R8P_2D(fptr)
   !< Free real array from device, R8P kind, rank 2.
   real(R8P), intent(in), target :: fptr(:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R8P_2D

   subroutine oac_free_R8P_3D(fptr)
   !< Free real array from device, R8P kind, rank 3.
   real(R8P), intent(in), target :: fptr(:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R8P_3D

   subroutine oac_free_R8P_4D(fptr)
   !< Free real array from device, R8P kind, rank 4.
   real(R8P), intent(in), target :: fptr(:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R8P_4D

   subroutine oac_free_R8P_5D(fptr)
   !< Free real array from device, R8P kind, rank 5.
   real(R8P), intent(in), target :: fptr(:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R8P_5D

   subroutine oac_free_R8P_6D(fptr)
   !< Free real array from device, R8P kind, rank 6.
   real(R8P), intent(in), target :: fptr(:,:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R8P_6D

   subroutine oac_free_R8P_7D(fptr)
   !< Free real array from device, R8P kind, rank 7.
   real(R8P), intent(in),  target :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R8P_7D

   subroutine oac_free_R4P_1D(fptr)
   !< Copy real array from device, R4P kind, rank 1.
   real(R4P), intent(in), target :: fptr(:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R4P_1D

   subroutine oac_free_R4P_2D(fptr)
   !< Copy real array from device, R4P kind, rank 2.
   real(R4P), intent(in), target :: fptr(:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R4P_2D

   subroutine oac_free_R4P_3D(fptr)
   !< Copy real array from device, R4P kind, rank 3.
   real(R4P), intent(in), target :: fptr(:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R4P_3D

   subroutine oac_free_R4P_4D(fptr)
   !< Copy real array from device, R4P kind, rank 4.
   real(R4P), intent(in), target :: fptr(:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R4P_4D

   subroutine oac_free_R4P_5D(fptr)
   !< Copy real array from device, R4P kind, rank 5.
   real(R4P), intent(in), target :: fptr(:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R4P_5D

   subroutine oac_free_R4P_6D(fptr)
   !< Copy real array from device, R4P kind, rank 6.
   real(R4P), intent(in), target :: fptr(:,:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R4P_6D

   subroutine oac_free_R4P_7D(fptr)
   !< Copy real array from device, R4P kind, rank 7.
   real(R4P), intent(in), target :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_R4P_7D

   subroutine oac_free_I8P_1D(fptr)
   !< Copy real array from device, I8P kind, rank 1.
   integer(I8P), intent(in), target :: fptr(:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I8P_1D

   subroutine oac_free_I8P_2D(fptr)
   !< Copy real array from device, I8P kind, rank 2.
   integer(I8P), intent(in), target :: fptr(:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I8P_2D

   subroutine oac_free_I8P_3D(fptr)
   !< Copy real array from device, I8P kind, rank 3.
   integer(I8P), intent(in), target :: fptr(:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I8P_3D

   subroutine oac_free_I8P_4D(fptr)
   !< Copy real array from device, I8P kind, rank 4.
   integer(I8P), intent(in), target :: fptr(:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I8P_4D

   subroutine oac_free_I8P_5D(fptr)
   !< Copy real array from device, I8P kind, rank 5.
   integer(I8P), intent(in), target :: fptr(:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I8P_5D

   subroutine oac_free_I8P_6D(fptr)
   !< Copy real array from device, I8P kind, rank 6.
   integer(I8P), intent(in), target :: fptr(:,:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I8P_6D

   subroutine oac_free_I8P_7D(fptr)
   !< Copy real array from device, I8P kind, rank 7.
   integer(I8P), intent(in), target :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I8P_7D

   subroutine oac_free_I4P_1D(fptr)
   !< Copy real array from device, I4P kind, rank 1.
   integer(I4P), intent(in), target :: fptr(:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I4P_1D

   subroutine oac_free_I4P_2D(fptr)
   !< Copy real array from device, I4P kind, rank 2.
   integer(I4P), intent(in), target :: fptr(:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I4P_2D

   subroutine oac_free_I4P_3D(fptr)
   !< Copy real array from device, I4P kind, rank 3.
   integer(I4P), intent(in), target :: fptr(:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I4P_3D

   subroutine oac_free_I4P_4D(fptr)
   !< Copy real array from device, I4P kind, rank 4.
   integer(I4P), intent(in), target :: fptr(:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I4P_4D

   subroutine oac_free_I4P_5D(fptr)
   !< Copy real array from device, I4P kind, rank 5.
   integer(I4P), intent(in), target :: fptr(:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I4P_5D

   subroutine oac_free_I4P_6D(fptr)
   !< Copy real array from device, I4P kind, rank 6.
   integer(I4P), intent(in), target :: fptr(:,:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I4P_6D

   subroutine oac_free_I4P_7D(fptr)
   !< Copy real array from device, I4P kind, rank 7.
   integer(I4P), intent(in), target :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I4P_7D

   subroutine oac_free_I1P_1D(fptr)
   !< Copy real array from device, I1P kind, rank 1.
   integer(I1P), intent(in), target :: fptr(:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I1P_1D

   subroutine oac_free_I1P_2D(fptr)
   !< Copy real array from device, I1P kind, rank 2.
   integer(I1P), intent(in), target :: fptr(:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I1P_2D

   subroutine oac_free_I1P_3D(fptr)
   !< Copy real array from device, I1P kind, rank 3.
   integer(I1P), intent(in), target :: fptr(:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I1P_3D

   subroutine oac_free_I1P_4D(fptr)
   !< Copy real array from device, I1P kind, rank 4.
   integer(I1P), intent(in), target :: fptr(:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I1P_4D

   subroutine oac_free_I1P_5D(fptr)
   !< Copy real array from device, I1P kind, rank 5.
   integer(I1P), intent(in), target :: fptr(:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I1P_5D

   subroutine oac_free_I1P_6D(fptr)
   !< Copy real array from device, I1P kind, rank 6.
   integer(I1P), intent(in), target :: fptr(:,:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I1P_6D

   subroutine oac_free_I1P_7D(fptr)
   !< Copy real array from device, I1P kind, rank 7.
   integer(I1P), intent(in), target :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.

   call acc_free_f(c_loc(fptr))
   endsubroutine oac_free_I1P_7D

   ! acc_memcpy_from_device
   subroutine oac_memcpy_from_device_R8P_1D(fptr_src, fptr_dst)
   !< Copy real array from device, R8P kind, rank 1.
   real(R8P), intent(in),  target :: fptr_src(:) !< Source memory (device memory).
   real(R8P), intent(out), target :: fptr_dst(:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_1D

   subroutine oac_memcpy_from_device_R8P_2D(fptr_src, fptr_dst)
   !< Copy real array from device, R8P kind, rank 2.
   real(R8P), intent(in),  target :: fptr_src(:,:) !< Source memory (device memory).
   real(R8P), intent(out), target :: fptr_dst(:,:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_2D

   subroutine oac_memcpy_from_device_R8P_3D(fptr_src, fptr_dst)
   !< Copy real array from device, R8P kind, rank 3.
   real(R8P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (device memory).
   real(R8P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_3D

   subroutine oac_memcpy_from_device_R8P_4D(fptr_src, fptr_dst)
   !< Copy real array from device, R8P kind, rank 4.
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (device memory).
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_4D

   subroutine oac_memcpy_from_device_R8P_5D(fptr_src, fptr_dst)
   !< Copy real array from device, R8P kind, rank 5.
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (device memory).
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_5D

   subroutine oac_memcpy_from_device_R8P_6D(fptr_src, fptr_dst)
   !< Copy real array from device, R8P kind, rank 6.
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (device memory).
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_6D

   subroutine oac_memcpy_from_device_R8P_7D(fptr_src, fptr_dst)
   !< Copy real array from device, R8P kind, rank 7.
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (device memory).
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_7D

   subroutine oac_memcpy_from_device_R4P_1D(fptr_src, fptr_dst)
   !< Copy real array from device, R4P kind, rank 1.
   real(R4P), intent(in),  target :: fptr_src(:) !< Source memory (device memory).
   real(R4P), intent(out), target :: fptr_dst(:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_1D

   subroutine oac_memcpy_from_device_R4P_2D(fptr_src, fptr_dst)
   !< Copy real array from device, R4P kind, rank 2.
   real(R4P), intent(in),  target :: fptr_src(:,:) !< Source memory (device memory).
   real(R4P), intent(out), target :: fptr_dst(:,:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_2D

   subroutine oac_memcpy_from_device_R4P_3D(fptr_src, fptr_dst)
   !< Copy real array from device, R4P kind, rank 3.
   real(R4P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (device memory).
   real(R4P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_3D

   subroutine oac_memcpy_from_device_R4P_4D(fptr_src, fptr_dst)
   !< Copy real array from device, R4P kind, rank 4.
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (device memory).
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_4D

   subroutine oac_memcpy_from_device_R4P_5D(fptr_src, fptr_dst)
   !< Copy real array from device, R4P kind, rank 5.
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (device memory).
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_5D

   subroutine oac_memcpy_from_device_R4P_6D(fptr_src, fptr_dst)
   !< Copy real array from device, R4P kind, rank 6.
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (device memory).
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_6D

   subroutine oac_memcpy_from_device_R4P_7D(fptr_src, fptr_dst)
   !< Copy real array from device, R4P kind, rank 7.
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (device memory).
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_7D

   subroutine oac_memcpy_from_device_I8P_1D(fptr_src, fptr_dst)
   !< Copy real array from device, I8P kind, rank 1.
   integer(I8P), intent(in),  target :: fptr_src(:) !< Source memory (device memory).
   integer(I8P), intent(out), target :: fptr_dst(:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_1D

   subroutine oac_memcpy_from_device_I8P_2D(fptr_src, fptr_dst)
   !< Copy real array from device, I8P kind, rank 2.
   integer(I8P), intent(in),  target :: fptr_src(:,:) !< Source memory (device memory).
   integer(I8P), intent(out), target :: fptr_dst(:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_2D

   subroutine oac_memcpy_from_device_I8P_3D(fptr_src, fptr_dst)
   !< Copy real array from device, I8P kind, rank 3.
   integer(I8P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (device memory).
   integer(I8P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_3D

   subroutine oac_memcpy_from_device_I8P_4D(fptr_src, fptr_dst)
   !< Copy real array from device, I8P kind, rank 4.
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (device memory).
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_4D

   subroutine oac_memcpy_from_device_I8P_5D(fptr_src, fptr_dst)
   !< Copy real array from device, I8P kind, rank 5.
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (device memory).
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_5D

   subroutine oac_memcpy_from_device_I8P_6D(fptr_src, fptr_dst)
   !< Copy real array from device, I8P kind, rank 6.
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_6D

   subroutine oac_memcpy_from_device_I8P_7D(fptr_src, fptr_dst)
   !< Copy real array from device, I8P kind, rank 7.
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_7D

   subroutine oac_memcpy_from_device_I4P_1D(fptr_src, fptr_dst)
   !< Copy real array from device, I4P kind, rank 1.
   integer(I4P), intent(in),  target :: fptr_src(:) !< Source memory (device memory).
   integer(I4P), intent(out), target :: fptr_dst(:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_1D

   subroutine oac_memcpy_from_device_I4P_2D(fptr_src, fptr_dst)
   !< Copy real array from device, I4P kind, rank 2.
   integer(I4P), intent(in),  target :: fptr_src(:,:) !< Source memory (device memory).
   integer(I4P), intent(out), target :: fptr_dst(:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_2D

   subroutine oac_memcpy_from_device_I4P_3D(fptr_src, fptr_dst)
   !< Copy real array from device, I4P kind, rank 3.
   integer(I4P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (device memory).
   integer(I4P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_3D

   subroutine oac_memcpy_from_device_I4P_4D(fptr_src, fptr_dst)
   !< Copy real array from device, I4P kind, rank 4.
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (device memory).
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_4D

   subroutine oac_memcpy_from_device_I4P_5D(fptr_src, fptr_dst)
   !< Copy real array from device, I4P kind, rank 5.
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (device memory).
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_5D

   subroutine oac_memcpy_from_device_I4P_6D(fptr_src, fptr_dst)
   !< Copy real array from device, I4P kind, rank 6.
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_6D

   subroutine oac_memcpy_from_device_I4P_7D(fptr_src, fptr_dst)
   !< Copy real array from device, I4P kind, rank 7.
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_7D

   subroutine oac_memcpy_from_device_I1P_1D(fptr_src, fptr_dst)
   !< Copy real array from device, I1P kind, rank 1.
   integer(I1P), intent(in),  target :: fptr_src(:) !< Source memory (device memory).
   integer(I1P), intent(out), target :: fptr_dst(:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_1D

   subroutine oac_memcpy_from_device_I1P_2D(fptr_src, fptr_dst)
   !< Copy real array from device, I1P kind, rank 2.
   integer(I1P), intent(in),  target :: fptr_src(:,:) !< Source memory (device memory).
   integer(I1P), intent(out), target :: fptr_dst(:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_2D

   subroutine oac_memcpy_from_device_I1P_3D(fptr_src, fptr_dst)
   !< Copy real array from device, I1P kind, rank 3.
   integer(I1P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (device memory).
   integer(I1P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_3D

   subroutine oac_memcpy_from_device_I1P_4D(fptr_src, fptr_dst)
   !< Copy real array from device, I1P kind, rank 4.
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (device memory).
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_4D

   subroutine oac_memcpy_from_device_I1P_5D(fptr_src, fptr_dst)
   !< Copy real array from device, I1P kind, rank 5.
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (device memory).
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_5D

   subroutine oac_memcpy_from_device_I1P_6D(fptr_src, fptr_dst)
   !< Copy real array from device, I1P kind, rank 6.
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_6D

   subroutine oac_memcpy_from_device_I1P_7D(fptr_src, fptr_dst)
   !< Copy real array from device, I1P kind, rank 7.
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   integer(c_size_t)                 :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_7D

   ! acc_memcpy_to_device
   subroutine oac_memcpy_to_device_R8P_1D(fptr_src, fptr_dst)
   !< Copy real array to device, R8P kind, rank 1.
   real(R8P), intent(in),  target :: fptr_src(:) !< Source memory (host memory).
   real(R8P), intent(out), target :: fptr_dst(:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_1D

   subroutine oac_memcpy_to_device_R8P_2D(fptr_src, fptr_dst)
   !< Copy real array to device, R8P kind, rank 2.
   real(R8P), intent(in),  target :: fptr_src(:,:) !< Source memory (host memory).
   real(R8P), intent(out), target :: fptr_dst(:,:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_2D

   subroutine oac_memcpy_to_device_R8P_3D(fptr_src, fptr_dst)
   !< Copy real array to device, R8P kind, rank 3.
   real(R8P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (host memory).
   real(R8P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_3D

   subroutine oac_memcpy_to_device_R8P_4D(fptr_src, fptr_dst)
   !< Copy real array to device, R8P kind, rank 4.
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (host memory).
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_4D

   subroutine oac_memcpy_to_device_R8P_5D(fptr_src, fptr_dst)
   !< Copy real array to device, R8P kind, rank 5.
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (host memory).
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_5D

   subroutine oac_memcpy_to_device_R8P_6D(fptr_src, fptr_dst)
   !< Copy real array to device, R8P kind, rank 6.
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (host memory).
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_6D

   subroutine oac_memcpy_to_device_R8P_7D(fptr_src, fptr_dst)
   !< Copy real array to device, R8P kind, rank 7.
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (host memory).
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_7D

   subroutine oac_memcpy_to_device_R4P_1D(fptr_src, fptr_dst)
   !< Copy real array to device, R4P kind, rank 1.
   real(R4P), intent(in),  target :: fptr_src(:) !< Source memory (host memory).
   real(R4P), intent(out), target :: fptr_dst(:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_1D

   subroutine oac_memcpy_to_device_R4P_2D(fptr_src, fptr_dst)
   !< Copy real array to device, R4P kind, rank 2.
   real(R4P), intent(in),  target :: fptr_src(:,:) !< Source memory (host memory).
   real(R4P), intent(out), target :: fptr_dst(:,:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_2D

   subroutine oac_memcpy_to_device_R4P_3D(fptr_src, fptr_dst)
   !< Copy real array to device, R4P kind, rank 3.
   real(R4P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (host memory).
   real(R4P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_3D

   subroutine oac_memcpy_to_device_R4P_4D(fptr_src, fptr_dst)
   !< Copy real array to device, R4P kind, rank 4.
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (host memory).
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_4D

   subroutine oac_memcpy_to_device_R4P_5D(fptr_src, fptr_dst)
   !< Copy real array to device, R4P kind, rank 5.
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (host memory).
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_5D

   subroutine oac_memcpy_to_device_R4P_6D(fptr_src, fptr_dst)
   !< Copy real array to device, R4P kind, rank 6.
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (host memory).
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_6D

   subroutine oac_memcpy_to_device_R4P_7D(fptr_src, fptr_dst)
   !< Copy real array to device, R4P kind, rank 7.
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (host memory).
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_7D

   subroutine oac_memcpy_to_device_I8P_1D(fptr_src, fptr_dst)
   !< Copy real array to device, I8P kind, rank 1.
   integer(I8P), intent(in),  target :: fptr_src(:) !< Source memory (host memory).
   integer(I8P), intent(out), target :: fptr_dst(:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_1D

   subroutine oac_memcpy_to_device_I8P_2D(fptr_src, fptr_dst)
   !< Copy real array to device, I8P kind, rank 2.
   integer(I8P), intent(in),  target :: fptr_src(:,:) !< Source memory (host memory).
   integer(I8P), intent(out), target :: fptr_dst(:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_2D

   subroutine oac_memcpy_to_device_I8P_3D(fptr_src, fptr_dst)
   !< Copy real array to device, I8P kind, rank 3.
   integer(I8P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (host memory).
   integer(I8P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_3D

   subroutine oac_memcpy_to_device_I8P_4D(fptr_src, fptr_dst)
   !< Copy real array to device, I8P kind, rank 4.
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (host memory).
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_4D

   subroutine oac_memcpy_to_device_I8P_5D(fptr_src, fptr_dst)
   !< Copy real array to device, I8P kind, rank 5.
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (host memory).
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_5D

   subroutine oac_memcpy_to_device_I8P_6D(fptr_src, fptr_dst)
   !< Copy real array to device, I8P kind, rank 6.
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_6D

   subroutine oac_memcpy_to_device_I8P_7D(fptr_src, fptr_dst)
   !< Copy real array to device, I8P kind, rank 7.
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_7D

   subroutine oac_memcpy_to_device_I4P_1D(fptr_src, fptr_dst)
   !< Copy real array to device, I4P kind, rank 1.
   integer(I4P), intent(in),  target :: fptr_src(:) !< Source memory (host memory).
   integer(I4P), intent(out), target :: fptr_dst(:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_1D

   subroutine oac_memcpy_to_device_I4P_2D(fptr_src, fptr_dst)
   !< Copy real array to device, I4P kind, rank 2.
   integer(I4P), intent(in),  target :: fptr_src(:,:) !< Source memory (host memory).
   integer(I4P), intent(out), target :: fptr_dst(:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_2D

   subroutine oac_memcpy_to_device_I4P_3D(fptr_src, fptr_dst)
   !< Copy real array to device, I4P kind, rank 3.
   integer(I4P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (host memory).
   integer(I4P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_3D

   subroutine oac_memcpy_to_device_I4P_4D(fptr_src, fptr_dst)
   !< Copy real array to device, I4P kind, rank 4.
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (host memory).
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_4D

   subroutine oac_memcpy_to_device_I4P_5D(fptr_src, fptr_dst)
   !< Copy real array to device, I4P kind, rank 5.
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (host memory).
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_5D

   subroutine oac_memcpy_to_device_I4P_6D(fptr_src, fptr_dst)
   !< Copy real array to device, I4P kind, rank 6.
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_6D

   subroutine oac_memcpy_to_device_I4P_7D(fptr_src, fptr_dst)
   !< Copy real array to device, I4P kind, rank 7.
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_7D

   subroutine oac_memcpy_to_device_I1P_1D(fptr_src, fptr_dst)
   !< Copy real array to device, I1P kind, rank 1.
   integer(I1P), intent(in),  target :: fptr_src(:) !< Source memory (host memory).
   integer(I1P), intent(out), target :: fptr_dst(:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_1D

   subroutine oac_memcpy_to_device_I1P_2D(fptr_src, fptr_dst)
   !< Copy real array to device, I1P kind, rank 2.
   integer(I1P), intent(in),  target :: fptr_src(:,:) !< Source memory (host memory).
   integer(I1P), intent(out), target :: fptr_dst(:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_2D

   subroutine oac_memcpy_to_device_I1P_3D(fptr_src, fptr_dst)
   !< Copy real array to device, I1P kind, rank 3.
   integer(I1P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (host memory).
   integer(I1P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_3D

   subroutine oac_memcpy_to_device_I1P_4D(fptr_src, fptr_dst)
   !< Copy real array to device, I1P kind, rank 4.
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (host memory).
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_4D

   subroutine oac_memcpy_to_device_I1P_5D(fptr_src, fptr_dst)
   !< Copy real array to device, I1P kind, rank 5.
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (host memory).
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_5D

   subroutine oac_memcpy_to_device_I1P_6D(fptr_src, fptr_dst)
   !< Copy real array to device, I1P kind, rank 6.
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_6D

   subroutine oac_memcpy_to_device_I1P_7D(fptr_src, fptr_dst)
   !< Copy real array to device, I1P kind, rank 7.
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   integer(c_size_t)                 :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_7D

   ! auxiliary rutines
   ! bytes_size
   function bytes_size_R8P_1D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 1.
   real(R8P),    intent(in), target   :: a(:)     !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_1D

   function bytes_size_R8P_2D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 2.
   real(R8P),    intent(in), target   :: a(:,:)   !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_2D

   function bytes_size_R8P_3D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 3.
   real(R8P),    intent(in), target   :: a(:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_3D

   function bytes_size_R8P_4D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 4.
   real(R8P),    intent(in), target   :: a(:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)   !< Sizes.
   integer(c_size_t)                  :: bytes      !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_4D

   function bytes_size_R8P_5D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 5.
   real(R8P),    intent(in), target   :: a(:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)     !< Sizes.
   integer(c_size_t)                  :: bytes        !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_5D

   function bytes_size_R8P_6D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 6.
   real(R8P),    intent(in), target   :: a(:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)       !< Sizes.
   integer(c_size_t)                  :: bytes          !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_6D

   function bytes_size_R8P_7D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 7.
   real(R8P),    intent(in), target   :: a(:,:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)         !< Sizes.
   integer(c_size_t)                  :: bytes            !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_7D

   function bytes_size_R4P_1D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 1.
   real(R4P),    intent(in), target   :: a(:)     !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_1D

   function bytes_size_R4P_2D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 2.
   real(R4P),    intent(in), target   :: a(:,:)   !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_2D

   function bytes_size_R4P_3D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 3.
   real(R4P),    intent(in), target   :: a(:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_3D

   function bytes_size_R4P_4D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 4.
   real(R4P),    intent(in), target   :: a(:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)   !< Sizes.
   integer(c_size_t)                  :: bytes      !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_4D

   function bytes_size_R4P_5D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 5.
   real(R4P),    intent(in), target   :: a(:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)     !< Sizes.
   integer(c_size_t)                  :: bytes        !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_5D

   function bytes_size_R4P_6D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 6.
   real(R4P),    intent(in), target   :: a(:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)       !< Sizes.
   integer(c_size_t)                  :: bytes          !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_6D

   function bytes_size_R4P_7D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 7.
   real(R4P),    intent(in), target   :: a(:,:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)         !< Sizes.
   integer(c_size_t)                  :: bytes            !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_7D

   function bytes_size_I8P_1D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 1.
   integer(I8P), intent(in), target   :: a(:)     !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_1D

   function bytes_size_I8P_2D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 2.
   integer(I8P), intent(in), target   :: a(:,:)   !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_2D

   function bytes_size_I8P_3D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 3.
   integer(I8P), intent(in), target   :: a(:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_3D

   function bytes_size_I8P_4D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 4.
   integer(I8P), intent(in), target   :: a(:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)   !< Sizes.
   integer(c_size_t)                  :: bytes      !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_4D

   function bytes_size_I8P_5D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 5.
   integer(I8P), intent(in), target   :: a(:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)     !< Sizes.
   integer(c_size_t)                  :: bytes        !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_5D

   function bytes_size_I8P_6D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 6.
   integer(I8P), intent(in), target   :: a(:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)       !< Sizes.
   integer(c_size_t)                  :: bytes          !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_6D

   function bytes_size_I8P_7D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 7.
   integer(I8P), intent(in), target   :: a(:,:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)         !< Sizes.
   integer(c_size_t)                  :: bytes            !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_7D

   function bytes_size_I4P_1D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 1.
   integer(I4P), intent(in), target   :: a(:)     !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_1D

   function bytes_size_I4P_2D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 2.
   integer(I4P), intent(in), target   :: a(:,:)   !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_2D

   function bytes_size_I4P_3D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 3.
   integer(I4P), intent(in), target   :: a(:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_3D

   function bytes_size_I4P_4D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 4.
   integer(I4P), intent(in), target   :: a(:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)   !< Sizes.
   integer(c_size_t)                  :: bytes      !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_4D

   function bytes_size_I4P_5D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 5.
   integer(I4P), intent(in), target   :: a(:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)     !< Sizes.
   integer(c_size_t)                  :: bytes        !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_5D

   function bytes_size_I4P_6D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 6.
   integer(I4P), intent(in), target   :: a(:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)       !< Sizes.
   integer(c_size_t)                  :: bytes          !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_6D

   function bytes_size_I4P_7D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 7.
   integer(I4P), intent(in), target   :: a(:,:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)         !< Sizes.
   integer(c_size_t)                  :: bytes            !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_7D

   function bytes_size_I1P_1D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 1.
   integer(I1P), intent(in), target   :: a(:)     !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_1D

   function bytes_size_I1P_2D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 2.
   integer(I1P), intent(in), target   :: a(:,:)   !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_2D

   function bytes_size_I1P_3D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 3.
   integer(I1P), intent(in), target   :: a(:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_3D

   function bytes_size_I1P_4D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 4.
   integer(I1P), intent(in), target   :: a(:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)   !< Sizes.
   integer(c_size_t)                  :: bytes      !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_4D

   function bytes_size_I1P_5D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 5.
   integer(I1P), intent(in), target   :: a(:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)     !< Sizes.
   integer(c_size_t)                  :: bytes        !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_5D

   function bytes_size_I1P_6D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 6.
   integer(I1P), intent(in), target   :: a(:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)       !< Sizes.
   integer(c_size_t)                  :: bytes          !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_6D

   function bytes_size_I1P_7D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 7.
   integer(I1P), intent(in), target   :: a(:,:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)         !< Sizes.
   integer(c_size_t)                  :: bytes            !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_7D
endmodule fundal
