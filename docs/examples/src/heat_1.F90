!run heat_1 heat_1
program heat_1
!< Tutorial, chapter 1: a first device array.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64, R8P=>real64
use            :: fundal
implicit none
integer(I4P), parameter :: n=8              ! number of cells
real(R8P), pointer      :: t_dev(:)=>null() ! temperature, on the device
real(R8P)               :: t(n)             ! temperature, on the host
integer(I8P)            :: allocs           ! live device allocations
integer(I4P)            :: ierr             ! error status

!region init
call dev_init
!endregion init
!region alloc
call dev_alloc(fptr_dev=t_dev, ubounds=[n], ierr=ierr, label='temperature')
if (ierr /= 0) error stop 'device allocation failed'
!endregion alloc
!region copy
t = 20._R8P                                   ! room temperature...
t(n/2) = 100._R8P                             ! ...with a hot spot
call dev_memcpy_to_device(dst=t_dev, src=t)   ! host -> device
t = 0._R8P                                    ! forget the host copy
call dev_memcpy_from_device(dst=t, src=t_dev) ! device -> host
print '(A,*(F6.1))', 'temperature:', t
!endregion copy
!region free
call dev_free(t_dev)
call dev_get_alloc_stats(allocs=allocs)
print '(A,I0)', 'live device allocations: ', allocs
!endregion free
endprogram heat_1
