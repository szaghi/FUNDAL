call dev_alloc(fptr_dev=t_dev, lbounds=[0], ubounds=[n+1], ierr=ierr, init_value=0._R8P, label='temperature')
if (ierr /= 0) error stop 'device allocation failed'
print '(A,I0,A,I0)', 'device array bounds: ', lbound(t_dev, 1), ':', ubound(t_dev, 1)
