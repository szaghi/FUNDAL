call dev_assign_to_device(lbounds=lbound(f), dst=f_dev, src=f, ierr=ierr) ! allocate f_dev(0:3,-2:2), copy f
if (ierr /= 0) error stop 'device allocation failed'
call dev_assign_from_device(lbounds=lbound(f_dev), dst=g, src=f_dev)       ! allocate g(0:3,-2:2), copy f_dev
print '(A,2(I0,A,I0,1X))', 'device bounds: ', lbound(f_dev, 1), ':', ubound(f_dev, 1), lbound(f_dev, 2), ':', &
                           ubound(f_dev, 2)
print '(A,2(I0,A,I0,1X))', 'host bounds:   ', lbound(g, 1), ':', ubound(g, 1), lbound(g, 2), ':', ubound(g, 2)
print '(A,L1)', 'same values: ', all(g == f)
call dev_free(f_dev)
