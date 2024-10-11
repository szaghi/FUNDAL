!< FUNDAL, memory free routines module.

#include "fundal.H"

#if defined DEV_OAC
#   define DEVFREE(p, d) call acc_free_f(p)
#elif defined DEV_OMP
#   define DEVFREE(p, d) call omp_target_free(p, d)
#else
#   define DEVFREE(p, d) call free_f(p)
#endif

module fundal_dev_free
!< FUNDAL, memory free routines module.
use, intrinsic :: iso_c_binding
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I2P=>int16, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: DEVMODULE
use            :: fundal_env,      only : mydev

implicit none
private
public :: dev_free

interface dev_free
   !< Free device memory OpenACC backend.
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
                    dev_free_I2P_1D,&
                    dev_free_I2P_2D,&
                    dev_free_I2P_3D,&
                    dev_free_I2P_4D,&
                    dev_free_I2P_5D,&
                    dev_free_I2P_6D,&
                    dev_free_I2P_7D,&
                    dev_free_I1P_1D,&
                    dev_free_I1P_2D,&
                    dev_free_I1P_3D,&
                    dev_free_I1P_4D,&
                    dev_free_I1P_5D,&
                    dev_free_I1P_6D,&
                    dev_free_I1P_7D
endinterface dev_free

#ifdef DEV_OAC
interface
   ! interface to C runtime routines
   subroutine acc_free_f(dev_ptr) bind(c, name="acc_free")
   use iso_c_binding, only : c_ptr
   implicit none
   type(c_ptr), value :: dev_ptr
   endsubroutine acc_free_f
endinterface
#else
interface
   ! interface to C runtime routines
   subroutine free_f(dev_ptr) bind(c, name="free")
   use iso_c_binding, only : c_ptr
   implicit none
   type(c_ptr), value :: dev_ptr
   endsubroutine free_f
endinterface
#endif

contains
   subroutine dev_free_R8P_1D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 1.
   real(R8P), intent(inout), pointer  :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id  !< Device ID.
   integer(I4P)                       :: dev_id_ !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R8P_1D

   subroutine dev_free_R8P_2D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 2.
   real(R8P), intent(inout), pointer  :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id    !< Device ID.
   integer(I4P)                       :: dev_id_   !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R8P_2D

   subroutine dev_free_R8P_3D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 3.
   real(R8P), intent(inout), pointer  :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id      !< Device ID.
   integer(I4P)                       :: dev_id_     !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R8P_3D

   subroutine dev_free_R8P_4D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 4.
   real(R8P), intent(inout), pointer  :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id        !< Device ID.
   integer(I4P)                       :: dev_id_       !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R8P_4D

   subroutine dev_free_R8P_5D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 5.
   real(R8P), intent(inout), pointer  :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id          !< Device ID.
   integer(I4P)                       :: dev_id_         !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R8P_5D

   subroutine dev_free_R8P_6D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 6.
   real(R8P), intent(inout), pointer  :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id            !< Device ID.
   integer(I4P)                       :: dev_id_           !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R8P_6D

   subroutine dev_free_R8P_7D(fptr, dev_id)
   !< Free array from device, R8P kind, rank 7.
   real(R8P), intent(inout), pointer  :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id              !< Device ID.
   integer(I4P)                       :: dev_id_             !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R8P_7D

   subroutine dev_free_R4P_1D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 1.
   real(R4P), intent(inout), pointer  :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id  !< Device ID.
   integer(I4P)                       :: dev_id_ !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R4P_1D

   subroutine dev_free_R4P_2D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 2.
   real(R4P), intent(inout), pointer  :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id    !< Device ID.
   integer(I4P)                       :: dev_id_   !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R4P_2D

   subroutine dev_free_R4P_3D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 3.
   real(R4P), intent(inout), pointer  :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id      !< Device ID.
   integer(I4P)                       :: dev_id_     !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R4P_3D

   subroutine dev_free_R4P_4D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 4.
   real(R4P), intent(inout), pointer  :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id        !< Device ID.
   integer(I4P)                       :: dev_id_       !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R4P_4D

   subroutine dev_free_R4P_5D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 5.
   real(R4P), intent(inout), pointer  :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id          !< Device ID.
   integer(I4P)                       :: dev_id_         !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R4P_5D

   subroutine dev_free_R4P_6D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 6.
   real(R4P), intent(inout), pointer  :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id            !< Device ID.
   integer(I4P)                       :: dev_id_           !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R4P_6D

   subroutine dev_free_R4P_7D(fptr, dev_id)
   !< Free array from device, R4P kind, rank 7.
   real(R4P), intent(inout), pointer  :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional :: dev_id              !< Device ID.
   integer(I4P)                       :: dev_id_             !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_R4P_7D

   subroutine dev_free_I8P_1D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 1.
   integer(I8P), intent(inout), pointer :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id  !< Device ID.
   integer(I4P)                         :: dev_id_ !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I8P_1D

   subroutine dev_free_I8P_2D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 2.
   integer(I8P), intent(inout), pointer :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id    !< Device ID.
   integer(I4P)                         :: dev_id_   !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I8P_2D

   subroutine dev_free_I8P_3D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 3.
   integer(I8P), intent(inout), pointer :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id      !< Device ID.
   integer(I4P)                         :: dev_id_     !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I8P_3D

   subroutine dev_free_I8P_4D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 4.
   integer(I8P), intent(inout), pointer :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id        !< Device ID.
   integer(I4P)                         :: dev_id_       !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I8P_4D

   subroutine dev_free_I8P_5D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 5.
   integer(I8P), intent(inout), pointer :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id          !< Device ID.
   integer(I4P)                         :: dev_id_         !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I8P_5D

   subroutine dev_free_I8P_6D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 6.
   integer(I8P), intent(inout), pointer :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id            !< Device ID.
   integer(I4P)                         :: dev_id_           !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I8P_6D

   subroutine dev_free_I8P_7D(fptr, dev_id)
   !< Free array from device, I8P kind, rank 7.
   integer(I8P), intent(inout), pointer :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id              !< Device ID.
   integer(I4P)                         :: dev_id_             !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I8P_7D

   subroutine dev_free_I4P_1D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 1.
   integer(I4P), intent(inout), pointer :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id  !< Device ID.
   integer(I4P)                         :: dev_id_ !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I4P_1D

   subroutine dev_free_I4P_2D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 2.
   integer(I4P), intent(inout), pointer :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id    !< Device ID.
   integer(I4P)                         :: dev_id_   !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I4P_2D

   subroutine dev_free_I4P_3D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 3.
   integer(I4P), intent(inout), pointer :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id      !< Device ID.
   integer(I4P)                         :: dev_id_     !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I4P_3D

   subroutine dev_free_I4P_4D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 4.
   integer(I4P), intent(inout), pointer :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id        !< Device ID.
   integer(I4P)                         :: dev_id_       !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I4P_4D

   subroutine dev_free_I4P_5D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 5.
   integer(I4P), intent(inout), pointer :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id          !< Device ID.
   integer(I4P)                         :: dev_id_         !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I4P_5D

   subroutine dev_free_I4P_6D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 6.
   integer(I4P), intent(inout), pointer :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id            !< Device ID.
   integer(I4P)                         :: dev_id_           !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I4P_6D

   subroutine dev_free_I4P_7D(fptr, dev_id)
   !< Free array from device, I4P kind, rank 7.
   integer(I4P), intent(inout), pointer :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id              !< Device ID.
   integer(I4P)                         :: dev_id_             !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I4P_7D

   subroutine dev_free_I2P_1D(fptr, dev_id)
   !< Free array from device, I2P kind, rank 1.
   integer(I2P), intent(inout), pointer :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id  !< Device ID.
   integer(I4P)                         :: dev_id_ !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I2P_1D

   subroutine dev_free_I2P_2D(fptr, dev_id)
   !< Free array from device, I2P kind, rank 2.
   integer(I2P), intent(inout), pointer :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id    !< Device ID.
   integer(I4P)                         :: dev_id_   !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I2P_2D

   subroutine dev_free_I2P_3D(fptr, dev_id)
   !< Free array from device, I2P kind, rank 3.
   integer(I2P), intent(inout), pointer :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id      !< Device ID.
   integer(I4P)                         :: dev_id_     !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I2P_3D

   subroutine dev_free_I2P_4D(fptr, dev_id)
   !< Free array from device, I2P kind, rank 4.
   integer(I2P), intent(inout), pointer :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id        !< Device ID.
   integer(I4P)                         :: dev_id_       !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I2P_4D

   subroutine dev_free_I2P_5D(fptr, dev_id)
   !< Free array from device, I2P kind, rank 5.
   integer(I2P), intent(inout), pointer :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id          !< Device ID.
   integer(I4P)                         :: dev_id_         !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I2P_5D

   subroutine dev_free_I2P_6D(fptr, dev_id)
   !< Free array from device, I2P kind, rank 6.
   integer(I2P), intent(inout), pointer :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id            !< Device ID.
   integer(I4P)                         :: dev_id_           !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I2P_6D

   subroutine dev_free_I2P_7D(fptr, dev_id)
   !< Free array from device, I2P kind, rank 7.
   integer(I2P), intent(inout), pointer :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id              !< Device ID.
   integer(I4P)                         :: dev_id_             !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I2P_7D

   subroutine dev_free_I1P_1D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 1.
   integer(I1P), intent(inout), pointer :: fptr(:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id  !< Device ID.
   integer(I4P)                         :: dev_id_ !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I1P_1D

   subroutine dev_free_I1P_2D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 2.
   integer(I1P), intent(inout), pointer :: fptr(:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id    !< Device ID.
   integer(I4P)                         :: dev_id_   !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I1P_2D

   subroutine dev_free_I1P_3D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 3.
   integer(I1P), intent(inout), pointer :: fptr(:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id      !< Device ID.
   integer(I4P)                         :: dev_id_     !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I1P_3D

   subroutine dev_free_I1P_4D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 4.
   integer(I1P), intent(inout), pointer :: fptr(:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id        !< Device ID.
   integer(I4P)                         :: dev_id_       !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I1P_4D

   subroutine dev_free_I1P_5D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 5.
   integer(I1P), intent(inout), pointer :: fptr(:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id          !< Device ID.
   integer(I4P)                         :: dev_id_         !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I1P_5D

   subroutine dev_free_I1P_6D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 6.
   integer(I1P), intent(inout), pointer :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id            !< Device ID.
   integer(I4P)                         :: dev_id_           !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I1P_6D

   subroutine dev_free_I1P_7D(fptr, dev_id)
   !< Free array from device, I1P kind, rank 7.
   integer(I1P), intent(inout), pointer :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   integer(I4P), intent(in), optional   :: dev_id              !< Device ID.
   integer(I4P)                         :: dev_id_             !< Device ID, local var.

   dev_id_ = mydev ; if (present(dev_id)) dev_id_ = dev_id
   DEVFREE(c_loc(fptr), int(dev_id_, c_int))
   nullify(fptr)
   endsubroutine dev_free_I1P_7D
endmodule fundal_dev_free
