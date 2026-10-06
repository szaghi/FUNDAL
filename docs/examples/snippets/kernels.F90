#include "fundal.H"

module kernels_m
!< Cookbook, kernels: procedures with device dummy arguments.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
implicit none
private
public :: scale_mapped

contains
   subroutine scale_mapped(a, factor)
   !< Scale an array mapped to the device by dev_alloc_unstr: present, not deviceptr.
   real(R8P), intent(inout) :: a(:)   ! host array, mapped to the device
   real(R8P), intent(in)    :: factor ! scale factor
   integer(I4P)             :: i      ! counter

   !$acc parallel loop present(a)
   !$omp OMPLOOP
   do i=1, size(a)
      a(i) = factor * a(i)
   enddo
   endsubroutine scale_mapped
endmodule kernels_m

program kernels
!< Cookbook, kernels: one recipe per command line argument.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal
use            :: kernels_m
implicit none
character(16) :: recipe ! recipe to run

call get_command_argument(1, recipe)
call dev_init
select case(trim(recipe))
case('collapse')
   call collapse
case('reduction')
   call reduction
case('jacobi')
   call jacobi
case('unstructured')
   call unstructured
endselect

contains
   subroutine collapse
   !< A nested loop on the device.
   integer(I4P), parameter :: ni=4, nj=3                ! array sizes
   real(R8P), pointer      :: a_dev(:,:)=>null()        ! device memory
   real(R8P)               :: a(0:ni-1,0:nj-1)          ! host memory
   integer(I4P)            :: i, j                      ! counters
   integer(I4P)            :: ierr                      ! error status

   call dev_alloc(fptr_dev=a_dev, lbounds=[0,0], ubounds=[ni-1,nj-1], ierr=ierr)
   if (ierr /= 0) error stop 'device allocation failed'
   !$acc parallel loop collapse(2) DEVICEVAR(a_dev)
   !$omp OMPLOOP collapse(2) DEVICEPTR(a_dev)
   do j=0, nj-1     ! outer loop: the last index
      do i=0, ni-1  ! inner loop: the first index, contiguous in memory
         a_dev(i,j) = real(10 * i + j, R8P)
      enddo
   enddo
   call dev_memcpy_from_device(dst=a, src=a_dev)
   do i=0, ni-1
      print '(*(F5.1))', a(i,:)
   enddo
   print '(A,L1)', 'a(i,j) == 10 i + j: ', all(a == reshape([((real(10*i+j, R8P), i=0, ni-1), j=0, nj-1)], [ni,nj]))
   call dev_free(a_dev)
   endsubroutine collapse

   subroutine reduction
   !< Reductions on the device.
   integer(I4P), parameter :: n=1000            ! array size
   real(R8P), pointer      :: a_dev(:)=>null()  ! device memory
   real(R8P)               :: total             ! sum of the elements
   real(R8P)               :: peak              ! maximum element
   integer(I4P)            :: i                 ! counter
   integer(I4P)            :: ierr              ! error status

   call dev_alloc(fptr_dev=a_dev, ubounds=[n], ierr=ierr)
   if (ierr /= 0) error stop 'device allocation failed'
   !$acc parallel loop DEVICEVAR(a_dev)
   !$omp OMPLOOP DEVICEPTR(a_dev)
   do i=1, n
      a_dev(i) = real(i, R8P)
   enddo
   total = 0._R8P
   peak = -huge(1._R8P)
   !$acc parallel loop reduction(+:total) reduction(max:peak) DEVICEVAR(a_dev)
   !$omp OMPLOOP reduction(+:total) reduction(max:peak) DEVICEPTR(a_dev)
   do i=1, n
      total = total + a_dev(i)
      peak = max(peak, a_dev(i))
   enddo
   print '(A,F9.1,A,F7.1)', 'sum: ', total, ', max: ', peak
   print '(A,L1)', 'sum == n (n+1) / 2: ', total == real(n * (n + 1) / 2, R8P)
   call dev_free(a_dev)
   endsubroutine reduction

   subroutine jacobi
   !< An iterative solver: two device buffers, swapped at each iteration, until convergence.
   integer(I4P), parameter :: n=16                 ! interior cells per direction
   integer(I4P), parameter :: max_iter=10000       ! maximum number of iterations
   real(R8P),    parameter :: tol=1.e-8_R8P        ! convergence tolerance
   real(R8P), pointer      :: t_dev(:,:)=>null()   ! current iterate, device memory
   real(R8P), pointer      :: tn_dev(:,:)=>null()  ! next iterate, device memory
   real(R8P), pointer      :: swap(:,:)=>null()    ! pointer swap
   real(R8P)               :: t(0:n+1,0:n+1)       ! host memory
   real(R8P)               :: change               ! largest change of an iteration
   integer(I4P)            :: i, j, iter           ! counters
   integer(I4P)            :: ierr                 ! error status

   ! the Laplace equation with T=1 on the whole boundary: the solution is T=1 everywhere
   call dev_alloc(fptr_dev=t_dev,  lbounds=[0,0], ubounds=[n+1,n+1], ierr=ierr, init_value=1._R8P)
   if (ierr /= 0) error stop 'device allocation failed'
   call dev_alloc(fptr_dev=tn_dev, lbounds=[0,0], ubounds=[n+1,n+1], ierr=ierr, init_value=1._R8P)
   if (ierr /= 0) error stop 'device allocation failed'
   t = 1._R8P ; t(1:n,1:n) = 0._R8P ! start from 0 inside
   call dev_memcpy_to_device(dst=t_dev, src=t)
   do iter=1, max_iter
      change = 0._R8P
      !$acc parallel loop collapse(2) reduction(max:change) DEVICEVAR(t_dev, tn_dev)
      !$omp OMPLOOP collapse(2) reduction(max:change) DEVICEPTR(t_dev, tn_dev)
      do j=1, n
         do i=1, n
            tn_dev(i,j) = 0.25_R8P * (t_dev(i-1,j) + t_dev(i+1,j) + t_dev(i,j-1) + t_dev(i,j+1))
            change = max(change, abs(tn_dev(i,j) - t_dev(i,j)))
         enddo
      enddo
      swap => t_dev ; t_dev => tn_dev ; tn_dev => swap ! the new iterate becomes the current one
      if (change < tol) exit
   enddo
   call dev_memcpy_from_device(dst=t, src=t_dev)
   print '(A,I0,A)', 'converged in ', iter, ' iterations'
   print '(A,L1)', 'max |T - 1| < 1e-6: ', maxval(abs(t - 1._R8P)) < 1.e-6_R8P
   call dev_free(t_dev)
   call dev_free(tn_dev)
   endsubroutine jacobi

   subroutine unstructured
   !< A procedure working on a host array mapped to the device.
   real(R8P), allocatable :: a(:) ! host memory, mapped to the device
   integer(I4P)           :: i    ! counter

   allocate(a(5)) ; a = [(real(i, R8P), i=1, 5)]
   call dev_alloc_unstr(fptr_dev=a)
   call dev_memcpy_to_device_unstr(dst=a)
   call scale_mapped(a=a, factor=10._R8P)
   call dev_memcpy_from_device_unstr(dst=a)
   call dev_free_unstr(fptr=a)
   print '(A,*(F6.1))', 'a:', a
   endsubroutine unstructured
endprogram kernels
