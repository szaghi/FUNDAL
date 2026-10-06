call dev_alloc(fptr_dev=t_dev, ubounds=[n], ierr=ierr, label='temperature')
if (ierr /= 0) error stop 'device allocation failed'
