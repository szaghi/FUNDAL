do n=10, 40, 10 ! the previous buffer is freed at each call: no leak
   call dev_alloc_replace(fptr_dev=u_dev, ubounds=[n], ierr=ierr, init_value=real(n, R8P), label='u')
   if (ierr /= 0) error stop 'device allocation failed'
enddo
call dev_get_alloc_stats(allocs=allocs)
call dev_memcpy_from_device(dst=u, src=u_dev(1:4))
print '(A,I0,A,I0)', 'size: ', size(u_dev), ', live device allocations: ', allocs
print '(A,*(F5.1))', 'first values (set by init_value, not preserved from the previous buffer):', u
call dev_free(u_dev)
