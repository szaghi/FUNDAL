call dev_alloc(fptr_dev=t_dev,  lbounds=[0], ubounds=[n+1], ierr=ierr, init_value=0._R8P, label='temperature')
if (ierr /= 0) error stop 'device allocation failed'
call dev_alloc(fptr_dev=tn_dev, lbounds=[0], ubounds=[n+1], ierr=ierr, init_value=0._R8P, label='temperature, next')
if (ierr /= 0) error stop 'device allocation failed'
call dev_get_alloc_stats(allocs=allocs, bytes=bytes)
print '(A,I0,A,I0,A)', 'live device allocations: ', allocs, ' (', bytes, ' bytes)'
