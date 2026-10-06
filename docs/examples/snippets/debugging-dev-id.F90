call dev_free(a_dev, dev_id=mydev+1, ierr=ierr) ! the buffer lives on mydev
call dev_get_alloc_stats(allocs=allocs)
print '(A,I0,A,L1,A,I0)', 'dev_free(dev_id=mydev+1): ', ierr, ', FUNDAL_ERR_DEV_ID_MISMATCH: ', &
                          ierr == FUNDAL_ERR_DEV_ID_MISMATCH, ', live allocations: ', allocs
call dev_free(a_dev, ierr=ierr)                 ! the buffer is freed on the device where it lives
call dev_get_alloc_stats(allocs=allocs)
print '(A,I0,A,I0)', 'dev_free: ', ierr, ', live allocations: ', allocs
