!< FUNDAL, memory copy routines module, unstructured model.

#include "fundal.H"

module fundal_dev_memcpy_unstructured
!< FUNDAL, memory copy routines module, unstructured model.
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64

implicit none
private
public :: dev_memcpy_from_device_unstr
public :: dev_memcpy_to_device_unstr

interface dev_memcpy_from_device_unstr
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
                    dev_memcpy_from_device_I1P_1D,&
                    dev_memcpy_from_device_I1P_2D,&
                    dev_memcpy_from_device_I1P_3D,&
                    dev_memcpy_from_device_I1P_4D,&
                    dev_memcpy_from_device_I1P_5D,&
                    dev_memcpy_from_device_I1P_6D,&
                    dev_memcpy_from_device_I1P_7D
endinterface dev_memcpy_from_device_unstr

interface dev_memcpy_to_device_unstr
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
                    dev_memcpy_to_device_I1P_1D,&
                    dev_memcpy_to_device_I1P_2D,&
                    dev_memcpy_to_device_I1P_3D,&
                    dev_memcpy_to_device_I1P_4D,&
                    dev_memcpy_to_device_I1P_5D,&
                    dev_memcpy_to_device_I1P_6D,&
                    dev_memcpy_to_device_I1P_7D
endinterface dev_memcpy_to_device_unstr

contains
   ! memcpy_from_device
   subroutine dev_memcpy_from_device_R8P_1D(fptr_dst)
   !< Copy array from device, R8P kind, rank 1.
   real(R8P), intent(inout) :: fptr_dst(:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R8P_1D

   subroutine dev_memcpy_from_device_R8P_2D(fptr_dst)
   !< Copy array from device, R8P kind, rank 2.
   real(R8P), intent(inout) :: fptr_dst(:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R8P_2D

   subroutine dev_memcpy_from_device_R8P_3D(fptr_dst)
   !< Copy array from device, R8P kind, rank 3.
   real(R8P), intent(inout) :: fptr_dst(:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R8P_3D

   subroutine dev_memcpy_from_device_R8P_4D(fptr_dst)
   !< Copy array from device, R8P kind, rank 4.
   real(R8P), intent(inout) :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R8P_4D

   subroutine dev_memcpy_from_device_R8P_5D(fptr_dst)
   !< Copy array from device, R8P kind, rank 5.
   real(R8P), intent(inout) :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R8P_5D

   subroutine dev_memcpy_from_device_R8P_6D(fptr_dst)
   !< Copy array from device, R8P kind, rank 6.
   real(R8P), intent(inout) :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R8P_6D

   subroutine dev_memcpy_from_device_R8P_7D(fptr_dst)
   !< Copy array from device, R8P kind, rank 7.
   real(R8P), intent(inout) :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R8P_7D

   subroutine dev_memcpy_from_device_R4P_1D(fptr_dst)
   !< Copy array from device, R4P kind, rank 1.
   real(R4P), intent(inout) :: fptr_dst(:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R4P_1D

   subroutine dev_memcpy_from_device_R4P_2D(fptr_dst)
   !< Copy array from device, R4P kind, rank 2.
   real(R4P), intent(inout) :: fptr_dst(:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R4P_2D

   subroutine dev_memcpy_from_device_R4P_3D(fptr_dst)
   !< Copy array from device, R4P kind, rank 3.
   real(R4P), intent(inout) :: fptr_dst(:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R4P_3D

   subroutine dev_memcpy_from_device_R4P_4D(fptr_dst)
   !< Copy array from device, R4P kind, rank 4.
   real(R4P), intent(inout) :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R4P_4D

   subroutine dev_memcpy_from_device_R4P_5D(fptr_dst)
   !< Copy array from device, R4P kind, rank 5.
   real(R4P), intent(inout) :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R4P_5D

   subroutine dev_memcpy_from_device_R4P_6D(fptr_dst)
   !< Copy array from device, R4P kind, rank 6.
   real(R4P), intent(inout) :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R4P_6D

   subroutine dev_memcpy_from_device_R4P_7D(fptr_dst)
   !< Copy array from device, R4P kind, rank 7.
   real(R4P), intent(inout) :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_R4P_7D

   subroutine dev_memcpy_from_device_I8P_1D(fptr_dst)
   !< Copy array from device, I8P kind, rank 1.
   integer(I8P), intent(inout) :: fptr_dst(:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I8P_1D

   subroutine dev_memcpy_from_device_I8P_2D(fptr_dst)
   !< Copy array from device, I8P kind, rank 2.
   integer(I8P), intent(inout) :: fptr_dst(:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I8P_2D

   subroutine dev_memcpy_from_device_I8P_3D(fptr_dst)
   !< Copy array from device, I8P kind, rank 3.
   integer(I8P), intent(inout) :: fptr_dst(:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I8P_3D

   subroutine dev_memcpy_from_device_I8P_4D(fptr_dst)
   !< Copy array from device, I8P kind, rank 4.
   integer(I8P), intent(inout) :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I8P_4D

   subroutine dev_memcpy_from_device_I8P_5D(fptr_dst)
   !< Copy array from device, I8P kind, rank 5.
   integer(I8P), intent(inout) :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I8P_5D

   subroutine dev_memcpy_from_device_I8P_6D(fptr_dst)
   !< Copy array from device, I8P kind, rank 6.
   integer(I8P), intent(inout) :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I8P_6D

   subroutine dev_memcpy_from_device_I8P_7D(fptr_dst)
   !< Copy array from device, I8P kind, rank 7.
   integer(I8P), intent(inout) :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I8P_7D

   subroutine dev_memcpy_from_device_I4P_1D(fptr_dst)
   !< Copy array from device, I4P kind, rank 1.
   integer(I4P), intent(inout) :: fptr_dst(:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I4P_1D

   subroutine dev_memcpy_from_device_I4P_2D(fptr_dst)
   !< Copy array from device, I4P kind, rank 2.
   integer(I4P), intent(inout) :: fptr_dst(:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I4P_2D

   subroutine dev_memcpy_from_device_I4P_3D(fptr_dst)
   !< Copy array from device, I4P kind, rank 3.
   integer(I4P), intent(inout) :: fptr_dst(:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I4P_3D

   subroutine dev_memcpy_from_device_I4P_4D(fptr_dst)
   !< Copy array from device, I4P kind, rank 4.
   integer(I4P), intent(inout) :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I4P_4D

   subroutine dev_memcpy_from_device_I4P_5D(fptr_dst)
   !< Copy array from device, I4P kind, rank 5.
   integer(I4P), intent(inout) :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I4P_5D

   subroutine dev_memcpy_from_device_I4P_6D(fptr_dst)
   !< Copy array from device, I4P kind, rank 6.
   integer(I4P), intent(inout) :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I4P_6D

   subroutine dev_memcpy_from_device_I4P_7D(fptr_dst)
   !< Copy array from device, I4P kind, rank 7.
   integer(I4P), intent(inout) :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I4P_7D

   subroutine dev_memcpy_from_device_I1P_1D(fptr_dst)
   !< Copy array from device, I1P kind, rank 1.
   integer(I1P), intent(inout) :: fptr_dst(:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I1P_1D

   subroutine dev_memcpy_from_device_I1P_2D(fptr_dst)
   !< Copy array from device, I1P kind, rank 2.
   integer(I1P), intent(inout) :: fptr_dst(:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I1P_2D

   subroutine dev_memcpy_from_device_I1P_3D(fptr_dst)
   !< Copy array from device, I1P kind, rank 3.
   integer(I1P), intent(inout) :: fptr_dst(:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I1P_3D

   subroutine dev_memcpy_from_device_I1P_4D(fptr_dst)
   !< Copy array from device, I1P kind, rank 4.
   integer(I1P), intent(inout) :: fptr_dst(:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I1P_4D

   subroutine dev_memcpy_from_device_I1P_5D(fptr_dst)
   !< Copy array from device, I1P kind, rank 5.
   integer(I1P), intent(inout) :: fptr_dst(:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I1P_5D

   subroutine dev_memcpy_from_device_I1P_6D(fptr_dst)
   !< Copy array from device, I1P kind, rank 6.
   integer(I1P), intent(inout) :: fptr_dst(:,:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I1P_6D

   subroutine dev_memcpy_from_device_I1P_7D(fptr_dst)
   !< Copy array from device, I1P kind, rank 7.
   integer(I1P), intent(inout) :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (host memory).
   !$acc update self(fptr_dst)
   !$omp target update from(fptr_dst)
   endsubroutine dev_memcpy_from_device_I1P_7D

   ! acc_memcpy_to_device
   subroutine dev_memcpy_to_device_R8P_1D(fptr_dst)
   !< Copy array to device, R8P kind, rank 1.
   real(R8P), intent(inout) :: fptr_dst(:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R8P_1D

   subroutine dev_memcpy_to_device_R8P_2D(fptr_dst)
   !< Copy array to device, R8P kind, rank 2.
   real(R8P), intent(inout) :: fptr_dst(:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R8P_2D

   subroutine dev_memcpy_to_device_R8P_3D(fptr_dst)
   !< Copy array to device, R8P kind, rank 3.
   real(R8P), intent(inout) :: fptr_dst(:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R8P_3D

   subroutine dev_memcpy_to_device_R8P_4D(fptr_dst)
   !< Copy array to device, R8P kind, rank 4.
   real(R8P), intent(inout) :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R8P_4D

   subroutine dev_memcpy_to_device_R8P_5D(fptr_dst)
   !< Copy array to device, R8P kind, rank 5.
   real(R8P), intent(inout) :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R8P_5D

   subroutine dev_memcpy_to_device_R8P_6D(fptr_dst)
   !< Copy array to device, R8P kind, rank 6.
   real(R8P), intent(inout) :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R8P_6D

   subroutine dev_memcpy_to_device_R8P_7D(fptr_dst)
   !< Copy array to device, R8P kind, rank 7.
   real(R8P), intent(inout) :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R8P_7D

   subroutine dev_memcpy_to_device_R4P_1D(fptr_dst)
   !< Copy array to device, R4P kind, rank 1.
   real(R4P), intent(inout) :: fptr_dst(:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R4P_1D

   subroutine dev_memcpy_to_device_R4P_2D(fptr_dst)
   !< Copy array to device, R4P kind, rank 2.
   real(R4P), intent(inout) :: fptr_dst(:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R4P_2D

   subroutine dev_memcpy_to_device_R4P_3D(fptr_dst)
   !< Copy array to device, R4P kind, rank 3.
   real(R4P), intent(inout) :: fptr_dst(:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R4P_3D

   subroutine dev_memcpy_to_device_R4P_4D(fptr_dst)
   !< Copy array to device, R4P kind, rank 4.
   real(R4P), intent(inout) :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R4P_4D

   subroutine dev_memcpy_to_device_R4P_5D(fptr_dst)
   !< Copy array to device, R4P kind, rank 5.
   real(R4P), intent(inout) :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R4P_5D

   subroutine dev_memcpy_to_device_R4P_6D(fptr_dst)
   !< Copy array to device, R4P kind, rank 6.
   real(R4P), intent(inout) :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R4P_6D

   subroutine dev_memcpy_to_device_R4P_7D(fptr_dst)
   !< Copy array to device, R4P kind, rank 7.
   real(R4P), intent(inout) :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_R4P_7D

   subroutine dev_memcpy_to_device_I8P_1D(fptr_dst)
   !< Copy array to device, I8P kind, rank 1.
   integer(I8P), intent(inout) :: fptr_dst(:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I8P_1D

   subroutine dev_memcpy_to_device_I8P_2D(fptr_dst)
   !< Copy array to device, I8P kind, rank 2.
   integer(I8P), intent(inout) :: fptr_dst(:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I8P_2D

   subroutine dev_memcpy_to_device_I8P_3D(fptr_dst)
   !< Copy array to device, I8P kind, rank 3.
   integer(I8P), intent(inout) :: fptr_dst(:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I8P_3D

   subroutine dev_memcpy_to_device_I8P_4D(fptr_dst)
   !< Copy array to device, I8P kind, rank 4.
   integer(I8P), intent(inout) :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I8P_4D

   subroutine dev_memcpy_to_device_I8P_5D(fptr_dst)
   !< Copy array to device, I8P kind, rank 5.
   integer(I8P), intent(inout) :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I8P_5D

   subroutine dev_memcpy_to_device_I8P_6D(fptr_dst)
   !< Copy array to device, I8P kind, rank 6.
   integer(I8P), intent(inout) :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I8P_6D

   subroutine dev_memcpy_to_device_I8P_7D(fptr_dst)
   !< Copy array to device, I8P kind, rank 7.
   integer(I8P), intent(inout) :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I8P_7D

   subroutine dev_memcpy_to_device_I4P_1D(fptr_dst)
   !< Copy array to device, I4P kind, rank 1.
   integer(I4P), intent(inout) :: fptr_dst(:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I4P_1D

   subroutine dev_memcpy_to_device_I4P_2D(fptr_dst)
   !< Copy array to device, I4P kind, rank 2.
   integer(I4P), intent(inout) :: fptr_dst(:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I4P_2D

   subroutine dev_memcpy_to_device_I4P_3D(fptr_dst)
   !< Copy array to device, I4P kind, rank 3.
   integer(I4P), intent(inout) :: fptr_dst(:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I4P_3D

   subroutine dev_memcpy_to_device_I4P_4D(fptr_dst)
   !< Copy array to device, I4P kind, rank 4.
   integer(I4P), intent(inout) :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I4P_4D

   subroutine dev_memcpy_to_device_I4P_5D(fptr_dst)
   !< Copy array to device, I4P kind, rank 5.
   integer(I4P), intent(inout) :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I4P_5D

   subroutine dev_memcpy_to_device_I4P_6D(fptr_dst)
   !< Copy array to device, I4P kind, rank 6.
   integer(I4P), intent(inout) :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I4P_6D

   subroutine dev_memcpy_to_device_I4P_7D(fptr_dst)
   !< Copy array to device, I4P kind, rank 7.
   integer(I4P), intent(inout) :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I4P_7D

   subroutine dev_memcpy_to_device_I1P_1D(fptr_dst)
   !< Copy array to device, I1P kind, rank 1.
   integer(I1P), intent(inout) :: fptr_dst(:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I1P_1D

   subroutine dev_memcpy_to_device_I1P_2D(fptr_dst)
   !< Copy array to device, I1P kind, rank 2.
   integer(I1P), intent(inout) :: fptr_dst(:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I1P_2D

   subroutine dev_memcpy_to_device_I1P_3D(fptr_dst)
   !< Copy array to device, I1P kind, rank 3.
   integer(I1P), intent(inout) :: fptr_dst(:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I1P_3D

   subroutine dev_memcpy_to_device_I1P_4D(fptr_dst)
   !< Copy array to device, I1P kind, rank 4.
   integer(I1P), intent(inout) :: fptr_dst(:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I1P_4D

   subroutine dev_memcpy_to_device_I1P_5D(fptr_dst)
   !< Copy array to device, I1P kind, rank 5.
   integer(I1P), intent(inout) :: fptr_dst(:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I1P_5D

   subroutine dev_memcpy_to_device_I1P_6D(fptr_dst)
   !< Copy array to device, I1P kind, rank 6.
   integer(I1P), intent(inout) :: fptr_dst(:,:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I1P_6D

   subroutine dev_memcpy_to_device_I1P_7D(fptr_dst)
   !< Copy array to device, I1P kind, rank 7.
   integer(I1P), intent(inout) :: fptr_dst(:,:,:,:,:,:,:) !< Destination memory (device memory).
   !$acc update device(fptr_dst)
   !$omp target update to(fptr_dst)
   endsubroutine dev_memcpy_to_device_I1P_7D
endmodule fundal_dev_memcpy_unstructured
