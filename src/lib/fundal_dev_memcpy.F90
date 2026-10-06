!< FUNDAL, memory copy routines module.

#include "fundal.H"

! Copy on the device chosen by memcpy_check (dv, -1 = as before the allocation registry); the CPU mode assigns directly.
#if defined DEV_OAC || defined DEV_OMP
#   define DEVMEMCPY_FROM_DEVICE(d, s, dv) call memcpy_device(c_loc(d), c_loc(s), bytes_size(a=s), .false., dv, ierr)
#   define DEVMEMCPY_TO_DEVICE(d, s, dv) call memcpy_device(c_loc(s), c_loc(d), bytes_size(a=s), .true., dv, ierr)
#else
#   define DEVMEMCPY_FROM_DEVICE(d, s, dv) d = s
#   define DEVMEMCPY_TO_DEVICE(d, s, dv) d = s
#endif

module fundal_dev_memcpy
!< FUNDAL, memory copy routines module.
use, intrinsic :: iso_c_binding
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I2P=>int16, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64, &
                                          error_unit
use            :: DEVMODULE
use            :: fundal_env,      only : mydev, myhos, devtype, dev_error_message, FUNDAL_ERR_NOT_REGISTERED, &
                                          FUNDAL_ERR_NOT_CONTIGUOUS, FUNDAL_ERR_MEMCPY_FAILED
use            :: fundal_registry, only : registry_entry, registry_address, registry_lookup_range, registry_policy, &
                                          registry_misuse, FUNDAL_REGISTRY_OFF, FUNDAL_REGISTRY_ERROR
use            :: fundal_utilities
use            :: fundal_transpose_array

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
                    dev_memcpy_from_device_I1P_7D,&
                    dev_memcpy_from_device_R8P_2D_T,&
                    dev_memcpy_from_device_R8P_3D_T,&
                    dev_memcpy_from_device_R8P_4D_T,&
                    dev_memcpy_from_device_R8P_5D_T,&
                    dev_memcpy_from_device_R8P_6D_T,&
                    dev_memcpy_from_device_R8P_7D_T,&
                    dev_memcpy_from_device_R4P_2D_T,&
                    dev_memcpy_from_device_R4P_3D_T,&
                    dev_memcpy_from_device_R4P_4D_T,&
                    dev_memcpy_from_device_R4P_5D_T,&
                    dev_memcpy_from_device_R4P_6D_T,&
                    dev_memcpy_from_device_R4P_7D_T,&
                    dev_memcpy_from_device_I8P_2D_T,&
                    dev_memcpy_from_device_I8P_3D_T,&
                    dev_memcpy_from_device_I8P_4D_T,&
                    dev_memcpy_from_device_I8P_5D_T,&
                    dev_memcpy_from_device_I8P_6D_T,&
                    dev_memcpy_from_device_I8P_7D_T,&
                    dev_memcpy_from_device_I4P_2D_T,&
                    dev_memcpy_from_device_I4P_3D_T,&
                    dev_memcpy_from_device_I4P_4D_T,&
                    dev_memcpy_from_device_I4P_5D_T,&
                    dev_memcpy_from_device_I4P_6D_T,&
                    dev_memcpy_from_device_I4P_7D_T,&
                    dev_memcpy_from_device_I2P_2D_T,&
                    dev_memcpy_from_device_I2P_3D_T,&
                    dev_memcpy_from_device_I2P_4D_T,&
                    dev_memcpy_from_device_I2P_5D_T,&
                    dev_memcpy_from_device_I2P_6D_T,&
                    dev_memcpy_from_device_I2P_7D_T,&
                    dev_memcpy_from_device_I1P_2D_T,&
                    dev_memcpy_from_device_I1P_3D_T,&
                    dev_memcpy_from_device_I1P_4D_T,&
                    dev_memcpy_from_device_I1P_5D_T,&
                    dev_memcpy_from_device_I1P_6D_T,&
                    dev_memcpy_from_device_I1P_7D_T
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
                    dev_memcpy_to_device_I1P_7D,&
                    dev_memcpy_to_device_R8P_2D_T,&
                    dev_memcpy_to_device_R8P_3D_T,&
                    dev_memcpy_to_device_R8P_4D_T,&
                    dev_memcpy_to_device_R8P_5D_T,&
                    dev_memcpy_to_device_R8P_6D_T,&
                    dev_memcpy_to_device_R8P_7D_T,&
                    dev_memcpy_to_device_R4P_2D_T,&
                    dev_memcpy_to_device_R4P_3D_T,&
                    dev_memcpy_to_device_R4P_4D_T,&
                    dev_memcpy_to_device_R4P_5D_T,&
                    dev_memcpy_to_device_R4P_6D_T,&
                    dev_memcpy_to_device_R4P_7D_T,&
                    dev_memcpy_to_device_I8P_2D_T,&
                    dev_memcpy_to_device_I8P_3D_T,&
                    dev_memcpy_to_device_I8P_4D_T,&
                    dev_memcpy_to_device_I8P_5D_T,&
                    dev_memcpy_to_device_I8P_6D_T,&
                    dev_memcpy_to_device_I8P_7D_T,&
                    dev_memcpy_to_device_I4P_2D_T,&
                    dev_memcpy_to_device_I4P_3D_T,&
                    dev_memcpy_to_device_I4P_4D_T,&
                    dev_memcpy_to_device_I4P_5D_T,&
                    dev_memcpy_to_device_I4P_6D_T,&
                    dev_memcpy_to_device_I4P_7D_T,&
                    dev_memcpy_to_device_I2P_2D_T,&
                    dev_memcpy_to_device_I2P_3D_T,&
                    dev_memcpy_to_device_I2P_4D_T,&
                    dev_memcpy_to_device_I2P_5D_T,&
                    dev_memcpy_to_device_I2P_6D_T,&
                    dev_memcpy_to_device_I2P_7D_T,&
                    dev_memcpy_to_device_I1P_2D_T,&
                    dev_memcpy_to_device_I1P_3D_T,&
                    dev_memcpy_to_device_I1P_4D_T,&
                    dev_memcpy_to_device_I1P_5D_T,&
                    dev_memcpy_to_device_I1P_6D_T,&
                    dev_memcpy_to_device_I1P_7D_T
endinterface dev_memcpy_to_device

#ifdef DEV_OAC
! OpenACC runtime routines are bound directly to their C API (void*, size_t) on purpose, instead of being taken from the
! vendor `openacc` module, whose Fortran interfaces are not portable (verified on nvhpc 26.1 and gfortran 16, see #2):
! - nvfortran declares acc_malloc/acc_free/acc_memcpy_* with the NVIDIA-only type(c_devptr), not type(c_ptr);
! - gfortran declares the host side of acc_memcpy_* as type(*), dimension(*): passing c_loc(x) compiles, but copies the
!   bytes of the temporary c_ptr instead of the data.
! The C symbols are defined by the OpenACC specification and exported by every implementation. The `_f` suffix avoids
! clashing with the names exported by the vendor module (used via DEVMODULE).
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
   subroutine memcpy_check(name, dev_ptr, bytes, contiguous, dev_id, proceed, ierr)
   !< Check a structured copy through the allocation registry (rank-agnostic core of dev_memcpy_*) and choose its device.
   !< A device range inside a registered allocation (whole buffer or contiguous section) is copied on the device where the
   !< buffer lives. With policy off, or for device memory the registry does not know (not allocated by FUNDAL) under
   !< policy warn, the copy is done as before the registry existed: on mydev for OpenMP, on the current device for
   !< OpenACC (dev_id=-1). A non-contiguous device argument or a range beyond the end of its allocation is a misuse; so is
   !< unknown device memory under policy error. Errors are returned through ierr if present (nothing is copied),
   !< otherwise handled by the policy (warn and copy as before, or error stop).
   character(*),      intent(in)            :: name       !< Name of the calling routine, for messages.
   type(c_ptr),       intent(in)            :: dev_ptr    !< Address of the device argument.
   integer(c_size_t), intent(in)            :: bytes      !< Size of the copy [bytes].
   logical,           intent(in)            :: contiguous !< The device argument is contiguous.
   integer(I4P),      intent(out)           :: dev_id     !< Device of the copy, -1 = as before the registry.
   logical,           intent(out)           :: proceed    !< The copy must be done.
   integer(I4P),      intent(out), optional :: ierr       !< Error status.
   type(registry_entry)                     :: entry      !< Registered allocation containing the device range.
   logical                                  :: found      !< The device range lies inside a registered allocation.
   logical                                  :: overflow   !< The device range ends beyond its allocation.

   dev_id = -1_I4P
   proceed = .true.
   if (present(ierr)) ierr = 0_I4P
   if (registry_policy() == FUNDAL_REGISTRY_OFF) return
   if (.not.contiguous) then
      if (present(ierr)) then
         ierr = FUNDAL_ERR_NOT_CONTIGUOUS
         proceed = .false.
         return
      endif
      call registry_misuse(msg=name//': device argument not contiguous (strided section)', &
                           action='copied as before the allocation registry')
      return
   endif
   if (bytes == 0_c_size_t) return
   call registry_lookup_range(registry_address(dev_ptr), int(bytes, I8P), found, entry, overflow)
   if (found) then
      dev_id = entry%dev_id
      return
   endif
   if (overflow .or. registry_policy() == FUNDAL_REGISTRY_ERROR) then
      if (present(ierr)) then
         ierr = FUNDAL_ERR_NOT_REGISTERED
         proceed = .false.
         return
      endif
      if (overflow) then
         call registry_misuse(msg=name//': device range beyond the end of its FUNDAL allocation', &
                              action='copied as before the allocation registry')
      else
         call registry_misuse(msg=name//': device memory not allocated by FUNDAL', &
                              action='copied as before the allocation registry')
      endif
   endif
   endsubroutine memcpy_check

#if defined DEV_OAC || defined DEV_OMP
   subroutine memcpy_device(host_ptr, dev_ptr, bytes, to_device, dev_id, ierr)
   !< Copy between host and device memory on a given device (-1 = as before the registry: mydev for OpenMP, the current
   !< device for OpenACC). OpenACC copies on the current device, which is switched to dev_id (and restored) when they
   !< differ. A failure reported by the runtime (OpenMP) is returned through ierr if present, otherwise it stops (it is
   !< ignored, as before the registry, with policy off).
   type(c_ptr),       intent(in)            :: host_ptr  !< Host memory.
   type(c_ptr),       intent(in)            :: dev_ptr   !< Device memory.
   integer(c_size_t), intent(in)            :: bytes     !< Size of the copy [bytes].
   logical,           intent(in)            :: to_device !< Direction: host to device if true.
   integer(I4P),      intent(in)            :: dev_id    !< Device of the copy, -1 = as before the registry.
   integer(I4P),      intent(inout), optional :: ierr    !< Error status (left unchanged on success).
#if defined DEV_OAC
   integer(I4P)                             :: current   !< Current device.
   logical                                  :: switch    !< The current device must be switched.

   current = acc_get_device_num(devtype)
   switch = (dev_id >= 0_I4P .and. dev_id /= current)
   if (switch) call acc_set_device_num(dev_id, devtype)
   if (to_device) then
      call acc_memcpy_to_device_f(dev_ptr, host_ptr, bytes)
   else
      call acc_memcpy_from_device_f(host_ptr, dev_ptr, bytes)
   endif
   if (switch) call acc_set_device_num(current, devtype)
#else
   integer(c_int)                           :: dev       !< Device of the copy.
   integer(c_int)                           :: status    !< Runtime status.
   character(:), allocatable                :: name      !< Name of the calling routine, for messages.

   dev = int(mydev, c_int) ; if (dev_id >= 0_I4P) dev = int(dev_id, c_int)
   if (to_device) then
      status = omp_target_memcpy(dev_ptr, host_ptr, bytes, 0_c_size_t, 0_c_size_t, dev, int(myhos, c_int))
      name = 'dev_memcpy_to_device'
   else
      status = omp_target_memcpy(host_ptr, dev_ptr, bytes, 0_c_size_t, 0_c_size_t, int(myhos, c_int), dev)
      name = 'dev_memcpy_from_device'
   endif
   if (status /= 0_c_int) then
      if (present(ierr)) then
         ierr = FUNDAL_ERR_MEMCPY_FAILED
      elseif (registry_policy() /= FUNDAL_REGISTRY_OFF) then
         write(error_unit, '(A)') 'FUNDAL error: '//name//': '//dev_error_message(FUNDAL_ERR_MEMCPY_FAILED)
         error stop 'FUNDAL: device copy failed'
      endif
   endif
#endif
   endsubroutine memcpy_device
#endif

#define KKP R8P
#define VARTYPE real
#define DEV_MEMCPY_FROM_DEVICE_KKP_1D dev_memcpy_from_device_R8P_1D
#define DEV_MEMCPY_FROM_DEVICE_KKP_2D dev_memcpy_from_device_R8P_2D
#define DEV_MEMCPY_FROM_DEVICE_KKP_3D dev_memcpy_from_device_R8P_3D
#define DEV_MEMCPY_FROM_DEVICE_KKP_4D dev_memcpy_from_device_R8P_4D
#define DEV_MEMCPY_FROM_DEVICE_KKP_5D dev_memcpy_from_device_R8P_5D
#define DEV_MEMCPY_FROM_DEVICE_KKP_6D dev_memcpy_from_device_R8P_6D
#define DEV_MEMCPY_FROM_DEVICE_KKP_7D dev_memcpy_from_device_R8P_7D
#define DEV_MEMCPY_FROM_DEVICE_KKP_2D_T dev_memcpy_from_device_R8P_2D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_3D_T dev_memcpy_from_device_R8P_3D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_4D_T dev_memcpy_from_device_R8P_4D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_5D_T dev_memcpy_from_device_R8P_5D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_6D_T dev_memcpy_from_device_R8P_6D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_7D_T dev_memcpy_from_device_R8P_7D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_1D dev_memcpy_to_device_R8P_1D
#define DEV_MEMCPY_TO_DEVICE_KKP_2D dev_memcpy_to_device_R8P_2D
#define DEV_MEMCPY_TO_DEVICE_KKP_3D dev_memcpy_to_device_R8P_3D
#define DEV_MEMCPY_TO_DEVICE_KKP_4D dev_memcpy_to_device_R8P_4D
#define DEV_MEMCPY_TO_DEVICE_KKP_5D dev_memcpy_to_device_R8P_5D
#define DEV_MEMCPY_TO_DEVICE_KKP_6D dev_memcpy_to_device_R8P_6D
#define DEV_MEMCPY_TO_DEVICE_KKP_7D dev_memcpy_to_device_R8P_7D
#define DEV_MEMCPY_TO_DEVICE_KKP_2D_T dev_memcpy_to_device_R8P_2D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_3D_T dev_memcpy_to_device_R8P_3D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_4D_T dev_memcpy_to_device_R8P_4D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_5D_T dev_memcpy_to_device_R8P_5D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_6D_T dev_memcpy_to_device_R8P_6D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_7D_T dev_memcpy_to_device_R8P_7D_T
#include "fundal_dev_memcpy_agnostic.INC"

#define KKP R4P
#define VARTYPE real
#define DEV_MEMCPY_FROM_DEVICE_KKP_1D dev_memcpy_from_device_R4P_1D
#define DEV_MEMCPY_FROM_DEVICE_KKP_2D dev_memcpy_from_device_R4P_2D
#define DEV_MEMCPY_FROM_DEVICE_KKP_3D dev_memcpy_from_device_R4P_3D
#define DEV_MEMCPY_FROM_DEVICE_KKP_4D dev_memcpy_from_device_R4P_4D
#define DEV_MEMCPY_FROM_DEVICE_KKP_5D dev_memcpy_from_device_R4P_5D
#define DEV_MEMCPY_FROM_DEVICE_KKP_6D dev_memcpy_from_device_R4P_6D
#define DEV_MEMCPY_FROM_DEVICE_KKP_7D dev_memcpy_from_device_R4P_7D
#define DEV_MEMCPY_FROM_DEVICE_KKP_2D_T dev_memcpy_from_device_R4P_2D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_3D_T dev_memcpy_from_device_R4P_3D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_4D_T dev_memcpy_from_device_R4P_4D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_5D_T dev_memcpy_from_device_R4P_5D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_6D_T dev_memcpy_from_device_R4P_6D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_7D_T dev_memcpy_from_device_R4P_7D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_1D dev_memcpy_to_device_R4P_1D
#define DEV_MEMCPY_TO_DEVICE_KKP_2D dev_memcpy_to_device_R4P_2D
#define DEV_MEMCPY_TO_DEVICE_KKP_3D dev_memcpy_to_device_R4P_3D
#define DEV_MEMCPY_TO_DEVICE_KKP_4D dev_memcpy_to_device_R4P_4D
#define DEV_MEMCPY_TO_DEVICE_KKP_5D dev_memcpy_to_device_R4P_5D
#define DEV_MEMCPY_TO_DEVICE_KKP_6D dev_memcpy_to_device_R4P_6D
#define DEV_MEMCPY_TO_DEVICE_KKP_7D dev_memcpy_to_device_R4P_7D
#define DEV_MEMCPY_TO_DEVICE_KKP_2D_T dev_memcpy_to_device_R4P_2D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_3D_T dev_memcpy_to_device_R4P_3D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_4D_T dev_memcpy_to_device_R4P_4D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_5D_T dev_memcpy_to_device_R4P_5D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_6D_T dev_memcpy_to_device_R4P_6D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_7D_T dev_memcpy_to_device_R4P_7D_T
#include "fundal_dev_memcpy_agnostic.INC"

#define KKP I8P
#define VARTYPE integer
#define DEV_MEMCPY_FROM_DEVICE_KKP_1D dev_memcpy_from_device_I8P_1D
#define DEV_MEMCPY_FROM_DEVICE_KKP_2D dev_memcpy_from_device_I8P_2D
#define DEV_MEMCPY_FROM_DEVICE_KKP_3D dev_memcpy_from_device_I8P_3D
#define DEV_MEMCPY_FROM_DEVICE_KKP_4D dev_memcpy_from_device_I8P_4D
#define DEV_MEMCPY_FROM_DEVICE_KKP_5D dev_memcpy_from_device_I8P_5D
#define DEV_MEMCPY_FROM_DEVICE_KKP_6D dev_memcpy_from_device_I8P_6D
#define DEV_MEMCPY_FROM_DEVICE_KKP_7D dev_memcpy_from_device_I8P_7D
#define DEV_MEMCPY_FROM_DEVICE_KKP_2D_T dev_memcpy_from_device_I8P_2D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_3D_T dev_memcpy_from_device_I8P_3D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_4D_T dev_memcpy_from_device_I8P_4D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_5D_T dev_memcpy_from_device_I8P_5D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_6D_T dev_memcpy_from_device_I8P_6D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_7D_T dev_memcpy_from_device_I8P_7D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_1D dev_memcpy_to_device_I8P_1D
#define DEV_MEMCPY_TO_DEVICE_KKP_2D dev_memcpy_to_device_I8P_2D
#define DEV_MEMCPY_TO_DEVICE_KKP_3D dev_memcpy_to_device_I8P_3D
#define DEV_MEMCPY_TO_DEVICE_KKP_4D dev_memcpy_to_device_I8P_4D
#define DEV_MEMCPY_TO_DEVICE_KKP_5D dev_memcpy_to_device_I8P_5D
#define DEV_MEMCPY_TO_DEVICE_KKP_6D dev_memcpy_to_device_I8P_6D
#define DEV_MEMCPY_TO_DEVICE_KKP_7D dev_memcpy_to_device_I8P_7D
#define DEV_MEMCPY_TO_DEVICE_KKP_2D_T dev_memcpy_to_device_I8P_2D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_3D_T dev_memcpy_to_device_I8P_3D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_4D_T dev_memcpy_to_device_I8P_4D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_5D_T dev_memcpy_to_device_I8P_5D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_6D_T dev_memcpy_to_device_I8P_6D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_7D_T dev_memcpy_to_device_I8P_7D_T
#include "fundal_dev_memcpy_agnostic.INC"

#define KKP I4P
#define VARTYPE integer
#define DEV_MEMCPY_FROM_DEVICE_KKP_1D dev_memcpy_from_device_I4P_1D
#define DEV_MEMCPY_FROM_DEVICE_KKP_2D dev_memcpy_from_device_I4P_2D
#define DEV_MEMCPY_FROM_DEVICE_KKP_3D dev_memcpy_from_device_I4P_3D
#define DEV_MEMCPY_FROM_DEVICE_KKP_4D dev_memcpy_from_device_I4P_4D
#define DEV_MEMCPY_FROM_DEVICE_KKP_5D dev_memcpy_from_device_I4P_5D
#define DEV_MEMCPY_FROM_DEVICE_KKP_6D dev_memcpy_from_device_I4P_6D
#define DEV_MEMCPY_FROM_DEVICE_KKP_7D dev_memcpy_from_device_I4P_7D
#define DEV_MEMCPY_FROM_DEVICE_KKP_2D_T dev_memcpy_from_device_I4P_2D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_3D_T dev_memcpy_from_device_I4P_3D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_4D_T dev_memcpy_from_device_I4P_4D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_5D_T dev_memcpy_from_device_I4P_5D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_6D_T dev_memcpy_from_device_I4P_6D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_7D_T dev_memcpy_from_device_I4P_7D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_1D dev_memcpy_to_device_I4P_1D
#define DEV_MEMCPY_TO_DEVICE_KKP_2D dev_memcpy_to_device_I4P_2D
#define DEV_MEMCPY_TO_DEVICE_KKP_3D dev_memcpy_to_device_I4P_3D
#define DEV_MEMCPY_TO_DEVICE_KKP_4D dev_memcpy_to_device_I4P_4D
#define DEV_MEMCPY_TO_DEVICE_KKP_5D dev_memcpy_to_device_I4P_5D
#define DEV_MEMCPY_TO_DEVICE_KKP_6D dev_memcpy_to_device_I4P_6D
#define DEV_MEMCPY_TO_DEVICE_KKP_7D dev_memcpy_to_device_I4P_7D
#define DEV_MEMCPY_TO_DEVICE_KKP_2D_T dev_memcpy_to_device_I4P_2D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_3D_T dev_memcpy_to_device_I4P_3D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_4D_T dev_memcpy_to_device_I4P_4D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_5D_T dev_memcpy_to_device_I4P_5D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_6D_T dev_memcpy_to_device_I4P_6D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_7D_T dev_memcpy_to_device_I4P_7D_T
#include "fundal_dev_memcpy_agnostic.INC"

#define KKP I2P
#define VARTYPE integer
#define DEV_MEMCPY_FROM_DEVICE_KKP_1D dev_memcpy_from_device_I2P_1D
#define DEV_MEMCPY_FROM_DEVICE_KKP_2D dev_memcpy_from_device_I2P_2D
#define DEV_MEMCPY_FROM_DEVICE_KKP_3D dev_memcpy_from_device_I2P_3D
#define DEV_MEMCPY_FROM_DEVICE_KKP_4D dev_memcpy_from_device_I2P_4D
#define DEV_MEMCPY_FROM_DEVICE_KKP_5D dev_memcpy_from_device_I2P_5D
#define DEV_MEMCPY_FROM_DEVICE_KKP_6D dev_memcpy_from_device_I2P_6D
#define DEV_MEMCPY_FROM_DEVICE_KKP_7D dev_memcpy_from_device_I2P_7D
#define DEV_MEMCPY_FROM_DEVICE_KKP_2D_T dev_memcpy_from_device_I2P_2D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_3D_T dev_memcpy_from_device_I2P_3D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_4D_T dev_memcpy_from_device_I2P_4D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_5D_T dev_memcpy_from_device_I2P_5D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_6D_T dev_memcpy_from_device_I2P_6D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_7D_T dev_memcpy_from_device_I2P_7D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_1D dev_memcpy_to_device_I2P_1D
#define DEV_MEMCPY_TO_DEVICE_KKP_2D dev_memcpy_to_device_I2P_2D
#define DEV_MEMCPY_TO_DEVICE_KKP_3D dev_memcpy_to_device_I2P_3D
#define DEV_MEMCPY_TO_DEVICE_KKP_4D dev_memcpy_to_device_I2P_4D
#define DEV_MEMCPY_TO_DEVICE_KKP_5D dev_memcpy_to_device_I2P_5D
#define DEV_MEMCPY_TO_DEVICE_KKP_6D dev_memcpy_to_device_I2P_6D
#define DEV_MEMCPY_TO_DEVICE_KKP_7D dev_memcpy_to_device_I2P_7D
#define DEV_MEMCPY_TO_DEVICE_KKP_2D_T dev_memcpy_to_device_I2P_2D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_3D_T dev_memcpy_to_device_I2P_3D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_4D_T dev_memcpy_to_device_I2P_4D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_5D_T dev_memcpy_to_device_I2P_5D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_6D_T dev_memcpy_to_device_I2P_6D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_7D_T dev_memcpy_to_device_I2P_7D_T
#include "fundal_dev_memcpy_agnostic.INC"

#define KKP I1P
#define VARTYPE integer
#define DEV_MEMCPY_FROM_DEVICE_KKP_1D dev_memcpy_from_device_I1P_1D
#define DEV_MEMCPY_FROM_DEVICE_KKP_2D dev_memcpy_from_device_I1P_2D
#define DEV_MEMCPY_FROM_DEVICE_KKP_3D dev_memcpy_from_device_I1P_3D
#define DEV_MEMCPY_FROM_DEVICE_KKP_4D dev_memcpy_from_device_I1P_4D
#define DEV_MEMCPY_FROM_DEVICE_KKP_5D dev_memcpy_from_device_I1P_5D
#define DEV_MEMCPY_FROM_DEVICE_KKP_6D dev_memcpy_from_device_I1P_6D
#define DEV_MEMCPY_FROM_DEVICE_KKP_7D dev_memcpy_from_device_I1P_7D
#define DEV_MEMCPY_FROM_DEVICE_KKP_2D_T dev_memcpy_from_device_I1P_2D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_3D_T dev_memcpy_from_device_I1P_3D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_4D_T dev_memcpy_from_device_I1P_4D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_5D_T dev_memcpy_from_device_I1P_5D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_6D_T dev_memcpy_from_device_I1P_6D_T
#define DEV_MEMCPY_FROM_DEVICE_KKP_7D_T dev_memcpy_from_device_I1P_7D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_1D dev_memcpy_to_device_I1P_1D
#define DEV_MEMCPY_TO_DEVICE_KKP_2D dev_memcpy_to_device_I1P_2D
#define DEV_MEMCPY_TO_DEVICE_KKP_3D dev_memcpy_to_device_I1P_3D
#define DEV_MEMCPY_TO_DEVICE_KKP_4D dev_memcpy_to_device_I1P_4D
#define DEV_MEMCPY_TO_DEVICE_KKP_5D dev_memcpy_to_device_I1P_5D
#define DEV_MEMCPY_TO_DEVICE_KKP_6D dev_memcpy_to_device_I1P_6D
#define DEV_MEMCPY_TO_DEVICE_KKP_7D dev_memcpy_to_device_I1P_7D
#define DEV_MEMCPY_TO_DEVICE_KKP_2D_T dev_memcpy_to_device_I1P_2D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_3D_T dev_memcpy_to_device_I1P_3D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_4D_T dev_memcpy_to_device_I1P_4D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_5D_T dev_memcpy_to_device_I1P_5D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_6D_T dev_memcpy_to_device_I1P_6D_T
#define DEV_MEMCPY_TO_DEVICE_KKP_7D_T dev_memcpy_to_device_I1P_7D_T
#include "fundal_dev_memcpy_agnostic.INC"
endmodule fundal_dev_memcpy
