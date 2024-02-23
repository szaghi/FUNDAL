!< FUNDAL, memory free routines module for OpenMP backend.
module fundal_omp_free
!< FUNDAL, memory free routines module for OpenMP backend.
use, intrinsic :: iso_c_binding
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: omp_lib, only : omp_target_free

implicit none
private
public :: omp_free

interface omp_free
   !< Free device memory OpenMP backend.
   module procedure omp_free_R8P_1D, &
                    omp_free_R8P_2D, &
                    omp_free_R8P_3D, &
                    omp_free_R8P_4D, &
                    omp_free_R8P_5D, &
                    omp_free_R8P_6D, &
                    omp_free_R8P_7D, &
                    omp_free_R4P_1D, &
                    omp_free_R4P_2D, &
                    omp_free_R4P_3D, &
                    omp_free_R4P_4D, &
                    omp_free_R4P_5D, &
                    omp_free_R4P_6D, &
                    omp_free_R4P_7D, &
                    omp_free_I8P_1D, &
                    omp_free_I8P_2D, &
                    omp_free_I8P_3D, &
                    omp_free_I8P_4D, &
                    omp_free_I8P_5D, &
                    omp_free_I8P_6D, &
                    omp_free_I8P_7D, &
                    omp_free_I4P_1D, &
                    omp_free_I4P_2D, &
                    omp_free_I4P_3D, &
                    omp_free_I4P_4D, &
                    omp_free_I4P_5D, &
                    omp_free_I4P_6D, &
                    omp_free_I4P_7D, &
                    omp_free_I1P_1D, &
                    omp_free_I1P_2D, &
                    omp_free_I1P_3D, &
                    omp_free_I1P_4D, &
                    omp_free_I1P_5D, &
                    omp_free_I1P_6D, &
                    omp_free_I1P_7D
endinterface omp_free

contains
   subroutine omp_free_R8P_1D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 1.
   real(R8P),    intent(inout), pointer :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id  !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R8P_1D

   subroutine omp_free_R8P_2D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 2.
   real(R8P),    intent(inout), pointer :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id    !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R8P_2D

   subroutine omp_free_R8P_3D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 3.
   real(R8P),    intent(inout), pointer :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id      !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R8P_3D

   subroutine omp_free_R8P_4D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 4.
   real(R8P),    intent(inout), pointer :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id        !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R8P_4D

   subroutine omp_free_R8P_5D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 5.
   real(R8P),    intent(inout), pointer :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id          !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R8P_5D

   subroutine omp_free_R8P_6D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 6.
   real(R8P),    intent(inout), pointer :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id            !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R8P_6D

   subroutine omp_free_R8P_7D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 7.
   real(R8P),    intent(inout), pointer :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id              !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R8P_7D

   subroutine omp_free_R4P_1D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 1.
   real(R4P),    intent(inout), pointer :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id  !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R4P_1D

   subroutine omp_free_R4P_2D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 2.
   real(R4P),    intent(inout), pointer :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id    !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R4P_2D

   subroutine omp_free_R4P_3D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 3.
   real(R4P),    intent(inout), pointer :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id      !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R4P_3D

   subroutine omp_free_R4P_4D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 4.
   real(R4P),    intent(inout), pointer :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id        !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R4P_4D

   subroutine omp_free_R4P_5D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 5.
   real(R4P),    intent(inout), pointer :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id          !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R4P_5D

   subroutine omp_free_R4P_6D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 6.
   real(R4P),    intent(inout), pointer :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id            !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R4P_6D

   subroutine omp_free_R4P_7D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 7.
   real(R4P),    intent(inout), pointer :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id              !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_R4P_7D

   subroutine omp_free_I8P_1D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 1.
   integer(I8P), intent(inout), pointer :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id  !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I8P_1D

   subroutine omp_free_I8P_2D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 2.
   integer(I8P), intent(inout), pointer :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id    !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I8P_2D

   subroutine omp_free_I8P_3D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 3.
   integer(I8P), intent(inout), pointer :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id      !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I8P_3D

   subroutine omp_free_I8P_4D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 4.
   integer(I8P), intent(inout), pointer :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id        !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I8P_4D

   subroutine omp_free_I8P_5D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 5.
   integer(I8P), intent(inout), pointer :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id          !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I8P_5D

   subroutine omp_free_I8P_6D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 6.
   integer(I8P), intent(inout), pointer :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id            !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I8P_6D

   subroutine omp_free_I8P_7D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 7.
   integer(I8P), intent(inout), pointer :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id              !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I8P_7D

   subroutine omp_free_I4P_1D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 1.
   integer(I4P), intent(inout), pointer :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id  !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I4P_1D

   subroutine omp_free_I4P_2D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 2.
   integer(I4P), intent(inout), pointer :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id    !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I4P_2D

   subroutine omp_free_I4P_3D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 3.
   integer(I4P), intent(inout), pointer :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id      !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I4P_3D

   subroutine omp_free_I4P_4D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 4.
   integer(I4P), intent(inout), pointer :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id        !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I4P_4D

   subroutine omp_free_I4P_5D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 5.
   integer(I4P), intent(inout), pointer :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id          !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I4P_5D

   subroutine omp_free_I4P_6D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 6.
   integer(I4P), intent(inout), pointer :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id            !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I4P_6D

   subroutine omp_free_I4P_7D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 7.
   integer(I4P), intent(inout), pointer :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id              !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I4P_7D

   subroutine omp_free_I1P_1D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 1.
   integer(I1P), intent(inout), pointer :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id  !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I1P_1D

   subroutine omp_free_I1P_2D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 2.
   integer(I1P), intent(inout), pointer :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id    !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I1P_2D

   subroutine omp_free_I1P_3D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 3.
   integer(I1P), intent(inout), pointer :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id      !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I1P_3D

   subroutine omp_free_I1P_4D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 4.
   integer(I1P), intent(inout), pointer :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id        !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I1P_4D

   subroutine omp_free_I1P_5D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 5.
   integer(I1P), intent(inout), pointer :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id          !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I1P_5D

   subroutine omp_free_I1P_6D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 6.
   integer(I1P), intent(inout), pointer :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id            !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I1P_6D

   subroutine omp_free_I1P_7D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 7.
   integer(I1P), intent(inout), pointer :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in)             :: dev_id              !< Device ID.

   call omp_target_free(c_loc(fptr), int(dev_id, c_int))
   nullify(fptr)
   endsubroutine omp_free_I1P_7D
endmodule fundal_omp_free
