module gpu_utils

  use, intrinsic :: iso_fortran_env
  use, intrinsic :: iso_c_binding
  use omp_lib, only : omp_target_alloc, omp_target_free, omp_target_is_present, omp_target_memcpy, omp_get_default_device

  implicit none
  private
  integer, parameter:: R8P  = REAL64
  integer, parameter:: R4P  = REAL32
  integer, parameter:: I8P  = INT64
  integer, parameter:: I4P  = INT32
  integer, parameter:: I1P  = INT8
  public :: omp_target_alloc_f, omp_target_free_f, omp_target_memcpy_f
  integer(kind=I4P),public ::  local_comm,mydev,myhos

  interface omp_target_alloc_f
    module procedure omp_target_alloc_R8P_1D, &
                     omp_target_alloc_R8P_2D, &
                     omp_target_alloc_R8P_3D, &
                     omp_target_alloc_R8P_4D, &
                     omp_target_alloc_R8P_5D, &
                     omp_target_alloc_R8P_6D, &
                     omp_target_alloc_I4P_1D, &
                     omp_target_alloc_I4P_2D, &
                     omp_target_alloc_I4P_5D, &
                     omp_target_alloc_I8P_1D, &
                     omp_target_alloc_I8P_2D, &
                     omp_target_alloc_I8P_3D
  endinterface omp_target_alloc_f

  interface omp_target_free_f
    module procedure omp_target_free_R8P_1D, &
                     omp_target_free_R8P_2D, &
                     omp_target_free_R8P_3D, &
                     omp_target_free_R8P_4D, &
                     omp_target_free_R8P_5D, &
                     omp_target_free_R8P_6D, &
                     omp_target_free_I4P_1D, &
                     omp_target_free_I4P_2D, &
                     omp_target_free_I4P_5D, &
                     omp_target_free_I8P_1D, &
                     omp_target_free_I8P_2D, &
                     omp_target_free_I8P_3D
  endinterface omp_target_free_f

  interface omp_target_memcpy_f
    module procedure omp_target_memcpy_R8P, &
                     omp_target_memcpy_I4P, &
                     omp_target_memcpy_I8P
  endinterface omp_target_memcpy_f

  interface byte_size
     module procedure byte_size_r8,byte_size_r4, &
                      byte_size_i8,byte_size_i4
  end interface byte_size

contains

  function byte_size_i8(i) result (bs)
     integer(kind=I8P), intent(in) :: i
     integer(kind=I1P)             :: bs
     integer(kind=I1P)             :: mold(1)
     bs = size(transfer(i, mold), dim=1, kind=I1P)
  end function byte_size_i8
  function byte_size_i4(i) result (bs)
     integer(kind=I4P), intent(in) :: i
     integer(kind=I1P)             :: bs
     integer(kind=I1P)             :: mold(1)
     bs = size(transfer(i, mold), dim=1, kind=I1P)
  end function byte_size_i4

  function byte_size_r8(i) result (bs)
     real(kind=R8P), intent(in) :: i
     integer(kind=I1P)          :: bs
     integer(kind=I1P)          :: mold(1)
     bs = size(transfer(i, mold), dim=1, kind=I1P)
  end function byte_size_r8

  function byte_size_r4(i) result (bs)
     real(kind=R4P), intent(in) :: i
     integer(kind=I1P)          :: bs
     integer(kind=I1P)          :: mold(1)
     bs = size(transfer(i, mold), dim=1, kind=I1P)
  end function byte_size_r4

  subroutine omp_target_alloc_R8P_1D(fptr_dev, ubounds, omp_dev, ierr, lbounds, init_value)
    real(R8P), pointer, intent(out) :: fptr_dev(:)
    integer(I4P), intent(in) :: ubounds(1)
    integer(I4P), intent(in), optional :: omp_dev
    integer(I4P), intent(in), optional :: lbounds(1)
    real(R8P),    intent(in), optional :: init_value
    integer(I4P), intent(out) :: ierr
    real(R8P), pointer :: fptr(:)
    type(c_ptr) :: cptr_dev
    integer(I4P) :: lbounds_(1)
    integer(I8P) :: sizes
    integer(I4P) :: i
    real(R8P)    :: init_value_
!
    lbounds_ = 1
    if (present(lbounds)) lbounds_ = lbounds
    sizes = ubounds(1) - lbounds_(1) + 1
    cptr_dev = omp_target_alloc(int(sizes * byte_size(1._R8P), c_size_t), int(omp_dev, c_int))
    if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=[sizes])
      fptr_dev(lbounds_(1):) => fptr
      ierr = 0
      if (present(init_value)) then
         init_value_ = init_value
         !$omp target teams distribute parallel do has_device_addr(fptr_dev)
         do i=lbounds_(1), ubounds(1)
            fptr_dev(i) = init_value_
         enddo
      endif
    else
      fptr_dev => null()
      ierr = 1000
    endif
!
  endsubroutine omp_target_alloc_R8P_1D

  subroutine omp_target_alloc_R8P_2D(fptr_dev, ubounds, omp_dev, ierr, lbounds, init_value)
    real(R8P), pointer, intent(out) :: fptr_dev(:,:)
    integer(I4P), intent(in) :: ubounds(2)
    integer(I4P), intent(in), optional :: omp_dev
    integer(I4P), intent(in), optional :: lbounds(2)
    real(R8P),    intent(in), optional :: init_value
    integer(I4P), intent(out) :: ierr
    real(R8P), pointer :: fptr(:,:)
    type(c_ptr) :: cptr_dev
    integer(I4P) :: lbounds_(2)
    integer(I8P) :: sizes(2)
    integer(I4P) :: i, j
    real(R8P)    :: init_value_
!
    lbounds_ = 1
    if (present(lbounds)) lbounds_ = lbounds
    sizes = ubounds - lbounds_ + 1
    cptr_dev = omp_target_alloc(int(product(sizes) * byte_size(1._R8P), c_size_t), int(omp_dev, c_int))
    if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):, lbounds_(2):) => fptr
      ierr = 0
      if (present(init_value)) then
         init_value_ = init_value
         !$omp target teams distribute parallel do collapse(2) has_device_addr(fptr_dev)
         do j=lbounds_(2), ubounds(2)
            do i=lbounds_(1), ubounds(1)
               fptr_dev(i,j) = init_value_
            enddo
         enddo
      endif
    else
      fptr_dev => null()
      ierr = 1000
    endif
!
  endsubroutine omp_target_alloc_R8P_2D

    subroutine omp_target_alloc_R8P_3D(fptr_dev, ubounds, omp_dev, ierr, lbounds, init_value)
    real(R8P), pointer, intent(out) :: fptr_dev(:,:,:)
    integer(I4P), intent(in) :: ubounds(3)
    integer(I4P), intent(in), optional :: omp_dev
    integer(I4P), intent(in), optional :: lbounds(3)
    real(R8P),    intent(in), optional :: init_value
    integer(I4P), intent(out) :: ierr
    real(R8P), pointer :: fptr(:,:,:)
    type(c_ptr) :: cptr_dev
    integer(I4P) :: lbounds_(3)
    integer(I8P) :: sizes(3)
    integer(I4P) :: i, j, k
    real(R8P)    :: init_value_
!
    lbounds_ = 1
    if (present(lbounds)) lbounds_ = lbounds
    sizes = ubounds - lbounds_ + 1
    cptr_dev = omp_target_alloc(int(product(sizes) * byte_size(1._R8P), c_size_t), int(omp_dev, c_int))
    if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):, lbounds_(2):, lbounds_(3):) => fptr
      ierr = 0
      if (present(init_value)) then
         init_value_ = init_value
         !$omp target teams distribute parallel do collapse(3) has_device_addr(fptr_dev)
         do k=lbounds_(3), ubounds(3)
            do j=lbounds_(2), ubounds(2)
               do i=lbounds_(1), ubounds(1)
                  fptr_dev(i,j,k) = init_value_
               enddo
            enddo
         enddo
      endif
    else
      fptr_dev => null()
      ierr = 1000
    endif
!
  endsubroutine omp_target_alloc_R8P_3D

  subroutine omp_target_alloc_R8P_4D(fptr_dev, ubounds, omp_dev, ierr, lbounds, init_value)
    real(R8P), pointer, intent(out) :: fptr_dev(:,:,:,:)
    integer(I4P), intent(in) :: ubounds(4)
    integer(I4P), intent(in), optional :: omp_dev
    integer(I4P), intent(in), optional :: lbounds(4)
    real(R8P),    intent(in), optional :: init_value
    integer(I4P), intent(out) :: ierr
    real(R8P), pointer :: fptr(:,:,:,:)
    type(c_ptr) :: cptr_dev
    integer(I4P) :: lbounds_(4)
    integer(I8P) :: sizes(4)
    integer(I4P) :: i, j, k, l
    real(R8P)    :: init_value_
!
    lbounds_ = 1
    if (present(lbounds)) lbounds_ = lbounds
    sizes = ubounds - lbounds_ + 1
    cptr_dev = omp_target_alloc(int(product(sizes) * byte_size(1._R8P), c_size_t), int(omp_dev, c_int))
    if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):, lbounds_(2):, lbounds_(3):, lbounds_(4):) => fptr
      ierr = 0
      if (present(init_value)) then
         init_value_ = init_value
         !$omp target teams distribute parallel do collapse(4) has_device_addr(fptr_dev)
         do l=lbounds_(4), ubounds(4)
            do k=lbounds_(3), ubounds(3)
               do j=lbounds_(2), ubounds(2)
                  do i=lbounds_(1), ubounds(1)
                     fptr_dev(i,j,k,l) = init_value_
                  enddo
               enddo
            enddo
         enddo
      endif
    else
      fptr_dev => null()
      ierr = 1000
    endif
!
  endsubroutine omp_target_alloc_R8P_4D

  subroutine omp_target_alloc_R8P_5D(fptr_dev, ubounds, omp_dev, ierr, lbounds, init_value)
    real(R8P), pointer, intent(out) :: fptr_dev(:,:,:,:,:)
    integer(I4P), intent(in) :: ubounds(5)
    integer(I4P), intent(in), optional :: omp_dev
    integer(I4P), intent(in), optional :: lbounds(5)
    real(R8P),    intent(in), optional :: init_value
    integer(I4P), intent(out) :: ierr
    real(R8P), pointer :: fptr(:,:,:,:,:)
    type(c_ptr) :: cptr_dev
    integer(I4P) :: lbounds_(5)
    integer(I8P) :: sizes(5)
    integer(I4P) :: i, j, k, l, m
    real(R8P)    :: init_value_
!
    lbounds_ = 1
    if (present(lbounds)) lbounds_ = lbounds
    sizes = ubounds - lbounds_ + 1
    cptr_dev = omp_target_alloc(int(product(sizes) * byte_size(1._R8P), c_size_t), int(omp_dev, c_int))
    if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):, lbounds_(2):, lbounds_(3):, lbounds_(4):, lbounds_(5):) => fptr
      ierr = 0
      if (present(init_value)) then
         init_value_ = init_value
         !$omp target teams distribute parallel do collapse(5) has_device_addr(fptr_dev)
         do m=lbounds_(5), ubounds(5)
            do l=lbounds_(4), ubounds(4)
               do k=lbounds_(3), ubounds(3)
                  do j=lbounds_(2), ubounds(2)
                     do i=lbounds_(1), ubounds(1)
                        fptr_dev(i,j,k,l,m) = init_value_
                     enddo
                  enddo
               enddo
            enddo
         enddo
      endif
    else
      fptr_dev => null()
      ierr = 1000
    endif
!
  endsubroutine omp_target_alloc_R8P_5D

  subroutine omp_target_alloc_R8P_6D(fptr_dev, ubounds, omp_dev, ierr, lbounds, init_value)
    real(R8P), pointer, intent(out) :: fptr_dev(:,:,:,:,:,:)
    integer(I4P), intent(in) :: ubounds(6)
    integer(I4P), intent(in) :: omp_dev
    integer(I4P), intent(in), optional :: lbounds(6)
    real(R8P), intent(in), optional :: init_value
    integer(I4P), intent(out) :: ierr
    real(R8P), pointer :: fptr(:,:,:,:,:,:)
    type(c_ptr) :: cptr_dev
    integer(I4P) :: lbounds_(6)
    integer(I8P) :: sizes(6)
    integer(I4P) :: i, j, k, l, m, n
    real(R8P) :: init_value_
!
    lbounds_ = 1
    if (present(lbounds)) lbounds_ = lbounds
    sizes = ubounds - lbounds_ + 1
    cptr_dev = omp_target_alloc(int(product(sizes) * byte_size(1_I4P), c_size_t), int(omp_dev, c_int))
    if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=[sizes])
      fptr_dev(lbounds_(1):, lbounds_(2):, lbounds_(3):, lbounds_(4):, lbounds_(5):, lbounds_(6):) => fptr
      ierr = 0
      if (present(init_value)) then
         init_value_ = init_value
         !$omp target teams distribute parallel do collapse(6) has_device_addr(fptr_dev)
         do n=lbounds_(6), ubounds(6)
            do m=lbounds_(5), ubounds(5)
               do l=lbounds_(4), ubounds(4)
                  do k=lbounds_(3), ubounds(3)
                     do j=lbounds_(2), ubounds(2)
                        do i=lbounds_(1), ubounds(1)
                           fptr_dev(i,j,k,l,m,n) = init_value_
                        enddo
                     enddo
                  enddo
               enddo
            enddo
         enddo
      endif
    else
      fptr_dev => null()
      ierr = 1000
    endif
!
  endsubroutine omp_target_alloc_R8P_6D

  subroutine omp_target_alloc_I4P_1D(fptr_dev, ubounds, omp_dev, ierr, lbounds, init_value)
    integer(I4P), pointer, intent(out) :: fptr_dev(:)
    integer(I4P), intent(in) :: ubounds(1)
    integer(I4P), intent(in) :: omp_dev
    integer(I4P), intent(in), optional :: lbounds(1)
    integer(I4P), intent(in), optional :: init_value
    integer(I4P), intent(out) :: ierr
    integer(I4P), pointer :: fptr(:)
    type(c_ptr) :: cptr_dev
    integer(I4P) :: lbounds_(1)
    integer(I8P) :: sizes
    integer(I4P) :: i
    integer(I4P) :: init_value_
!
    lbounds_ = 1
    if (present(lbounds)) lbounds_ = lbounds
    sizes = ubounds(1) - lbounds_(1) + 1
    cptr_dev = omp_target_alloc(int(sizes * byte_size(1_I4P), c_size_t), int(omp_dev, c_int))
    if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=[sizes])
      fptr_dev(lbounds_(1):) => fptr
      ierr = 0
      if (present(init_value)) then
         init_value_ = init_value
         !$omp target teams distribute parallel do has_device_addr(fptr_dev)
         do i=lbounds_(1), ubounds(1)
            fptr_dev(i) = init_value_
         enddo
      endif
    else
      fptr_dev => null()
      ierr = 1000
    endif
!
  endsubroutine omp_target_alloc_I4P_1D

  subroutine omp_target_alloc_I4P_2D(fptr_dev, ubounds, omp_dev, ierr, lbounds, init_value)
    integer(I4P), pointer, intent(out) :: fptr_dev(:,:)
    integer(I4P), intent(in) :: ubounds(2)
    integer(I4P), intent(in) :: omp_dev
    integer(I4P), intent(in), optional :: lbounds(2)
    integer(I4P), intent(in), optional :: init_value
    integer(I4P), intent(out) :: ierr
    integer(I4P), pointer :: fptr(:,:)
    type(c_ptr) :: cptr_dev
    integer(I4P) :: lbounds_(2)
    integer(I8P) :: sizes(2)
    integer(I4P) :: i, j
    integer(I4P) :: init_value_
!
    lbounds_ = 1
    if (present(lbounds)) lbounds_ = lbounds
    sizes = ubounds - lbounds_ + 1
    cptr_dev = omp_target_alloc(int(product(sizes) * byte_size(1_I8P), c_size_t), int(omp_dev, c_int))
    if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):, lbounds_(2):) => fptr
      ierr = 0
      if (present(init_value)) then
         init_value_ = init_value
         !$omp target teams distribute parallel do collapse(2) has_device_addr(fptr_dev)
         do j=lbounds_(2), ubounds(2)
            do i=lbounds_(1), ubounds(1)
               fptr_dev(i,j) = init_value_
            enddo
         enddo
      endif
    else
      fptr_dev => null()
      ierr = 1000
    endif
!
  endsubroutine omp_target_alloc_I4P_2D

  subroutine omp_target_alloc_I4P_5D(fptr_dev, ubounds, omp_dev, ierr, lbounds, init_value)
    integer(I4P), pointer, intent(out) :: fptr_dev(:,:,:,:,:)
    integer(I4P), intent(in) :: ubounds(5)
    integer(I4P), intent(in) :: omp_dev
    integer(I4P), intent(in), optional :: lbounds(5)
    integer(I4P), intent(in), optional :: init_value
    integer(I4P), intent(out) :: ierr
    integer(I4P), pointer :: fptr(:,:,:,:,:)
    type(c_ptr) :: cptr_dev
    integer(I4P) :: lbounds_(5)
    integer(I8P) :: sizes(5)
    integer(I4P) :: i, j, k, l, m
    integer(I4P) :: init_value_
!
    lbounds_ = 1
    if (present(lbounds)) lbounds_ = lbounds
    sizes = ubounds - lbounds_ + 1
    cptr_dev = omp_target_alloc(int(product(sizes) * byte_size(1_I4P), c_size_t), int(omp_dev, c_int))
    if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=[sizes])
      fptr_dev(lbounds_(1):, lbounds_(2):, lbounds_(3):, lbounds_(4):, lbounds_(5):) => fptr
      ierr = 0
      if (present(init_value)) then
         init_value_ = init_value
         !$omp target teams distribute parallel do collapse(4) has_device_addr(fptr_dev)
         do m=lbounds_(5), ubounds(5)
            do l=lbounds_(4), ubounds(4)
               do k=lbounds_(3), ubounds(3)
                  do j=lbounds_(2), ubounds(2)
                     do i=lbounds_(1), ubounds(1)
                        fptr_dev(i,j,k,l,m) = init_value_
                     enddo
                  enddo
               enddo
            enddo
         enddo
      endif
    else
      fptr_dev => null()
      ierr = 1000
    endif
!
  endsubroutine omp_target_alloc_I4P_5D

  subroutine omp_target_alloc_I8P_1D(fptr_dev, ubounds, omp_dev, ierr, lbounds, init_value)
    integer(I8P), pointer, intent(out) :: fptr_dev(:)
    integer(I4P), intent(in) :: ubounds(1)
    integer(I4P), intent(in) :: omp_dev
    integer(I4P), intent(in), optional :: lbounds(1)
    integer(I8P), intent(in), optional :: init_value
    integer(I4P), intent(out) :: ierr
    integer(I8P), pointer :: fptr(:)
    type(c_ptr) :: cptr_dev
    integer(I4P) :: lbounds_(1)
    integer(I8P) :: sizes
    integer(I4P) :: i
    integer(I8P) :: init_value_
!
    lbounds_ = 1
    if (present(lbounds)) lbounds_ = lbounds
    sizes = ubounds(1) - lbounds_(1) + 1
    cptr_dev = omp_target_alloc(int(sizes * byte_size(1_I8P), c_size_t), int(omp_dev, c_int))
    if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=[sizes])
      fptr_dev(lbounds_(1):) => fptr
      ierr = 0
      if (present(init_value)) then
         init_value_ = init_value
         !$omp target teams distribute parallel do has_device_addr(fptr_dev)
         do i=lbounds_(1), ubounds(1)
            fptr_dev(i) = init_value_
         enddo
      endif
    else
      fptr_dev => null()
      ierr = 1000
    endif
!
  endsubroutine omp_target_alloc_I8P_1D

  subroutine omp_target_alloc_I8P_2D(fptr_dev, ubounds, omp_dev, ierr, lbounds, init_value)
    integer(I8P), pointer, intent(out) :: fptr_dev(:,:)
    integer(I4P), intent(in) :: ubounds(2)
    integer(I4P), intent(in) :: omp_dev
    integer(I4P), intent(in), optional :: lbounds(2)
    integer(I8P), intent(in), optional :: init_value
    integer(I4P), intent(out) :: ierr
    integer(I8P), pointer :: fptr(:,:)
    type(c_ptr) :: cptr_dev
    integer(I4P) :: lbounds_(2)
    integer(I8P) :: sizes(2)
    integer(I4P) :: i, j
    integer(I8P) :: init_value_
!
    lbounds_ = 1
    if (present(lbounds)) lbounds_ = lbounds
    sizes = ubounds(1) - lbounds_(1) + 1
    cptr_dev = omp_target_alloc(int(product(sizes) * byte_size(1_I8P), c_size_t), int(omp_dev, c_int))
    if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):, lbounds_(2):) => fptr
      ierr = 0
      if (present(init_value)) then
         init_value_ = init_value
         !$omp target teams distribute parallel do collapse(2) has_device_addr(fptr_dev)
         do j=lbounds_(2), ubounds(2)
            do i=lbounds_(1), ubounds(1)
               fptr_dev(i,j) = init_value_
            enddo
         enddo
      endif
    else
      fptr_dev => null()
      ierr = 1000
    endif
!
  endsubroutine omp_target_alloc_I8P_2D

  subroutine omp_target_alloc_I8P_3D(fptr_dev, ubounds, omp_dev, ierr, lbounds, init_value)
    integer(I8P), pointer, intent(out) :: fptr_dev(:,:,:)
    integer(I4P), intent(in) :: ubounds(3)
    integer(I4P), intent(in) :: omp_dev
    integer(I4P), intent(in), optional :: lbounds(3)
    integer(I8P), intent(in), optional :: init_value
    integer(I4P), intent(out) :: ierr
    integer(I8P), pointer :: fptr(:,:,:)
    type(c_ptr) :: cptr_dev
    integer(I4P) :: lbounds_(3)
    integer(I8P) :: sizes(3)
    integer(I4P) :: i, j, k
    integer(I8P) :: init_value_
!
    lbounds_ = 1
    if (present(lbounds)) lbounds_ = lbounds
    sizes = ubounds(1) - lbounds_(1) + 1
    cptr_dev = omp_target_alloc(int(product(sizes) * byte_size(1_I8P), c_size_t), int(omp_dev, c_int))
    if (c_associated(cptr_dev)) then
      call c_f_pointer(cptr_dev, fptr, shape=sizes)
      fptr_dev(lbounds_(1):, lbounds_(2):, lbounds_(3):) => fptr
      ierr = 0
      if (present(init_value)) then
         init_value_ = init_value
         !$omp target teams distribute parallel do collapse(2) has_device_addr(fptr_dev)
         do k=lbounds_(3), ubounds(3)
            do j=lbounds_(2), ubounds(2)
               do i=lbounds_(1), ubounds(1)
                  fptr_dev(i,j,k) = init_value_
               enddo
            enddo
         enddo
      endif
    else
      fptr_dev => null()
      ierr = 1000
    endif
!
  endsubroutine omp_target_alloc_I8P_3D

  subroutine omp_target_free_R8P_1D(fptr_dev, omp_dev)
    real(R8P), pointer, intent(out) :: fptr_dev(:)
    integer,            intent(in)  :: omp_dev

    call omp_target_free(c_loc(fptr_dev), int(omp_dev, c_int))

    nullify(fptr_dev)
  endsubroutine omp_target_free_R8P_1D

  subroutine omp_target_free_R8P_2D(fptr_dev, omp_dev)
    real(R8P), pointer, intent(out) :: fptr_dev(:,:)
    integer,            intent(in)  :: omp_dev

    call omp_target_free(c_loc(fptr_dev), int(omp_dev, c_int))

    nullify(fptr_dev)
  endsubroutine omp_target_free_R8P_2D

  subroutine omp_target_free_R8P_3D(fptr_dev, omp_dev)
    real(R8P), pointer, intent(out) :: fptr_dev(:,:,:)
    integer,            intent(in)  :: omp_dev

    call omp_target_free(c_loc(fptr_dev), int(omp_dev, c_int))

    nullify(fptr_dev)
  endsubroutine omp_target_free_R8P_3D

  subroutine omp_target_free_R8P_4D(fptr_dev, omp_dev)
    real(R8P), pointer, intent(out) :: fptr_dev(:,:,:,:)
    integer,            intent(in)  :: omp_dev

    call omp_target_free(c_loc(fptr_dev), int(omp_dev, c_int))

    nullify(fptr_dev)
  endsubroutine omp_target_free_R8P_4D

  subroutine omp_target_free_R8P_5D(fptr_dev, omp_dev)
    real(R8P), pointer, intent(out) :: fptr_dev(:,:,:,:,:)
    integer,            intent(in)  :: omp_dev

    call omp_target_free(c_loc(fptr_dev), int(omp_dev, c_int))

    nullify(fptr_dev)
  endsubroutine omp_target_free_R8P_5D

  subroutine omp_target_free_R8P_6D(fptr_dev, omp_dev)
    real(R8P), pointer, intent(out) :: fptr_dev(:,:,:,:,:,:)
    integer,            intent(in)  :: omp_dev

    call omp_target_free(c_loc(fptr_dev), int(omp_dev, c_int))

    nullify(fptr_dev)
  endsubroutine omp_target_free_R8P_6D

  subroutine omp_target_free_I4P_1D(fptr_dev, omp_dev)
    integer(I4P), pointer, intent(out) :: fptr_dev(:)
    integer(I4P),          intent(in)  :: omp_dev

    call omp_target_free(c_loc(fptr_dev), int(omp_dev, c_int))

    nullify(fptr_dev)
  endsubroutine omp_target_free_I4P_1D

  subroutine omp_target_free_I4P_2D(fptr_dev, omp_dev)
    integer(I4P), pointer, intent(out) :: fptr_dev(:,:)
    integer(I4P),          intent(in)  :: omp_dev

    call omp_target_free(c_loc(fptr_dev), int(omp_dev, c_int))

    nullify(fptr_dev)
  endsubroutine omp_target_free_I4P_2D

  subroutine omp_target_free_I4P_5D(fptr_dev, omp_dev)
    integer(I4P), pointer, intent(out) :: fptr_dev(:,:,:,:,:)
    integer(I4P),          intent(in)  :: omp_dev

    call omp_target_free(c_loc(fptr_dev), int(omp_dev, c_int))

    nullify(fptr_dev)
  endsubroutine omp_target_free_I4P_5D

  subroutine omp_target_free_I8P_1D(fptr_dev, omp_dev)
    integer(I8P), pointer, intent(out) :: fptr_dev(:)
    integer(I4P),          intent(in)  :: omp_dev

    call omp_target_free(c_loc(fptr_dev), int(omp_dev, c_int))

    nullify(fptr_dev)
  endsubroutine omp_target_free_I8P_1D

  subroutine omp_target_free_I8P_2D(fptr_dev, omp_dev)
    integer(I8P), pointer, intent(out) :: fptr_dev(:,:)
    integer(I4P),          intent(in)  :: omp_dev

    call omp_target_free(c_loc(fptr_dev), int(omp_dev, c_int))

    nullify(fptr_dev)
  endsubroutine omp_target_free_I8P_2D

  subroutine omp_target_free_I8P_3D(fptr_dev, omp_dev)
    integer(I8P), pointer, intent(out) :: fptr_dev(:,:,:)
    integer(I4P),          intent(in)  :: omp_dev

    call omp_target_free(c_loc(fptr_dev), int(omp_dev, c_int))

    nullify(fptr_dev)
  endsubroutine omp_target_free_I8P_3D

  function omp_target_memcpy_R8P(fptr_dst, fptr_src, dst_off, src_off, omp_dst_dev, omp_src_dev)
    integer(I4P) :: omp_target_memcpy_R8P
    real(R8P), target, intent(out) :: fptr_dst(..)
    real(R8P), target, intent(in)  :: fptr_src(..)
    integer(I4P), intent(in) :: omp_dst_dev, omp_src_dev
    integer(I4P), intent(in) :: dst_off, src_off
    integer(I8P) :: n_elements
    integer(c_size_t) :: total_dim

    n_elements = size(fptr_src,kind=I8P)

    total_dim = int(n_elements * byte_size(1._R8P), c_size_t)

    omp_target_memcpy_R8P = int(omp_target_memcpy(c_loc(fptr_dst), c_loc(fptr_src), total_dim, &
       int(dst_off, c_size_t), int(src_off, c_size_t), int(omp_dst_dev, c_int), int(omp_src_dev, c_int)), I4P)
  endfunction omp_target_memcpy_R8P

  function omp_target_memcpy_I4P(fptr_dst, fptr_src, dst_off, src_off, omp_dst_dev, omp_src_dev)
    integer(I4P) :: omp_target_memcpy_I4P
    integer(I4P), target, intent(out) :: fptr_dst(..)
    integer(I4P), target, intent(in)  :: fptr_src(..)
    integer(I4P), intent(in) :: omp_dst_dev, omp_src_dev
    integer(I4P), intent(in) :: dst_off, src_off
    integer(I8P) :: n_elements
    integer(c_size_t) :: total_dim

    n_elements = size(fptr_src,kind=I8P)

    total_dim = int(n_elements * byte_size(1_I4P), c_size_t)

    omp_target_memcpy_I4P = int(omp_target_memcpy(c_loc(fptr_dst), c_loc(fptr_src), total_dim, &
       int(dst_off, c_size_t), int(src_off, c_size_t), int(omp_dst_dev, c_int), int(omp_src_dev, c_int)), I4P)
  endfunction omp_target_memcpy_I4P

  function omp_target_memcpy_I8P(fptr_dst, fptr_src, dst_off, src_off, omp_dst_dev, omp_src_dev)
    integer(I4P) :: omp_target_memcpy_I8P
    integer(I8P), target, intent(out) :: fptr_dst(..)
    integer(I8P), target, intent(in)  :: fptr_src(..)
    integer(I4P), intent(in) :: omp_dst_dev, omp_src_dev
    integer(I4P), intent(in) :: dst_off, src_off
    integer(I8P) :: n_elements
    integer(c_size_t) :: total_dim

    n_elements = size(fptr_src,kind=I8P)

    total_dim = int(n_elements * byte_size(1_I8P), c_size_t)

    omp_target_memcpy_I8P = int(omp_target_memcpy(c_loc(fptr_dst), c_loc(fptr_src), total_dim, &
       int(dst_off, c_size_t), int(src_off, c_size_t), int(omp_dst_dev, c_int), int(omp_src_dev, c_int)), I4P)
  endfunction omp_target_memcpy_I8P

endmodule gpu_utils

