!< FUNDAL, laplace test, baseline serial version.
program fundal_laplace_baseline
!< FUNDAL, laplace test, baseline serial version.
!< Test taken from OpenACC best practice [documentation](https://github.com/OpenACC/openacc-best-practices-guide).
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64

integer(I4P), parameter :: n=4096, m=4096, iter_max=1000
real(R8P), allocatable  :: A(:,:), Anew(:,:)
real(R8P)               :: tol=1.0e-6_R8P, error=1.0_R8P
real(R8P)               :: start_time, stop_time
integer(I4P)            :: i, j, iter

allocate(A(0:n-1,0:m-1), Anew(0:n-1,0:m-1))

A    = 0.0_R8P
Anew = 0.0_R8P

! Set B.C.
A(0,:)    = 1.0_R8P
Anew(0,:) = 1.0_R8P

write(*,'(a,i5,a,i5,a)') 'Jacobi relaxation Calculation:', n, ' x', m, ' mesh'

call cpu_time(start_time)

iter=0

do while ( error .gt. tol .and. iter .lt. iter_max )
   error=0.0_R8P

   do j=1,m-2
      do i=1,n-2
         Anew(i,j) = 0.25_R8P * ( A(i+1,j  ) + A(i-1,j  ) + &
                                  A(i  ,j-1) + A(i  ,j+1) )
         error = max(error, abs(Anew(i,j)-A(i,j)))
      enddo
   enddo

   if(mod(iter,100).eq.0 ) write(*,'(i5,f10.6)') iter, error
   iter = iter + 1

   do j=1,m-2
      do i=1,n-2
         A(i,j) = Anew(i,j)
      enddo
   enddo
enddo

call cpu_time(stop_time)
write(*,'(a,f10.3,a)')  ' completed in ', stop_time-start_time, ' seconds'
deallocate(A,Anew)

print '(A)', 'test passed'
endprogram fundal_laplace_baseline
