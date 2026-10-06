program debugging
!< Cookbook, debugging: one recipe per command line argument.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64, R8P=>real64
use            :: fundal
implicit none
character(16) :: recipe ! recipe to run

call get_command_argument(1, recipe)
call dev_init
select case(trim(recipe))
case('fallback')
   call fallback
case('leak')
   call leak
case('double-free')
   call double_free
case('dev-id')
   call dev_id_mismatch
case('misuse')
   call misuse
endselect

contains
   subroutine fallback
   !< Where does the run happen?
   print '(A,L1)', 'host fallback: ', dev_is_host_fallback()
   endsubroutine fallback

   subroutine leak
   !< Find a leaked allocation.
   real(R8P), pointer :: u_dev(:)=>null()    ! device memory
   real(R8P), pointer :: halo_dev(:)=>null() ! device memory
   integer(I4P)       :: ierr                ! error status

   call dev_alloc(fptr_dev=u_dev,    ubounds=[100], ierr=ierr, label='u')
   if (ierr /= 0) error stop 'device allocation failed'
   call dev_alloc(fptr_dev=halo_dev, ubounds=[8],   ierr=ierr, label='halo buffer')
   if (ierr /= 0) error stop 'device allocation failed'
   call dev_free(u_dev)
   ! ... halo_dev is never freed
   call dev_alloc_report() ! at teardown: what is still allocated?
   call dev_free(halo_dev)
   endsubroutine leak

   subroutine double_free
   !< Catch a double free through an alias.
   real(R8P), pointer :: a_dev(:)=>null() ! device memory
   real(R8P), pointer :: alias(:)=>null() ! another pointer to the same buffer
   integer(I4P)       :: ierr             ! error status

   call dev_alloc(fptr_dev=a_dev, ubounds=[10], ierr=ierr)
   if (ierr /= 0) error stop 'device allocation failed'
   alias => a_dev
   call dev_free(a_dev, ierr=ierr)  ! frees the buffer and nullifies a_dev, but not alias
   print '(A,I0)', 'first dev_free: ', ierr
   call dev_free(alias, ierr=ierr)  ! the same buffer again: detected, nothing is freed
   print '(A,I0,A,L1)', 'second dev_free: ', ierr, ', FUNDAL_ERR_NOT_REGISTERED: ', ierr == FUNDAL_ERR_NOT_REGISTERED
   endsubroutine double_free

   subroutine dev_id_mismatch
   !< A dev_id that contradicts the device of the buffer.
   real(R8P), pointer :: a_dev(:)=>null() ! device memory
   integer(I8P)       :: allocs           ! live device allocations
   integer(I4P)       :: ierr             ! error status

   call dev_alloc(fptr_dev=a_dev, ubounds=[10], ierr=ierr)
   if (ierr /= 0) error stop 'device allocation failed'
   call dev_free(a_dev, dev_id=mydev+1, ierr=ierr) ! the buffer lives on mydev
   call dev_get_alloc_stats(allocs=allocs)
   print '(A,I0,A,L1,A,I0)', 'dev_free(dev_id=mydev+1): ', ierr, ', FUNDAL_ERR_DEV_ID_MISMATCH: ', &
                             ierr == FUNDAL_ERR_DEV_ID_MISMATCH, ', live allocations: ', allocs
   call dev_free(a_dev, ierr=ierr)                 ! the buffer is freed on the device where it lives
   call dev_get_alloc_stats(allocs=allocs)
   print '(A,I0,A,I0)', 'dev_free: ', ierr, ', live allocations: ', allocs
   endsubroutine dev_id_mismatch

   subroutine misuse
   !< A misuse of dev_free without ierr: handled by the registry policy.
   real(R8P), pointer :: a_dev(:)=>null() ! device memory
   real(R8P), pointer :: alias(:)=>null() ! another pointer to the same buffer
   integer(I4P)       :: ierr             ! error status

   call dev_alloc(fptr_dev=a_dev, ubounds=[10], ierr=ierr)
   if (ierr /= 0) error stop 'device allocation failed'
   alias => a_dev
   call dev_free(a_dev)
   print '(A)', 'freeing the buffer a second time, through alias'
   call dev_free(alias) ! FUNDAL_REGISTRY=error: error stop
   print '(A)', 'not reached'
   endsubroutine misuse
endprogram debugging
