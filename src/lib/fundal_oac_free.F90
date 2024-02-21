module fundal_oac_free
!< FUNDAL, memory free routines module for OpenACC backend.
use, intrinsic :: iso_c_binding
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use, intrinsic :: openacc
use fundal_utilities

implicit none

private
public :: oac_free

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

interface
   subroutine acc_free_f(dev_ptr) bind(c, name="acc_free")
   use iso_c_binding, only : c_ptr
   implicit none
   type(c_ptr), value :: dev_ptr
   endsubroutine acc_free_f
endinterface

contains
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
endmodule fundal_oac_free
