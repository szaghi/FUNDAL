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
use            :: fundal_env,      only : devtype, mydev
use            :: fundal_registry, only : registry_address, registry_entry, registry_lookup, registry_misuse, &
                                          registry_policy, registry_remove, FUNDAL_REGISTRY_OFF,               &
                                          FUNDAL_ERR_DEV_ID_MISMATCH, FUNDAL_ERR_NOT_REGISTERED

implicit none
private
public :: dev_free
public :: free_checked

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
! OpenACC runtime routines are bound directly to their C API (void*, size_t) on purpose, instead of being taken from the
! vendor `openacc` module, whose Fortran interfaces are not portable (verified on nvhpc 26.1 and gfortran 16, see #2):
! - nvfortran declares acc_malloc/acc_free/acc_memcpy_* with the NVIDIA-only type(c_devptr), not type(c_ptr);
! - gfortran declares the host side of acc_memcpy_* as type(*), dimension(*): passing c_loc(x) compiles, but copies the
!   bytes of the temporary c_ptr instead of the data.
! The C symbols are defined by the OpenACC specification and exported by every implementation. The `_f` suffix avoids
! clashing with the names exported by the vendor module (used via DEVMODULE).
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
   subroutine free_checked(cptr, contiguous, freed, dev_id, ierr, check_dev_id)
   !< Free a structured allocation through the allocation registry (rank-agnostic core of dev_free).
   !< A registered buffer is freed on the device where it lives (recorded at allocation). With policy off, or for a
   !< pointer the registry does not know (double free, foreign or section pointer) under policy warn, the buffer is freed
   !< exactly as before the registry existed: on dev_id (or mydev) for OpenMP, on the current device for OpenACC.
   !< Errors are returned through ierr if present (nothing is freed), otherwise handled by the policy (warn/error stop).
   type(c_ptr),  intent(in)            :: cptr         !< Address of the buffer (c_loc of the Fortran pointer).
   logical,      intent(in)            :: contiguous   !< The Fortran pointer is contiguous.
   logical,      intent(out)           :: freed        !< The buffer has been freed (the pointer must be nullified).
   integer(I4P), intent(in),  optional :: dev_id       !< Device ID claimed by the caller.
   integer(I4P), intent(out), optional :: ierr         !< Error status.
   logical,      intent(in),  optional :: check_dev_id !< Check dev_id against the recorded device (default true).
   type(registry_entry)                :: entry        !< Registered allocation.
   logical                             :: found        !< The buffer is registered.
   logical                             :: check_       !< Check dev_id, local var.
   integer(I4P)                        :: legacy_dev   !< Device of the legacy (pre-registry) free.
   character(64)                       :: msg          !< Message buffer.

   freed = .false.
   if (present(ierr)) ierr = 0_I4P
   check_ = .true. ; if (present(check_dev_id)) check_ = check_dev_id
   legacy_dev = mydev ; if (present(dev_id)) legacy_dev = dev_id
   found = .false.
   if (registry_policy() == FUNDAL_REGISTRY_OFF) then
      ! no checks: forget the buffer if registered (statistics) and free it as before the registry existed
      if (contiguous) call registry_remove(registry_address(cptr), found)
      DEVFREE(cptr, int(legacy_dev, c_int))
      freed = .true.
      return
   endif
   if (contiguous) call registry_lookup(registry_address(cptr), found, entry)
   if (.not.found) then
      if (present(ierr)) then
         ierr = FUNDAL_ERR_NOT_REGISTERED
         return
      endif
      call registry_misuse(msg='dev_free: pointer not allocated by FUNDAL (double free, foreign or section pointer)', &
                           action='freed as before the allocation registry')
      DEVFREE(cptr, int(legacy_dev, c_int))
      freed = .true.
      return
   endif
   if (check_ .and. present(dev_id)) then
      if (dev_id /= entry%dev_id) then
         if (present(ierr)) then
            ierr = FUNDAL_ERR_DEV_ID_MISMATCH
            return
         endif
         write(msg, '(A,I0,A,I0)') 'dev_id=', dev_id, ' but the buffer lives on device ', entry%dev_id
         call registry_misuse(msg='dev_free: '//trim(msg), action='freed there')
      endif
   endif
   call registry_remove(entry%addr, found)
   call free_on_device(cptr, entry%dev_id)
   freed = .true.
   endsubroutine free_checked

   subroutine free_on_device(cptr, dev)
   !< Free a buffer on a given device: OpenMP takes the device as argument, OpenACC frees on the current device, which is
   !< switched to the buffer's device (and restored) when they differ.
   type(c_ptr),  intent(in) :: cptr    !< Address of the buffer.
   integer(I4P), intent(in) :: dev     !< Device where the buffer lives.
#if defined DEV_OAC
   integer(I4P)             :: current !< Current device.

   current = acc_get_device_num(devtype)
   if (current /= dev) call acc_set_device_num(dev, devtype)
   DEVFREE(cptr, int(dev, c_int))
   if (current /= dev) call acc_set_device_num(current, devtype)
#else

   DEVFREE(cptr, int(dev, c_int))
#endif
   endsubroutine free_on_device

#define KKP R8P
#define VARTYPE real
#define DEV_FREE_KKP_1D dev_free_R8P_1D
#define DEV_FREE_KKP_2D dev_free_R8P_2D
#define DEV_FREE_KKP_3D dev_free_R8P_3D
#define DEV_FREE_KKP_4D dev_free_R8P_4D
#define DEV_FREE_KKP_5D dev_free_R8P_5D
#define DEV_FREE_KKP_6D dev_free_R8P_6D
#define DEV_FREE_KKP_7D dev_free_R8P_7D
#include "fundal_dev_free_agnostic.INC"

#define KKP R4P
#define VARTYPE real
#define DEV_FREE_KKP_1D dev_free_R4P_1D
#define DEV_FREE_KKP_2D dev_free_R4P_2D
#define DEV_FREE_KKP_3D dev_free_R4P_3D
#define DEV_FREE_KKP_4D dev_free_R4P_4D
#define DEV_FREE_KKP_5D dev_free_R4P_5D
#define DEV_FREE_KKP_6D dev_free_R4P_6D
#define DEV_FREE_KKP_7D dev_free_R4P_7D
#include "fundal_dev_free_agnostic.INC"

#define KKP I8P
#define VARTYPE integer
#define DEV_FREE_KKP_1D dev_free_I8P_1D
#define DEV_FREE_KKP_2D dev_free_I8P_2D
#define DEV_FREE_KKP_3D dev_free_I8P_3D
#define DEV_FREE_KKP_4D dev_free_I8P_4D
#define DEV_FREE_KKP_5D dev_free_I8P_5D
#define DEV_FREE_KKP_6D dev_free_I8P_6D
#define DEV_FREE_KKP_7D dev_free_I8P_7D
#include "fundal_dev_free_agnostic.INC"

#define KKP I4P
#define VARTYPE integer
#define DEV_FREE_KKP_1D dev_free_I4P_1D
#define DEV_FREE_KKP_2D dev_free_I4P_2D
#define DEV_FREE_KKP_3D dev_free_I4P_3D
#define DEV_FREE_KKP_4D dev_free_I4P_4D
#define DEV_FREE_KKP_5D dev_free_I4P_5D
#define DEV_FREE_KKP_6D dev_free_I4P_6D
#define DEV_FREE_KKP_7D dev_free_I4P_7D
#include "fundal_dev_free_agnostic.INC"

#define KKP I2P
#define VARTYPE integer
#define DEV_FREE_KKP_1D dev_free_I2P_1D
#define DEV_FREE_KKP_2D dev_free_I2P_2D
#define DEV_FREE_KKP_3D dev_free_I2P_3D
#define DEV_FREE_KKP_4D dev_free_I2P_4D
#define DEV_FREE_KKP_5D dev_free_I2P_5D
#define DEV_FREE_KKP_6D dev_free_I2P_6D
#define DEV_FREE_KKP_7D dev_free_I2P_7D
#include "fundal_dev_free_agnostic.INC"

#define KKP I1P
#define VARTYPE integer
#define DEV_FREE_KKP_1D dev_free_I1P_1D
#define DEV_FREE_KKP_2D dev_free_I1P_2D
#define DEV_FREE_KKP_3D dev_free_I1P_3D
#define DEV_FREE_KKP_4D dev_free_I1P_4D
#define DEV_FREE_KKP_5D dev_free_I1P_5D
#define DEV_FREE_KKP_6D dev_free_I1P_6D
#define DEV_FREE_KKP_7D dev_free_I1P_7D
#include "fundal_dev_free_agnostic.INC"
endmodule fundal_dev_free
