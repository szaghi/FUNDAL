program test_dtype
   use openacc
   implicit none
   type :: mytype
       ! prototype derived type
       real, pointer, dimension(:,:) :: a => null() ! a matrix
       real, pointer, dimension(:,:) :: b => null() ! b matrix
       real, pointer, dimension(:,:) :: c => null() ! c = a x b matrix
   endtype
   integer              :: i, j, k, m, n                     ! counter
   integer              :: t1, t2, dt, count_rate, count_max ! timing counter
   real                 :: secs                              ! timing seconds
   real                 :: tmp                               ! temporary buffer
   ! type(mytype), target :: mat                               ! derived type matrices instance
   type(mytype), target :: mat(1)                            ! derived type matrices instance
   ! real, pointer, dimension(:) :: a =>null(),b=>null()

   call system_clock(count_max=count_max, count_rate=count_rate)
   associate(aa=>mat(1)%a, bb=>mat(1)%b, cc=>mat(1)%c)
   do m=1,4 ! test for different size matrix multiplies
      n = 1000*2**(m-1) ! 1000, 2000, 4000, 8000
      print '(A)'
      print '(A,I6)', 'Elements number: ', n
      allocate(mat(1)%a(n,n), mat(1)%b(n,n), mat(1)%c(n,n) )
      call system_clock(t1)
      !$acc data create(aa,bb) copyout(cc)
      ! initialize matrices
      !$acc parallel loop gang worker vector collapse(2)
      do j=1,n
         do i=1,n
            if (i == j) then
               mat(1)%a(i,j) = 10.0
               mat(1)%b(i,j) = 0.1
            else
               mat(1)%a(i,j) = 0.0
               mat(1)%b(i,j) = 0.0
            endif
         enddo
      enddo
      !$acc end parallel loop
      ! multiply matrices
      !$acc parallel loop gang worker vector collapse(2) private(i,j,k) reduction(+:tmp) vector_length(128)
      do j=1,n
         do i=1,n
            tmp = 0.0  ! enables ACC parallelism for k-loop
            !$acc loop private(k)
            do k=1,n
               tmp = tmp + mat(1)%a(i,k)*mat(1)%b(k,j)
            enddo
            mat(1)%c(i,j) = tmp
         enddo
      enddo
      !$acc end parallel loop
      !$acc end data
      do i=n/10,n,n/10
         print '(A,I6,F10.1)', 'c(i,i): ', i, mat(1)%c(i,i)
      enddo
      call system_clock(t2)
      dt = t2-t1
      secs = real(dt)/real(count_rate)
      print '(A,E16.4)', 'Seconds: ', secs
      deallocate(mat(1)%a, mat(1)%b, mat(1)%c)
   enddo
   endassociate
endprogram test_dtype
