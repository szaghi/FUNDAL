!< FUNDAL, memory copy routines module for OpenMP backend.
module fundal_omp_memcpy
!< FUNDAL, memory copy routines module for OpenMP backend.
use, intrinsic :: iso_c_binding
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: omp_lib,         only : omp_target_memcpy
use            :: fundal_env,      only : mydev, myhos
use            :: fundal_utilities

implicit none
private
public :: omp_memcpy
public :: omp_memcpy_from_device
public :: omp_memcpy_to_device

interface omp_memcpy
   !< Copy memory from/to device.
   module procedure omp_memcpy_R8P,&
                    omp_memcpy_R4P,&
                    omp_memcpy_I8P,&
                    omp_memcpy_I4P,&
                    omp_memcpy_I1P
endinterface omp_memcpy

interface omp_memcpy_from_device
   !< Copy memory from device.
   module procedure omp_memcpy_from_device_R8P,&
                    omp_memcpy_from_device_R4P,&
                    omp_memcpy_from_device_I8P,&
                    omp_memcpy_from_device_I4P,&
                    omp_memcpy_from_device_I1P
endinterface omp_memcpy_from_device

interface omp_memcpy_to_device
   !< Copy memory to device.
   module procedure omp_memcpy_to_device_R8P,&
                    omp_memcpy_to_device_R4P,&
                    omp_memcpy_to_device_I8P,&
                    omp_memcpy_to_device_I4P,&
                    omp_memcpy_to_device_I1P
endinterface omp_memcpy_to_device

contains
   function omp_memcpy_R8P(fptr_dst, fptr_src, off_dst, off_src, dev_dst, dev_src) result(ierr)
   !< Copy real array from device, R8P kind, all ranks.
   real(R8P),    intent(out), target :: fptr_dst(..) !< Destination memory.
   real(R8P),    intent(in),  target :: fptr_src(..) !< Source memory.
   integer(I4P), intent(in)          :: off_dst      !< Destination memory offset.
   integer(I4P), intent(in)          :: off_src      !< Source memory offset.
   integer(I4P), intent(in)          :: dev_dst      !< Destination device ID.
   integer(I4P), intent(in)          :: dev_src      !< Source device ID.
   integer(I4P)                      :: ierr         !< Error status.
   integer(c_size_t)                 :: bytes        !< Bytes of memory copied.

   bytes = bytes_size(a=[1._R8P])*size(fptr_src)
   ierr = int(omp_target_memcpy(c_loc(fptr_dst), c_loc(fptr_src), bytes,        &
                                int(off_dst, c_size_t), int(off_src, c_size_t), &
                                int(dev_dst, c_int), int(dev_src, c_int)), I4P)
   endfunction omp_memcpy_R8P

   function omp_memcpy_R4P(fptr_dst, fptr_src, off_dst, off_src, dev_dst, dev_src) result(ierr)
   !< Copy real array from device, R4P kind, all ranks.
   real(R4P),    intent(out), target :: fptr_dst(..) !< Destination memory.
   real(R4P),    intent(in),  target :: fptr_src(..) !< Source memory.
   integer(I4P), intent(in)          :: off_dst      !< Destination memory offset.
   integer(I4P), intent(in)          :: off_src      !< Source memory offset.
   integer(I4P), intent(in)          :: dev_dst      !< Destination device ID.
   integer(I4P), intent(in)          :: dev_src      !< Source device ID.
   integer(I4P)                      :: ierr         !< Error status.
   integer(c_size_t)                 :: bytes        !< Bytes of memory copied.

   bytes = bytes_size(a=[1._R4P])*size(fptr_src)
   ierr = int(omp_target_memcpy(c_loc(fptr_dst), c_loc(fptr_src), bytes,        &
                                int(off_dst, c_size_t), int(off_src, c_size_t), &
                                int(dev_dst, c_int), int(dev_src, c_int)), I4P)
   endfunction omp_memcpy_R4P

   function omp_memcpy_I8P(fptr_dst, fptr_src, off_dst, off_src, dev_dst, dev_src) result(ierr)
   !< Copy real array from device, I8P kind, all ranks.
   integer(I8P), intent(out), target :: fptr_dst(..) !< Destination memory.
   integer(I8P), intent(in),  target :: fptr_src(..) !< Source memory.
   integer(I4P), intent(in)          :: off_dst      !< Destination memory offset.
   integer(I4P), intent(in)          :: off_src      !< Source memory offset.
   integer(I4P), intent(in)          :: dev_dst      !< Destination device ID.
   integer(I4P), intent(in)          :: dev_src      !< Source device ID.
   integer(I4P)                      :: ierr         !< Error status.
   integer(c_size_t)                 :: bytes        !< Bytes of memory copied.

   bytes = bytes_size(a=[1_I8P])*size(fptr_src)
   ierr = int(omp_target_memcpy(c_loc(fptr_dst), c_loc(fptr_src), bytes,        &
                                int(off_dst, c_size_t), int(off_src, c_size_t), &
                                int(dev_dst, c_int), int(dev_src, c_int)), I4P)
   endfunction omp_memcpy_I8P

   function omp_memcpy_I4P(fptr_dst, fptr_src, off_dst, off_src, dev_dst, dev_src) result(ierr)
   !< Copy real array from device, I4P kind, all ranks.
   integer(I4P), intent(out), target :: fptr_dst(..) !< Destination memory.
   integer(I4P), intent(in),  target :: fptr_src(..) !< Source memory.
   integer(I4P), intent(in)          :: off_dst      !< Destination memory offset.
   integer(I4P), intent(in)          :: off_src      !< Source memory offset.
   integer(I4P), intent(in)          :: dev_dst      !< Destination device ID.
   integer(I4P), intent(in)          :: dev_src      !< Source device ID.
   integer(I4P)                      :: ierr         !< Error status.
   integer(c_size_t)                 :: bytes        !< Bytes of memory copied.

   bytes = bytes_size(a=[1_I4P])*size(fptr_src)
   ierr = int(omp_target_memcpy(c_loc(fptr_dst), c_loc(fptr_src), bytes,        &
                                int(off_dst, c_size_t), int(off_src, c_size_t), &
                                int(dev_dst, c_int), int(dev_src, c_int)), I4P)
   endfunction omp_memcpy_I4P

   function omp_memcpy_I1P(fptr_dst, fptr_src, off_dst, off_src, dev_dst, dev_src) result(ierr)
   !< Copy real array from device, I1P kind, all ranks.
   integer(I1P), intent(out), target :: fptr_dst(..) !< Destination memory.
   integer(I1P), intent(in),  target :: fptr_src(..) !< Source memory.
   integer(I4P), intent(in)          :: off_dst      !< Destination memory offset.
   integer(I4P), intent(in)          :: off_src      !< Source memory offset.
   integer(I4P), intent(in)          :: dev_dst      !< Destination device ID.
   integer(I4P), intent(in)          :: dev_src      !< Source device ID.
   integer(I4P)                      :: ierr         !< Error status.
   integer(c_size_t)                 :: bytes        !< Bytes of memory copied.

   bytes = bytes_size(a=[1_I1P])*size(fptr_src)
   ierr = int(omp_target_memcpy(c_loc(fptr_dst), c_loc(fptr_src), bytes,        &
                                int(off_dst, c_size_t), int(off_src, c_size_t), &
                                int(dev_dst, c_int), int(dev_src, c_int)), I4P)
   endfunction omp_memcpy_I1P

   ! unified API with OpenACC memcpy from/to device
   ! omp_memcpy_from_device
   subroutine omp_memcpy_from_device_R8P(fptr_dst, fptr_src)
   !< Copy array from device, R8P kind, all ranks.
   !< Note: the evinronment global varibales myhos and mydev must be initialized before using this procedure.
   real(R8P), intent(out), target :: fptr_dst(..) !< Destination memory (host memory).
   real(R8P), intent(in),  target :: fptr_src(..) !< Source memory (device memory).
   integer(I4P)                   :: ierr         !< Error status.

   ierr = omp_memcpy(fptr_dst=fptr_dst, fptr_src=fptr_src, off_dst=0_I4P, off_src=0_I4P, dev_dst=myhos, dev_src=mydev)
   endsubroutine omp_memcpy_from_device_R8P

   subroutine omp_memcpy_from_device_R4P(fptr_dst, fptr_src)
   !< Copy array from device, R4P kind, all ranks.
   !< Note: the evinronment global varibales myhos and mydev must be initialized before using this procedure.
   real(R4P), intent(out), target :: fptr_dst(..) !< Destination memory (host memory).
   real(R4P), intent(in),  target :: fptr_src(..) !< Source memory (device memory).
   integer(I4P)                   :: ierr         !< Error status.

   ierr = omp_memcpy(fptr_dst=fptr_dst, fptr_src=fptr_src, off_dst=0_I4P, off_src=0_I4P, dev_dst=myhos, dev_src=mydev)
   endsubroutine omp_memcpy_from_device_R4P

   subroutine omp_memcpy_from_device_I8P(fptr_dst, fptr_src)
   !< Copy array from device, I8P kind, all ranks.
   !< Note: the evinronment global varibales myhos and mydev must be initialized before using this procedure.
   integer(I8P), intent(out), target :: fptr_dst(..) !< Destination memory (host memory).
   integer(I8P), intent(in),  target :: fptr_src(..) !< Source memory (device memory).
   integer(I4P)                      :: ierr         !< Error status.

   ierr = omp_memcpy(fptr_dst=fptr_dst, fptr_src=fptr_src, off_dst=0_I4P, off_src=0_I4P, dev_dst=myhos, dev_src=mydev)
   endsubroutine omp_memcpy_from_device_I8P

   subroutine omp_memcpy_from_device_I4P(fptr_dst, fptr_src)
   !< Copy array from device, I4P kind, all ranks.
   !< Note: the evinronment global varibales myhos and mydev must be initialized before using this procedure.
   integer(I4P), intent(out), target :: fptr_dst(..) !< Destination memory (host memory).
   integer(I4P), intent(in),  target :: fptr_src(..) !< Source memory (device memory).
   integer(I4P)                      :: ierr         !< Error status.

   ierr = omp_memcpy(fptr_dst=fptr_dst, fptr_src=fptr_src, off_dst=0_I4P, off_src=0_I4P, dev_dst=myhos, dev_src=mydev)
   endsubroutine omp_memcpy_from_device_I4P

   subroutine omp_memcpy_from_device_I1P(fptr_dst, fptr_src)
   !< Copy array from device, I1P kind, all ranks.
   !< Note: the evinronment global varibales myhos and mydev must be initialized before using this procedure.
   integer(I1P), intent(out), target :: fptr_dst(..) !< Destination memory (host memory).
   integer(I1P), intent(in),  target :: fptr_src(..) !< Source memory (device memory).
   integer(I4P)                      :: ierr         !< Error status.

   ierr = omp_memcpy(fptr_dst=fptr_dst, fptr_src=fptr_src, off_dst=0_I4P, off_src=0_I4P, dev_dst=myhos, dev_src=mydev)
   endsubroutine omp_memcpy_from_device_I1P

   ! omp_memcpy_to_device
   subroutine omp_memcpy_to_device_R8P(fptr_dst, fptr_src)
   !< Copy array to device, R8P kind, all ranks.
   !< Note: the evinronment global varibales myhos and mydev must be initialized before using this procedure.
   real(R8P), intent(out), target :: fptr_dst(..) !< Destination memory (device memory).
   real(R8P), intent(in),  target :: fptr_src(..) !< Source memory (host memory).
   integer(I4P)                   :: ierr         !< Error status.

   ierr = omp_memcpy(fptr_dst=fptr_dst, fptr_src=fptr_src, off_dst=0_I4P, off_src=0_I4P, dev_dst=mydev, dev_src=myhos)
   endsubroutine omp_memcpy_to_device_R8P

   subroutine omp_memcpy_to_device_R4P(fptr_dst, fptr_src)
   !< Copy array to device, R4P kind, all ranks.
   !< Note: the evinronment global varibales myhos and mydev must be initialized before using this procedure.
   real(R4P), intent(out), target :: fptr_dst(..) !< Destination memory (device memory).
   real(R4P), intent(in),  target :: fptr_src(..) !< Source memory (host memory).
   integer(I4P)                   :: ierr         !< Error status.

   ierr = omp_memcpy(fptr_dst=fptr_dst, fptr_src=fptr_src, off_dst=0_I4P, off_src=0_I4P, dev_dst=mydev, dev_src=myhos)
   endsubroutine omp_memcpy_to_device_R4P

   subroutine omp_memcpy_to_device_I8P(fptr_dst, fptr_src)
   !< Copy array to device, I8P kind, all ranks.
   !< Note: the evinronment global varibales myhos and mydev must be initialized before using this procedure.
   integer(I8P), intent(out), target :: fptr_dst(..) !< Destination memory (device memory).
   integer(I8P), intent(in),  target :: fptr_src(..) !< Source memory (host memory).
   integer(I4P)                      :: ierr         !< Error status.

   ierr = omp_memcpy(fptr_dst=fptr_dst, fptr_src=fptr_src, off_dst=0_I4P, off_src=0_I4P, dev_dst=mydev, dev_src=myhos)
   endsubroutine omp_memcpy_to_device_I8P

   subroutine omp_memcpy_to_device_I4P(fptr_dst, fptr_src)
   !< Copy array to device, I4P kind, all ranks.
   !< Note: the evinronment global varibales myhos and mydev must be initialized before using this procedure.
   integer(I4P), intent(out), target :: fptr_dst(..) !< Destination memory (device memory).
   integer(I4P), intent(in),  target :: fptr_src(..) !< Source memory (host memory).
   integer(I4P)                      :: ierr         !< Error status.

   ierr = omp_memcpy(fptr_dst=fptr_dst, fptr_src=fptr_src, off_dst=0_I4P, off_src=0_I4P, dev_dst=mydev, dev_src=myhos)
   endsubroutine omp_memcpy_to_device_I4P

   subroutine omp_memcpy_to_device_I1P(fptr_dst, fptr_src)
   !< Copy array to device, I1P kind, all ranks.
   !< Note: the evinronment global varibales myhos and mydev must be initialized before using this procedure.
   integer(I1P), intent(out), target :: fptr_dst(..) !< Destination memory (device memory).
   integer(I1P), intent(in),  target :: fptr_src(..) !< Source memory (host memory).
   integer(I4P)                      :: ierr         !< Error status.

   ierr = omp_memcpy(fptr_dst=fptr_dst, fptr_src=fptr_src, off_dst=0_I4P, off_src=0_I4P, dev_dst=mydev, dev_src=myhos)
   endsubroutine omp_memcpy_to_device_I1P
endmodule fundal_omp_memcpy
