allocate(t(0:n+1))
t = 20._R8P ; t(0) = 0._R8P ; t(n+1) = 0._R8P   ! room temperature, cold boundaries
call dev_assign_to_device(dst=t_dev, src=t, ierr=ierr)
if (ierr /= 0) error stop 'device allocation failed'
print '(A,I0,A,I0)', 'dev_assign_to_device(dst, src):          ', lbound(t_dev, 1), ':', ubound(t_dev, 1)
call dev_assign_to_device(lbounds=lbound(t, 1), dst=t_dev, src=t, ierr=ierr)
if (ierr /= 0) error stop 'device allocation failed'
print '(A,I0,A,I0)', 'dev_assign_to_device(lbounds, dst, src): ', lbound(t_dev, 1), ':', ubound(t_dev, 1)
