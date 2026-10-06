call dev_assign_from_device(dst=t_back, src=t_dev)
print '(A,I0,A,I0)', 'dev_assign_from_device(dst, src):          ', lbound(t_back, 1), ':', ubound(t_back, 1)
call dev_assign_from_device(lbounds=lbound(t_dev, 1), dst=t_back, src=t_dev)
print '(A,I0,A,I0)', 'dev_assign_from_device(lbounds, dst, src): ', lbound(t_back, 1), ':', ubound(t_back, 1)
print '(A,*(F5.1))', 'temperature:', t_back
