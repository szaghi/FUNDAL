call dev_alloc(fptr_dev=t_dev,  lbounds=[first-1], ubounds=[last+1], ierr=ierr, init_value=0._R8P, label='t')
if (ierr /= 0) call mpih%abort(msg='device allocation failed')
call dev_alloc(fptr_dev=tn_dev, lbounds=[first-1], ubounds=[last+1], ierr=ierr, init_value=0._R8P, label='tn')
if (ierr /= 0) call mpih%abort(msg='device allocation failed')
t = [(sin(pi*i*dx), i=0, n+1)]
t(0) = 0._R8P ; t(n+1) = 0._R8P
call dev_memcpy_to_device(dst=t_dev, src=t(first-1:last+1)) ! only the cells of this rank, and its ghosts
