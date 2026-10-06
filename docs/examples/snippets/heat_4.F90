#include "fundal.H"

module heat_solver_m
!< A 1-D heat solver whose state lives on the device.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal
implicit none
private
public :: heat_solver

type :: heat_solver
   !< Explicit solver of the 1-D heat equation, temperature with ghost cells 0 and n+1.
   integer(I4P)       :: n=0               ! interior cells
   real(R8P)          :: r=0._R8P          ! alpha*dt/dx**2
   real(R8P), pointer :: t_dev(:)=>null()  ! temperature at the current step, on the device
   real(R8P), pointer :: tn_dev(:)=>null() ! temperature at the next step, on the device
   contains
      procedure, pass(self) :: init    ! allocate the device state and upload the initial condition
      procedure, pass(self) :: run     ! advance some steps on the device
      procedure, pass(self) :: get     ! download the temperature
      procedure, pass(self) :: destroy ! release the device state
endtype heat_solver

contains
   subroutine init(self, t, r, ierr)
   !< Allocate the device state and upload the initial condition t(0:n+1).
   class(heat_solver), intent(inout) :: self ! solver
   real(R8P),          intent(in)    :: t(0:) ! initial temperature, ghost cells included
   real(R8P),          intent(in)    :: r     ! alpha*dt/dx**2
   integer(I4P),       intent(out)   :: ierr  ! error status

   self%n = size(t) - 2
   self%r = r
   call dev_alloc(fptr_dev=self%t_dev,  lbounds=[0], ubounds=[self%n+1], ierr=ierr, init_value=0._R8P, label='t')
   if (ierr /= 0) return
   call dev_alloc(fptr_dev=self%tn_dev, lbounds=[0], ubounds=[self%n+1], ierr=ierr, init_value=0._R8P, label='tn')
   if (ierr /= 0) return
   call dev_memcpy_to_device(dst=self%t_dev, src=t)
   endsubroutine init

   subroutine run(self, steps)
   !< Advance some steps on the device.
   class(heat_solver), intent(inout) :: self  ! solver
   integer(I4P),       intent(in)    :: steps          ! number of steps
   real(R8P), pointer                :: swap(:)=>null() ! pointer swap
   integer(I4P)                      :: s              ! counter

   do s=1, steps
      call diffuse(n=self%n, r=self%r, t=self%t_dev, tn=self%tn_dev) ! components passed as plain arrays
      swap => self%t_dev ; self%t_dev => self%tn_dev ; self%tn_dev => swap
   enddo
   endsubroutine run

   subroutine get(self, t)
   !< Download the temperature, ghost cells included.
   class(heat_solver), intent(in)  :: self  ! solver
   real(R8P),          intent(out) :: t(0:) ! temperature

   call dev_memcpy_from_device(dst=t, src=self%t_dev)
   endsubroutine get

   subroutine destroy(self)
   !< Release the device state.
   class(heat_solver), intent(inout) :: self ! solver

   call dev_free(self%t_dev)
   call dev_free(self%tn_dev)
   endsubroutine destroy

   subroutine diffuse(n, r, t, tn)
   !< One explicit step: the device arrays are dummy arguments, as OpenACC deviceptr requires.
   integer(I4P), intent(in)    :: n      ! interior cells
   real(R8P),    intent(in)    :: r      ! alpha*dt/dx**2
   real(R8P),    intent(in)    :: t(0:)  ! temperature at the current step, device memory
   real(R8P),    intent(inout) :: tn(0:) ! temperature at the next step, device memory
   integer(I4P)                :: i      ! counter

   !$acc parallel loop DEVICEVAR(t, tn)
   !$omp OMPLOOP DEVICEPTR(t, tn)
   do i=1, n
      tn(i) = t(i) + r * (t(i-1) - 2._R8P * t(i) + t(i+1))
   enddo
   endsubroutine diffuse
endmodule heat_solver_m

program heat_4
!< Tutorial, chapter 4: kernels in procedures, a type holding device arrays.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal
use            :: heat_solver_m
implicit none
integer(I4P), parameter :: n=15             ! interior cells
integer(I4P), parameter :: steps=50         ! time steps
real(R8P),    parameter :: r=0.25_R8P       ! alpha*dt/dx**2
real(R8P),    parameter :: pi=acos(-1._R8P) ! pi
real(R8P),    parameter :: dx=1._R8P/(n+1)  ! cell size
type(heat_solver)       :: solver           ! the solver
real(R8P)               :: t(0:n+1)         ! temperature, on the host
real(R8P)               :: exact(0:n+1)     ! exact solution of the discrete problem
integer(I4P)            :: i                ! counter
integer(I4P)            :: ierr             ! error status

call dev_init
t = [(sin(pi*i*dx), i=0, n+1)]
t(0) = 0._R8P ; t(n+1) = 0._R8P
call solver%init(t=t, r=r, ierr=ierr)
if (ierr /= 0) error stop 'device allocation failed'
call solver%run(steps=steps)
call solver%get(t=t)
call solver%destroy
exact = (1._R8P - 4._R8P * r * sin(pi * dx / 2._R8P)**2)**steps * [(sin(pi*i*dx), i=0, n+1)]
exact(0) = 0._R8P ; exact(n+1) = 0._R8P
print '(A,I0,A,F7.5)', 'temperature at the centre after ', steps, ' steps: ', t((n+1)/2)
print '(A,L1)', 'equal to the exact discrete solution: ', maxval(abs(t - exact)) < 1.e-12_R8P
endprogram heat_4
