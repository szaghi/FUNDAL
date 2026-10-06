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
