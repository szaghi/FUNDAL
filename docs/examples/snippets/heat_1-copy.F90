t = 20._R8P                                   ! room temperature...
t(n/2) = 100._R8P                             ! ...with a hot spot
call dev_memcpy_to_device(dst=t_dev, src=t)   ! host -> device
t = 0._R8P                                    ! forget the host copy
call dev_memcpy_from_device(dst=t, src=t_dev) ! device -> host
print '(A,*(F6.1))', 'temperature:', t
