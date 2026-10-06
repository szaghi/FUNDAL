allocate(t(0:n+1), tn(0:n+1))
t = [(sin(pi*i*dx), i=0, n+1)]
t(0) = 0._R8P ; t(n+1) = 0._R8P
call dev_alloc_unstr(fptr_dev=t)                      ! a device copy of t, uninitialised
call dev_memcpy_to_device_unstr(dst=t)                ! host t -> device t
call dev_alloc_unstr(fptr_dev=tn, init_value=0._R8P)  ! a device copy of tn, set on the device
