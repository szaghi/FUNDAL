   subroutine TEST_KKP(init_value)
   !< Test KKP kind.
   VARTYPE(KKP), intent(in), optional :: init_value                !< Initial value.
   VARTYPE(KKP), pointer              :: a1(:)=>null()             !< Array on device memory, lbound=[1].
   VARTYPE(KKP), pointer              :: a2(:,:)=>null()           !< Array on device memory, lbound=[1,1].
   VARTYPE(KKP), pointer              :: a3(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
   VARTYPE(KKP), pointer              :: a4(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
   VARTYPE(KKP), pointer              :: a5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
   VARTYPE(KKP), pointer              :: a6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
   VARTYPE(KKP), pointer              :: a7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
   VARTYPE(KKP), pointer              :: b1(:)=>null()             !< Array on device memory, lbound=[-1].
   VARTYPE(KKP), pointer              :: b2(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
   VARTYPE(KKP), pointer              :: b3(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
   VARTYPE(KKP), pointer              :: b4(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
   VARTYPE(KKP), pointer              :: b5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
   VARTYPE(KKP), pointer              :: b6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
   VARTYPE(KKP), pointer              :: b7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   VARTYPE(KKP), allocatable          :: a1_h(:)                   !< Array on host memory, lbound=[1].
   VARTYPE(KKP), allocatable          :: a2_h(:,:)                 !< Array on host memory, lbound=[1,1].
   VARTYPE(KKP), allocatable          :: a3_h(:,:,:)               !< Array on host memory, lbound=[1,1,1].
   VARTYPE(KKP), allocatable          :: a4_h(:,:,:,:)             !< Array on host memory, lbound=[1,1,1,1].
   VARTYPE(KKP), allocatable          :: a5_h(:,:,:,:,:)           !< Array on host memory, lbound=[1,1,1,1,1].
   VARTYPE(KKP), allocatable          :: a6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[1,1,1,1,1,1].
   VARTYPE(KKP), allocatable          :: a7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[1,1,1,1,1,1,1].
   VARTYPE(KKP), allocatable          :: b1_h(:)                   !< Array on host memory, lbound=[-1].
   VARTYPE(KKP), allocatable          :: b2_h(:,:)                 !< Array on host memory, lbound=[-1,-2].
   VARTYPE(KKP), allocatable          :: b3_h(:,:,:)               !< Array on host memory, lbound=[-1,-2,-3].
   VARTYPE(KKP), allocatable          :: b4_h(:,:,:,:)             !< Array on host memory, lbound=[-1,-2,-3,-4].
   VARTYPE(KKP), allocatable          :: b5_h(:,:,:,:,:)           !< Array on host memory, lbound=[-1,-2,-3,-4,-5].
   VARTYPE(KKP), allocatable          :: b6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6].
   VARTYPE(KKP), allocatable          :: b7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P)                       :: ierr                      !< Error status.
   integer(I4P)                       :: lbounds1(1), ubounds1(1)  !< Bounds, 1D.
   integer(I4P)                       :: lbounds2(2), ubounds2(2)  !< Bounds, 2D.
   integer(I4P)                       :: lbounds3(3), ubounds3(3)  !< Bounds, 3D.
   integer(I4P)                       :: lbounds4(4), ubounds4(4)  !< Bounds, 4D.
   integer(I4P)                       :: lbounds5(5), ubounds5(5)  !< Bounds, 5D.
   integer(I4P)                       :: lbounds6(6), ubounds6(6)  !< Bounds, 6D.
   integer(I4P)                       :: lbounds7(7), ubounds7(7)  !< Bounds, 7D.

   print '(A)', ECHO_KKP
   lbounds1=[-1                  ] ; ubounds1=[1            ]
   lbounds2=[-1,-2               ] ; ubounds2=[1,2          ]
   lbounds3=[-1,-2,-3            ] ; ubounds3=[1,2,3        ]
   lbounds4=[-1,-2,-3,-4         ] ; ubounds4=[1,2,3,4      ]
   lbounds5=[-1,-2,-3,-4,-5      ] ; ubounds5=[1,2,3,4,5    ]
   lbounds6=[-1,-2,-3,-4,-5,-6   ] ; ubounds6=[1,2,3,4,5,6  ]
   lbounds7=[-1,-2,-3,-4,-5,-6,-7] ; ubounds7=[1,2,3,4,5,6,7]
   allocate(a1_h( 1:1                              ))
   allocate(a2_h( 1:1, 1:2                         ))
   allocate(a3_h( 1:1, 1:2, 1:3                    ))
   allocate(a4_h( 1:1, 1:2, 1:3, 1:4               ))
   allocate(a5_h( 1:1, 1:2, 1:3, 1:4, 1:5          ))
   allocate(a6_h( 1:1, 1:2, 1:3, 1:4, 1:5, 1:6     ))
   allocate(a7_h( 1:1, 1:2, 1:3, 1:4, 1:5, 1:6, 1:7))
   allocate(b1_h(-1:1                              ))
   allocate(b2_h(-1:1,-2:2                         ))
   allocate(b3_h(-1:1,-2:2,-3:3                    ))
   allocate(b4_h(-1:1,-2:2,-3:3,-4:4               ))
   allocate(b5_h(-1:1,-2:2,-3:3,-4:4,-5:5          ))
   allocate(b6_h(-1:1,-2:2,-3:3,-4:4,-5:5,-6:6     ))
   allocate(b7_h(-1:1,-2:2,-3:3,-4:4,-5:5,-6:6,-7:7))
   if (present(init_value)) then
      print '(A)', '    test dev_alloc with initial value'
   else
      print '(A)', '    test dev_alloc without initial value'
   endif
   call dev_alloc(fptr_dev=a1,                 ubounds=ubounds1,ierr=ierr,init_value=init_value) ; call error_print(ierr,'a1')
   call dev_alloc(fptr_dev=a2,                 ubounds=ubounds2,ierr=ierr,init_value=init_value) ; call error_print(ierr,'a2')
   call dev_alloc(fptr_dev=a3,                 ubounds=ubounds3,ierr=ierr,init_value=init_value) ; call error_print(ierr,'a3')
   call dev_alloc(fptr_dev=a4,                 ubounds=ubounds4,ierr=ierr,init_value=init_value) ; call error_print(ierr,'a4')
   call dev_alloc(fptr_dev=a5,                 ubounds=ubounds5,ierr=ierr,init_value=init_value) ; call error_print(ierr,'a5')
   call dev_alloc(fptr_dev=a6,                 ubounds=ubounds6,ierr=ierr,init_value=init_value) ; call error_print(ierr,'a6')
   call dev_alloc(fptr_dev=a7,                 ubounds=ubounds7,ierr=ierr,init_value=init_value) ; call error_print(ierr,'a7')
   call dev_alloc(fptr_dev=b1,lbounds=lbounds1,ubounds=ubounds1,ierr=ierr,init_value=init_value) ; call error_print(ierr,'b1')
   call dev_alloc(fptr_dev=b2,lbounds=lbounds2,ubounds=ubounds2,ierr=ierr,init_value=init_value) ; call error_print(ierr,'b2')
   call dev_alloc(fptr_dev=b3,lbounds=lbounds3,ubounds=ubounds3,ierr=ierr,init_value=init_value) ; call error_print(ierr,'b3')
   call dev_alloc(fptr_dev=b4,lbounds=lbounds4,ubounds=ubounds4,ierr=ierr,init_value=init_value) ; call error_print(ierr,'b4')
   call dev_alloc(fptr_dev=b5,lbounds=lbounds5,ubounds=ubounds5,ierr=ierr,init_value=init_value) ; call error_print(ierr,'b5')
   call dev_alloc(fptr_dev=b6,lbounds=lbounds6,ubounds=ubounds6,ierr=ierr,init_value=init_value) ; call error_print(ierr,'b6')
   call dev_alloc(fptr_dev=b7,lbounds=lbounds7,ubounds=ubounds7,ierr=ierr,init_value=init_value) ; call error_print(ierr,'b7')
   print '("    a1 bounds: [",1(i2,X),"]/[",1(i2,X),"]")', lbound(a1), ubound(a1)
   print '("    a2 bounds: [",2(i2,X),"]/[",2(i2,X),"]")', lbound(a2), ubound(a2)
   print '("    a3 bounds: [",3(i2,X),"]/[",3(i2,X),"]")', lbound(a3), ubound(a3)
   print '("    a4 bounds: [",4(i2,X),"]/[",4(i2,X),"]")', lbound(a4), ubound(a4)
   print '("    a5 bounds: [",5(i2,X),"]/[",5(i2,X),"]")', lbound(a5), ubound(a5)
   print '("    a6 bounds: [",6(i2,X),"]/[",6(i2,X),"]")', lbound(a6), ubound(a6)
   print '("    a7 bounds: [",7(i2,X),"]/[",7(i2,X),"]")', lbound(a7), ubound(a7)
   print '("    b1 bounds: [",1(i2,X),"]/[",1(i2,X),"]")', lbound(b1), ubound(b1)
   print '("    b2 bounds: [",2(i2,X),"]/[",2(i2,X),"]")', lbound(b2), ubound(b2)
   print '("    b3 bounds: [",3(i2,X),"]/[",3(i2,X),"]")', lbound(b3), ubound(b3)
   print '("    b4 bounds: [",4(i2,X),"]/[",4(i2,X),"]")', lbound(b4), ubound(b4)
   print '("    b5 bounds: [",5(i2,X),"]/[",5(i2,X),"]")', lbound(b5), ubound(b5)
   print '("    b6 bounds: [",6(i2,X),"]/[",6(i2,X),"]")', lbound(b6), ubound(b6)
   print '("    b7 bounds: [",7(i2,X),"]/[",7(i2,X),"]")', lbound(b7), ubound(b7)
   if (present(init_value)) then
      call dev_memcpy_from_device(src=a1, dst=a1_h)
      call dev_memcpy_from_device(src=a2, dst=a2_h)
      call dev_memcpy_from_device(src=a3, dst=a3_h)
      call dev_memcpy_from_device(src=a4, dst=a4_h)
      call dev_memcpy_from_device(src=a5, dst=a5_h)
      call dev_memcpy_from_device(src=a6, dst=a6_h)
      call dev_memcpy_from_device(src=a7, dst=a7_h)
      call dev_memcpy_from_device(src=b1, dst=b1_h)
      call dev_memcpy_from_device(src=b2, dst=b2_h)
      call dev_memcpy_from_device(src=b3, dst=b3_h)
      call dev_memcpy_from_device(src=b4, dst=b4_h)
      call dev_memcpy_from_device(src=b5, dst=b5_h)
      call dev_memcpy_from_device(src=b6, dst=b6_h)
      call dev_memcpy_from_device(src=b7, dst=b7_h)
      print '("    a1 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b7_h)
   endif
   print '(A)', '    test dev_free'
   call dev_free(a1,dev_id=mydev)
   call dev_free(a2,dev_id=mydev)
   call dev_free(a3,dev_id=mydev)
   call dev_free(a4,dev_id=mydev)
   call dev_free(a5,dev_id=mydev)
   call dev_free(a6,dev_id=mydev)
   call dev_free(a7,dev_id=mydev)
   call dev_free(b1,dev_id=mydev)
   call dev_free(b2,dev_id=mydev)
   call dev_free(b3,dev_id=mydev)
   call dev_free(b4,dev_id=mydev)
   call dev_free(b5,dev_id=mydev)
   call dev_free(b6,dev_id=mydev)
   call dev_free(b7,dev_id=mydev)
   print '(A)', '    test dev_alloc_unstr'
   call dev_alloc_unstr(a1_h,init_value=init_value)
   call dev_alloc_unstr(a2_h,init_value=init_value)
   call dev_alloc_unstr(a3_h,init_value=init_value)
   call dev_alloc_unstr(a4_h,init_value=init_value)
   call dev_alloc_unstr(a5_h,init_value=init_value)
   call dev_alloc_unstr(a6_h,init_value=init_value)
   call dev_alloc_unstr(a7_h,init_value=init_value)
   call dev_alloc_unstr(b1_h,init_value=init_value)
   call dev_alloc_unstr(b2_h,init_value=init_value)
   call dev_alloc_unstr(b3_h,init_value=init_value)
   call dev_alloc_unstr(b4_h,init_value=init_value)
   call dev_alloc_unstr(b5_h,init_value=init_value)
   call dev_alloc_unstr(b6_h,init_value=init_value)
   call dev_alloc_unstr(b7_h,init_value=init_value)
   if (present(init_value)) then
      call dev_memcpy_from_device_unstr(a1_h)
      call dev_memcpy_from_device_unstr(a2_h)
      call dev_memcpy_from_device_unstr(a3_h)
      call dev_memcpy_from_device_unstr(a4_h)
      call dev_memcpy_from_device_unstr(a5_h)
      call dev_memcpy_from_device_unstr(a6_h)
      call dev_memcpy_from_device_unstr(a7_h)
      call dev_memcpy_from_device_unstr(b1_h)
      call dev_memcpy_from_device_unstr(b2_h)
      call dev_memcpy_from_device_unstr(b3_h)
      call dev_memcpy_from_device_unstr(b4_h)
      call dev_memcpy_from_device_unstr(b5_h)
      call dev_memcpy_from_device_unstr(b6_h)
      call dev_memcpy_from_device_unstr(b7_h)
      print '("    a1 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1('//FORMATKKP//',X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1('//FORMATKKP//',X),"]")', maxval(b7_h)
   endif
   print '(A)', '    test dev_free_unstr'
   call dev_free_unstr(a1_h)
   call dev_free_unstr(b1_h)
   call dev_free_unstr(a2_h)
   call dev_free_unstr(b2_h)
   call dev_free_unstr(a3_h)
   call dev_free_unstr(b3_h)
   call dev_free_unstr(a4_h)
   call dev_free_unstr(b4_h)
   call dev_free_unstr(a5_h)
   call dev_free_unstr(b5_h)
   call dev_free_unstr(a6_h)
   call dev_free_unstr(b6_h)
   call dev_free_unstr(a7_h)
   call dev_free_unstr(b7_h)
   endsubroutine TEST_KKP
