#include "fundal.H"

program heat_3
!< Tutorial, chapter 3: a portable kernel, the explicit diffusion step on the device.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal
implicit none
integer(I4P), parameter :: n=15                ! interior cells, ghost cells 0 and n+1
integer(I4P), parameter :: steps=50            ! time steps
real(R8P),    parameter :: r=0.25_R8P          ! alpha*dt/dx**2, the scheme is stable for r <= 0.5
real(R8P),    parameter :: pi=acos(-1._R8P)    ! pi
real(R8P),    parameter :: dx=1._R8P/(n+1)     ! cell size
real(R8P), pointer      :: t_dev(:)=>null()    ! temperature at the current step, on the device
real(R8P), pointer      :: tn_dev(:)=>null()   ! temperature at the next step, on the device
real(R8P), pointer      :: swap(:)=>null()     ! pointer swap
real(R8P)               :: t(0:n+1)            ! temperature, on the host
real(R8P)               :: exact(0:n+1)        ! exact solution of the discrete problem
integer(I4P)            :: i, s                ! counters
integer(I4P)            :: ierr                ! error status

call dev_init
call dev_alloc(fptr_dev=t_dev,  lbounds=[0], ubounds=[n+1], ierr=ierr, init_value=0._R8P, label='t')
if (ierr /= 0) error stop 'device allocation failed'
call dev_alloc(fptr_dev=tn_dev, lbounds=[0], ubounds=[n+1], ierr=ierr, init_value=0._R8P, label='tn')
if (ierr /= 0) error stop 'device allocation failed'
t = [(sin(pi*i*dx), i=0, n+1)] ! one sine arch, zero at both ends
t(0) = 0._R8P ; t(n+1) = 0._R8P
call dev_memcpy_to_device(dst=t_dev, src=t)

do s=1, steps
   !$acc parallel loop DEVICEVAR(t_dev, tn_dev)
   !$omp OMPLOOP DEVICEPTR(t_dev, tn_dev)
   do i=1, n
      tn_dev(i) = t_dev(i) + r * (t_dev(i-1) - 2._R8P * t_dev(i) + t_dev(i+1))
   enddo
   swap => t_dev ; t_dev => tn_dev ; tn_dev => swap ! the new step becomes the current one: no copy
enddo

call dev_memcpy_from_device(dst=t, src=t_dev)
! the sine arch is an eigenvector of the scheme: each step multiplies it by g = 1 - 4 r sin(pi dx/2)**2
exact = (1._R8P - 4._R8P * r * sin(pi * dx / 2._R8P)**2)**steps * [(sin(pi*i*dx), i=0, n+1)]
exact(0) = 0._R8P ; exact(n+1) = 0._R8P
print '(A,I0,A,F7.5)', 'temperature at the centre after ', steps, ' steps: ', t((n+1)/2)
print '(A,L1)', 'equal to the exact discrete solution: ', maxval(abs(t - exact)) < 1.e-12_R8P
call dev_free(t_dev)
call dev_free(tn_dev)
endprogram heat_3
