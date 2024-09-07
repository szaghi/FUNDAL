program test_deviceptr_mpi
use :: iso_c_binding
use :: mpi
use :: openacc

implicit none

integer                   :: sizes(3)=[1,2,3]  ! arrays sizes
real, pointer             :: buffer_dev(:,:,:) ! device work array
real, allocatable, target :: buffer_hos(:,:,:) ! host work array
type(c_ptr)               :: cptr              ! c-pointer
integer(c_size_t)         :: bytes             ! number of bytes of arryas
integer                   :: ierr              ! error status
integer                   :: procs_number      ! MPI processes number
integer                   :: myrank            ! MPI current ID
character(:), allocatable :: myrankstr         ! MPI ID stringified
integer                   :: local_comm        ! MPI local communicator
integer                   :: local_rank        ! local MPI split ID
integer                   :: devices_number    ! devices number
integer                   :: mydev             ! device current ID
integer                   :: i, j, k           ! counters

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

! initialize MPI and devices env
call MPI_INIT(ierr)
call MPI_COMM_SIZE(MPI_COMM_WORLD, procs_number, ierr)
call MPI_COMM_RANK(MPI_COMM_WORLD, myrank, ierr)
call MPI_COMM_SPLIT_TYPE(MPI_COMM_WORLD, MPI_COMM_TYPE_SHARED, 0, MPI_INFO_NULL, local_comm, ierr)
call MPI_COMM_RANK(local_comm, local_rank, ierr)
myrankstr = repeat(' ',5)
write(myrankstr, '(I5.5)') myrank
myrankstr = 'proc'//trim(adjustl(myrankstr))//':'
devices_number = acc_get_num_devices(acc_device_nvidia)
mydev = mod(local_rank, devices_number)
call acc_set_device_num(mydev, acc_device_nvidia)
call acc_init(acc_device_nvidia)

print '(A,2I2)', myrankstr//' devices number, mydev', devices_number, mydev
call MPI_BARRIER(MPI_COMM_WORLD, ierr)

! allocate work arrays on host and devices
bytes = int(storage_size(buffer_dev)/8, c_size_t) * int(product(sizes), c_size_t)
cptr = acc_malloc_f(bytes)
if (c_associated(cptr)) call c_f_pointer(cptr, buffer_dev, shape=sizes)
allocate(buffer_hos(sizes(1),sizes(2),sizes(3))) ; buffer_hos = -1.0

! prepare buffer_dev array
!$acc parallel loop collapse(3) deviceptr(buffer_dev)
do k=1, sizes(3)
   do j=1, sizes(2)
      do i=1, sizes(1)
         if (myrank == 0) then
            buffer_dev(i,j,k) = 0.0
         else
            buffer_dev(i,j,k) = 1.0
         endif
      enddo
   enddo
enddo
! check buffer status
call acc_memcpy_from_device_f(c_loc(buffer_hos), c_loc(buffer_dev), bytes)
print '(A)', myrankstr//' buffer_dev array'
do k=1, sizes(3)
   do j=1, sizes(2)
      do i=1, sizes(1)
         print '(A,3I3,F5.1)', myrankstr//' i j k a:', i,j,k,buffer_hos(i,j,k)
      enddo
   enddo
enddo
call MPI_BARRIER(MPI_COMM_WORLD, ierr)

! MPI send from dev 1 to dev 0
!!$acc data deviceptr(buffer_dev)
!!$acc host_data use_device(buffer_dev)
if (myrank == 1) call MPI_SEND(buffer_dev, 6, MPI_REAL8, 0, 101, MPI_COMM_WORLD, ierr)
if (myrank == 0) call MPI_RECV(buffer_dev, 6, MPI_REAL8, 1, 101, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
!!$acc end host_data
!!$acc end data
call MPI_BARRIER(MPI_COMM_WORLD, ierr)

if (myrank == 0) then
   print '(A)', myrankstr//' check communication result'
   call acc_memcpy_from_device_f(c_loc(buffer_hos), c_loc(buffer_dev), bytes)
   print '(A)', myrankstr//' buffer_dev array'
   do k=1, sizes(3)
      do j=1, sizes(2)
         do i=1, sizes(1)
            print '(A,3I3,F5.1)', myrankstr//' i j k a:', i,j,k,buffer_hos(i,j,k)
         enddo
      enddo
   enddo
   if (any(int(buffer_hos) /= 1)) then
      print '(A)', myrankstr//' communication failed'
   else
      print '(A)', myrankstr//' communication done'
   endif
endif

call MPI_FINALIZE(ierr)
endprogram test_deviceptr_mpi
