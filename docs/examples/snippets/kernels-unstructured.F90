allocate(a(5)) ; a = [(real(i, R8P), i=1, 5)]
call dev_alloc_unstr(fptr_dev=a)
call dev_memcpy_to_device_unstr(dst=a)
call scale_mapped(a=a, factor=10._R8P)
call dev_memcpy_from_device_unstr(dst=a)
call dev_free_unstr(fptr=a)
print '(A,*(F6.1))', 'a:', a
