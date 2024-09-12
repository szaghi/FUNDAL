!< FUNDAL, MPI handler class definition.

#include "fundal.H"

module fundal_mpih_object
!< MPI handler classs definition.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: mpi
#ifdef DEV_OAC
use            :: openacc,         only : acc_device_kind
#endif
use            :: fundal

implicit none
private
public :: mpih_object

type :: mpih_object
   !< MPI handler class.
   integer(I4P)                      :: ierr=0_I4P         !< Error status.
   integer(I4P)                      :: myrank=0_I4P       !< MPI ID process.
   integer(I4P)                      :: procs_number=1_I4P !< Number of MPI processes.
   integer(I4P)                      :: devs_number=0_I4P  !< Number of devices.
   integer(I4P),             pointer :: mydev=>null()      !< Device ID.
   integer(I4P),             pointer :: local_comm=>null() !< Local communicator.
   integer(I4P),             pointer :: myhos=>null()      !< Host ID.
#ifdef DEV_OAC
   integer(acc_device_kind), pointer :: devtype=>null()    !< OpenACC device type.
#else
   integer(I4P),             pointer :: devtype=>null()    !< OpenACC device type.
#endif
   character(:), allocatable         :: myrankstr          !< MPI ID stringified.
   contains
      procedure, pass(self) :: description !< Return pretty-printed object description.
      procedure, pass(self) :: initialize  !< Initialize MPI handler.
endtype mpih_object

contains
   ! public methods
   pure function description(self) result(desc)
   !< Return a pretty-formatted object description.
   class(mpih_object) , intent(in) :: self             !< MPI handler.
   character(len=:), allocatable   :: desc             !< Description.
   character(len=1), parameter     :: NL=new_line('a') !< New line character.

   desc =       self%myrankstr//'MPIH main data'//NL
   desc = desc//self%myrankstr//'  myrank:       '//trim(str(self%myrank      ))//NL
   desc = desc//self%myrankstr//'  procs_number: '//trim(str(self%procs_number))//NL
   desc = desc//self%myrankstr//'  local_comm:   '//trim(str(self%local_comm  ))//NL
   desc = desc//self%myrankstr//'  myhos:        '//trim(str(self%myhos       ))//NL
   desc = desc//self%myrankstr//'  devtype:      '//trim(str(self%devtype     ))//NL
   desc = desc//self%myrankstr//'  devs_number:  '//trim(str(self%devs_number ))//NL
   desc = desc//self%myrankstr//'  mydev:        '//trim(str(self%mydev       ))
   endfunction description

   subroutine initialize(self, myrankstr_char_length)
   !< Initialize MPI handler.
   class(mpih_object), intent(out)          :: self                   !< MPI handler.
   integer(I4P),       intent(in), optional :: myrankstr_char_length  !< MPI ID string length.
   integer(I4P)                             :: myrankstr_char_length_ !< MPI ID string length, local variable.
   integer(I4P)                             :: local_rank             !< Local MPI split ID.

   myrankstr_char_length_ = 5 ; if (present(myrankstr_char_length)) myrankstr_char_length_ = myrankstr_char_length

   ! associate handler members to the global env FUNDAL variables
   self%local_comm => local_comm
   self%myhos      => myhos
   self%mydev      => mydev
   self%devtype    => devtype

   ! initialize MPI and device env
   call MPI_INIT(self%ierr)
   call MPI_COMM_SIZE(MPI_COMM_WORLD, self%procs_number, self%ierr)
   call MPI_COMM_RANK(MPI_COMM_WORLD, self%myrank, self%ierr)
   call MPI_COMM_SPLIT_TYPE(MPI_COMM_WORLD, MPI_COMM_TYPE_SHARED, 0, MPI_INFO_NULL, self%local_comm, self%ierr)
   call MPI_COMM_RANK(self%local_comm, local_rank, self%ierr)
   self%devtype = dev_get_device_type()
   self%devs_number = dev_get_num_devices()
   self%mydev = mod(local_rank, self%devs_number)
   self%myhos = dev_get_host_num()
   call dev_set_device_num(self%mydev)
   call dev_init

   self%myrankstr = 'mpi-'//trim(strz(self%myrank,myrankstr_char_length_))//':'

   print '(A)', self%description()
   endsubroutine initialize

   ! private non TBP
   elemental function str(n)
   !< Return integer cast to string.
   integer(I4P), intent(in) :: n   !< Integer to be converted.
   character(11)            :: str !< Returned string containing input number.

   write(str, '(I11)') n    ! Casting of n to string.
   str = adjustl(trim(str)) ! Removing white spaces.
   endfunction str

   elemental function strz(n, nz_pad)
   !< Return integer cast to string, prefixing with the right number of zeros.
   integer(I4P), intent(in)           :: n      !< Integer to be converted.
   integer(I4P), intent(in), optional :: nz_pad !< Number of zeros padding.
   character(11)                      :: strz   !< Returned string containing input number plus padding zeros.

   write(strz,'(I11.11)') n                       ! Casting of n to string.
   strz=strz(2:)                                  ! Leaving out the sign.
   if (present(nz_pad)) strz=strz(11-nz_pad:11-1) ! Leaving out the extra zeros padding
   endfunction strz
endmodule fundal_mpih_object
