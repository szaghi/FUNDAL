!< FUNDAL, laplace test, OpenACC inline version.

#include "fundal.H"

program fundal_laplace_dev_inline
!< FUNDAL, laplace test, device inline version.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal

integer(I4P), parameter :: n=4096, m=4096, iter_max=1000
real(R8P), pointer      :: A(:,:), Anew(:,:)
real(R8P)               :: tol=1.0e-6_R8P, error=1.0_R8P
real(R8P)               :: start_time, stop_time
integer(I4P)            :: i, j, iter, ierr

! initialize environment global variables
myhos = dev_get_host_num()
devtype = dev_get_device_type()
call dev_set_device_num(0)
mydev = dev_get_device_num()

call dev_alloc(fptr_dev=A,   lbounds=[0,0],ubounds=[n-1,m-1],ierr=ierr,init_value=0._R8P)
call dev_alloc(fptr_dev=Anew,lbounds=[0,0],ubounds=[n-1,m-1],ierr=ierr,init_value=0._R8P)

! Set B.C.
#if defined DEV_OMP
!$omp OMPLOOP DEVICEPTR(A,Anew)
do j=0,m-1
   A(   0,j) = 1.0_R8P
   Anew(0,j) = 1.0_R8P
enddo
#else
!$acc kernels
A(   0,:) = 1.0_R8P
Anew(0,:) = 1.0_R8P
!$acc end kernels
#endif

write(*,'(a,i5,a,i5,a)') 'Jacobi relaxation Calculation:', n, ' x', m, ' mesh'

call cpu_time(start_time)

iter=0

do while ( error .gt. tol .and. iter .lt. iter_max )
   error=0.0_R8P

   !$acc parallel loop reduction(max:error) DEVICEVAR(A,Anew)
   !$omp OMPLOOP DEVICEPTR(A,Anew) reduction(max:error)
   do j=1,m-2
      do i=1,n-2
         Anew(i,j) = 0.25_R8P * ( A(i+1,j  ) + A(i-1,j  ) + &
                                  A(i  ,j-1) + A(i  ,j+1) )
         error = max(error, abs(Anew(i,j)-A(i,j)))
      enddo
   enddo

   !$acc parallel loop DEVICEVAR(A,Anew)
   !$omp OMPLOOP DEVICEPTR(A,Anew)
   do j=1,m-2
      do i=1,n-2
         A(i,j) = Anew(i,j)
      enddo
   enddo

   if(mod(iter,100).eq.0 ) write(*,'(i5,f10.6)') iter, error
   iter = iter + 1
enddo

call cpu_time(stop_time)
write(*,'(a,f10.3,a)')  ' completed in ', stop_time-start_time, ' seconds'
call dev_free(A,mydev)
call dev_free(Anew,mydev)

print '(A)', 'test passed'
endprogram fundal_laplace_dev_inline
