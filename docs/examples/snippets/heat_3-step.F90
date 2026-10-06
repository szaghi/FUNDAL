do s=1, steps
   !$acc parallel loop DEVICEVAR(t_dev, tn_dev)
   !$omp OMPLOOP DEVICEPTR(t_dev, tn_dev)
   do i=1, n
      tn_dev(i) = t_dev(i) + r * (t_dev(i-1) - 2._R8P * t_dev(i) + t_dev(i+1))
   enddo
   swap => t_dev ; t_dev => tn_dev ; tn_dev => swap ! the new step becomes the current one: no copy
enddo
