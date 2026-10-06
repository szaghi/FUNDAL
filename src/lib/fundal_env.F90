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
endmodule fundal_env
