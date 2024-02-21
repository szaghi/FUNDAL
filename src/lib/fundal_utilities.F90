!< FUNDAL, utilities module.
module fundal_utilities
!< FUNDAL, utilities module.
use, intrinsic :: iso_c_binding
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64

implicit none

private
public :: bytes_size

interface bytes_size
   !< Return bytes size of input array.
   module procedure bytes_size_R8P_1D,&
                    bytes_size_R8P_2D,&
                    bytes_size_R8P_3D,&
                    bytes_size_R8P_4D,&
                    bytes_size_R8P_5D,&
                    bytes_size_R8P_6D,&
                    bytes_size_R8P_7D,&
                    bytes_size_R4P_1D,&
                    bytes_size_R4P_2D,&
                    bytes_size_R4P_3D,&
                    bytes_size_R4P_4D,&
                    bytes_size_R4P_5D,&
                    bytes_size_R4P_6D,&
                    bytes_size_R4P_7D,&
                    bytes_size_I8P_1D,&
                    bytes_size_I8P_2D,&
                    bytes_size_I8P_3D,&
                    bytes_size_I8P_4D,&
                    bytes_size_I8P_5D,&
                    bytes_size_I8P_6D,&
                    bytes_size_I8P_7D,&
                    bytes_size_I4P_1D,&
                    bytes_size_I4P_2D,&
                    bytes_size_I4P_3D,&
                    bytes_size_I4P_4D,&
                    bytes_size_I4P_5D,&
                    bytes_size_I4P_6D,&
                    bytes_size_I4P_7D,&
                    bytes_size_I1P_1D,&
                    bytes_size_I1P_2D,&
                    bytes_size_I1P_3D,&
                    bytes_size_I1P_4D,&
                    bytes_size_I1P_5D,&
                    bytes_size_I1P_6D,&
                    bytes_size_I1P_7D
endinterface bytes_size

contains
   function bytes_size_R8P_1D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 1.
   real(R8P),    intent(in), target   :: a(:)     !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_1D

   function bytes_size_R8P_2D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 2.
   real(R8P),    intent(in), target   :: a(:,:)   !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_2D

   function bytes_size_R8P_3D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 3.
   real(R8P),    intent(in), target   :: a(:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_3D

   function bytes_size_R8P_4D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 4.
   real(R8P),    intent(in), target   :: a(:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)   !< Sizes.
   integer(c_size_t)                  :: bytes      !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_4D

   function bytes_size_R8P_5D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 5.
   real(R8P),    intent(in), target   :: a(:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)     !< Sizes.
   integer(c_size_t)                  :: bytes        !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_5D

   function bytes_size_R8P_6D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 6.
   real(R8P),    intent(in), target   :: a(:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)       !< Sizes.
   integer(c_size_t)                  :: bytes          !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_6D

   function bytes_size_R8P_7D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R8P, rank 7.
   real(R8P),    intent(in), target   :: a(:,:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)         !< Sizes.
   integer(c_size_t)                  :: bytes            !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R8P_7D

   function bytes_size_R4P_1D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 1.
   real(R4P),    intent(in), target   :: a(:)     !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_1D

   function bytes_size_R4P_2D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 2.
   real(R4P),    intent(in), target   :: a(:,:)   !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_2D

   function bytes_size_R4P_3D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 3.
   real(R4P),    intent(in), target   :: a(:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_3D

   function bytes_size_R4P_4D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 4.
   real(R4P),    intent(in), target   :: a(:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)   !< Sizes.
   integer(c_size_t)                  :: bytes      !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_4D

   function bytes_size_R4P_5D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 5.
   real(R4P),    intent(in), target   :: a(:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)     !< Sizes.
   integer(c_size_t)                  :: bytes        !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_5D

   function bytes_size_R4P_6D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 6.
   real(R4P),    intent(in), target   :: a(:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)       !< Sizes.
   integer(c_size_t)                  :: bytes          !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_6D

   function bytes_size_R4P_7D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind R4P, rank 7.
   real(R4P),    intent(in), target   :: a(:,:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)         !< Sizes.
   integer(c_size_t)                  :: bytes            !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_R4P_7D

   function bytes_size_I8P_1D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 1.
   integer(I8P), intent(in), target   :: a(:)     !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_1D

   function bytes_size_I8P_2D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 2.
   integer(I8P), intent(in), target   :: a(:,:)   !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_2D

   function bytes_size_I8P_3D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 3.
   integer(I8P), intent(in), target   :: a(:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_3D

   function bytes_size_I8P_4D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 4.
   integer(I8P), intent(in), target   :: a(:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)   !< Sizes.
   integer(c_size_t)                  :: bytes      !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_4D

   function bytes_size_I8P_5D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 5.
   integer(I8P), intent(in), target   :: a(:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)     !< Sizes.
   integer(c_size_t)                  :: bytes        !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_5D

   function bytes_size_I8P_6D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 6.
   integer(I8P), intent(in), target   :: a(:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)       !< Sizes.
   integer(c_size_t)                  :: bytes          !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_6D

   function bytes_size_I8P_7D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I8P, rank 7.
   integer(I8P), intent(in), target   :: a(:,:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)         !< Sizes.
   integer(c_size_t)                  :: bytes            !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I8P_7D

   function bytes_size_I4P_1D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 1.
   integer(I4P), intent(in), target   :: a(:)     !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_1D

   function bytes_size_I4P_2D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 2.
   integer(I4P), intent(in), target   :: a(:,:)   !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_2D

   function bytes_size_I4P_3D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 3.
   integer(I4P), intent(in), target   :: a(:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_3D

   function bytes_size_I4P_4D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 4.
   integer(I4P), intent(in), target   :: a(:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)   !< Sizes.
   integer(c_size_t)                  :: bytes      !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_4D

   function bytes_size_I4P_5D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 5.
   integer(I4P), intent(in), target   :: a(:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)     !< Sizes.
   integer(c_size_t)                  :: bytes        !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_5D

   function bytes_size_I4P_6D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 6.
   integer(I4P), intent(in), target   :: a(:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)       !< Sizes.
   integer(c_size_t)                  :: bytes          !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_6D

   function bytes_size_I4P_7D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I4P, rank 7.
   integer(I4P), intent(in), target   :: a(:,:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)         !< Sizes.
   integer(c_size_t)                  :: bytes            !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I4P_7D

   function bytes_size_I1P_1D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 1.
   integer(I1P), intent(in), target   :: a(:)     !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_1D

   function bytes_size_I1P_2D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 2.
   integer(I1P), intent(in), target   :: a(:,:)   !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_2D

   function bytes_size_I1P_3D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 3.
   integer(I1P), intent(in), target   :: a(:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:) !< Sizes.
   integer(c_size_t)                  :: bytes    !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_3D

   function bytes_size_I1P_4D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 4.
   integer(I1P), intent(in), target   :: a(:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)   !< Sizes.
   integer(c_size_t)                  :: bytes      !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_4D

   function bytes_size_I1P_5D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 5.
   integer(I1P), intent(in), target   :: a(:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)     !< Sizes.
   integer(c_size_t)                  :: bytes        !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_5D

   function bytes_size_I1P_6D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 6.
   integer(I1P), intent(in), target   :: a(:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)       !< Sizes.
   integer(c_size_t)                  :: bytes          !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_6D

   function bytes_size_I1P_7D(a, sizes) result(bytes)
   !< Return bytes size of input array, kind I1P, rank 7.
   integer(I1P), intent(in), target   :: a(:,:,:,:,:,:,:) !< Input array.
   integer(I8P), intent(in), optional :: sizes(:)         !< Sizes.
   integer(c_size_t)                  :: bytes            !< Bytes of array memory.

   if (present(sizes)) then
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(product(sizes), c_size_t)
   else
      bytes = int(storage_size(a,kind=I8P)/8_I8P, c_size_t) * int(size(a), c_size_t)
   endif
   endfunction bytes_size_I1P_7D
endmodule fundal_utilities
