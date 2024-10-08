!< FUNDAL, environment global module.
module fundal_env
!< FUNDAL, environment global module.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64
#ifdef DEV_OAC
use            :: openacc,         only : ACC_DEVICE_KIND, ACC_DEVICE_DEFAULT
#endif

implicit none
private
public :: dev_memory_avail
public :: local_comm
public :: mydev
public :: myhos
public :: devtype
public :: IDK

integer(I8P), target :: dev_memory_avail=0_I8P     !< Device memory available (GB).
integer(I4P), target :: local_comm=0_I4P           !< Local communicator.
integer(I4P), target :: mydev=0_I4P                !< Device ID.
integer(I4P), target :: myhos=0_I4P                !< Host ID.
#ifdef DEV_OAC
integer, parameter   :: IDK=ACC_DEVICE_KIND        !< Kind parameter for device type definitio.
integer(IDK), target :: devtype=ACC_DEVICE_DEFAULT !< OpenACC device type.
#else
integer, parameter   :: IDK=I4P                    !< Kind parameter for device type definitio.
integer(IDK), target :: devtype=0_I4P              !< OpenACC device type.
#endif
endmodule fundal_env
