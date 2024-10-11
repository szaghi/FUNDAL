!< FUNDAL, memory copy routines module.

#include "fundal.H"

#if defined DEV_OAC
#   define DEVMEMCPY_FROM_DEVICE(d, s, b) call acc_memcpy_from_device_f(c_loc(d), c_loc(s), bytes_size(a=s))
#   define DEVMEMCPY_TO_DEVICE(d, s, b) call acc_memcpy_to_device_f(c_loc(d), c_loc(s), bytes_size(a=s))

#elif defined DEV_OMP
#   define DEVMEMCPY_FROM_DEVICE(d, s, b) ierr = int(omp_target_memcpy(c_loc(d), c_loc(s), bytes_size(a=s), int(0, c_size_t), int(0, c_size_t), int(myhos, c_int), int(mydev, c_int)), I4P)
#   define DEVMEMCPY_TO_DEVICE(d, s, b) ierr = int(omp_target_memcpy(c_loc(d), c_loc(s), bytes_size(a=s), int(0, c_size_t), int(0, c_size_t), int(mydev, c_int), int(myhos, c_int)), I4P)
#else
#   define DEVMEMCPY_FROM_DEVICE(d, s, b) d = s
#   define DEVMEMCPY_TO_DEVICE(d, s, b) d = s
#endif

module fundal_dev_memcpy
!< FUNDAL, memory copy routines module.
use, intrinsic :: iso_c_binding
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I2P=>int16, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: DEVMODULE
use            :: fundal_env,      only : mydev, myhos
use            :: fundal_utilities

implicit none
private
! public :: dev_memcpy
public :: dev_memcpy_from_device
public :: dev_memcpy_to_device

!interface dev_memcpy
!   !< Copy memory from/to device.
!   module procedure dev_memcpy_R8P_1D!,&
!endinterface dev_memcpy

interface dev_memcpy_from_device
   !< Copy memory from device.
   module procedure dev_memcpy_from_device_R8P_1D,&
                    dev_memcpy_from_device_R8P_2D,&
                    dev_memcpy_from_device_R8P_3D,&
                    dev_memcpy_from_device_R8P_4D,&
                    dev_memcpy_from_device_R8P_5D,&
                    dev_memcpy_from_device_R8P_6D,&
                    dev_memcpy_from_device_R8P_7D,&
                    dev_memcpy_from_device_R4P_1D,&
                    dev_memcpy_from_device_R4P_2D,&
                    dev_memcpy_from_device_R4P_3D,&
                    dev_memcpy_from_device_R4P_4D,&
                    dev_memcpy_from_device_R4P_5D,&
                    dev_memcpy_from_device_R4P_6D,&
                    dev_memcpy_from_device_R4P_7D,&
                    dev_memcpy_from_device_I8P_1D,&
                    dev_memcpy_from_device_I8P_2D,&
                    dev_memcpy_from_device_I8P_3D,&
                    dev_memcpy_from_device_I8P_4D,&
                    dev_memcpy_from_device_I8P_5D,&
                    dev_memcpy_from_device_I8P_6D,&
                    dev_memcpy_from_device_I8P_7D,&
                    dev_memcpy_from_device_I4P_1D,&
                    dev_memcpy_from_device_I4P_2D,&
                    dev_memcpy_from_device_I4P_3D,&
                    dev_memcpy_from_device_I4P_4D,&
                    dev_memcpy_from_device_I4P_5D,&
                    dev_memcpy_from_device_I4P_6D,&
                    dev_memcpy_from_device_I4P_7D,&
                    dev_memcpy_from_device_I2P_1D,&
                    dev_memcpy_from_device_I2P_2D,&
                    dev_memcpy_from_device_I2P_3D,&
                    dev_memcpy_from_device_I2P_4D,&
                    dev_memcpy_from_device_I2P_5D,&
                    dev_memcpy_from_device_I2P_6D,&
                    dev_memcpy_from_device_I2P_7D,&
                    dev_memcpy_from_device_I1P_1D,&
                    dev_memcpy_from_device_I1P_2D,&
                    dev_memcpy_from_device_I1P_3D,&
                    dev_memcpy_from_device_I1P_4D,&
                    dev_memcpy_from_device_I1P_5D,&
                    dev_memcpy_from_device_I1P_6D,&
                    dev_memcpy_from_device_I1P_7D
endinterface dev_memcpy_from_device

interface dev_memcpy_to_device
   !< Copy memory to device.
   module procedure dev_memcpy_to_device_R8P_1D,&
                    dev_memcpy_to_device_R8P_2D,&
                    dev_memcpy_to_device_R8P_3D,&
                    dev_memcpy_to_device_R8P_4D,&
                    dev_memcpy_to_device_R8P_5D,&
                    dev_memcpy_to_device_R8P_6D,&
                    dev_memcpy_to_device_R8P_7D,&
                    dev_memcpy_to_device_R4P_1D,&
                    dev_memcpy_to_device_R4P_2D,&
                    dev_memcpy_to_device_R4P_3D,&
                    dev_memcpy_to_device_R4P_4D,&
                    dev_memcpy_to_device_R4P_5D,&
                    dev_memcpy_to_device_R4P_6D,&
                    dev_memcpy_to_device_R4P_7D,&
                    dev_memcpy_to_device_I8P_1D,&
                    dev_memcpy_to_device_I8P_2D,&
                    dev_memcpy_to_device_I8P_3D,&
                    dev_memcpy_to_device_I8P_4D,&
                    dev_memcpy_to_device_I8P_5D,&
                    dev_memcpy_to_device_I8P_6D,&
                    dev_memcpy_to_device_I8P_7D,&
                    dev_memcpy_to_device_I4P_1D,&
                    dev_memcpy_to_device_I4P_2D,&
                    dev_memcpy_to_device_I4P_3D,&
                    dev_memcpy_to_device_I4P_4D,&
                    dev_memcpy_to_device_I4P_5D,&
                    dev_memcpy_to_device_I4P_6D,&
                    dev_memcpy_to_device_I4P_7D,&
                    dev_memcpy_to_device_I2P_1D,&
                    dev_memcpy_to_device_I2P_2D,&
                    dev_memcpy_to_device_I2P_3D,&
                    dev_memcpy_to_device_I2P_4D,&
                    dev_memcpy_to_device_I2P_5D,&
                    dev_memcpy_to_device_I2P_6D,&
                    dev_memcpy_to_device_I2P_7D,&
                    dev_memcpy_to_device_I1P_1D,&
                    dev_memcpy_to_device_I1P_2D,&
                    dev_memcpy_to_device_I1P_3D,&
                    dev_memcpy_to_device_I1P_4D,&
                    dev_memcpy_to_device_I1P_5D,&
                    dev_memcpy_to_device_I1P_6D,&
                    dev_memcpy_to_device_I1P_7D
endinterface dev_memcpy_to_device

#ifdef DEV_OAC
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
#endif

contains
   ! dev_memcpy_from_device
   subroutine dev_memcpy_from_device_R8P_1D(dst, src)
   !< Copy array from device, R8P kind, rank 1.
   real(R8P), intent(out), target :: dst(:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: src(:) !< Source memory (device memory).
   integer(I4P)                   :: ierr   !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R8P_1D

   subroutine dev_memcpy_from_device_R8P_2D(dst, src)
   !< Copy array from device, R8P kind, rank 2.
   real(R8P), intent(out), target :: dst(:,:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: src(:,:) !< Source memory (device memory).
   integer(I4P)                   :: ierr     !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R8P_2D

   subroutine dev_memcpy_from_device_R8P_3D(dst, src)
   !< Copy array from device, R8P kind, rank 3.
   real(R8P), intent(out), target :: dst(:,:,:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: src(:,:,:) !< Source memory (device memory).
   integer(I4P)                   :: ierr       !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R8P_3D

   subroutine dev_memcpy_from_device_R8P_4D(dst, src)
   !< Copy array from device, R8P kind, rank 4.
   real(R8P), intent(out), target :: dst(:,:,:,:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: src(:,:,:,:) !< Source memory (device memory).
   integer(I4P)                   :: ierr         !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R8P_4D

   subroutine dev_memcpy_from_device_R8P_5D(dst, src)
   !< Copy array from device, R8P kind, rank 5.
   real(R8P), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: src(:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                   :: ierr           !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R8P_5D

   subroutine dev_memcpy_from_device_R8P_6D(dst, src)
   !< Copy array from device, R8P kind, rank 6.
   real(R8P), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                   :: ierr             !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R8P_6D

   subroutine dev_memcpy_from_device_R8P_7D(dst, src)
   !< Copy array from device, R8P kind, rank 7.
   real(R8P), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                   :: ierr               !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R8P_7D

   subroutine dev_memcpy_from_device_R4P_1D(dst, src)
   !< Copy array from device, R4P kind, rank 1.
   real(R4P), intent(out), target :: dst(:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: src(:) !< Source memory (device memory).
   integer(I4P)                   :: ierr   !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R4P_1D

   subroutine dev_memcpy_from_device_R4P_2D(dst, src)
   !< Copy array from device, R4P kind, rank 2.
   real(R4P), intent(out), target :: dst(:,:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: src(:,:) !< Source memory (device memory).
   integer(I4P)                   :: ierr     !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R4P_2D

   subroutine dev_memcpy_from_device_R4P_3D(dst, src)
   !< Copy array from device, R4P kind, rank 3.
   real(R4P), intent(out), target :: dst(:,:,:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: src(:,:,:) !< Source memory (device memory).
   integer(I4P)                   :: ierr       !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R4P_3D

   subroutine dev_memcpy_from_device_R4P_4D(dst, src)
   !< Copy array from device, R4P kind, rank 4.
   real(R4P), intent(out), target :: dst(:,:,:,:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: src(:,:,:,:) !< Source memory (device memory).
   integer(I4P)                   :: ierr         !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R4P_4D

   subroutine dev_memcpy_from_device_R4P_5D(dst, src)
   !< Copy array from device, R4P kind, rank 5.
   real(R4P), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: src(:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                   :: ierr           !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R4P_5D

   subroutine dev_memcpy_from_device_R4P_6D(dst, src)
   !< Copy array from device, R4P kind, rank 6.
   real(R4P), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                   :: ierr             !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R4P_6D

   subroutine dev_memcpy_from_device_R4P_7D(dst, src)
   !< Copy array from device, R4P kind, rank 7.
   real(R4P), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                   :: ierr               !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_R4P_7D

   subroutine dev_memcpy_from_device_I8P_1D(dst, src)
   !< Copy array from device, I8P kind, rank 1.
   integer(I8P), intent(out), target :: dst(:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: src(:) !< Source memory (device memory).
   integer(I4P)                      :: ierr   !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I8P_1D

   subroutine dev_memcpy_from_device_I8P_2D(dst, src)
   !< Copy array from device, I8P kind, rank 2.
   integer(I8P), intent(out), target :: dst(:,:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: src(:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr     !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I8P_2D

   subroutine dev_memcpy_from_device_I8P_3D(dst, src)
   !< Copy array from device, I8P kind, rank 3.
   integer(I8P), intent(out), target :: dst(:,:,:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: src(:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr       !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I8P_3D

   subroutine dev_memcpy_from_device_I8P_4D(dst, src)
   !< Copy array from device, I8P kind, rank 4.
   integer(I8P), intent(out), target :: dst(:,:,:,:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: src(:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr         !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I8P_4D

   subroutine dev_memcpy_from_device_I8P_5D(dst, src)
   !< Copy array from device, I8P kind, rank 5.
   integer(I8P), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: src(:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr           !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I8P_5D

   subroutine dev_memcpy_from_device_I8P_6D(dst, src)
   !< Copy array from device, I8P kind, rank 6.
   integer(I8P), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr             !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I8P_6D

   subroutine dev_memcpy_from_device_I8P_7D(dst, src)
   !< Copy array from device, I8P kind, rank 7.
   integer(I8P), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr               !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I8P_7D

   subroutine dev_memcpy_from_device_I4P_1D(dst, src)
   !< Copy array from device, I4P kind, rank 1.
   integer(I4P), intent(out), target :: dst(:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: src(:) !< Source memory (device memory).
   integer(I4P)                      :: ierr   !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I4P_1D

   subroutine dev_memcpy_from_device_I4P_2D(dst, src)
   !< Copy array from device, I4P kind, rank 2.
   integer(I4P), intent(out), target :: dst(:,:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: src(:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr     !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I4P_2D

   subroutine dev_memcpy_from_device_I4P_3D(dst, src)
   !< Copy array from device, I4P kind, rank 3.
   integer(I4P), intent(out), target :: dst(:,:,:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: src(:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr       !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I4P_3D

   subroutine dev_memcpy_from_device_I4P_4D(dst, src)
   !< Copy array from device, I4P kind, rank 4.
   integer(I4P), intent(out), target :: dst(:,:,:,:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: src(:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr         !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I4P_4D

   subroutine dev_memcpy_from_device_I4P_5D(dst, src)
   !< Copy array from device, I4P kind, rank 5.
   integer(I4P), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: src(:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr           !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I4P_5D

   subroutine dev_memcpy_from_device_I4P_6D(dst, src)
   !< Copy array from device, I4P kind, rank 6.
   integer(I4P), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr             !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I4P_6D

   subroutine dev_memcpy_from_device_I4P_7D(dst, src)
   !< Copy array from device, I4P kind, rank 7.
   integer(I4P), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr               !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I4P_7D

   subroutine dev_memcpy_from_device_I2P_1D(dst, src)
   !< Copy array from device, I2P kind, rank 1.
   integer(I2P), intent(out), target :: dst(:) !< Destination memory (host memory).
   integer(I2P), intent(in),  target :: src(:) !< Source memory (device memory).
   integer(I4P)                      :: ierr   !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I2P_1D

   subroutine dev_memcpy_from_device_I2P_2D(dst, src)
   !< Copy array from device, I2P kind, rank 2.
   integer(I2P), intent(out), target :: dst(:,:) !< Destination memory (host memory).
   integer(I2P), intent(in),  target :: src(:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr     !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I2P_2D

   subroutine dev_memcpy_from_device_I2P_3D(dst, src)
   !< Copy array from device, I2P kind, rank 3.
   integer(I2P), intent(out), target :: dst(:,:,:) !< Destination memory (host memory).
   integer(I2P), intent(in),  target :: src(:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr       !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I2P_3D

   subroutine dev_memcpy_from_device_I2P_4D(dst, src)
   !< Copy array from device, I2P kind, rank 4.
   integer(I2P), intent(out), target :: dst(:,:,:,:) !< Destination memory (host memory).
   integer(I2P), intent(in),  target :: src(:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr         !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I2P_4D

   subroutine dev_memcpy_from_device_I2P_5D(dst, src)
   !< Copy array from device, I2P kind, rank 5.
   integer(I2P), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (host memory).
   integer(I2P), intent(in),  target :: src(:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr           !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I2P_5D

   subroutine dev_memcpy_from_device_I2P_6D(dst, src)
   !< Copy array from device, I2P kind, rank 6.
   integer(I2P), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I2P), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr             !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I2P_6D

   subroutine dev_memcpy_from_device_I2P_7D(dst, src)
   !< Copy array from device, I2P kind, rank 7.
   integer(I2P), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I2P), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr               !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I2P_7D

   subroutine dev_memcpy_from_device_I1P_1D(dst, src)
   !< Copy array from device, I1P kind, rank 1.
   integer(I1P), intent(out), target :: dst(:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: src(:) !< Source memory (device memory).
   integer(I4P)                      :: ierr   !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I1P_1D

   subroutine dev_memcpy_from_device_I1P_2D(dst, src)
   !< Copy array from device, I1P kind, rank 2.
   integer(I1P), intent(out), target :: dst(:,:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: src(:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr     !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I1P_2D

   subroutine dev_memcpy_from_device_I1P_3D(dst, src)
   !< Copy array from device, I1P kind, rank 3.
   integer(I1P), intent(out), target :: dst(:,:,:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: src(:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr       !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I1P_3D

   subroutine dev_memcpy_from_device_I1P_4D(dst, src)
   !< Copy array from device, I1P kind, rank 4.
   integer(I1P), intent(out), target :: dst(:,:,:,:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: src(:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr         !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I1P_4D

   subroutine dev_memcpy_from_device_I1P_5D(dst, src)
   !< Copy array from device, I1P kind, rank 5.
   integer(I1P), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: src(:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr           !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I1P_5D

   subroutine dev_memcpy_from_device_I1P_6D(dst, src)
   !< Copy array from device, I1P kind, rank 6.
   integer(I1P), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr             !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I1P_6D

   subroutine dev_memcpy_from_device_I1P_7D(dst, src)
   !< Copy array from device, I1P kind, rank 7.
   integer(I1P), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (device memory).
   integer(I4P)                      :: ierr               !< Error status.

   DEVMEMCPY_FROM_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_from_device_I1P_7D

   ! dev_memcpy_to_device
   subroutine dev_memcpy_to_device_R8P_1D(dst, src)
   !< Copy array to device, R8P kind, rank 1.
   real(R8P), intent(out), target :: dst(:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: src(:) !< Source memory (host memory).
   integer(I4P)                   :: ierr   !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R8P_1D

   subroutine dev_memcpy_to_device_R8P_2D(dst, src)
   !< Copy array to device, R8P kind, rank 2.
   real(R8P), intent(out), target :: dst(:,:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: src(:,:) !< Source memory (host memory).
   integer(I4P)                   :: ierr     !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R8P_2D

   subroutine dev_memcpy_to_device_R8P_3D(dst, src)
   !< Copy array to device, R8P kind, rank 3.
   real(R8P), intent(out), target :: dst(:,:,:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: src(:,:,:) !< Source memory (host memory).
   integer(I4P)                   :: ierr       !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R8P_3D

   subroutine dev_memcpy_to_device_R8P_4D(dst, src)
   !< Copy array to device, R8P kind, rank 4.
   real(R8P), intent(out), target :: dst(:,:,:,:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: src(:,:,:,:) !< Source memory (host memory).
   integer(I4P)                   :: ierr         !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R8P_4D

   subroutine dev_memcpy_to_device_R8P_5D(dst, src)
   !< Copy array to device, R8P kind, rank 5.
   real(R8P), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: src(:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                   :: ierr           !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R8P_5D

   subroutine dev_memcpy_to_device_R8P_6D(dst, src)
   !< Copy array to device, R8P kind, rank 6.
   real(R8P), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                   :: ierr             !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R8P_6D

   subroutine dev_memcpy_to_device_R8P_7D(dst, src)
   !< Copy array to device, R8P kind, rank 7.
   real(R8P), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                   :: ierr               !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R8P_7D

   subroutine dev_memcpy_to_device_R4P_1D(dst, src)
   !< Copy array to device, R4P kind, rank 1.
   real(R4P), intent(out), target :: dst(:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: src(:) !< Source memory (host memory).
   integer(I4P)                   :: ierr   !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R4P_1D

   subroutine dev_memcpy_to_device_R4P_2D(dst, src)
   !< Copy array to device, R4P kind, rank 2.
   real(R4P), intent(out), target :: dst(:,:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: src(:,:) !< Source memory (host memory).
   integer(I4P)                   :: ierr     !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R4P_2D

   subroutine dev_memcpy_to_device_R4P_3D(dst, src)
   !< Copy array to device, R4P kind, rank 3.
   real(R4P), intent(out), target :: dst(:,:,:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: src(:,:,:) !< Source memory (host memory).
   integer(I4P)                   :: ierr       !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R4P_3D

   subroutine dev_memcpy_to_device_R4P_4D(dst, src)
   !< Copy array to device, R4P kind, rank 4.
   real(R4P), intent(out), target :: dst(:,:,:,:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: src(:,:,:,:) !< Source memory (host memory).
   integer(I4P)                   :: ierr         !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R4P_4D

   subroutine dev_memcpy_to_device_R4P_5D(dst, src)
   !< Copy array to device, R4P kind, rank 5.
   real(R4P), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: src(:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                   :: ierr           !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R4P_5D

   subroutine dev_memcpy_to_device_R4P_6D(dst, src)
   !< Copy array to device, R4P kind, rank 6.
   real(R4P), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                   :: ierr             !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R4P_6D

   subroutine dev_memcpy_to_device_R4P_7D(dst, src)
   !< Copy array to device, R4P kind, rank 7.
   real(R4P), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                   :: ierr               !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_R4P_7D

   subroutine dev_memcpy_to_device_I8P_1D(dst, src)
   !< Copy array to device, I8P kind, rank 1.
   integer(I8P), intent(out), target :: dst(:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: src(:) !< Source memory (host memory).
   integer(I4P)                      :: ierr   !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I8P_1D

   subroutine dev_memcpy_to_device_I8P_2D(dst, src)
   !< Copy array to device, I8P kind, rank 2.
   integer(I8P), intent(out), target :: dst(:,:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: src(:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr     !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I8P_2D

   subroutine dev_memcpy_to_device_I8P_3D(dst, src)
   !< Copy array to device, I8P kind, rank 3.
   integer(I8P), intent(out), target :: dst(:,:,:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: src(:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr       !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I8P_3D

   subroutine dev_memcpy_to_device_I8P_4D(dst, src)
   !< Copy array to device, I8P kind, rank 4.
   integer(I8P), intent(out), target :: dst(:,:,:,:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: src(:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr         !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I8P_4D

   subroutine dev_memcpy_to_device_I8P_5D(dst, src)
   !< Copy array to device, I8P kind, rank 5.
   integer(I8P), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: src(:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr           !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I8P_5D

   subroutine dev_memcpy_to_device_I8P_6D(dst, src)
   !< Copy array to device, I8P kind, rank 6.
   integer(I8P), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr             !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I8P_6D

   subroutine dev_memcpy_to_device_I8P_7D(dst, src)
   !< Copy array to device, I8P kind, rank 7.
   integer(I8P), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr               !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I8P_7D

   subroutine dev_memcpy_to_device_I4P_1D(dst, src)
   !< Copy array to device, I4P kind, rank 1.
   integer(I4P), intent(out), target :: dst(:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: src(:) !< Source memory (host memory).
   integer(I4P)                      :: ierr   !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I4P_1D

   subroutine dev_memcpy_to_device_I4P_2D(dst, src)
   !< Copy array to device, I4P kind, rank 2.
   integer(I4P), intent(out), target :: dst(:,:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: src(:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr     !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I4P_2D

   subroutine dev_memcpy_to_device_I4P_3D(dst, src)
   !< Copy array to device, I4P kind, rank 3.
   integer(I4P), intent(out), target :: dst(:,:,:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: src(:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr       !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I4P_3D

   subroutine dev_memcpy_to_device_I4P_4D(dst, src)
   !< Copy array to device, I4P kind, rank 4.
   integer(I4P), intent(out), target :: dst(:,:,:,:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: src(:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr         !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I4P_4D

   subroutine dev_memcpy_to_device_I4P_5D(dst, src)
   !< Copy array to device, I4P kind, rank 5.
   integer(I4P), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: src(:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr           !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I4P_5D

   subroutine dev_memcpy_to_device_I4P_6D(dst, src)
   !< Copy array to device, I4P kind, rank 6.
   integer(I4P), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr             !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I4P_6D

   subroutine dev_memcpy_to_device_I4P_7D(dst, src)
   !< Copy array to device, I4P kind, rank 7.
   integer(I4P), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr               !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I4P_7D

   subroutine dev_memcpy_to_device_I2P_1D(dst, src)
   !< Copy array to device, I2P kind, rank 1.
   integer(I2P), intent(out), target :: dst(:) !< Destination memory (device memory).
   integer(I2P), intent(in),  target :: src(:) !< Source memory (host memory).
   integer(I4P)                      :: ierr   !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I2P_1D

   subroutine dev_memcpy_to_device_I2P_2D(dst, src)
   !< Copy array to device, I2P kind, rank 2.
   integer(I2P), intent(out), target :: dst(:,:) !< Destination memory (device memory).
   integer(I2P), intent(in),  target :: src(:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr     !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I2P_2D

   subroutine dev_memcpy_to_device_I2P_3D(dst, src)
   !< Copy array to device, I2P kind, rank 3.
   integer(I2P), intent(out), target :: dst(:,:,:) !< Destination memory (device memory).
   integer(I2P), intent(in),  target :: src(:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr       !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I2P_3D

   subroutine dev_memcpy_to_device_I2P_4D(dst, src)
   !< Copy array to device, I2P kind, rank 4.
   integer(I2P), intent(out), target :: dst(:,:,:,:) !< Destination memory (device memory).
   integer(I2P), intent(in),  target :: src(:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr         !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I2P_4D

   subroutine dev_memcpy_to_device_I2P_5D(dst, src)
   !< Copy array to device, I2P kind, rank 5.
   integer(I2P), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (device memory).
   integer(I2P), intent(in),  target :: src(:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr           !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I2P_5D

   subroutine dev_memcpy_to_device_I2P_6D(dst, src)
   !< Copy array to device, I2P kind, rank 6.
   integer(I2P), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I2P), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr             !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I2P_6D

   subroutine dev_memcpy_to_device_I2P_7D(dst, src)
   !< Copy array to device, I2P kind, rank 7.
   integer(I2P), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I2P), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr               !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I2P_7D

   subroutine dev_memcpy_to_device_I1P_1D(dst, src)
   !< Copy array to device, I1P kind, rank 1.
   integer(I1P), intent(out), target :: dst(:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: src(:) !< Source memory (host memory).
   integer(I4P)                      :: ierr   !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I1P_1D

   subroutine dev_memcpy_to_device_I1P_2D(dst, src)
   !< Copy array to device, I1P kind, rank 2.
   integer(I1P), intent(out), target :: dst(:,:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: src(:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr     !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I1P_2D

   subroutine dev_memcpy_to_device_I1P_3D(dst, src)
   !< Copy array to device, I1P kind, rank 3.
   integer(I1P), intent(out), target :: dst(:,:,:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: src(:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr       !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I1P_3D

   subroutine dev_memcpy_to_device_I1P_4D(dst, src)
   !< Copy array to device, I1P kind, rank 4.
   integer(I1P), intent(out), target :: dst(:,:,:,:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: src(:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr         !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I1P_4D

   subroutine dev_memcpy_to_device_I1P_5D(dst, src)
   !< Copy array to device, I1P kind, rank 5.
   integer(I1P), intent(out), target :: dst(:,:,:,:,:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: src(:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr           !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I1P_5D

   subroutine dev_memcpy_to_device_I1P_6D(dst, src)
   !< Copy array to device, I1P kind, rank 6.
   integer(I1P), intent(out), target :: dst(:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: src(:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr             !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I1P_6D

   subroutine dev_memcpy_to_device_I1P_7D(dst, src)
   !< Copy array to device, I1P kind, rank 7.
   integer(I1P), intent(out), target :: dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: src(:,:,:,:,:,:,:) !< Source memory (host memory).
   integer(I4P)                      :: ierr               !< Error status.

   DEVMEMCPY_TO_DEVICE(dst, src, bytes)
   endsubroutine dev_memcpy_to_device_I1P_7D
endmodule fundal_dev_memcpy
