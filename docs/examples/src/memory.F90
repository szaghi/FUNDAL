!run memory-bounds memory bounds
!run memory-kinds memory kinds
!run memory-replace memory replace
!run memory-assign memory assign
!run memory-transpose memory transpose
!run memory-stats memory stats
program memory
!< Cookbook, device memory: one recipe per command line argument.
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: fundal
implicit none
character(16) :: recipe ! recipe to run

call get_command_argument(1, recipe)
call dev_init
select case(trim(recipe))
case('bounds')
   call bounds
case('kinds')
   call kinds
case('replace')
   call replace
case('assign')
   call assign
case('transpose')
   call transpose_copy
case('stats')
   call stats
endselect

contains
   subroutine bounds
   !< An array with custom bounds and an initial value.
   real(R8P), pointer :: q_dev(:,:,:)=>null() ! device memory
   real(R8P)          :: q(-1:1,0:2,3)        ! host memory
   integer(I4P)       :: ierr                 ! error status

   !region bounds
   call dev_alloc(fptr_dev=q_dev, lbounds=[-1,0,1], ubounds=[1,2,3], ierr=ierr, init_value=-1._R8P, label='q')
   if (ierr /= 0) error stop 'device allocation failed'
   call dev_memcpy_from_device(dst=q, src=q_dev)
   print '(A,3(I0,A,I0,1X))', 'bounds: ', lbound(q_dev, 1), ':', ubound(q_dev, 1), lbound(q_dev, 2), ':', &
                              ubound(q_dev, 2), lbound(q_dev, 3), ':', ubound(q_dev, 3)
   print '(A,L1)', 'every element set on the device to -1: ', all(q == -1._R8P)
   call dev_free(q_dev)
   !endregion bounds
   endsubroutine bounds

   subroutine kinds
   !< Arrays of other kinds.
   integer(I1P), pointer :: mask_dev(:)=>null()  ! device memory, 1 byte integers
   real(R4P),    pointer :: phi_dev(:,:)=>null() ! device memory, single precision
   integer(I8P)          :: bytes                ! bytes of the live allocations
   integer(I4P)          :: ierr                 ! error status

   !region kinds
   call dev_alloc(fptr_dev=mask_dev, ubounds=[100], ierr=ierr, init_value=0_I1P, label='mask')
   if (ierr /= 0) error stop 'device allocation failed'
   call dev_alloc(fptr_dev=phi_dev, ubounds=[10,10], ierr=ierr, init_value=0._R4P, label='phi')
   if (ierr /= 0) error stop 'device allocation failed'
   call dev_get_alloc_stats(bytes=bytes)
   print '(A,I0,A)', 'device memory in use: ', bytes, ' bytes (100 x 1 + 100 x 4)'
   call dev_free(mask_dev)
   call dev_free(phi_dev)
   !endregion kinds
   endsubroutine kinds

   subroutine replace
   !< Resize a device array.
   real(R8P), pointer :: u_dev(:)=>null() ! device memory: =>null() is required by dev_alloc_replace
   real(R8P)          :: u(4)             ! host memory
   integer(I8P)       :: allocs           ! live device allocations
   integer(I4P)       :: n                ! array size
   integer(I4P)       :: ierr             ! error status

   !region replace
   do n=10, 40, 10 ! the previous buffer is freed at each call: no leak
      call dev_alloc_replace(fptr_dev=u_dev, ubounds=[n], ierr=ierr, init_value=real(n, R8P), label='u')
      if (ierr /= 0) error stop 'device allocation failed'
   enddo
   call dev_get_alloc_stats(allocs=allocs)
   call dev_memcpy_from_device(dst=u, src=u_dev(1:4))
   print '(A,I0,A,I0)', 'size: ', size(u_dev), ', live device allocations: ', allocs
   print '(A,*(F5.1))', 'first values (set by init_value, not preserved from the previous buffer):', u
   call dev_free(u_dev)
   !endregion replace
   endsubroutine replace

   subroutine assign
   !< Copy a host array into a new device array, keeping its bounds.
   real(R8P), pointer     :: f_dev(:,:)=>null() ! device memory
   real(R8P), allocatable :: f(:,:)             ! host memory
   real(R8P), allocatable :: g(:,:)             ! host memory, copied back
   integer(I4P)           :: ierr               ! error status

   allocate(f(0:3,-2:2)) ; f = 1.5_R8P
   !region assign
   call dev_assign_to_device(lbounds=lbound(f), dst=f_dev, src=f, ierr=ierr) ! allocate f_dev(0:3,-2:2), copy f
   if (ierr /= 0) error stop 'device allocation failed'
   call dev_assign_from_device(lbounds=lbound(f_dev), dst=g, src=f_dev)       ! allocate g(0:3,-2:2), copy f_dev
   print '(A,2(I0,A,I0,1X))', 'device bounds: ', lbound(f_dev, 1), ':', ubound(f_dev, 1), lbound(f_dev, 2), ':', &
                              ubound(f_dev, 2)
   print '(A,2(I0,A,I0,1X))', 'host bounds:   ', lbound(g, 1), ':', ubound(g, 1), lbound(g, 2), ':', ubound(g, 2)
   print '(A,L1)', 'same values: ', all(g == f)
   call dev_free(f_dev)
   !endregion assign
   endsubroutine assign

   subroutine transpose_copy
   !< Copy a device array back to the host, transposed.
   real(R8P), pointer     :: a_dev(:,:)=>null()   ! device memory, 2 x 3
   real(R8P), pointer     :: b_dev(:,:,:)=>null() ! device memory, 2 x 3 x 4
   real(R8P)              :: a(2,3)               ! host memory
   real(R8P)              :: at(3,2)              ! a transposed, host memory
   real(R8P)              :: buf(2,3)             ! host buffer, the shape of a
   real(R8P)              :: b(2,3,4)             ! host memory
   real(R8P), allocatable :: bt(:,:,:)            ! b with the indexes 1 and 3 swapped, host memory
   integer(I4P)           :: bb(2,2)              ! bounds of a: bb(1,:) lower, bb(2,:) upper
   integer(I4P)           :: tb(2,2)              ! bounds of at
   integer(I4P)           :: i, j, k              ! counters
   integer(I4P)           :: ierr                 ! error status

   a = reshape([(real(i, R8P), i=1, 6)], [2,3])
   b = reshape([(real(i, R8P), i=1, 24)], [2,3,4])
   call dev_alloc(fptr_dev=a_dev, ubounds=[2,3], ierr=ierr)
   if (ierr /= 0) error stop 'device allocation failed'
   call dev_alloc(fptr_dev=b_dev, ubounds=[2,3,4], ierr=ierr)
   if (ierr /= 0) error stop 'device allocation failed'
   call dev_memcpy_to_device(dst=a_dev, src=a)
   call dev_memcpy_to_device(dst=b_dev, src=b)
   !region transpose
   bb(1,:) = [1, 1] ; bb(2,:) = [2, 3] ! a_dev(1:2,1:3)
   tb(1,:) = [1, 1] ; tb(2,:) = [3, 2] ! at(1:3,1:2)
   call dev_memcpy_from_device(bb=bb, tb=tb, dst=at, src=a_dev, buf=buf) ! at = transpose(a_dev), through buf
   print '(A,L1)', 'at == transpose(a): ', all(at == transpose(a))
   call dev_assign_from_device(dst=bt, src=b_dev, ij=[1,3])             ! bt(k,j,i) = b_dev(i,j,k), allocated
   print '(A,3(I0,1X))', 'shape of bt: ', shape(bt)
   print '(A,L1)', 'bt(k,j,i) == b(i,j,k): ', all([(((bt(k,j,i) == b(i,j,k), i=1, 2), j=1, 3), k=1, 4)])
   !endregion transpose
   call dev_free(a_dev)
   call dev_free(b_dev)
   endsubroutine transpose_copy

   subroutine stats
   !< Count the live device allocations.
   real(R8P), pointer :: x_dev(:)=>null() ! device memory
   real(R8P), pointer :: y_dev(:)=>null() ! device memory
   integer(I8P)       :: allocs, bytes    ! live device allocations
   integer(I4P)       :: ierr             ! error status

   call dev_alloc(fptr_dev=x_dev, ubounds=[1000], ierr=ierr)
   if (ierr /= 0) error stop 'device allocation failed'
   call dev_alloc(fptr_dev=y_dev, ubounds=[500], ierr=ierr)
   if (ierr /= 0) error stop 'device allocation failed'
   !region stats
   call dev_get_alloc_stats(allocs=allocs, bytes=bytes)              ! on every device
   print '(A,I0,A,I0,A)', 'live: ', allocs, ' allocations, ', bytes, ' bytes'
   call dev_get_alloc_stats(allocs=allocs, bytes=bytes, dev_id=mydev) ! on this device only
   print '(A,I0,A,I0,A)', 'on this device: ', allocs, ' allocations, ', bytes, ' bytes'
   call dev_free(x_dev)
   call dev_free(y_dev)
   call dev_get_alloc_stats(allocs=allocs)
   if (allocs /= 0_I8P) error stop 'device memory leaked'
   print '(A,I0)', 'after the frees: ', allocs
   !endregion stats
   endsubroutine stats
endprogram memory
