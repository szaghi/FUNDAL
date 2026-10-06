call dev_free(t_dev, ierr=ierr)
if (ierr /= 0) error stop 'dev_free failed'
call dev_free(tn_dev, ierr=ierr)
if (ierr /= 0) error stop 'dev_free failed'
call dev_alloc_report() ! nothing should be left
