!< FUNDAL, memory copy routines module for OpenACC backend.
module fundal_oac_memcpy
!< FUNDAL, memory copy routines module for OpenACC backend.
use, intrinsic :: iso_c_binding
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: openacc
use            :: fundal_utilities

implicit none
private
public :: oac_memcpy_from_device
public :: oac_memcpy_to_device

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

interface
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

contains
   ! acc_memcpy_from_device
   subroutine oac_memcpy_from_device_R8P_1D(fptr_dst, fptr_src)
   !< Copy array from device, R8P kind, rank 1.
   real(R8P), intent(out), target :: fptr_dst(:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: fptr_src(:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_1D

   subroutine oac_memcpy_from_device_R8P_2D(fptr_dst, fptr_src)
   !< Copy array from device, R8P kind, rank 2.
   real(R8P), intent(out), target :: fptr_dst(:,:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: fptr_src(:,:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_2D

   subroutine oac_memcpy_from_device_R8P_3D(fptr_dst, fptr_src)
   !< Copy array from device, R8P kind, rank 3.
   real(R8P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_3D

   subroutine oac_memcpy_from_device_R8P_4D(fptr_dst, fptr_src)
   !< Copy array from device, R8P kind, rank 4.
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_4D

   subroutine oac_memcpy_from_device_R8P_5D(fptr_dst, fptr_src)
   !< Copy array from device, R8P kind, rank 5.
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_5D

   subroutine oac_memcpy_from_device_R8P_6D(fptr_dst, fptr_src)
   !< Copy array from device, R8P kind, rank 6.
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_6D

   subroutine oac_memcpy_from_device_R8P_7D(fptr_dst, fptr_src)
   !< Copy array from device, R8P kind, rank 7.
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R8P_7D

   subroutine oac_memcpy_from_device_R4P_1D(fptr_dst, fptr_src)
   !< Copy array from device, R4P kind, rank 1.
   real(R4P), intent(out), target :: fptr_dst(:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: fptr_src(:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_1D

   subroutine oac_memcpy_from_device_R4P_2D(fptr_dst, fptr_src)
   !< Copy array from device, R4P kind, rank 2.
   real(R4P), intent(out), target :: fptr_dst(:,:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: fptr_src(:,:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_2D

   subroutine oac_memcpy_from_device_R4P_3D(fptr_dst, fptr_src)
   !< Copy array from device, R4P kind, rank 3.
   real(R4P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_3D

   subroutine oac_memcpy_from_device_R4P_4D(fptr_dst, fptr_src)
   !< Copy array from device, R4P kind, rank 4.
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_4D

   subroutine oac_memcpy_from_device_R4P_5D(fptr_dst, fptr_src)
   !< Copy array from device, R4P kind, rank 5.
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_5D

   subroutine oac_memcpy_from_device_R4P_6D(fptr_dst, fptr_src)
   !< Copy array from device, R4P kind, rank 6.
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_6D

   subroutine oac_memcpy_from_device_R4P_7D(fptr_dst, fptr_src)
   !< Copy array from device, R4P kind, rank 7.
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)              :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_R4P_7D

   subroutine oac_memcpy_from_device_I8P_1D(fptr_dst, fptr_src)
   !< Copy array from device, I8P kind, rank 1.
   integer(I8P), intent(out), target :: fptr_dst(:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: fptr_src(:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_1D

   subroutine oac_memcpy_from_device_I8P_2D(fptr_dst, fptr_src)
   !< Copy array from device, I8P kind, rank 2.
   integer(I8P), intent(out), target :: fptr_dst(:,:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: fptr_src(:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_2D

   subroutine oac_memcpy_from_device_I8P_3D(fptr_dst, fptr_src)
   !< Copy array from device, I8P kind, rank 3.
   integer(I8P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_3D

   subroutine oac_memcpy_from_device_I8P_4D(fptr_dst, fptr_src)
   !< Copy array from device, I8P kind, rank 4.
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_4D

   subroutine oac_memcpy_from_device_I8P_5D(fptr_dst, fptr_src)
   !< Copy array from device, I8P kind, rank 5.
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_5D

   subroutine oac_memcpy_from_device_I8P_6D(fptr_dst, fptr_src)
   !< Copy array from device, I8P kind, rank 6.
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_6D

   subroutine oac_memcpy_from_device_I8P_7D(fptr_dst, fptr_src)
   !< Copy array from device, I8P kind, rank 7.
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I8P_7D

   subroutine oac_memcpy_from_device_I4P_1D(fptr_dst, fptr_src)
   !< Copy array from device, I4P kind, rank 1.
   integer(I4P), intent(out), target :: fptr_dst(:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: fptr_src(:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_1D

   subroutine oac_memcpy_from_device_I4P_2D(fptr_dst, fptr_src)
   !< Copy array from device, I4P kind, rank 2.
   integer(I4P), intent(out), target :: fptr_dst(:,:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: fptr_src(:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_2D

   subroutine oac_memcpy_from_device_I4P_3D(fptr_dst, fptr_src)
   !< Copy array from device, I4P kind, rank 3.
   integer(I4P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_3D

   subroutine oac_memcpy_from_device_I4P_4D(fptr_dst, fptr_src)
   !< Copy array from device, I4P kind, rank 4.
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_4D

   subroutine oac_memcpy_from_device_I4P_5D(fptr_dst, fptr_src)
   !< Copy array from device, I4P kind, rank 5.
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_5D

   subroutine oac_memcpy_from_device_I4P_6D(fptr_dst, fptr_src)
   !< Copy array from device, I4P kind, rank 6.
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_6D

   subroutine oac_memcpy_from_device_I4P_7D(fptr_dst, fptr_src)
   !< Copy array from device, I4P kind, rank 7.
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I4P_7D

   subroutine oac_memcpy_from_device_I1P_1D(fptr_dst, fptr_src)
   !< Copy array from device, I1P kind, rank 1.
   integer(I1P), intent(out), target :: fptr_dst(:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: fptr_src(:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_1D

   subroutine oac_memcpy_from_device_I1P_2D(fptr_dst, fptr_src)
   !< Copy array from device, I1P kind, rank 2.
   integer(I1P), intent(out), target :: fptr_dst(:,:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: fptr_src(:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_2D

   subroutine oac_memcpy_from_device_I1P_3D(fptr_dst, fptr_src)
   !< Copy array from device, I1P kind, rank 3.
   integer(I1P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_3D

   subroutine oac_memcpy_from_device_I1P_4D(fptr_dst, fptr_src)
   !< Copy array from device, I1P kind, rank 4.
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_4D

   subroutine oac_memcpy_from_device_I1P_5D(fptr_dst, fptr_src)
   !< Copy array from device, I1P kind, rank 5.
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_5D

   subroutine oac_memcpy_from_device_I1P_6D(fptr_dst, fptr_src)
   !< Copy array from device, I1P kind, rank 6.
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_6D

   subroutine oac_memcpy_from_device_I1P_7D(fptr_dst, fptr_src)
   !< Copy array from device, I1P kind, rank 7.
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(c_size_t)                 :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_from_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_from_device_I1P_7D

   ! acc_memcpy_to_device
   subroutine oac_memcpy_to_device_R8P_1D(fptr_dst, fptr_src)
   !< Copy array to device, R8P kind, rank 1.
   real(R8P), intent(out), target :: fptr_dst(:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: fptr_src(:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_1D

   subroutine oac_memcpy_to_device_R8P_2D(fptr_dst, fptr_src)
   !< Copy array to device, R8P kind, rank 2.
   real(R8P), intent(out), target :: fptr_dst(:,:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: fptr_src(:,:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_2D

   subroutine oac_memcpy_to_device_R8P_3D(fptr_dst, fptr_src)
   !< Copy array to device, R8P kind, rank 3.
   real(R8P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_3D

   subroutine oac_memcpy_to_device_R8P_4D(fptr_dst, fptr_src)
   !< Copy array to device, R8P kind, rank 4.
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_4D

   subroutine oac_memcpy_to_device_R8P_5D(fptr_dst, fptr_src)
   !< Copy array to device, R8P kind, rank 5.
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_5D

   subroutine oac_memcpy_to_device_R8P_6D(fptr_dst, fptr_src)
   !< Copy array to device, R8P kind, rank 6.
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_6D

   subroutine oac_memcpy_to_device_R8P_7D(fptr_dst, fptr_src)
   !< Copy array to device, R8P kind, rank 7.
   real(R8P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R8P_7D

   subroutine oac_memcpy_to_device_R4P_1D(fptr_dst, fptr_src)
   !< Copy array to device, R4P kind, rank 1.
   real(R4P), intent(out), target :: fptr_dst(:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: fptr_src(:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_1D

   subroutine oac_memcpy_to_device_R4P_2D(fptr_dst, fptr_src)
   !< Copy array to device, R4P kind, rank 2.
   real(R4P), intent(out), target :: fptr_dst(:,:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: fptr_src(:,:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_2D

   subroutine oac_memcpy_to_device_R4P_3D(fptr_dst, fptr_src)
   !< Copy array to device, R4P kind, rank 3.
   real(R4P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_3D

   subroutine oac_memcpy_to_device_R4P_4D(fptr_dst, fptr_src)
   !< Copy array to device, R4P kind, rank 4.
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_4D

   subroutine oac_memcpy_to_device_R4P_5D(fptr_dst, fptr_src)
   !< Copy array to device, R4P kind, rank 5.
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_5D

   subroutine oac_memcpy_to_device_R4P_6D(fptr_dst, fptr_src)
   !< Copy array to device, R4P kind, rank 6.
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_6D

   subroutine oac_memcpy_to_device_R4P_7D(fptr_dst, fptr_src)
   !< Copy array to device, R4P kind, rank 7.
   real(R4P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)              :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_R4P_7D

   subroutine oac_memcpy_to_device_I8P_1D(fptr_dst, fptr_src)
   !< Copy array to device, I8P kind, rank 1.
   integer(I8P), intent(out), target :: fptr_dst(:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: fptr_src(:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_1D

   subroutine oac_memcpy_to_device_I8P_2D(fptr_dst, fptr_src)
   !< Copy array to device, I8P kind, rank 2.
   integer(I8P), intent(out), target :: fptr_dst(:,:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: fptr_src(:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_2D

   subroutine oac_memcpy_to_device_I8P_3D(fptr_dst, fptr_src)
   !< Copy array to device, I8P kind, rank 3.
   integer(I8P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_3D

   subroutine oac_memcpy_to_device_I8P_4D(fptr_dst, fptr_src)
   !< Copy array to device, I8P kind, rank 4.
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_4D

   subroutine oac_memcpy_to_device_I8P_5D(fptr_dst, fptr_src)
   !< Copy array to device, I8P kind, rank 5.
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_5D

   subroutine oac_memcpy_to_device_I8P_6D(fptr_dst, fptr_src)
   !< Copy array to device, I8P kind, rank 6.
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_6D

   subroutine oac_memcpy_to_device_I8P_7D(fptr_dst, fptr_src)
   !< Copy array to device, I8P kind, rank 7.
   integer(I8P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I8P_7D

   subroutine oac_memcpy_to_device_I4P_1D(fptr_dst, fptr_src)
   !< Copy array to device, I4P kind, rank 1.
   integer(I4P), intent(out), target :: fptr_dst(:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: fptr_src(:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_1D

   subroutine oac_memcpy_to_device_I4P_2D(fptr_dst, fptr_src)
   !< Copy array to device, I4P kind, rank 2.
   integer(I4P), intent(out), target :: fptr_dst(:,:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: fptr_src(:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_2D

   subroutine oac_memcpy_to_device_I4P_3D(fptr_dst, fptr_src)
   !< Copy array to device, I4P kind, rank 3.
   integer(I4P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_3D

   subroutine oac_memcpy_to_device_I4P_4D(fptr_dst, fptr_src)
   !< Copy array to device, I4P kind, rank 4.
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_4D

   subroutine oac_memcpy_to_device_I4P_5D(fptr_dst, fptr_src)
   !< Copy array to device, I4P kind, rank 5.
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_5D

   subroutine oac_memcpy_to_device_I4P_6D(fptr_dst, fptr_src)
   !< Copy array to device, I4P kind, rank 6.
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_6D

   subroutine oac_memcpy_to_device_I4P_7D(fptr_dst, fptr_src)
   !< Copy array to device, I4P kind, rank 7.
   integer(I4P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I4P_7D

   subroutine oac_memcpy_to_device_I1P_1D(fptr_dst, fptr_src)
   !< Copy array to device, I1P kind, rank 1.
   integer(I1P), intent(out), target :: fptr_dst(:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: fptr_src(:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes       !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_1D

   subroutine oac_memcpy_to_device_I1P_2D(fptr_dst, fptr_src)
   !< Copy array to device, I1P kind, rank 2.
   integer(I1P), intent(out), target :: fptr_dst(:,:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: fptr_src(:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes         !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_2D

   subroutine oac_memcpy_to_device_I1P_3D(fptr_dst, fptr_src)
   !< Copy array to device, I1P kind, rank 3.
   integer(I1P), intent(out), target :: fptr_dst(:,:,:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: fptr_src(:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes           !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_3D

   subroutine oac_memcpy_to_device_I1P_4D(fptr_dst, fptr_src)
   !< Copy array to device, I1P kind, rank 4.
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes             !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_4D

   subroutine oac_memcpy_to_device_I1P_5D(fptr_dst, fptr_src)
   !< Copy array to device, I1P kind, rank 5.
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes               !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_5D

   subroutine oac_memcpy_to_device_I1P_6D(fptr_dst, fptr_src)
   !< Copy array to device, I1P kind, rank 6.
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes                 !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_6D

   subroutine oac_memcpy_to_device_I1P_7D(fptr_dst, fptr_src)
   !< Copy array to device, I1P kind, rank 7.
   integer(I1P), intent(out), target :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: fptr_src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(c_size_t)                 :: bytes                   !< Bytes of memory copied.

   bytes = bytes_size(a=fptr_src)
   call acc_memcpy_to_device_f(c_loc(fptr_dst), c_loc(fptr_src), bytes)
   endsubroutine oac_memcpy_to_device_I1P_7D
endmodule fundal_oac_memcpy
