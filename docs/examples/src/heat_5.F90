!run heat_5 heat_5
#include "fundal.H"

program heat_5
!< Tutorial, chapter 5: the unstructured model, host allocatables mapped to the device.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal
implicit none
integer(I4P), parameter :: n=15             ! interior cells, ghost cells 0 and n+1
integer(I4P), parameter :: steps=50         ! time steps (even: two per iteration)
real(R8P),    parameter :: r=0.25_R8P       ! alpha*dt/dx**2
real(R8P),    parameter :: pi=acos(-1._R8P) ! pi
real(R8P),    parameter :: dx=1._R8P/(n+1)  ! cell size
real(R8P), allocatable  :: t(:)             ! temperature, host array mapped to the device
real(R8P), allocatable  :: tn(:)            ! temperature at the next step, host array mapped to the device
real(R8P)               :: exact(0:n+1)     ! exact solution of the discrete problem
integer(I4P)            :: i, s             ! counters

call dev_init
!region map
allocate(t(0:n+1), tn(0:n+1))
t = [(sin(pi*i*dx), i=0, n+1)]
t(0) = 0._R8P ; t(n+1) = 0._R8P
call dev_alloc_unstr(fptr_dev=t)                      ! a device copy of t, uninitialised
call dev_memcpy_to_device_unstr(dst=t)                ! host t -> device t
call dev_alloc_unstr(fptr_dev=tn, init_value=0._R8P)  ! a device copy of tn, set on the device
!endregion map
!region step
do s=1, steps, 2 ! two steps per iteration: t -> tn, then tn -> t
   !$acc parallel loop present(t, tn)
   !$omp OMPLOOP
   do i=1, n
      tn(i) = t(i) + r * (t(i-1) - 2._R8P * t(i) + t(i+1))
   enddo
   !$acc parallel loop present(t, tn)
   !$omp OMPLOOP
   do i=1, n
      t(i) = tn(i) + r * (tn(i-1) - 2._R8P * tn(i) + tn(i+1))
   enddo
enddo
!endregion step
!region unmap
call dev_memcpy_from_device_unstr(dst=t) ! device t -> host t
call dev_free_unstr(fptr=t)
call dev_free_unstr(fptr=tn)
!endregion unmap
exact = (1._R8P - 4._R8P * r * sin(pi * dx / 2._R8P)**2)**steps * [(sin(pi*i*dx), i=0, n+1)]
exact(0) = 0._R8P ; exact(n+1) = 0._R8P
print '(A,I0,A,F7.5)', 'temperature at the centre after ', steps, ' steps: ', t((n+1)/2)
print '(A,L1)', 'equal to the exact discrete solution: ', maxval(abs(t - exact)) < 1.e-12_R8P
deallocate(t, tn)
endprogram heat_5
