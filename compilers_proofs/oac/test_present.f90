program test_present
use iso_c_binding
use openacc

implicit none

integer                   :: sizes(3)=[1,2,3]
real, pointer             :: a(:,:,:)
real, allocatable, target :: b(:,:,:)
type(c_ptr)               :: cptr
integer(c_size_t)         :: bytes
integer                   :: i, j, k

interface
   function acc_malloc_f(total_byte_dim) bind(c, name="acc_malloc")
   use iso_c_binding, only : c_ptr, c_size_t
   implicit none
   type(c_ptr)                          :: acc_malloc_f
   integer(c_size_t), value, intent(in) :: total_byte_dim
   endfunction acc_malloc_f

   subroutine acc_memcpy_from_device_f(host_ptr, dev_ptr, total_byte_dim) bind(c, name="acc_memcpy_from_device")
   use iso_c_binding, only : c_ptr, c_size_t
   implicit none
   type(c_ptr),       value :: host_ptr
   type(c_ptr),       value :: dev_ptr
   integer(c_size_t), value :: total_byte_dim
   endsubroutine acc_memcpy_from_device_f
endinterface

bytes = int(storage_size(a)/8, c_size_t) * int(product(sizes), c_size_t)
cptr = acc_malloc_f(bytes)
if (c_associated(cptr)) call c_f_pointer(cptr, a, shape=sizes)
!$acc parallel loop collapse(3) present(a)
do k=1, sizes(3)
   do j=1, sizes(2)
      do i=1, sizes(1)
         a(i,j,k) = (i + j + k) * 0.5
      enddo
   enddo
enddo
allocate(b(sizes(1),sizes(2),sizes(3)))
call acc_memcpy_from_device_f(c_loc(b), c_loc(a), bytes)
do k=1, sizes(3)
   do j=1, sizes(2)
      do i=1, sizes(1)
         print*, b(i,j,k)
      enddo
   enddo
enddo
endprogram test_present
