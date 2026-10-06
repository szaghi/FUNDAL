do s=1, steps, 2 ! two steps per iteration: t -> tn, then tn -> t
   !$acc parallel loop present(t, tn)
   !$omp OMPLOOP
   do i=1, n
      tn(i) = t(i) + r * (t(i-1) - 2._R8P * t(i) + t(i+1))
   enddo
   !$acc parallel loop present(t, tn)
   !$omp OMPLOOP
   do i=1, n
      t(i) = tn(i) + r * (tn(i-1) - 2._R8P * tn(i) + tn(i+1))
   enddo
enddo
