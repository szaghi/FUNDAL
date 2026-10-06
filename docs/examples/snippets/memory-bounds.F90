call dev_alloc(fptr_dev=q_dev, lbounds=[-1,0,1], ubounds=[1,2,3], ierr=ierr, init_value=-1._R8P, label='q')
if (ierr /= 0) error stop 'device allocation failed'
call dev_memcpy_from_device(dst=q, src=q_dev)
print '(A,3(I0,A,I0,1X))', 'bounds: ', lbound(q_dev, 1), ':', ubound(q_dev, 1), lbound(q_dev, 2), ':', &
                           ubound(q_dev, 2), lbound(q_dev, 3), ':', ubound(q_dev, 3)
print '(A,L1)', 'every element set on the device to -1: ', all(q == -1._R8P)
call dev_free(q_dev)
