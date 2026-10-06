call dev_memcpy_from_device_unstr(dst=t) ! device t -> host t
call dev_free_unstr(fptr=t)
call dev_free_unstr(fptr=tn)
