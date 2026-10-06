!< FUNDAL, environment global module.
module fundal_env
!< FUNDAL, environment global module.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64
#ifdef DEV_OAC
use            :: openacc,         only : ACC_DEVICE_KIND, ACC_DEVICE_DEFAULT
#endif

implicit none
private
public :: dev_allocs_live
public :: dev_host_fallback
public :: dev_bytes_live
public :: devs_number
public :: dev_memory_avail
public :: dev_memory_total
public :: local_comm
public :: mydev
public :: myhos
public :: devtype
public :: IDK
public :: FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED, FUNDAL_ERR_NO_DEVICE, FUNDAL_ERR_NOT_REGISTERED, FUNDAL_ERR_DEV_ID_MISMATCH
public :: FUNDAL_ERR_NOT_CONTIGUOUS, FUNDAL_ERR_MEMCPY_FAILED
public :: dev_error_message
public :: FUNDAL_DEVICE_HOST
public :: FUNDAL_DEVICE_GPU

integer(I8P), target :: dev_allocs_live=0_I8P      !< Live structured device allocations (dev_alloc not yet dev_free-d).
logical,      target :: dev_host_fallback=.false. !< Compiled for a device backend but running on the host.
integer(I8P), target :: dev_bytes_live=0_I8P       !< Bytes of live structured device allocations.
integer(I4P), target :: devs_number=0_I4P          !< Number of devices.
integer(I8P), target :: dev_memory_avail=0_I8P     !< Device memory FREE at init (bytes).
integer(I8P), target :: dev_memory_total=0_I8P     !< Device memory TOTAL, a machine property (bytes).
integer(I4P), target :: local_comm=0_I4P           !< Local communicator.
integer(I4P), target :: mydev=0_I4P                !< Device ID.
integer(I4P), target :: myhos=0_I4P                !< Host ID.
! Error codes returned through ierr (dev_error_message gives their description).
integer(I4P), parameter :: FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED=101_I4P !< Device memory not allocated.
integer(I4P), parameter :: FUNDAL_ERR_NO_DEVICE=102_I4P              !< No device available, host fallback forbidden.
integer(I4P), parameter :: FUNDAL_ERR_NOT_REGISTERED=103_I4P         !< Pointer not allocated by FUNDAL.
integer(I4P), parameter :: FUNDAL_ERR_DEV_ID_MISMATCH=104_I4P        !< dev_id differs from the recorded device.
integer(I4P), parameter :: FUNDAL_ERR_NOT_CONTIGUOUS=105_I4P         !< Device argument of a copy not contiguous.
integer(I4P), parameter :: FUNDAL_ERR_MEMCPY_FAILED=106_I4P          !< The device runtime reported a failed copy.
! Device types returned by dev_get_device_type on the OpenMP backend (OpenACC returns acc_device_* values) and in CPU mode.
integer(I4P), parameter :: FUNDAL_DEVICE_HOST=0_I4P !< Device type: host (no offload device available).
integer(I4P), parameter :: FUNDAL_DEVICE_GPU =1_I4P !< Device type: accelerator/GPU offload device.
#ifdef DEV_OAC
integer, parameter   :: IDK=ACC_DEVICE_KIND        !< Kind parameter for device type definitio.
integer(IDK), target :: devtype=ACC_DEVICE_DEFAULT !< OpenACC device type.
#else
integer, parameter      :: IDK=I4P                  !< Kind parameter for device type definitio.
integer(IDK), target    :: devtype=0_I4P            !< Device type.
#endif

contains
   pure function dev_error_message(ierr) result(msg)
   !< Return the description of a FUNDAL error code (as returned through ierr).
   integer(I4P), intent(in)  :: ierr !< Error code.
   character(:), allocatable :: msg  !< Description.
   character(16)             :: code !< Code as text.

   select case(ierr)
   case(0)
      msg = 'no error'
   case(FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED)
      msg = 'device memory not allocated (the device allocator failed)'
   case(FUNDAL_ERR_NO_DEVICE)
      msg = 'no device available and host fallback forbidden'
   case(FUNDAL_ERR_NOT_REGISTERED)
      msg = 'pointer not allocated by FUNDAL (double free, foreign or section pointer, or a range beyond its allocation)'
   case(FUNDAL_ERR_DEV_ID_MISMATCH)
      msg = 'dev_id differs from the device where the buffer lives: nothing freed'
   case(FUNDAL_ERR_NOT_CONTIGUOUS)
      msg = 'device argument of a copy is not contiguous (strided section): nothing copied'
   case(FUNDAL_ERR_MEMCPY_FAILED)
      msg = 'the device runtime reported a failed copy'
   case default
      write(code, '(I0)') ierr
      msg = 'unknown FUNDAL error code '//trim(code)
   endselect
   endfunction dev_error_message
endmodule fundal_env
