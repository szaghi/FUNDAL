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
