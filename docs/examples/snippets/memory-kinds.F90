call dev_alloc(fptr_dev=mask_dev, ubounds=[100], ierr=ierr, init_value=0_I1P, label='mask')
if (ierr /= 0) error stop 'device allocation failed'
call dev_alloc(fptr_dev=phi_dev, ubounds=[10,10], ierr=ierr, init_value=0._R4P, label='phi')
if (ierr /= 0) error stop 'device allocation failed'
call dev_get_alloc_stats(bytes=bytes)
print '(A,I0,A)', 'device memory in use: ', bytes, ' bytes (100 x 1 + 100 x 4)'
call dev_free(mask_dev)
call dev_free(phi_dev)
