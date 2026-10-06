alias => a_dev
call dev_free(a_dev)
print '(A)', 'freeing the buffer a second time, through alias'
call dev_free(alias) ! FUNDAL_REGISTRY=error: error stop
print '(A)', 'not reached'
