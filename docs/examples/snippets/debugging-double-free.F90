alias => a_dev
call dev_free(a_dev, ierr=ierr)  ! frees the buffer and nullifies a_dev, but not alias
print '(A,I0)', 'first dev_free: ', ierr
call dev_free(alias, ierr=ierr)  ! the same buffer again: detected, nothing is freed
print '(A,I0,A,L1)', 'second dev_free: ', ierr, ', FUNDAL_ERR_NOT_REGISTERED: ', ierr == FUNDAL_ERR_NOT_REGISTERED
