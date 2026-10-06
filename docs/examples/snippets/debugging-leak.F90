call dev_alloc(fptr_dev=u_dev,    ubounds=[100], ierr=ierr, label='u')
if (ierr /= 0) error stop 'device allocation failed'
call dev_alloc(fptr_dev=halo_dev, ubounds=[8],   ierr=ierr, label='halo buffer')
if (ierr /= 0) error stop 'device allocation failed'
call dev_free(u_dev)
! ... halo_dev is never freed
call dev_alloc_report() ! at teardown: what is still allocated?
