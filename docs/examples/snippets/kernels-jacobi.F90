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
