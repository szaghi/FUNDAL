   subroutine transpose_array_KKP_2D(b1, b2, a, t)
   !< Transpose array (kind KKP, rank 2).
   integer(I4P), intent(in)               :: b1(2), b2(2)     !< Array dimensions bounds.
   VARTYPE(KKP), intent(in)               :: a(b1(1):,b2(1):) !< Input array.
   VARTYPE(KKP), intent(out), allocatable :: t(:,:)           !< Transposed array.
   integer(I4P)                           :: i1,i2            !< Counter.

   allocate(t(b2(1):b2(2),b1(1):b1(2)))
   do i2=b2(1), b2(2)
   do i1=b1(1), b1(2)
      t(i2,i1) = a(i1,i2)
   enddo
   enddo
   endsubroutine transpose_array_KKP_2D

   subroutine transpose_array_KKP_3D(b1, b2, b3, a, t)
   !< Transpose array (kind KKP, rank 3).
   integer(I4P), intent(in)               :: b1(2), b2(2), b3(2)     !< Array dimensions bounds.
   VARTYPE(KKP), intent(in)               :: a(b1(1):,b2(1):,b3(1):) !< Input array.
   VARTYPE(KKP), intent(out), allocatable :: t(:,:,:)                !< Transposed array.
   integer(I4P)                           :: i1,i2,i3                !< Counter.

   allocate(t(b3(1):b3(2),b2(1):b2(2),b1(1):b1(2)))
   do i3=b3(1), b3(2)
   do i2=b2(1), b2(2)
   do i1=b1(1), b1(2)
      t(i3,i2,i1) = a(i1,i2,i3)
   enddo
   enddo
   enddo
   endsubroutine transpose_array_KKP_3D

   subroutine transpose_array_KKP_4D(b1, b2, b3, b4, a, t)
   !< Transpose array (kind KKP, rank 4).
   integer(I4P), intent(in)               :: b1(2), b2(2), b3(2), b4(2)     !< Array dimensions bounds.
   VARTYPE(KKP), intent(in)               :: a(b1(1):,b2(1):,b3(1):,b4(1):) !< Input array.
   VARTYPE(KKP), intent(out), allocatable :: t(:,:,:,:)                     !< Transposed array.
   integer(I4P)                           :: i1,i2,i3,i4                    !< Counter.

   allocate(t(b4(1):b4(2),b2(1):b2(2),b3(1):b3(2),b1(1):b1(2)))
   do i4=b4(1), b4(2)
   do i3=b3(1), b3(2)
   do i2=b2(1), b2(2)
   do i1=b1(1), b1(2)
      t(i4,i2,i3,i1) = a(i1,i2,i3,i4)
   enddo
   enddo
   enddo
   enddo
   endsubroutine transpose_array_KKP_4D

   subroutine transpose_array_KKP_5D(b1, b2, b3, b4, b5, a, t)
   !< Transpose array (kind KKP, rank 5).
   integer(I4P), intent(in)               :: b1(2), b2(2), b3(2), b4(2), b5(2)     !< Array dimensions bounds.
   VARTYPE(KKP), intent(in)               :: a(b1(1):,b2(1):,b3(1):,b4(1):,b5(1):) !< Input array.
   VARTYPE(KKP), intent(out), allocatable :: t(:,:,:,:,:)                          !< Transposed array.
   integer(I4P)                           :: i1,i2,i3,i4,i5                        !< Counter.

   allocate(t(b5(1):b5(2),b2(1):b2(2),b3(1):b3(2),b4(1):b4(2),b1(1):b1(2)))
   do i5=b5(1), b5(2)
   do i4=b4(1), b4(2)
   do i3=b3(1), b3(2)
   do i2=b2(1), b2(2)
   do i1=b1(1), b1(2)
      t(i5,i2,i3,i4,i1) = a(i1,i2,i3,i4,i5)
   enddo
   enddo
   enddo
   enddo
   enddo
   endsubroutine transpose_array_KKP_5D

   subroutine transpose_array_KKP_6D(b1, b2, b3, b4, b5, b6, a, t)
   !< Transpose array (kind KKP, rank 6).
   integer(I4P), intent(in)               :: b1(2), b2(2), b3(2), b4(2), b5(2), b6(2)     !< Array dimensions bounds.
   VARTYPE(KKP), intent(in)               :: a(b1(1):,b2(1):,b3(1):,b4(1):,b5(1):,b6(1):) !< Input array.
   VARTYPE(KKP), intent(out), allocatable :: t(:,:,:,:,:,:)                               !< Transposed array.
   integer(I4P)                           :: i1,i2,i3,i4,i5,i6                            !< Counter.

   allocate(t(b6(1):b6(2),b2(1):b2(2),b3(1):b3(2),b4(1):b4(2),b5(1):b5(2),b1(1):b1(2)))
   do i6=b6(1), b6(2)
   do i5=b5(1), b5(2)
   do i4=b4(1), b4(2)
   do i3=b3(1), b3(2)
   do i2=b2(1), b2(2)
   do i1=b1(1), b1(2)
      t(i6,i2,i3,i4,i5,i1) = a(i1,i2,i3,i4,i5,i6)
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   endsubroutine transpose_array_KKP_6D

   subroutine transpose_array_KKP_7D(b1, b2, b3, b4, b5, b6, b7, a, t)
   !< Transpose array (kind KKP, rank 7).
   integer(I4P), intent(in)               :: b1(2), b2(2), b3(2), b4(2), b5(2), b6(2), b7(2)     !< Array dimensions bounds.
   VARTYPE(KKP), intent(in)               :: a(b1(1):,b2(1):,b3(1):,b4(1):,b5(1):,b6(1):,b7(1):) !< Input array.
   VARTYPE(KKP), intent(out), allocatable :: t(:,:,:,:,:,:,:)                                    !< Transposed array.
   integer(I4P)                           :: i1,i2,i3,i4,i5,i6,i7                                !< Counter.

   allocate(t(b7(1):b7(2),b2(1):b2(2),b3(1):b3(2),b4(1):b4(2),b5(1):b5(2),b6(1):b6(2),b1(1):b1(2)))
   do i7=b7(1), b7(2)
   do i6=b6(1), b6(2)
   do i5=b5(1), b5(2)
   do i4=b4(1), b4(2)
   do i3=b3(1), b3(2)
   do i2=b2(1), b2(2)
   do i1=b1(1), b1(2)
      t(i7,i2,i3,i4,i5,i6,i1) = a(i1,i2,i3,i4,i5,i6,i7)
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   enddo
   endsubroutine transpose_array_KKP_7D
