!$acc parallel loop collapse(2) DEVICEVAR(a_dev)
!$omp OMPLOOP collapse(2) DEVICEPTR(a_dev)
do j=0, nj-1     ! outer loop: the last index
   do i=0, ni-1  ! inner loop: the first index, contiguous in memory
      a_dev(i,j) = real(10 * i + j, R8P)
   enddo
enddo
