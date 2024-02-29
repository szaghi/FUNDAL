!< FUNDAL, environment global module.
module fundal_env
!< FUNDAL, environment global module.
use, intrinsic :: iso_fortran_env, only : I4P=>int32

implicit none
private
public :: local_comm
public :: mydev
public :: myhos

integer(kind=I4P) :: local_comm=0_I4P !< Local communicator.
integer(kind=I4P) :: mydev=0_I4P      !< Device ID.
integer(kind=I4P) :: myhos=0_I4P      !< Host ID.
endmodule fundal_env
