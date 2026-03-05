   subroutine TRANSPOSE_ARRAY_KKP_2D(bb, a, t)
   !< Transpose array (kind KKP, rank 2).
   integer(I4P), intent(in)               :: bb(2,2)              !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   VARTYPE(KKP), intent(in)               :: a(bb(1,1):,bb(1,2):) !< Input array.
   VARTYPE(KKP), intent(out), allocatable :: t(:,:)               !< Transposed array.
   integer(I4P)                           :: i1,i2                !< Counter.

   allocate(t(bb(1,2):bb(2,2),bb(1,1):bb(2,1)))
   do i2=bb(1,2), bb(2,2) ; do i1=bb(1,1), bb(2,1)
      t(i2,i1) = a(i1,i2)
   enddo ; enddo
   endsubroutine TRANSPOSE_ARRAY_KKP_2D 

   subroutine TRANSPOSE_ARRAY_KKP_3D(bb, ij, a, t)
   !< Transpose array (kind KKP, rank 3), swapping index positions ij(1) and ij(2).
   integer(I4P), intent(in)               :: bb(2,3)                         !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)               :: ij(2)                           !< 1-based index pair to swap.
   VARTYPE(KKP), intent(in)               :: a(bb(1,1):,bb(1,2):,bb(1,3):)  !< Input array.
   VARTYPE(KKP), intent(out), allocatable :: t(:,:,:)                        !< Transposed array.
   integer(I4P)                           :: i1,i2,i3                        !< Counters.
   integer(I4P)                           :: tb(2,3)                         !< Bounds of transposed array.
   integer(I4P)                           :: p, q                            !< Canonicalized swap pair (p<q).

   p = min(ij(1), ij(2))
   q = max(ij(1), ij(2))
   tb = bb
   tb(:,p) = bb(:,q)
   tb(:,q) = bb(:,p)
   allocate(t(tb(1,1):tb(2,1), tb(1,2):tb(2,2), tb(1,3):tb(2,3)))

   select case(p*10 + q)
   case(12)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i2,i1,i3) = a(i1,i2,i3)
      enddo ; enddo ; enddo
   case(13)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i3,i2,i1) = a(i1,i2,i3)
      enddo ; enddo ; enddo
   case(23)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i3,i2) = a(i1,i2,i3)
      enddo ; enddo ; enddo
   endselect
   endsubroutine TRANSPOSE_ARRAY_KKP_3D

   subroutine TRANSPOSE_ARRAY_KKP_4D(bb, ij, a, t)
   !< Transpose array (kind KKP, rank 4), swapping index positions ij(1) and ij(2).
   integer(I4P), intent(in)               :: bb(2,4)                                  !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)               :: ij(2)                                    !< 1-based index pair to swap.
   VARTYPE(KKP), intent(in)               :: a(bb(1,1):,bb(1,2):,bb(1,3):,bb(1,4):)  !< Input array.
   VARTYPE(KKP), intent(out), allocatable :: t(:,:,:,:)                               !< Transposed array.
   integer(I4P)                           :: i1,i2,i3,i4                              !< Counters.
   integer(I4P)                           :: tb(2,4)                                  !< Bounds of transposed array.
   integer(I4P)                           :: p, q                                     !< Canonicalized swap pair (p<q).

   p = min(ij(1), ij(2))
   q = max(ij(1), ij(2))
   tb = bb
   tb(:,p) = bb(:,q)
   tb(:,q) = bb(:,p)
   allocate(t(tb(1,1):tb(2,1), tb(1,2):tb(2,2), tb(1,3):tb(2,3), tb(1,4):tb(2,4)))

   select case(p*10 + q)
   case(12)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i2,i1,i3,i4) = a(i1,i2,i3,i4)
      enddo ; enddo ; enddo ; enddo
   case(13)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i3,i2,i1,i4) = a(i1,i2,i3,i4)
      enddo ; enddo ; enddo ; enddo
   case(14)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i4,i2,i3,i1) = a(i1,i2,i3,i4)
      enddo ; enddo ; enddo ; enddo
   case(23)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i3,i2,i4) = a(i1,i2,i3,i4)
      enddo ; enddo ; enddo ; enddo
   case(24)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i4,i3,i2) = a(i1,i2,i3,i4)
      enddo ; enddo ; enddo ; enddo
   case(34)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i4,i3) = a(i1,i2,i3,i4)
      enddo ; enddo ; enddo ; enddo
   endselect
   endsubroutine TRANSPOSE_ARRAY_KKP_4D

   subroutine TRANSPOSE_ARRAY_KKP_5D(bb, ij, a, t)
   !< Transpose array (kind KKP, rank 5), swapping index positions ij(1) and ij(2).
   integer(I4P), intent(in)               :: bb(2,5)                                           !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)               :: ij(2)                                             !< 1-based index pair to swap.
   VARTYPE(KKP), intent(in)               :: a(bb(1,1):,bb(1,2):,bb(1,3):,bb(1,4):,bb(1,5):)  !< Input array.
   VARTYPE(KKP), intent(out), allocatable :: t(:,:,:,:,:)                                      !< Transposed array.
   integer(I4P)                           :: i1,i2,i3,i4,i5                                    !< Counters.
   integer(I4P)                           :: tb(2,5)                                           !< Bounds of transposed array.
   integer(I4P)                           :: p, q                                              !< Canonicalized swap pair (p<q).

   p = min(ij(1), ij(2))
   q = max(ij(1), ij(2))
   tb = bb
   tb(:,p) = bb(:,q)
   tb(:,q) = bb(:,p)
   allocate(t(tb(1,1):tb(2,1), tb(1,2):tb(2,2), tb(1,3):tb(2,3), &
              tb(1,4):tb(2,4), tb(1,5):tb(2,5)))

   select case(p*10 + q)
   case(12)
      do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3)
      do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i2,i1,i3,i4,i5) = a(i1,i2,i3,i4,i5)
      enddo ; enddo ; enddo ; enddo ; enddo
   case(13)
      do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3)
      do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i3,i2,i1,i4,i5) = a(i1,i2,i3,i4,i5)
      enddo ; enddo ; enddo ; enddo ; enddo
   case(14)
      do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3)
      do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i4,i2,i3,i1,i5) = a(i1,i2,i3,i4,i5)
      enddo ; enddo ; enddo ; enddo ; enddo
   case(15)
      do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3)
      do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i5,i2,i3,i4,i1) = a(i1,i2,i3,i4,i5)
      enddo ; enddo ; enddo ; enddo ; enddo
   case(23)
      do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3)
      do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i3,i2,i4,i5) = a(i1,i2,i3,i4,i5)
      enddo ; enddo ; enddo ; enddo ; enddo
   case(24)
      do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3)
      do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i4,i3,i2,i5) = a(i1,i2,i3,i4,i5)
      enddo ; enddo ; enddo ; enddo ; enddo
   case(25)
      do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3)
      do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i5,i3,i4,i2) = a(i1,i2,i3,i4,i5)
      enddo ; enddo ; enddo ; enddo ; enddo
   case(34)
      do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3)
      do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i4,i3,i5) = a(i1,i2,i3,i4,i5)
      enddo ; enddo ; enddo ; enddo ; enddo
   case(35)
      do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3)
      do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i5,i4,i3) = a(i1,i2,i3,i4,i5)
      enddo ; enddo ; enddo ; enddo ; enddo
   case(45)
      do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3)
      do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i3,i5,i4) = a(i1,i2,i3,i4,i5)
      enddo ; enddo ; enddo ; enddo ; enddo
   endselect
   endsubroutine TRANSPOSE_ARRAY_KKP_5D

   subroutine TRANSPOSE_ARRAY_KKP_6D(bb, ij, a, t)
   !< Transpose array (kind KKP, rank 6), swapping index positions ij(1) and ij(2).
   integer(I4P), intent(in)               :: bb(2,6)                                                      !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)               :: ij(2)                                                        !< 1-based index pair to swap.
   VARTYPE(KKP), intent(in)               :: a(bb(1,1):,bb(1,2):,bb(1,3):,bb(1,4):,bb(1,5):,bb(1,6):)   !< Input array.
   VARTYPE(KKP), intent(out), allocatable :: t(:,:,:,:,:,:)                                               !< Transposed array.
   integer(I4P)                           :: i1,i2,i3,i4,i5,i6                                           !< Counters.
   integer(I4P)                           :: tb(2,6)                                                      !< Bounds of transposed array.
   integer(I4P)                           :: p, q                                                         !< Canonicalized swap pair (p<q).

   p = min(ij(1), ij(2))
   q = max(ij(1), ij(2))
   tb = bb
   tb(:,p) = bb(:,q)
   tb(:,q) = bb(:,p)
   allocate(t(tb(1,1):tb(2,1), tb(1,2):tb(2,2), tb(1,3):tb(2,3), &
              tb(1,4):tb(2,4), tb(1,5):tb(2,5), tb(1,6):tb(2,6)))

   select case(p*10 + q)
   case(12)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i2,i1,i3,i4,i5,i6) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(13)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i3,i2,i1,i4,i5,i6) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(14)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i4,i2,i3,i1,i5,i6) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(15)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i5,i2,i3,i4,i1,i6) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(16)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i6,i2,i3,i4,i5,i1) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(23)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i3,i2,i4,i5,i6) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(24)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i4,i3,i2,i5,i6) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(25)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i5,i3,i4,i2,i6) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(26)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i6,i3,i4,i5,i2) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(34)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i4,i3,i5,i6) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(35)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i5,i4,i3,i6) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(36)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i6,i4,i5,i3) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(45)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i3,i5,i4,i6) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(46)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i3,i6,i5,i4) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(56)
      do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5) ; do i4=bb(1,4),bb(2,4)
      do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i3,i4,i6,i5) = a(i1,i2,i3,i4,i5,i6)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   endselect
   endsubroutine TRANSPOSE_ARRAY_KKP_6D

   subroutine TRANSPOSE_ARRAY_KKP_7D(bb, ij, a, t)
   !< Transpose array (kind KKP, rank 7), swapping index positions ij(1) and ij(2).
   integer(I4P), intent(in)               :: bb(2,7)                                                               !< Bounds: bb(1,:)=lower, bb(2,:)=upper.
   integer(I4P), intent(in)               :: ij(2)                                                                 !< 1-based index pair to swap.
   VARTYPE(KKP), intent(in)               :: a(bb(1,1):,bb(1,2):,bb(1,3):,bb(1,4):,bb(1,5):,bb(1,6):,bb(1,7):)  !< Input array.
   VARTYPE(KKP), intent(out), allocatable :: t(:,:,:,:,:,:,:)                                                      !< Transposed array.
   integer(I4P)                           :: i1,i2,i3,i4,i5,i6,i7                                                 !< Counters.
   integer(I4P)                           :: tb(2,7)                                                               !< Bounds of transposed array.
   integer(I4P)                           :: p, q                                                                  !< Canonicalized swap pair (p<q).

   p = min(ij(1), ij(2))
   q = max(ij(1), ij(2))
   tb = bb
   tb(:,p) = bb(:,q)
   tb(:,q) = bb(:,p)
   allocate(t(tb(1,1):tb(2,1), tb(1,2):tb(2,2), tb(1,3):tb(2,3), tb(1,4):tb(2,4), &
              tb(1,5):tb(2,5), tb(1,6):tb(2,6), tb(1,7):tb(2,7)))

   select case(p*10 + q)
   case(12)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i2,i1,i3,i4,i5,i6,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(13)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i3,i2,i1,i4,i5,i6,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(14)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i4,i2,i3,i1,i5,i6,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(15)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i5,i2,i3,i4,i1,i6,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(16)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i6,i2,i3,i4,i5,i1,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(17)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i7,i2,i3,i4,i5,i6,i1) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(23)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i3,i2,i4,i5,i6,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(24)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i4,i3,i2,i5,i6,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(25)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i5,i3,i4,i2,i6,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(26)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i6,i3,i4,i5,i2,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(27)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i7,i3,i4,i5,i6,i2) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(34)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i4,i3,i5,i6,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(35)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i5,i4,i3,i6,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(36)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i6,i4,i5,i3,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(37)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i7,i4,i5,i6,i3) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(45)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i3,i5,i4,i6,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(46)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i3,i6,i5,i4,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(47)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i3,i7,i5,i6,i4) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(56)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i3,i4,i6,i5,i7) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(57)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i3,i4,i7,i6,i5) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   case(67)
      do i7=bb(1,7),bb(2,7) ; do i6=bb(1,6),bb(2,6) ; do i5=bb(1,5),bb(2,5)
      do i4=bb(1,4),bb(2,4) ; do i3=bb(1,3),bb(2,3) ; do i2=bb(1,2),bb(2,2) ; do i1=bb(1,1),bb(2,1)
         t(i1,i2,i3,i4,i5,i7,i6) = a(i1,i2,i3,i4,i5,i6,i7)
      enddo ; enddo ; enddo ; enddo ; enddo ; enddo ; enddo
   endselect
   endsubroutine TRANSPOSE_ARRAY_KKP_7D
