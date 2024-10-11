!< FUNDAL, memory assignment routines module.

#include "fundal.H"

module fundal_dev_assign
!< FUNDAL, memory assignment routines module.
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I2P=>int16, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: fundal_dev_alloc
use            :: fundal_dev_free
use            :: fundal_dev_memcpy

implicit none
private
public :: dev_assign_from_device
public :: dev_assign_to_device

interface dev_assign_from_device
   !< Allocate device memory.
   !< @NOTE Destination variable (device) is re-allocated before assignment.
   module procedure dev_assign_from_device_R8P_1D,&
                    dev_assign_from_device_R8P_2D,&
                    dev_assign_from_device_R8P_3D,&
                    dev_assign_from_device_R8P_4D,&
                    dev_assign_from_device_R8P_5D,&
                    dev_assign_from_device_R8P_6D,&
                    dev_assign_from_device_R8P_7D,&
                    dev_assign_from_device_R4P_1D,&
                    dev_assign_from_device_R4P_2D,&
                    dev_assign_from_device_R4P_3D,&
                    dev_assign_from_device_R4P_4D,&
                    dev_assign_from_device_R4P_5D,&
                    dev_assign_from_device_R4P_6D,&
                    dev_assign_from_device_R4P_7D,&
                    dev_assign_from_device_I8P_1D,&
                    dev_assign_from_device_I8P_2D,&
                    dev_assign_from_device_I8P_3D,&
                    dev_assign_from_device_I8P_4D,&
                    dev_assign_from_device_I8P_5D,&
                    dev_assign_from_device_I8P_6D,&
                    dev_assign_from_device_I8P_7D,&
                    dev_assign_from_device_I4P_1D,&
                    dev_assign_from_device_I4P_2D,&
                    dev_assign_from_device_I4P_3D,&
                    dev_assign_from_device_I4P_4D,&
                    dev_assign_from_device_I4P_5D,&
                    dev_assign_from_device_I4P_6D,&
                    dev_assign_from_device_I4P_7D,&
                    dev_assign_from_device_I2P_1D,&
                    dev_assign_from_device_I2P_2D,&
                    dev_assign_from_device_I2P_3D,&
                    dev_assign_from_device_I2P_4D,&
                    dev_assign_from_device_I2P_5D,&
                    dev_assign_from_device_I2P_6D,&
                    dev_assign_from_device_I2P_7D,&
                    dev_assign_from_device_I1P_1D,&
                    dev_assign_from_device_I1P_2D,&
                    dev_assign_from_device_I1P_3D,&
                    dev_assign_from_device_I1P_4D,&
                    dev_assign_from_device_I1P_5D,&
                    dev_assign_from_device_I1P_6D,&
                    dev_assign_from_device_I1P_7D
endinterface dev_assign_from_device

interface dev_assign_to_device
   !< Allocate device memory.
   !< @NOTE Destination variable (device) is re-allocated before assignment.
   module procedure dev_assign_to_device_R8P_1D,&
                    dev_assign_to_device_R8P_2D,&
                    dev_assign_to_device_R8P_3D,&
                    dev_assign_to_device_R8P_4D,&
                    dev_assign_to_device_R8P_5D,&
                    dev_assign_to_device_R8P_6D,&
                    dev_assign_to_device_R8P_7D,&
                    dev_assign_to_device_R4P_1D,&
                    dev_assign_to_device_R4P_2D,&
                    dev_assign_to_device_R4P_3D,&
                    dev_assign_to_device_R4P_4D,&
                    dev_assign_to_device_R4P_5D,&
                    dev_assign_to_device_R4P_6D,&
                    dev_assign_to_device_R4P_7D,&
                    dev_assign_to_device_I8P_1D,&
                    dev_assign_to_device_I8P_2D,&
                    dev_assign_to_device_I8P_3D,&
                    dev_assign_to_device_I8P_4D,&
                    dev_assign_to_device_I8P_5D,&
                    dev_assign_to_device_I8P_6D,&
                    dev_assign_to_device_I8P_7D,&
                    dev_assign_to_device_I4P_1D,&
                    dev_assign_to_device_I4P_2D,&
                    dev_assign_to_device_I4P_3D,&
                    dev_assign_to_device_I4P_4D,&
                    dev_assign_to_device_I4P_5D,&
                    dev_assign_to_device_I4P_6D,&
                    dev_assign_to_device_I4P_7D,&
                    dev_assign_to_device_I2P_1D,&
                    dev_assign_to_device_I2P_2D,&
                    dev_assign_to_device_I2P_3D,&
                    dev_assign_to_device_I2P_4D,&
                    dev_assign_to_device_I2P_5D,&
                    dev_assign_to_device_I2P_6D,&
                    dev_assign_to_device_I2P_7D,&
                    dev_assign_to_device_I1P_1D,&
                    dev_assign_to_device_I1P_2D,&
                    dev_assign_to_device_I1P_3D,&
                    dev_assign_to_device_I1P_4D,&
                    dev_assign_to_device_I1P_5D,&
                    dev_assign_to_device_I1P_6D,&
                    dev_assign_to_device_I1P_7D
endinterface dev_assign_to_device

contains
   ! dev_assign_from_device
   subroutine dev_assign_from_device_R8P_1D(dst, src)
   !< Assign array, R8P kind, rank 1.
   real(R8P), intent(inout), allocatable :: dst(:) !< Assign memory.
   real(R8P), intent(in)                 :: src(:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R8P_1D

   subroutine dev_assign_from_device_R8P_2D(dst, src)
   !< Assign array, R8P kind, rank 2.
   real(R8P), intent(inout), allocatable :: dst(:,:) !< Assign memory.
   real(R8P), intent(in)                 :: src(:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R8P_2D

   subroutine dev_assign_from_device_R8P_3D(dst, src)
   !< Assign array, R8P kind, rank 3.
   real(R8P), intent(inout), allocatable :: dst(:,:,:) !< Assign memory.
   real(R8P), intent(in)                 :: src(:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R8P_3D

   subroutine dev_assign_from_device_R8P_4D(dst, src)
   !< Assign array, R8P kind, rank 4.
   real(R8P), intent(inout), allocatable :: dst(:,:,:,:) !< Assign memory.
   real(R8P), intent(in)                 :: src(:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R8P_4D

   subroutine dev_assign_from_device_R8P_5D(dst, src)
   !< Assign array, R8P kind, rank 5.
   real(R8P), intent(inout), allocatable :: dst(:,:,:,:,:) !< Assign memory.
   real(R8P), intent(in)                 :: src(:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R8P_5D

   subroutine dev_assign_from_device_R8P_6D(dst, src)
   !< Assign array, R8P kind, rank 6.
   real(R8P), intent(inout), allocatable :: dst(:,:,:,:,:,:) !< Assign memory.
   real(R8P), intent(in)                 :: src(:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R8P_6D

   subroutine dev_assign_from_device_R8P_7D(dst, src)
   !< Assign array, R8P kind, rank 7.
   real(R8P), intent(inout), allocatable :: dst(:,:,:,:,:,:,:) !< Assign memory.
   real(R8P), intent(in)                 :: src(:,:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6), &
                lbound(src,dim=7):ubound(src,dim=7)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R8P_7D

   subroutine dev_assign_from_device_R4P_1D(dst, src)
   !< Assign array, R4P kind, rank 1.
   real(R4P), intent(inout), allocatable :: dst(:) !< Assign memory.
   real(R4P), intent(in)                 :: src(:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R4P_1D

   subroutine dev_assign_from_device_R4P_2D(dst, src)
   !< Assign array, R4P kind, rank 2.
   real(R4P), intent(inout), allocatable :: dst(:,:) !< Assign memory.
   real(R4P), intent(in)                 :: src(:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R4P_2D

   subroutine dev_assign_from_device_R4P_3D(dst, src)
   !< Assign array, R4P kind, rank 3.
   real(R4P), intent(inout), allocatable :: dst(:,:,:) !< Assign memory.
   real(R4P), intent(in)                 :: src(:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R4P_3D

   subroutine dev_assign_from_device_R4P_4D(dst, src)
   !< Assign array, R4P kind, rank 4.
   real(R4P), intent(inout), allocatable :: dst(:,:,:,:) !< Assign memory.
   real(R4P), intent(in)                 :: src(:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R4P_4D

   subroutine dev_assign_from_device_R4P_5D(dst, src)
   !< Assign array, R4P kind, rank 5.
   real(R4P), intent(inout), allocatable :: dst(:,:,:,:,:) !< Assign memory.
   real(R4P), intent(in)                 :: src(:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R4P_5D

   subroutine dev_assign_from_device_R4P_6D(dst, src)
   !< Assign array, R4P kind, rank 6.
   real(R4P), intent(inout), allocatable :: dst(:,:,:,:,:,:) !< Assign memory.
   real(R4P), intent(in)                 :: src(:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R4P_6D

   subroutine dev_assign_from_device_R4P_7D(dst, src)
   !< Assign array, R4P kind, rank 7.
   real(R4P), intent(inout), allocatable :: dst(:,:,:,:,:,:,:) !< Assign memory.
   real(R4P), intent(in)                 :: src(:,:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6), &
                lbound(src,dim=7):ubound(src,dim=7)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_R4P_7D

   subroutine dev_assign_from_device_I8P_1D(dst, src)
   !< Assign array, I8P kind, rank 1.
   integer(I8P), intent(inout), allocatable :: dst(:) !< Assign memory.
   integer(I8P), intent(in)                 :: src(:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I8P_1D

   subroutine dev_assign_from_device_I8P_2D(dst, src)
   !< Assign array, I8P kind, rank 2.
   integer(I8P), intent(inout), allocatable :: dst(:,:) !< Assign memory.
   integer(I8P), intent(in)                 :: src(:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I8P_2D

   subroutine dev_assign_from_device_I8P_3D(dst, src)
   !< Assign array, I8P kind, rank 3.
   integer(I8P), intent(inout), allocatable :: dst(:,:,:) !< Assign memory.
   integer(I8P), intent(in)                 :: src(:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I8P_3D

   subroutine dev_assign_from_device_I8P_4D(dst, src)
   !< Assign array, I8P kind, rank 4.
   integer(I8P), intent(inout), allocatable :: dst(:,:,:,:) !< Assign memory.
   integer(I8P), intent(in)                 :: src(:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I8P_4D

   subroutine dev_assign_from_device_I8P_5D(dst, src)
   !< Assign array, I8P kind, rank 5.
   integer(I8P), intent(inout), allocatable :: dst(:,:,:,:,:) !< Assign memory.
   integer(I8P), intent(in)                 :: src(:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I8P_5D

   subroutine dev_assign_from_device_I8P_6D(dst, src)
   !< Assign array, I8P kind, rank 6.
   integer(I8P), intent(inout), allocatable :: dst(:,:,:,:,:,:) !< Assign memory.
   integer(I8P), intent(in)                 :: src(:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I8P_6D

   subroutine dev_assign_from_device_I8P_7D(dst, src)
   !< Assign array, I8P kind, rank 7.
   integer(I8P), intent(inout), allocatable :: dst(:,:,:,:,:,:,:) !< Assign memory.
   integer(I8P), intent(in)                 :: src(:,:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6), &
                lbound(src,dim=7):ubound(src,dim=7)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I8P_7D

   subroutine dev_assign_from_device_I4P_1D(dst, src)
   !< Assign array, I4P kind, rank 1.
   integer(I4P), intent(inout), allocatable :: dst(:) !< Assign memory.
   integer(I4P), intent(in)                 :: src(:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I4P_1D

   subroutine dev_assign_from_device_I4P_2D(dst, src)
   !< Assign array, I4P kind, rank 2.
   integer(I4P), intent(inout), allocatable :: dst(:,:) !< Assign memory.
   integer(I4P), intent(in)                 :: src(:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I4P_2D

   subroutine dev_assign_from_device_I4P_3D(dst, src)
   !< Assign array, I4P kind, rank 3.
   integer(I4P), intent(inout), allocatable :: dst(:,:,:) !< Assign memory.
   integer(I4P), intent(in)                 :: src(:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I4P_3D

   subroutine dev_assign_from_device_I4P_4D(dst, src)
   !< Assign array, I4P kind, rank 4.
   integer(I4P), intent(inout), allocatable :: dst(:,:,:,:) !< Assign memory.
   integer(I4P), intent(in)                 :: src(:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I4P_4D

   subroutine dev_assign_from_device_I4P_5D(dst, src)
   !< Assign array, I4P kind, rank 5.
   integer(I4P), intent(inout), allocatable :: dst(:,:,:,:,:) !< Assign memory.
   integer(I4P), intent(in)                 :: src(:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I4P_5D

   subroutine dev_assign_from_device_I4P_6D(dst, src)
   !< Assign array, I4P kind, rank 6.
   integer(I4P), intent(inout), allocatable :: dst(:,:,:,:,:,:) !< Assign memory.
   integer(I4P), intent(in)                 :: src(:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I4P_6D

   subroutine dev_assign_from_device_I4P_7D(dst, src)
   !< Assign array, I4P kind, rank 7.
   integer(I4P), intent(inout), allocatable :: dst(:,:,:,:,:,:,:) !< Assign memory.
   integer(I4P), intent(in)                 :: src(:,:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6), &
                lbound(src,dim=7):ubound(src,dim=7)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I4P_7D

   subroutine dev_assign_from_device_I2P_1D(dst, src)
   !< Assign array, I2P kind, rank 1.
   integer(I2P), intent(inout), allocatable :: dst(:) !< Assign memory.
   integer(I2P), intent(in)                 :: src(:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I2P_1D

   subroutine dev_assign_from_device_I2P_2D(dst, src)
   !< Assign array, I2P kind, rank 2.
   integer(I2P), intent(inout), allocatable :: dst(:,:) !< Assign memory.
   integer(I2P), intent(in)                 :: src(:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I2P_2D

   subroutine dev_assign_from_device_I2P_3D(dst, src)
   !< Assign array, I2P kind, rank 3.
   integer(I2P), intent(inout), allocatable :: dst(:,:,:) !< Assign memory.
   integer(I2P), intent(in)                 :: src(:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I2P_3D

   subroutine dev_assign_from_device_I2P_4D(dst, src)
   !< Assign array, I2P kind, rank 4.
   integer(I2P), intent(inout), allocatable :: dst(:,:,:,:) !< Assign memory.
   integer(I2P), intent(in)                 :: src(:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I2P_4D

   subroutine dev_assign_from_device_I2P_5D(dst, src)
   !< Assign array, I2P kind, rank 5.
   integer(I2P), intent(inout), allocatable :: dst(:,:,:,:,:) !< Assign memory.
   integer(I2P), intent(in)                 :: src(:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I2P_5D

   subroutine dev_assign_from_device_I2P_6D(dst, src)
   !< Assign array, I2P kind, rank 6.
   integer(I2P), intent(inout), allocatable :: dst(:,:,:,:,:,:) !< Assign memory.
   integer(I2P), intent(in)                 :: src(:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I2P_6D

   subroutine dev_assign_from_device_I2P_7D(dst, src)
   !< Assign array, I2P kind, rank 7.
   integer(I2P), intent(inout), allocatable :: dst(:,:,:,:,:,:,:) !< Assign memory.
   integer(I2P), intent(in)                 :: src(:,:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6), &
                lbound(src,dim=7):ubound(src,dim=7)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I2P_7D

   subroutine dev_assign_from_device_I1P_1D(dst, src)
   !< Assign array, I1P kind, rank 1.
   integer(I1P), intent(inout), allocatable :: dst(:) !< Assign memory.
   integer(I1P), intent(in)                 :: src(:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I1P_1D

   subroutine dev_assign_from_device_I1P_2D(dst, src)
   !< Assign array, I1P kind, rank 2.
   integer(I1P), intent(inout), allocatable :: dst(:,:) !< Assign memory.
   integer(I1P), intent(in)                 :: src(:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I1P_2D

   subroutine dev_assign_from_device_I1P_3D(dst, src)
   !< Assign array, I1P kind, rank 3.
   integer(I1P), intent(inout), allocatable :: dst(:,:,:) !< Assign memory.
   integer(I1P), intent(in)                 :: src(:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I1P_3D

   subroutine dev_assign_from_device_I1P_4D(dst, src)
   !< Assign array, I1P kind, rank 4.
   integer(I1P), intent(inout), allocatable :: dst(:,:,:,:) !< Assign memory.
   integer(I1P), intent(in)                 :: src(:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I1P_4D

   subroutine dev_assign_from_device_I1P_5D(dst, src)
   !< Assign array, I1P kind, rank 5.
   integer(I1P), intent(inout), allocatable :: dst(:,:,:,:,:) !< Assign memory.
   integer(I1P), intent(in)                 :: src(:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I1P_5D

   subroutine dev_assign_from_device_I1P_6D(dst, src)
   !< Assign array, I1P kind, rank 6.
   integer(I1P), intent(inout), allocatable :: dst(:,:,:,:,:,:) !< Assign memory.
   integer(I1P), intent(in)                 :: src(:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I1P_6D

   subroutine dev_assign_from_device_I1P_7D(dst, src)
   !< Assign array, I1P kind, rank 7.
   integer(I1P), intent(inout), allocatable :: dst(:,:,:,:,:,:,:) !< Assign memory.
   integer(I1P), intent(in)                 :: src(:,:,:,:,:,:,:) !< Source memory.

   if (allocated(dst)) deallocate(dst)
   allocate(dst(lbound(src,dim=1):ubound(src,dim=1), &
                lbound(src,dim=2):ubound(src,dim=2), &
                lbound(src,dim=3):ubound(src,dim=3), &
                lbound(src,dim=4):ubound(src,dim=4), &
                lbound(src,dim=5):ubound(src,dim=5), &
                lbound(src,dim=6):ubound(src,dim=6), &
                lbound(src,dim=7):ubound(src,dim=7)))
   call dev_memcpy_from_device(dst=dst, src=src)
   endsubroutine dev_assign_from_device_I1P_7D

   ! dev_assign_to_device
   subroutine dev_assign_to_device_R8P_1D(dst, src)
   !< Assign array, R8P kind, rank 1.
   real(R8P), intent(inout), pointer :: dst(:) !< Pointer to assign memory.
   real(R8P), intent(in)             :: src(:) !< Source memory.
   integer(I4P)                      :: ierr   !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R8P_1D

   subroutine dev_assign_to_device_R8P_2D(dst, src)
   !< Assign array, R8P kind, rank 2.
   real(R8P), intent(inout), pointer :: dst(:,:) !< Pointer to assign memory.
   real(R8P), intent(in)             :: src(:,:) !< Source memory.
   integer(I4P)                      :: ierr     !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R8P_2D

   subroutine dev_assign_to_device_R8P_3D(dst, src)
   !< Assign array, R8P kind, rank 3.
   real(R8P), intent(inout), pointer :: dst(:,:,:) !< Pointer to assign memory.
   real(R8P), intent(in)             :: src(:,:,:) !< Source memory.
   integer(I4P)                      :: ierr       !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R8P_3D

   subroutine dev_assign_to_device_R8P_4D(dst, src)
   !< Assign array, R8P kind, rank 4.
   real(R8P), intent(inout), pointer :: dst(:,:,:,:) !< Pointer to assign memory.
   real(R8P), intent(in)             :: src(:,:,:,:) !< Source memory.
   integer(I4P)                      :: ierr         !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R8P_4D

   subroutine dev_assign_to_device_R8P_5D(dst, src)
   !< Assign array, R8P kind, rank 5.
   real(R8P), intent(inout), pointer :: dst(:,:,:,:,:) !< Pointer to assign memory.
   real(R8P), intent(in)             :: src(:,:,:,:,:) !< Source memory.
   integer(I4P)                      :: ierr           !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R8P_5D

   subroutine dev_assign_to_device_R8P_6D(dst, src)
   !< Assign array, R8P kind, rank 6.
   real(R8P), intent(inout), pointer :: dst(:,:,:,:,:,:) !< Pointer to assign memory.
   real(R8P), intent(in)             :: src(:,:,:,:,:,:) !< Source memory.
   integer(I4P)                      :: ierr             !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R8P_6D

   subroutine dev_assign_to_device_R8P_7D(dst, src)
   !< Assign array, R8P kind, rank 7.
   real(R8P), intent(inout), pointer :: dst(:,:,:,:,:,:,:) !< Pointer to assign memory.
   real(R8P), intent(in)             :: src(:,:,:,:,:,:,:) !< Source memory.
   integer(I4P)                      :: ierr               !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R8P_7D

   subroutine dev_assign_to_device_R4P_1D(dst, src)
   !< Assign array, R4P kind, rank 1.
   real(R4P), intent(inout), pointer :: dst(:) !< Pointer to assign memory.
   real(R4P), intent(in)             :: src(:) !< Source memory.
   integer(I4P)                      :: ierr   !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R4P_1D

   subroutine dev_assign_to_device_R4P_2D(dst, src)
   !< Assign array, R4P kind, rank 2.
   real(R4P), intent(inout), pointer :: dst(:,:) !< Pointer to assign memory.
   real(R4P), intent(in)             :: src(:,:) !< Source memory.
   integer(I4P)                      :: ierr     !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R4P_2D

   subroutine dev_assign_to_device_R4P_3D(dst, src)
   !< Assign array, R4P kind, rank 3.
   real(R4P), intent(inout), pointer :: dst(:,:,:) !< Pointer to assign memory.
   real(R4P), intent(in)             :: src(:,:,:) !< Source memory.
   integer(I4P)                      :: ierr       !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R4P_3D

   subroutine dev_assign_to_device_R4P_4D(dst, src)
   !< Assign array, R4P kind, rank 4.
   real(R4P), intent(inout), pointer :: dst(:,:,:,:) !< Pointer to assign memory.
   real(R4P), intent(in)             :: src(:,:,:,:) !< Source memory.
   integer(I4P)                      :: ierr         !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R4P_4D

   subroutine dev_assign_to_device_R4P_5D(dst, src)
   !< Assign array, R4P kind, rank 5.
   real(R4P), intent(inout), pointer :: dst(:,:,:,:,:) !< Pointer to assign memory.
   real(R4P), intent(in)             :: src(:,:,:,:,:) !< Source memory.
   integer(I4P)                      :: ierr           !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R4P_5D

   subroutine dev_assign_to_device_R4P_6D(dst, src)
   !< Assign array, R4P kind, rank 6.
   real(R4P), intent(inout), pointer :: dst(:,:,:,:,:,:) !< Pointer to assign memory.
   real(R4P), intent(in)             :: src(:,:,:,:,:,:) !< Source memory.
   integer(I4P)                      :: ierr             !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R4P_6D

   subroutine dev_assign_to_device_R4P_7D(dst, src)
   !< Assign array, R4P kind, rank 7.
   real(R4P), intent(inout), pointer :: dst(:,:,:,:,:,:,:) !< Pointer to assign memory.
   real(R4P), intent(in)             :: src(:,:,:,:,:,:,:) !< Source memory.
   integer(I4P)                      :: ierr               !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_R4P_7D

   subroutine dev_assign_to_device_I8P_1D(dst, src)
   !< Assign array, I8P kind, rank 1.
   integer(I8P), intent(inout), pointer :: dst(:) !< Pointer to assign memory.
   integer(I8P), intent(in)             :: src(:) !< Source memory.
   integer(I4P)                         :: ierr   !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I8P_1D

   subroutine dev_assign_to_device_I8P_2D(dst, src)
   !< Assign array, I8P kind, rank 2.
   integer(I8P), intent(inout), pointer :: dst(:,:) !< Pointer to assign memory.
   integer(I8P), intent(in)             :: src(:,:) !< Source memory.
   integer(I4P)                         :: ierr     !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I8P_2D

   subroutine dev_assign_to_device_I8P_3D(dst, src)
   !< Assign array, I8P kind, rank 3.
   integer(I8P), intent(inout), pointer :: dst(:,:,:) !< Pointer to assign memory.
   integer(I8P), intent(in)             :: src(:,:,:) !< Source memory.
   integer(I4P)                         :: ierr       !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I8P_3D

   subroutine dev_assign_to_device_I8P_4D(dst, src)
   !< Assign array, I8P kind, rank 4.
   integer(I8P), intent(inout), pointer :: dst(:,:,:,:) !< Pointer to assign memory.
   integer(I8P), intent(in)             :: src(:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr         !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I8P_4D

   subroutine dev_assign_to_device_I8P_5D(dst, src)
   !< Assign array, I8P kind, rank 5.
   integer(I8P), intent(inout), pointer :: dst(:,:,:,:,:) !< Pointer to assign memory.
   integer(I8P), intent(in)             :: src(:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr           !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I8P_5D

   subroutine dev_assign_to_device_I8P_6D(dst, src)
   !< Assign array, I8P kind, rank 6.
   integer(I8P), intent(inout), pointer :: dst(:,:,:,:,:,:) !< Pointer to assign memory.
   integer(I8P), intent(in)             :: src(:,:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr             !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I8P_6D

   subroutine dev_assign_to_device_I8P_7D(dst, src)
   !< Assign array, I8P kind, rank 7.
   integer(I8P), intent(inout), pointer :: dst(:,:,:,:,:,:,:) !< Pointer to assign memory.
   integer(I8P), intent(in)             :: src(:,:,:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr               !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I8P_7D

   subroutine dev_assign_to_device_I4P_1D(dst, src)
   !< Assign array, I4P kind, rank 1.
   integer(I4P), intent(inout), pointer :: dst(:) !< Pointer to assign memory.
   integer(I4P), intent(in)             :: src(:) !< Source memory.
   integer(I4P)                         :: ierr   !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I4P_1D

   subroutine dev_assign_to_device_I4P_2D(dst, src)
   !< Assign array, I4P kind, rank 2.
   integer(I4P), intent(inout), pointer :: dst(:,:) !< Pointer to assign memory.
   integer(I4P), intent(in)             :: src(:,:) !< Source memory.
   integer(I4P)                         :: ierr     !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I4P_2D

   subroutine dev_assign_to_device_I4P_3D(dst, src)
   !< Assign array, I4P kind, rank 3.
   integer(I4P), intent(inout), pointer :: dst(:,:,:) !< Pointer to assign memory.
   integer(I4P), intent(in)             :: src(:,:,:) !< Source memory.
   integer(I4P)                         :: ierr       !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I4P_3D

   subroutine dev_assign_to_device_I4P_4D(dst, src)
   !< Assign array, I4P kind, rank 4.
   integer(I4P), intent(inout), pointer :: dst(:,:,:,:) !< Pointer to assign memory.
   integer(I4P), intent(in)             :: src(:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr         !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I4P_4D

   subroutine dev_assign_to_device_I4P_5D(dst, src)
   !< Assign array, I4P kind, rank 5.
   integer(I4P), intent(inout), pointer :: dst(:,:,:,:,:) !< Pointer to assign memory.
   integer(I4P), intent(in)             :: src(:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr           !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I4P_5D

   subroutine dev_assign_to_device_I4P_6D(dst, src)
   !< Assign array, I4P kind, rank 6.
   integer(I4P), intent(inout), pointer :: dst(:,:,:,:,:,:) !< Pointer to assign memory.
   integer(I4P), intent(in)             :: src(:,:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr             !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I4P_6D

   subroutine dev_assign_to_device_I4P_7D(dst, src)
   !< Assign array, I4P kind, rank 7.
   integer(I4P), intent(inout), pointer :: dst(:,:,:,:,:,:,:) !< Pointer to assign memory.
   integer(I4P), intent(in)             :: src(:,:,:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr               !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I4P_7D

   subroutine dev_assign_to_device_I2P_1D(dst, src)
   !< Assign array, I2P kind, rank 1.
   integer(I2P), intent(inout), pointer :: dst(:) !< Pointer to assign memory.
   integer(I2P), intent(in)             :: src(:) !< Source memory.
   integer(I4P)                         :: ierr   !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I2P_1D

   subroutine dev_assign_to_device_I2P_2D(dst, src)
   !< Assign array, I2P kind, rank 2.
   integer(I2P), intent(inout), pointer :: dst(:,:) !< Pointer to assign memory.
   integer(I2P), intent(in)             :: src(:,:) !< Source memory.
   integer(I4P)                         :: ierr     !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I2P_2D

   subroutine dev_assign_to_device_I2P_3D(dst, src)
   !< Assign array, I2P kind, rank 3.
   integer(I2P), intent(inout), pointer :: dst(:,:,:) !< Pointer to assign memory.
   integer(I2P), intent(in)             :: src(:,:,:) !< Source memory.
   integer(I4P)                         :: ierr       !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I2P_3D

   subroutine dev_assign_to_device_I2P_4D(dst, src)
   !< Assign array, I2P kind, rank 4.
   integer(I2P), intent(inout), pointer :: dst(:,:,:,:) !< Pointer to assign memory.
   integer(I2P), intent(in)             :: src(:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr         !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I2P_4D

   subroutine dev_assign_to_device_I2P_5D(dst, src)
   !< Assign array, I2P kind, rank 5.
   integer(I2P), intent(inout), pointer :: dst(:,:,:,:,:) !< Pointer to assign memory.
   integer(I2P), intent(in)             :: src(:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr           !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I2P_5D

   subroutine dev_assign_to_device_I2P_6D(dst, src)
   !< Assign array, I2P kind, rank 6.
   integer(I2P), intent(inout), pointer :: dst(:,:,:,:,:,:) !< Pointer to assign memory.
   integer(I2P), intent(in)             :: src(:,:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr             !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I2P_6D

   subroutine dev_assign_to_device_I2P_7D(dst, src)
   !< Assign array, I2P kind, rank 7.
   integer(I2P), intent(inout), pointer :: dst(:,:,:,:,:,:,:) !< Pointer to assign memory.
   integer(I2P), intent(in)             :: src(:,:,:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr               !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I2P_7D

   subroutine dev_assign_to_device_I1P_1D(dst, src)
   !< Assign array, I1P kind, rank 1.
   integer(I1P), intent(inout), pointer :: dst(:) !< Pointer to assign memory.
   integer(I1P), intent(in)             :: src(:) !< Source memory.
   integer(I4P)                         :: ierr   !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I1P_1D

   subroutine dev_assign_to_device_I1P_2D(dst, src)
   !< Assign array, I1P kind, rank 2.
   integer(I1P), intent(inout), pointer :: dst(:,:) !< Pointer to assign memory.
   integer(I1P), intent(in)             :: src(:,:) !< Source memory.
   integer(I4P)                         :: ierr     !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I1P_2D

   subroutine dev_assign_to_device_I1P_3D(dst, src)
   !< Assign array, I1P kind, rank 3.
   integer(I1P), intent(inout), pointer :: dst(:,:,:) !< Pointer to assign memory.
   integer(I1P), intent(in)             :: src(:,:,:) !< Source memory.
   integer(I4P)                         :: ierr       !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I1P_3D

   subroutine dev_assign_to_device_I1P_4D(dst, src)
   !< Assign array, I1P kind, rank 4.
   integer(I1P), intent(inout), pointer :: dst(:,:,:,:) !< Pointer to assign memory.
   integer(I1P), intent(in)             :: src(:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr         !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I1P_4D

   subroutine dev_assign_to_device_I1P_5D(dst, src)
   !< Assign array, I1P kind, rank 5.
   integer(I1P), intent(inout), pointer :: dst(:,:,:,:,:) !< Pointer to assign memory.
   integer(I1P), intent(in)             :: src(:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr           !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I1P_5D

   subroutine dev_assign_to_device_I1P_6D(dst, src)
   !< Assign array, I1P kind, rank 6.
   integer(I1P), intent(inout), pointer :: dst(:,:,:,:,:,:) !< Pointer to assign memory.
   integer(I1P), intent(in)             :: src(:,:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr             !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I1P_6D

   subroutine dev_assign_to_device_I1P_7D(dst, src)
   !< Assign array, I1P kind, rank 7.
   integer(I1P), intent(inout), pointer :: dst(:,:,:,:,:,:,:) !< Pointer to assign memory.
   integer(I1P), intent(in)             :: src(:,:,:,:,:,:,:) !< Source memory.
   integer(I4P)                         :: ierr               !< Error status.

   if (associated(dst)) call dev_free(dst)
   call dev_alloc(fptr_dev=dst, ubounds=ubound(src), lbounds=lbound(src), ierr=ierr)
   call dev_memcpy_to_device(dst=dst, src=src)
   endsubroutine dev_assign_to_device_I1P_7D
endmodule fundal_dev_assign
