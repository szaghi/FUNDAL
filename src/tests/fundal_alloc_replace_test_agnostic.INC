   subroutine TEST_KKP
   !< Test KKP kind.
   VARTYPE(KKP), parameter   :: V1=1                     !< Value of first allocation.
   VARTYPE(KKP), parameter   :: V2=2                     !< Value after replace with new bounds.
   VARTYPE(KKP), parameter   :: V3=3                     !< Value after replace with same bounds.
   VARTYPE(KKP), pointer     :: a1(:)=>null()             !< Device array, rank 1.
   VARTYPE(KKP), pointer     :: a2(:,:)=>null()           !< Device array, rank 2.
   VARTYPE(KKP), pointer     :: a3(:,:,:)=>null()         !< Device array, rank 3.
   VARTYPE(KKP), pointer     :: a4(:,:,:,:)=>null()       !< Device array, rank 4.
   VARTYPE(KKP), pointer     :: a5(:,:,:,:,:)=>null()     !< Device array, rank 5.
   VARTYPE(KKP), pointer     :: a6(:,:,:,:,:,:)=>null()   !< Device array, rank 6.
   VARTYPE(KKP), pointer     :: a7(:,:,:,:,:,:,:)=>null() !< Device array, rank 7.
   VARTYPE(KKP), allocatable :: h1(:)                     !< Host array, rank 1.
   VARTYPE(KKP), allocatable :: h2(:,:)                   !< Host array, rank 2.
   VARTYPE(KKP), allocatable :: h3(:,:,:)                 !< Host array, rank 3.
   VARTYPE(KKP), allocatable :: h4(:,:,:,:)               !< Host array, rank 4.
   VARTYPE(KKP), allocatable :: h5(:,:,:,:,:)             !< Host array, rank 5.
   VARTYPE(KKP), allocatable :: h6(:,:,:,:,:,:)           !< Host array, rank 6.
   VARTYPE(KKP), allocatable :: h7(:,:,:,:,:,:,:)         !< Host array, rank 7.
   VARTYPE(KKP)              :: mold(1)                  !< Mold for storage_size.
   integer(I4P)              :: lb(7), ub(7)             !< Bounds.
   integer(I4P)              :: ierr                     !< Error status.
   integer(I8P)              :: allocs0, bytes0          !< Allocation stats, baseline.
   integer(I8P)              :: allocs, bytes            !< Allocation stats.
   integer(I8P)              :: bytes_expected           !< Expected live bytes.

   print '(A)', ECHO_KKP
   call dev_get_alloc_stats(allocs=allocs0, bytes=bytes0)

   print '(A)', '    dev_alloc_replace on nullified pointers'
   ub = 2
   call dev_alloc_replace(fptr_dev=a1, ubounds=ub(1:1), ierr=ierr, init_value=V1) ; call check(ierr==0, 'a1 alloc')
   call dev_alloc_replace(fptr_dev=a2, ubounds=ub(1:2), ierr=ierr, init_value=V1) ; call check(ierr==0, 'a2 alloc')
   call dev_alloc_replace(fptr_dev=a3, ubounds=ub(1:3), ierr=ierr, init_value=V1) ; call check(ierr==0, 'a3 alloc')
   call dev_alloc_replace(fptr_dev=a4, ubounds=ub(1:4), ierr=ierr, init_value=V1) ; call check(ierr==0, 'a4 alloc')
   call dev_alloc_replace(fptr_dev=a5, ubounds=ub(1:5), ierr=ierr, init_value=V1) ; call check(ierr==0, 'a5 alloc')
   call dev_alloc_replace(fptr_dev=a6, ubounds=ub(1:6), ierr=ierr, init_value=V1) ; call check(ierr==0, 'a6 alloc')
   call dev_alloc_replace(fptr_dev=a7, ubounds=ub(1:7), ierr=ierr, init_value=V1) ; call check(ierr==0, 'a7 alloc')
   call dev_get_alloc_stats(allocs=allocs, bytes=bytes)
   bytes_expected = (2_I8P + 4_I8P + 8_I8P + 16_I8P + 32_I8P + 64_I8P + 128_I8P) * (storage_size(mold, kind=I8P) / 8_I8P)
   call check(allocs - allocs0 == 7_I8P,              'live allocations after first allocation')
   call check(bytes  - bytes0  == bytes_expected,     'live bytes after first allocation')

   print '(A)', '    dev_alloc_replace on associated pointers, different bounds'
   lb = -1 ; ub = 1
   call dev_alloc_replace(fptr_dev=a1, lbounds=lb(1:1), ubounds=ub(1:1), ierr=ierr, init_value=V2) ; call check(ierr==0, 'a1 replace')
   call dev_alloc_replace(fptr_dev=a2, lbounds=lb(1:2), ubounds=ub(1:2), ierr=ierr, init_value=V2) ; call check(ierr==0, 'a2 replace')
   call dev_alloc_replace(fptr_dev=a3, lbounds=lb(1:3), ubounds=ub(1:3), ierr=ierr, init_value=V2) ; call check(ierr==0, 'a3 replace')
   call dev_alloc_replace(fptr_dev=a4, lbounds=lb(1:4), ubounds=ub(1:4), ierr=ierr, init_value=V2) ; call check(ierr==0, 'a4 replace')
   call dev_alloc_replace(fptr_dev=a5, lbounds=lb(1:5), ubounds=ub(1:5), ierr=ierr, init_value=V2) ; call check(ierr==0, 'a5 replace')
   call dev_alloc_replace(fptr_dev=a6, lbounds=lb(1:6), ubounds=ub(1:6), ierr=ierr, init_value=V2) ; call check(ierr==0, 'a6 replace')
   call dev_alloc_replace(fptr_dev=a7, lbounds=lb(1:7), ubounds=ub(1:7), ierr=ierr, init_value=V2) ; call check(ierr==0, 'a7 replace')
   call check(all(lbound(a1)==lb(1:1)).and.all(ubound(a1)==ub(1:1)), 'a1 bounds')
   call check(all(lbound(a2)==lb(1:2)).and.all(ubound(a2)==ub(1:2)), 'a2 bounds')
   call check(all(lbound(a3)==lb(1:3)).and.all(ubound(a3)==ub(1:3)), 'a3 bounds')
   call check(all(lbound(a4)==lb(1:4)).and.all(ubound(a4)==ub(1:4)), 'a4 bounds')
   call check(all(lbound(a5)==lb(1:5)).and.all(ubound(a5)==ub(1:5)), 'a5 bounds')
   call check(all(lbound(a6)==lb(1:6)).and.all(ubound(a6)==ub(1:6)), 'a6 bounds')
   call check(all(lbound(a7)==lb(1:7)).and.all(ubound(a7)==ub(1:7)), 'a7 bounds')
   allocate(h1(lb(1):ub(1)))
   allocate(h2(lb(1):ub(1),lb(2):ub(2)))
   allocate(h3(lb(1):ub(1),lb(2):ub(2),lb(3):ub(3)))
   allocate(h4(lb(1):ub(1),lb(2):ub(2),lb(3):ub(3),lb(4):ub(4)))
   allocate(h5(lb(1):ub(1),lb(2):ub(2),lb(3):ub(3),lb(4):ub(4),lb(5):ub(5)))
   allocate(h6(lb(1):ub(1),lb(2):ub(2),lb(3):ub(3),lb(4):ub(4),lb(5):ub(5),lb(6):ub(6)))
   allocate(h7(lb(1):ub(1),lb(2):ub(2),lb(3):ub(3),lb(4):ub(4),lb(5):ub(5),lb(6):ub(6),lb(7):ub(7)))
   call dev_memcpy_from_device(src=a1, dst=h1) ; call check(all(h1==V2), 'a1 value')
   call dev_memcpy_from_device(src=a2, dst=h2) ; call check(all(h2==V2), 'a2 value')
   call dev_memcpy_from_device(src=a3, dst=h3) ; call check(all(h3==V2), 'a3 value')
   call dev_memcpy_from_device(src=a4, dst=h4) ; call check(all(h4==V2), 'a4 value')
   call dev_memcpy_from_device(src=a5, dst=h5) ; call check(all(h5==V2), 'a5 value')
   call dev_memcpy_from_device(src=a6, dst=h6) ; call check(all(h6==V2), 'a6 value')
   call dev_memcpy_from_device(src=a7, dst=h7) ; call check(all(h7==V2), 'a7 value')
   call dev_get_alloc_stats(allocs=allocs, bytes=bytes)
   bytes_expected = (3_I8P + 9_I8P + 27_I8P + 81_I8P + 243_I8P + 729_I8P + 2187_I8P) * (storage_size(mold, kind=I8P) / 8_I8P)
   call check(allocs - allocs0 == 7_I8P,          'live allocations after replace, different bounds')
   call check(bytes  - bytes0  == bytes_expected, 'live bytes after replace, different bounds')

   print '(A)', '    dev_alloc_replace on associated pointers, same bounds'
   lb = -1 ; ub = 1
   call dev_alloc_replace(fptr_dev=a1, lbounds=lb(1:1), ubounds=ub(1:1), ierr=ierr, init_value=V3) ; call check(ierr==0, 'a1 replace')
   call dev_alloc_replace(fptr_dev=a2, lbounds=lb(1:2), ubounds=ub(1:2), ierr=ierr, init_value=V3) ; call check(ierr==0, 'a2 replace')
   call dev_alloc_replace(fptr_dev=a3, lbounds=lb(1:3), ubounds=ub(1:3), ierr=ierr, init_value=V3) ; call check(ierr==0, 'a3 replace')
   call dev_alloc_replace(fptr_dev=a4, lbounds=lb(1:4), ubounds=ub(1:4), ierr=ierr, init_value=V3) ; call check(ierr==0, 'a4 replace')
   call dev_alloc_replace(fptr_dev=a5, lbounds=lb(1:5), ubounds=ub(1:5), ierr=ierr, init_value=V3) ; call check(ierr==0, 'a5 replace')
   call dev_alloc_replace(fptr_dev=a6, lbounds=lb(1:6), ubounds=ub(1:6), ierr=ierr, init_value=V3) ; call check(ierr==0, 'a6 replace')
   call dev_alloc_replace(fptr_dev=a7, lbounds=lb(1:7), ubounds=ub(1:7), ierr=ierr, init_value=V3) ; call check(ierr==0, 'a7 replace')
   call check(all(lbound(a1)==lb(1:1)).and.all(ubound(a1)==ub(1:1)), 'a1 bounds')
   call check(all(lbound(a2)==lb(1:2)).and.all(ubound(a2)==ub(1:2)), 'a2 bounds')
   call check(all(lbound(a3)==lb(1:3)).and.all(ubound(a3)==ub(1:3)), 'a3 bounds')
   call check(all(lbound(a4)==lb(1:4)).and.all(ubound(a4)==ub(1:4)), 'a4 bounds')
   call check(all(lbound(a5)==lb(1:5)).and.all(ubound(a5)==ub(1:5)), 'a5 bounds')
   call check(all(lbound(a6)==lb(1:6)).and.all(ubound(a6)==ub(1:6)), 'a6 bounds')
   call check(all(lbound(a7)==lb(1:7)).and.all(ubound(a7)==ub(1:7)), 'a7 bounds')
   call dev_memcpy_from_device(src=a1, dst=h1) ; call check(all(h1==V3), 'a1 value')
   call dev_memcpy_from_device(src=a2, dst=h2) ; call check(all(h2==V3), 'a2 value')
   call dev_memcpy_from_device(src=a3, dst=h3) ; call check(all(h3==V3), 'a3 value')
   call dev_memcpy_from_device(src=a4, dst=h4) ; call check(all(h4==V3), 'a4 value')
   call dev_memcpy_from_device(src=a5, dst=h5) ; call check(all(h5==V3), 'a5 value')
   call dev_memcpy_from_device(src=a6, dst=h6) ; call check(all(h6==V3), 'a6 value')
   call dev_memcpy_from_device(src=a7, dst=h7) ; call check(all(h7==V3), 'a7 value')
   call dev_get_alloc_stats(allocs=allocs, bytes=bytes)
   bytes_expected = (3_I8P + 9_I8P + 27_I8P + 81_I8P + 243_I8P + 729_I8P + 2187_I8P) * (storage_size(mold, kind=I8P) / 8_I8P)
   call check(allocs - allocs0 == 7_I8P,          'live allocations after replace, same bounds')
   call check(bytes  - bytes0  == bytes_expected, 'live bytes after replace, same bounds')

   print '(A)', '    dev_free twice (second call must be a no-op)'
   call dev_free(a1) ; call dev_free(a1) ; call check(.not.associated(a1), 'a1 nullified')
   call dev_free(a2) ; call dev_free(a2) ; call check(.not.associated(a2), 'a2 nullified')
   call dev_free(a3) ; call dev_free(a3) ; call check(.not.associated(a3), 'a3 nullified')
   call dev_free(a4) ; call dev_free(a4) ; call check(.not.associated(a4), 'a4 nullified')
   call dev_free(a5) ; call dev_free(a5) ; call check(.not.associated(a5), 'a5 nullified')
   call dev_free(a6) ; call dev_free(a6) ; call check(.not.associated(a6), 'a6 nullified')
   call dev_free(a7) ; call dev_free(a7) ; call check(.not.associated(a7), 'a7 nullified')
   call dev_get_alloc_stats(allocs=allocs, bytes=bytes)
   call check(allocs == allocs0, 'live allocations after free')
   call check(bytes  == bytes0,  'live bytes after free')
   endsubroutine TEST_KKP
