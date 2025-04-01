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
   type(mytype), target :: mat                               ! derived type matrices instance
   ! real, pointer, dimension(:) :: a =>null(),b=>null()

   call system_clock(count_max=count_max, count_rate=count_rate)
   associate(aa=>mat%a, bb=>mat%b, cc=>mat%c)
   do m=1,4 ! test for different size matrix multiplies
      n = 1000*2**(m-1) ! 1000, 2000, 4000, 8000
      print '(A)'
      print '(A,I6)', 'Elements number: ', n
      allocate(mat%a(n,n), mat%b(n,n), mat%c(n,n) )
      call system_clock(t1)
      !$acc data create(aa,bb) copyout(cc)
      ! initialize matrices
      !$acc parallel loop gang worker vector collapse(2)
      do j=1,n
         do i=1,n
            if (i == j) then
               mat%a(i,j) = 10.0
               mat%b(i,j) = 0.1
            else
               mat%a(i,j) = 0.0
               mat%b(i,j) = 0.0
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
               tmp = tmp + mat%a(i,k)*mat%b(k,j)
            enddo
            mat%c(i,j) = tmp
         enddo
      enddo
      !$acc end parallel loop
      !$acc end data
      do i=n/10,n,n/10
         print '(A,I6,F10.1)', 'c(i,i): ', i, mat%c(i,i)
      enddo
      call system_clock(t2)
      dt = t2-t1
      secs = real(dt)/real(count_rate)
      print '(A,E16.4)', 'Seconds: ', secs
      deallocate(mat%a, mat%b, mat%c)
   enddo
   endassociate
endprogram test_dtype
