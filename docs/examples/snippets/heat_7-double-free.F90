if (double_free) then ! the buffer of alias has already been freed through t_dev
   call dev_free(alias, ierr=ierr)
   if (ierr == FUNDAL_ERR_NOT_REGISTERED) then
      print '(A,I0,A)', 'dev_free(alias): error ', ierr, ', not a live FUNDAL allocation, nothing freed'
      stop 1
   endif
endif
