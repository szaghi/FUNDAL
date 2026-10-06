call dev_get_alloc_stats(allocs=allocs, bytes=bytes)              ! on every device
print '(A,I0,A,I0,A)', 'live: ', allocs, ' allocations, ', bytes, ' bytes'
call dev_get_alloc_stats(allocs=allocs, bytes=bytes, dev_id=mydev) ! on this device only
print '(A,I0,A,I0,A)', 'on this device: ', allocs, ' allocations, ', bytes, ' bytes'
call dev_free(x_dev)
call dev_free(y_dev)
call dev_get_alloc_stats(allocs=allocs)
if (allocs /= 0_I8P) error stop 'device memory leaked'
print '(A,I0)', 'after the frees: ', allocs
