program heat_2
!< Tutorial, chapter 2: bounds, resizing, assignment.
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64, R8P=>real64
use            :: fundal
implicit none
integer(I4P)           :: n=4               ! interior cells, ghost cells 0 and n+1
real(R8P), pointer     :: t_dev(:)=>null()  ! temperature, on the device
real(R8P), allocatable :: t(:)              ! temperature, on the host
real(R8P), allocatable :: t_back(:)         ! temperature copied back to the host
integer(I8P)           :: allocs            ! live device allocations
integer(I8P)           :: bytes             ! bytes of the live device allocations
integer(I4P)           :: ierr              ! error status

call dev_init
call dev_alloc(fptr_dev=t_dev, lbounds=[0], ubounds=[n+1], ierr=ierr, init_value=0._R8P, label='temperature')
if (ierr /= 0) error stop 'device allocation failed'
print '(A,I0,A,I0)', 'device array bounds: ', lbound(t_dev, 1), ':', ubound(t_dev, 1)
n = 2*n ! refine the grid: twice the cells
call dev_alloc_replace(fptr_dev=t_dev, lbounds=[0], ubounds=[n+1], ierr=ierr, init_value=0._R8P, label='temperature')
if (ierr /= 0) error stop 'device allocation failed'
call dev_get_alloc_stats(allocs=allocs, bytes=bytes)
print '(A,I0,A,I0)', 'after the refinement: ', lbound(t_dev, 1), ':', ubound(t_dev, 1)
print '(A,I0,A,I0,A)', 'live device allocations: ', allocs, ' (', bytes, ' bytes)'
allocate(t(0:n+1))
t = 20._R8P ; t(0) = 0._R8P ; t(n+1) = 0._R8P   ! room temperature, cold boundaries
call dev_assign_to_device(dst=t_dev, src=t, ierr=ierr)
if (ierr /= 0) error stop 'device allocation failed'
print '(A,I0,A,I0)', 'dev_assign_to_device(dst, src):          ', lbound(t_dev, 1), ':', ubound(t_dev, 1)
call dev_assign_to_device(lbounds=lbound(t, 1), dst=t_dev, src=t, ierr=ierr)
if (ierr /= 0) error stop 'device allocation failed'
print '(A,I0,A,I0)', 'dev_assign_to_device(lbounds, dst, src): ', lbound(t_dev, 1), ':', ubound(t_dev, 1)
call dev_assign_from_device(dst=t_back, src=t_dev)
print '(A,I0,A,I0)', 'dev_assign_from_device(dst, src):          ', lbound(t_back, 1), ':', ubound(t_back, 1)
call dev_assign_from_device(lbounds=lbound(t_dev, 1), dst=t_back, src=t_dev)
print '(A,I0,A,I0)', 'dev_assign_from_device(lbounds, dst, src): ', lbound(t_back, 1), ':', ubound(t_back, 1)
print '(A,*(F5.1))', 'temperature:', t_back
call dev_free(t_dev)
call dev_get_alloc_stats(allocs=allocs)
print '(A,I0)', 'live device allocations: ', allocs
endprogram heat_2
