call dev_init(require_device=require_device, ierr=ierr)
if (ierr == FUNDAL_ERR_NO_DEVICE) then
   print '(A)', 'no device available and the host fallback is forbidden: stop'
   stop 1
endif
print '(A,L1)', 'running on the host: ', dev_is_host_fallback()
