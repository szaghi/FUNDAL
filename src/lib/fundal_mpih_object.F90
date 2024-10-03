!< FUNDAL, MPI handler class definition.

#include "fundal.H"

module fundal_mpih_object
!< MPI handler classs definition.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64, R8P=>real64, stderr=>error_unit
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
   integer(I4P)                      :: error=0_I4P        !< Error traping flag.
   integer(I4P)                      :: myrank=0_I4P       !< MPI ID process.
   integer(I4P)                      :: procs_number=1_I4P !< Number of MPI processes.
   integer(I8P)                      :: memory_avail=0_I8P !< CPU memory available (GB) for each process.
   real(R8P)                         :: timing(1:2)        !< Tic toc timing.
   integer(I4P)                      :: tictoc=1_I4P       !< Next is tic or toc?
   integer(I4P), allocatable         :: req_send_recv(:)   !< MPI request receive flags.
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
      ! public methods
      procedure, pass(self) :: abort         !< Handy MPI abort wrapper.
      procedure, pass(self) :: barrier       !< Handy MPI barrier wrapper.
      procedure, pass(self) :: description   !< Return pretty-printed object description.
      procedure, pass(self) :: error_stop    !< Stop run with error output.
      procedure, pass(self) :: finalize      !< Handy MPI finalize wrapper.
      procedure, pass(self) :: initialize    !< Initialize MPI handler data.
      procedure, pass(self) :: print_message !< Print a message on stdout with rank prefix.
      procedure, pass(self) :: tictoc_timing !< Return the last tic toc timing.
      procedure, pass(self) :: tic           !< Start a tic toc timing.
      procedure, pass(self) :: toc           !< Stop  a tic toc timing.
endtype mpih_object

contains
   ! public methods
   subroutine abort(self, error_code, msg)
   !< Handy MPI abort wrapper.
   class(mpih_object) , intent(inout)        :: self        !< MPI handler.
   integer(I4P),        intent(in), optional :: error_code  !< Abort error code.
   character(*),        intent(in), optional :: msg         !< Error message.
   character(:), allocatable                 :: msg_        !< Error message, local variable.
   integer(I4P)                              :: error_code_ !< Abort error code, local variable.

   msg_        = ''   ; if (present(msg))        msg_        = msg
   error_code_ = -101 ; if (present(error_code)) error_code_ = error_code
   if (msg_ /='') write(stderr, '(A)') self%myrankstr//'abort '//msg_
   call MPI_ABORT(MPI_COMM_WORLD, error_code_, self%error)
   stop
   endsubroutine abort

   subroutine barrier(self, tictoc, timing, single)
   !< Handy MPI barrier wrapper.
   class(mpih_object) , intent(inout)         :: self    !< MPI handler.
   logical,             intent(in),  optional :: tictoc  !< Activate tic toc timing between 2 barrier calls.
   real(R8P),           intent(out), optional :: timing  !< Current timing.
   logical,             intent(in),  optional :: single  !< Single tictoc for one-shot timing.
   logical                                    :: tictoc_ !< Activate tic toc timing between 2 barrier calls, local var.
   logical                                    :: single_ !< Single tictoc for one-shot timing, local var.

   tictoc_ = .false. ; if (present(tictoc)) tictoc_ = tictoc
   single_ = .false. ; if (present(single)) single_ = single
   call MPI_BARRIER(MPI_COMM_WORLD, self%error)
   if (tictoc_) then
      self%timing(self%tictoc) = MPI_WTIME()
      if (present(timing)) timing = self%timing(self%tictoc)
      if (.not.single_) then
         if (self%tictoc==1) then
            self%tictoc = 2
         else
            self%tictoc = 1
         endif
      endif
   endif
   endsubroutine barrier

   pure function description(self) result(desc)
   !< Return a pretty-formatted object description.
   class(mpih_object) , intent(in) :: self             !< MPI handler.
   character(len=:), allocatable   :: desc             !< Description.
   character(len=1), parameter     :: NL=new_line('a') !< New line character.

   desc =       self%myrankstr//'MPIH main data'//NL
   desc = desc//self%myrankstr//'  myrank:       '//trim(str(self%myrank               ))//NL
   desc = desc//self%myrankstr//'  procs_number: '//trim(str(self%procs_number         ))//NL
   desc = desc//self%myrankstr//'  memory_avail: '//trim(str(int(self%memory_avail,I4P)))//NL
   desc = desc//self%myrankstr//'  local_comm:   '//trim(str(self%local_comm           ))//NL
   desc = desc//self%myrankstr//'  myhos:        '//trim(str(self%myhos                ))//NL
   desc = desc//self%myrankstr//'  devtype:      '//trim(str(self%devtype              ))//NL
   desc = desc//self%myrankstr//'  devs_number:  '//trim(str(self%devs_number          ))//NL
   desc = desc//self%myrankstr//'  mydev:        '//trim(str(self%mydev                ))
   endfunction description

   subroutine error_stop(self, msg)
   !< Stop run with error output.
   class(mpih_object), intent(inout)        :: self !< MPI handler.
   character(*),       intent(in), optional :: msg  !< Error message.
   character(:), allocatable                :: msg_ !< Error message, local variable.

   msg_ = '' ; if (present(msg)) msg_ = msg
   write(stderr, '(A)') self%myrankstr//'error stop '//msg_
   call self%finalize
   stop
   endsubroutine error_stop

   subroutine finalize(self)
   !< Handy MPI finalize wrapper.
   class(mpih_object) , intent(inout) :: self !< MPI handler.

   call MPI_FINALIZE(self%error)
   endsubroutine finalize

   subroutine initialize(self, do_mpi_init, do_device_init, myrankstr_char_length, verbose)
   !< Initialize MPI handler.
   class(mpih_object), intent(out)          :: self                   !< MPI handler.
   logical,            intent(in), optional :: do_mpi_init            !< Flag to activate MPI init call.
   logical,            intent(in), optional :: do_device_init         !< Flag to activate device init call (used by backends).
   integer(I4P),       intent(in), optional :: myrankstr_char_length  !< MPI ID string length.
   logical,            intent(in), optional :: verbose                !< Trigger verbose output.
   logical                                  :: verbose_               !< Trigger verbose output, local variable.
   integer(I4P)                             :: myrankstr_char_length_ !< MPI ID string length, local variable.
   integer(I8P)                             :: mem_free, mem_total    !< CPU memory.
   integer(I4P)                             :: local_rank             !< Local MPI split ID.

   verbose_ = .false. ; if (present(verbose)) verbose_ = verbose
   myrankstr_char_length_ = 5 ; if (present(myrankstr_char_length)) myrankstr_char_length_ = myrankstr_char_length

   ! associate handler members to the global env FUNDAL variables
   self%local_comm => local_comm
   self%myhos      => myhos
   self%mydev      => mydev
   self%devtype    => devtype

   if (present(do_mpi_init)) then
      if (do_mpi_init) call MPI_INIT(self%error)
   endif
   call MPI_COMM_SIZE(MPI_COMM_WORLD, self%procs_number, self%error)
   call MPI_COMM_RANK(MPI_COMM_WORLD, self%myrank, self%error)
   self%myrankstr = '[mpi-'//trim(strz(self%myrank,myrankstr_char_length_))//']'
   if (verbose_) call self%print_message('mpih_object%initialize start')
   call get_memory_info(mem_free=mem_free, mem_total=mem_total)
   self%memory_avail = int(real(mem_free, R8P)/self%procs_number,I8P)
   if (allocated(self%req_send_recv)) deallocate(self%req_send_recv) ; allocate(self%req_send_recv(0:self%procs_number*2-1))
   if (present(do_device_init)) then
      if (do_device_init) then
         call MPI_COMM_SPLIT_TYPE(MPI_COMM_WORLD, MPI_COMM_TYPE_SHARED, 0, MPI_INFO_NULL, self%local_comm, self%error)
         call MPI_COMM_RANK(self%local_comm, local_rank, self%error)
         self%devtype = dev_get_device_type()
         self%devs_number = dev_get_num_devices()
         self%mydev = mod(local_rank, self%devs_number)
         self%myhos = dev_get_host_num()
         call dev_set_device_num(self%mydev)
         call dev_init
      endif
   endif
   if (verbose_) call self%print_message('mpih_object%initialize finish')
   if (verbose_) print '(A)', self%description()
   endsubroutine initialize

   subroutine print_message(self, msg)
   !< Print a message on stdout with rank prefix.
   class(mpih_object) , intent(in) :: self !< MPI handler.
   character(*),        intent(in) :: msg  !< Message to print.

   print '(A)', self%myrankstr//trim(adjustl(msg))
   endsubroutine print_message

   function tictoc_timing(self) result(timing)
   !< Return the last tic toc timing.
   class(mpih_object) , intent(in) :: self   !< MPI handler.
   real(R8P)                       :: timing !< Last tic toc timing.

   timing = self%timing(2) - self%timing(1)
   endfunction tictoc_timing

   subroutine tic(self)
   !< Start a tic toc timing.
   class(mpih_object) , intent(inout) :: self !< MPI handler.

   self%timing(1) = MPI_WTIME()
   endsubroutine tic

   function toc(self) result(timing)
   !< Stop a tic toc timing.
   class(mpih_object) , intent(inout) :: self !< MPI handler.
   real(R8P)                          :: timing !< Tic toc timing.

   self%timing(2) = MPI_WTIME()
   timing = self%tictoc_timing()
   endfunction toc

   ! private non TBP
   function cton(str, knd, pref, error) result(n)
   !< Convert string to integer.
   character(*),           intent(in)  :: str   !< String containing input number.
   integer(I8P),           intent(in)  :: knd   !< Number kind.
   character(*), optional, intent(in)  :: pref  !< Prefixing string.
   integer(I4P), optional, intent(out) :: error !< Error trapping flag: 0 no errors, >0 error occurs.
   integer(I8P)                        :: n     !< Number returned.
   integer(I4P)                        :: err   !< Error trapping flag: 0 no errors, >0 error occurs.
   character(len=:), allocatable       :: prefd !< Prefixing string.

   read(str, *, iostat=err) n ! Casting of str to n.
   if (err/=0) then
     prefd = '' ; if (present(pref)) prefd = pref
     write(stderr, '(A,I1,A)') prefd//' Error: conversion of string "'//str//'" to integer failed! integer(', kind(knd), ')'
   endif
   if (present(error)) error = err
   endfunction cton

   subroutine get_memory_info(mem_free, mem_total)
   !< Get the current CPU-memory status.
   !< @NOTE Currently implemented only per Unix/Linux based systems. Return -1 if failing.
   integer(I8P), intent(out) :: mem_free   !< Free memory.
   integer(I8P), intent(out) :: mem_total  !< Total memory.
   logical                   :: is_present !< Logical flag to check the presence of '/proc/meminfo' system file.
   integer(I4P)              :: file_unit  !< File unit.
   character(999)            :: line       !< Line buffer.

   mem_free  = -1_I8P
   mem_total = -1_I8P
   inquire(file='/proc/meminfo', exist=is_present)
   if (is_present) then
      open(newunit=file_unit, file='/proc/meminfo', status='old')
      read(file_unit, '(A)') line ! total memory
      call parse_line(l=line, v=mem_total)
      read(file_unit, '(A)') line ! free memory
      call parse_line(l=line, v=mem_free)
      close(file_unit)
   endif
   contains
      subroutine parse_line(l,v)
      !< Parse input line and return memory value.
      character(*), intent(in)  :: l      !< Input line.
      integer(I8P), intent(out) :: v      !< Memory value.
      integer(I4P)              :: colon  !< Index of colon (name/value separator) char in line.
      character(:), allocatable :: memval !< Memory value, string.

      colon = index(l, ':')                 ! find name/value separator position
      memval = trim(adjustl(l(colon+1:)))   ! get memory value, string
      memval = trim(memval(:len(memval)-2)) ! remove memory unit, e.g. kb
      v = cton(str=memval, knd=1_I8P)       ! cast to string to integer
      endsubroutine parse_line
   endsubroutine get_memory_info

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
