!< FUNDAL, memory free routines module, unstructured model.

#include "fundal.H"

module fundal_dev_free_unstructured
!< FUNDAL, memory free routines module, unstructured model.
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64

implicit none
private
public :: dev_free_unstr

interface dev_free_unstr
   !< Free device memory, unstructured model.
   module procedure dev_free_R8P_1D,&
                    dev_free_R8P_2D,&
                    dev_free_R8P_3D,&
                    dev_free_R8P_4D,&
                    dev_free_R8P_5D,&
                    dev_free_R8P_6D,&
                    dev_free_R8P_7D,&
                    dev_free_R4P_1D,&
                    dev_free_R4P_2D,&
                    dev_free_R4P_3D,&
                    dev_free_R4P_4D,&
                    dev_free_R4P_5D,&
                    dev_free_R4P_6D,&
                    dev_free_R4P_7D,&
                    dev_free_I8P_1D,&
                    dev_free_I8P_2D,&
                    dev_free_I8P_3D,&
                    dev_free_I8P_4D,&
                    dev_free_I8P_5D,&
                    dev_free_I8P_6D,&
                    dev_free_I8P_7D,&
                    dev_free_I4P_1D,&
                    dev_free_I4P_2D,&
                    dev_free_I4P_3D,&
                    dev_free_I4P_4D,&
                    dev_free_I4P_5D,&
                    dev_free_I4P_6D,&
                    dev_free_I4P_7D,&
                    dev_free_I1P_1D,&
                    dev_free_I1P_2D,&
                    dev_free_I1P_3D,&
                    dev_free_I1P_4D,&
                    dev_free_I1P_5D,&
                    dev_free_I1P_6D,&
                    dev_free_I1P_7D
endinterface dev_free_unstr

contains
   subroutine dev_free_R8P_1D(fptr)
   !< Free array from device, R8P kind, rank 1.
   real(R8P), intent(inout) :: fptr(:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R8P_1D

   subroutine dev_free_R8P_2D(fptr)
   !< Free array from device, R8P kind, rank 2.
   real(R8P), intent(inout) :: fptr(:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R8P_2D

   subroutine dev_free_R8P_3D(fptr)
   !< Free array from device, R8P kind, rank 3.
   real(R8P), intent(inout) :: fptr(:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R8P_3D

   subroutine dev_free_R8P_4D(fptr)
   !< Free array from device, R8P kind, rank 4.
   real(R8P), intent(inout) :: fptr(:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R8P_4D

   subroutine dev_free_R8P_5D(fptr)
   !< Free array from device, R8P kind, rank 5.
   real(R8P), intent(inout) :: fptr(:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R8P_5D

   subroutine dev_free_R8P_6D(fptr)
   !< Free array from device, R8P kind, rank 6.
   real(R8P), intent(inout) :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R8P_6D

   subroutine dev_free_R8P_7D(fptr)
   !< Free array from device, R8P kind, rank 7.
   real(R8P), intent(inout) :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R8P_7D

   subroutine dev_free_R4P_1D(fptr)
   !< Free array from device, R4P kind, rank 1.
   real(R4P), intent(inout) :: fptr(:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R4P_1D

   subroutine dev_free_R4P_2D(fptr)
   !< Free array from device, R4P kind, rank 2.
   real(R4P), intent(inout) :: fptr(:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R4P_2D

   subroutine dev_free_R4P_3D(fptr)
   !< Free array from device, R4P kind, rank 3.
   real(R4P), intent(inout) :: fptr(:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R4P_3D

   subroutine dev_free_R4P_4D(fptr)
   !< Free array from device, R4P kind, rank 4.
   real(R4P), intent(inout) :: fptr(:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R4P_4D

   subroutine dev_free_R4P_5D(fptr)
   !< Free array from device, R4P kind, rank 5.
   real(R4P), intent(inout) :: fptr(:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R4P_5D

   subroutine dev_free_R4P_6D(fptr)
   !< Free array from device, R4P kind, rank 6.
   real(R4P), intent(inout) :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R4P_6D

   subroutine dev_free_R4P_7D(fptr)
   !< Free array from device, R4P kind, rank 7.
   real(R4P), intent(inout) :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_R4P_7D

   subroutine dev_free_I8P_1D(fptr)
   !< Free array from device, I8P kind, rank 1.
   integer(I8P), intent(inout) :: fptr(:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I8P_1D

   subroutine dev_free_I8P_2D(fptr)
   !< Free array from device, I8P kind, rank 2.
   integer(I8P), intent(inout) :: fptr(:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I8P_2D

   subroutine dev_free_I8P_3D(fptr)
   !< Free array from device, I8P kind, rank 3.
   integer(I8P), intent(inout) :: fptr(:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I8P_3D

   subroutine dev_free_I8P_4D(fptr)
   !< Free array from device, I8P kind, rank 4.
   integer(I8P), intent(inout) :: fptr(:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I8P_4D

   subroutine dev_free_I8P_5D(fptr)
   !< Free array from device, I8P kind, rank 5.
   integer(I8P), intent(inout) :: fptr(:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I8P_5D

   subroutine dev_free_I8P_6D(fptr)
   !< Free array from device, I8P kind, rank 6.
   integer(I8P), intent(inout) :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I8P_6D

   subroutine dev_free_I8P_7D(fptr)
   !< Free array from device, I8P kind, rank 7.
   integer(I8P), intent(inout) :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I8P_7D

   subroutine dev_free_I4P_1D(fptr)
   !< Free array from device, I4P kind, rank 1.
   integer(I4P), intent(inout) :: fptr(:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I4P_1D

   subroutine dev_free_I4P_2D(fptr)
   !< Free array from device, I4P kind, rank 2.
   integer(I4P), intent(inout) :: fptr(:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I4P_2D

   subroutine dev_free_I4P_3D(fptr)
   !< Free array from device, I4P kind, rank 3.
   integer(I4P), intent(inout) :: fptr(:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I4P_3D

   subroutine dev_free_I4P_4D(fptr)
   !< Free array from device, I4P kind, rank 4.
   integer(I4P), intent(inout) :: fptr(:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I4P_4D

   subroutine dev_free_I4P_5D(fptr)
   !< Free array from device, I4P kind, rank 5.
   integer(I4P), intent(inout) :: fptr(:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I4P_5D

   subroutine dev_free_I4P_6D(fptr)
   !< Free array from device, I4P kind, rank 6.
   integer(I4P), intent(inout) :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I4P_6D

   subroutine dev_free_I4P_7D(fptr)
   !< Free array from device, I4P kind, rank 7.
   integer(I4P), intent(inout) :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I4P_7D

   subroutine dev_free_I1P_1D(fptr)
   !< Free array from device, I1P kind, rank 1.
   integer(I1P), intent(inout) :: fptr(:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I1P_1D

   subroutine dev_free_I1P_2D(fptr)
   !< Free array from device, I1P kind, rank 2.
   integer(I1P), intent(inout) :: fptr(:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I1P_2D

   subroutine dev_free_I1P_3D(fptr)
   !< Free array from device, I1P kind, rank 3.
   integer(I1P), intent(inout) :: fptr(:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I1P_3D

   subroutine dev_free_I1P_4D(fptr)
   !< Free array from device, I1P kind, rank 4.
   integer(I1P), intent(inout) :: fptr(:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I1P_4D

   subroutine dev_free_I1P_5D(fptr)
   !< Free array from device, I1P kind, rank 5.
   integer(I1P), intent(inout) :: fptr(:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I1P_5D

   subroutine dev_free_I1P_6D(fptr)
   !< Free array from device, I1P kind, rank 6.
   integer(I1P), intent(inout) :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I1P_6D

   subroutine dev_free_I1P_7D(fptr)
   !< Free array from device, I1P kind, rank 7.
   integer(I1P), intent(inout) :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   endsubroutine dev_free_I1P_7D
endmodule fundal_dev_free_unstructured
