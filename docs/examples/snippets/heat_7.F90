#include "fundal.H"

program heat_7
!< Tutorial, chapter 7: production, no silent host fallback, a strict allocation registry, checked frees.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64, R8P=>real64
use            :: fundal
implicit none
integer(I4P), parameter :: n=15             ! interior cells, ghost cells 0 and n+1
integer(I4P), parameter :: steps=50         ! time steps
real(R8P),    parameter :: r=0.25_R8P       ! alpha*dt/dx**2
real(R8P),    parameter :: pi=acos(-1._R8P) ! pi
real(R8P),    parameter :: dx=1._R8P/(n+1)  ! cell size
real(R8P), pointer      :: t_dev(:)=>null() ! temperature at the current step, on the device
real(R8P), pointer      :: tn_dev(:)=>null()! temperature at the next step, on the device
real(R8P), pointer      :: swap(:)=>null()  ! pointer swap
real(R8P), pointer      :: alias(:)=>null() ! a second pointer to t_dev, for the --double-free bug
real(R8P)               :: t(0:n+1)         ! temperature, on the host
character(32)           :: arg              ! command line argument
logical                 :: require_device   ! --require-device passed
logical                 :: double_free      ! --double-free passed
integer(I8P)            :: allocs, bytes    ! live device allocations
integer(I4P)            :: i, s             ! counters
integer(I4P)            :: ierr             ! error status

require_device = .false. ; double_free = .false.
do i=1, command_argument_count()
   call get_command_argument(i, arg)
   if (trim(arg) == '--require-device') require_device = .true.
   if (trim(arg) == '--double-free')    double_free = .true.
enddo

call dev_init(require_device=require_device, ierr=ierr)
if (ierr == FUNDAL_ERR_NO_DEVICE) then
   print '(A)', 'no device available and the host fallback is forbidden: stop'
   stop 1
endif
print '(A,L1)', 'running on the host: ', dev_is_host_fallback()

call dev_set_registry_policy('error') ! a misuse of dev_free without ierr stops the run (default: warn)
call dev_alloc(fptr_dev=t_dev,  lbounds=[0], ubounds=[n+1], ierr=ierr, init_value=0._R8P, label='temperature')
if (ierr /= 0) error stop 'device allocation failed'
call dev_alloc(fptr_dev=tn_dev, lbounds=[0], ubounds=[n+1], ierr=ierr, init_value=0._R8P, label='temperature, next')
if (ierr /= 0) error stop 'device allocation failed'
call dev_get_alloc_stats(allocs=allocs, bytes=bytes)
print '(A,I0,A,I0,A)', 'live device allocations: ', allocs, ' (', bytes, ' bytes)'
t = [(sin(pi*i*dx), i=0, n+1)]
t(0) = 0._R8P ; t(n+1) = 0._R8P
call dev_memcpy_to_device(dst=t_dev, src=t)
do s=1, steps
   !$acc parallel loop DEVICEVAR(t_dev, tn_dev)
   !$omp OMPLOOP DEVICEPTR(t_dev, tn_dev)
   do i=1, n
      tn_dev(i) = t_dev(i) + r * (t_dev(i-1) - 2._R8P * t_dev(i) + t_dev(i+1))
   enddo
   swap => t_dev ; t_dev => tn_dev ; tn_dev => swap
enddo
call dev_memcpy_from_device(dst=t, src=t_dev)
print '(A,I0,A,F7.5)', 'temperature at the centre after ', steps, ' steps: ', t((n+1)/2)
if (double_free) alias => t_dev

call dev_free(t_dev, ierr=ierr)
if (ierr /= 0) error stop 'dev_free failed'
call dev_free(tn_dev, ierr=ierr)
if (ierr /= 0) error stop 'dev_free failed'
call dev_alloc_report() ! nothing should be left
if (double_free) then ! the buffer of alias has already been freed through t_dev
   call dev_free(alias, ierr=ierr)
   if (ierr == FUNDAL_ERR_NOT_REGISTERED) then
      print '(A,I0,A)', 'dev_free(alias): error ', ierr, ', not a live FUNDAL allocation, nothing freed'
      stop 1
   endif
endif
endprogram heat_7
