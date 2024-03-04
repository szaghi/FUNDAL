!< FUNDAL, environment global module.
module fundal_env
!< FUNDAL, environment global module.
use, intrinsic :: iso_fortran_env, only : I4P=>int32
#ifdef DEV_OAC
use            :: openacc,         only : acc_device_kind, acc_device_default
#endif

implicit none
private
public :: local_comm
public :: mydev
public :: myhos
public :: devtype

integer(I4P)             :: local_comm=0_I4P           !< Local communicator.
integer(I4P)             :: mydev=0_I4P                !< Device ID.
integer(I4P)             :: myhos=0_I4P                !< Host ID.
#ifdef DEV_OAC
integer(acc_device_kind) :: devtype=acc_device_default !< OpenACC device type.
#else
integer(I4P)             :: devtype=0_I4P              !< OpenACC device type.
#endif
endmodule fundal_env
