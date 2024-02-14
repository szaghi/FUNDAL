!< OAFML, runtime memory library module.
module oafml
!< OAFML, runtime memory library module.
use openacc
use, intrinsic :: iso_c_binding
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64

implicit none

private
public :: oac_alloc
public :: oac_memcpy_from_device
public :: oac_memcpy_to_device

integer(I4P), parameter, public :: OAFML_ERR_FPTR_DEV_NOT_ALLOCATED=101 !< Error flag, not allocated device memory.

interface
   ! interface to C runtime routines
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
   module procedure oac_alloc_R8P_1D
endinterface oac_alloc

interface oac_memcpy_from_device
   !< Copy memory from device.
   module procedure oac_memcpy_from_device_R8P_1D
endinterface oac_memcpy_from_device

interface oac_memcpy_to_device
   !< Copy memory to device.
   module procedure oac_memcpy_to_device_R8P_1D
endinterface oac_memcpy_to_device

contains
   subroutine oac_alloc_R8P_1D(fptr_dev, ubounds, ierr, lbounds, init_value)
   !< Allocate real array, rank 1, R8P kind.
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
   integer(I4P)                       :: i           !< Counter.

   ierr = 0
   lbounds_ = 1 ; if (present(lbounds)) lbounds_ = lbounds
   sizes = ubounds - lbounds_ + 1
   bytes = int(storage_size(fptr_dev,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   cptr_dev = acc_malloc_f(bytes)
   if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):) => fptr
      if (present(init_value)) then
         !$acc parallel loop collapse(1) deviceptr(fptr_dev)
         do i=lbounds_(1), ubounds(1)
            fptr_dev(i) = init_value
         enddo
      endif
   else
      fptr_dev => null()
      ierr = OAFML_ERR_FPTR_DEV_NOT_ALLOCATED
   endif
   endsubroutine oac_alloc_R8P_1D

   subroutine oac_memcpy_from_device_R8P_1D(fptr_src, fptr_dst)
   !< Copy real array from device, rank 1, R8P kind.
   real(R8P), intent(in) , target :: fptr_src(:) !< Source memory (device memory).
   real(R8P), intent(out), target :: fptr_dst(:) !< Destination memory (host memory).
   integer(c_size_t)              :: bytes       !< Bytes of memory copied.

   bytes = int(storage_size(fptr_src,kind=I8P)/8_I8P, c_size_t) * int(size(fptr_src), c_size_t)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_1D

   subroutine oac_memcpy_to_device_R8P_1D(fptr_src, fptr_dst)
   !< Copy real array to device, rank 1, R8P kind.
   real(R8P), intent(in) , target :: fptr_src(:) !< Source memory (host memory).
   real(R8P), intent(out), target :: fptr_dst(:) !< Destination memory (device memory).
   integer(c_size_t)              :: bytes       !< Bytes of memory copied.

   bytes = int(storage_size(fptr_src,kind=I8P)/8_I8P, c_size_t) * int(size(fptr_src), c_size_t)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_1D
endmodule oafml
