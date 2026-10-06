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
