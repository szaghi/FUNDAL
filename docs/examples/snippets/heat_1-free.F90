call dev_free(t_dev)
call dev_get_alloc_stats(allocs=allocs)
print '(A,I0)', 'live device allocations: ', allocs
