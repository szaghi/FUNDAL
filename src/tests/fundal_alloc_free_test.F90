!< FUNDAL, device memory alloc test.
program fundal_alloc_free_test
!< FUNDAL, device memory alloc test.

use, intrinsic :: iso_fortran_env, only : I1P=>int8, I2P=>int16, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: fundal

implicit none

call dev_init
call test_R8P
call test_R8P(init_value=8._R8P)
call test_R4P
call test_R4P(init_value=4._R4P)
call test_I8P
call test_I8P(init_value=8_I8P)
call test_I4P
call test_I4P(init_value=4_I4P)
call test_I2P
call test_I2P(init_value=2_I2P)
call test_I1P
call test_I1P(init_value=1_I1P)

print '(A)', 'test passed'

contains
   subroutine error_print(error, msg)
   !< Print error message.
   integer(I4P), intent(in) :: error !< Error status.
   character(*), intent(in) :: msg   !< Error message.

   if (error /= 0) then
      print '(A)', 'error: '//trim(adjustl(msg))//' not allocated!'
      stop
   endif
   endsubroutine error_print

   subroutine test_R8P(init_value)
   !< Test R8P kind.
   real(R8P), intent(in), optional :: init_value                !< Initial value.
   real(R8P), pointer              :: a1(:)=>null()             !< Array on device memory, lbound=[1].
   real(R8P), pointer              :: a2(:,:)=>null()           !< Array on device memory, lbound=[1,1].
   real(R8P), pointer              :: a3(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
   real(R8P), pointer              :: a4(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
   real(R8P), pointer              :: a5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
   real(R8P), pointer              :: a6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
   real(R8P), pointer              :: a7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
   real(R8P), pointer              :: b1(:)=>null()             !< Array on device memory, lbound=[-1].
   real(R8P), pointer              :: b2(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
   real(R8P), pointer              :: b3(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
   real(R8P), pointer              :: b4(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
   real(R8P), pointer              :: b5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
   real(R8P), pointer              :: b6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
   real(R8P), pointer              :: b7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   real(R8P), allocatable          :: a1_h(:)                   !< Array on host memory, lbound=[1].
   real(R8P), allocatable          :: a2_h(:,:)                 !< Array on host memory, lbound=[1,1].
   real(R8P), allocatable          :: a3_h(:,:,:)               !< Array on host memory, lbound=[1,1,1].
   real(R8P), allocatable          :: a4_h(:,:,:,:)             !< Array on host memory, lbound=[1,1,1,1].
   real(R8P), allocatable          :: a5_h(:,:,:,:,:)           !< Array on host memory, lbound=[1,1,1,1,1].
   real(R8P), allocatable          :: a6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[1,1,1,1,1,1].
   real(R8P), allocatable          :: a7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[1,1,1,1,1,1,1].
   real(R8P), allocatable          :: b1_h(:)                   !< Array on host memory, lbound=[-1].
   real(R8P), allocatable          :: b2_h(:,:)                 !< Array on host memory, lbound=[-1,-2].
   real(R8P), allocatable          :: b3_h(:,:,:)               !< Array on host memory, lbound=[-1,-2,-3].
   real(R8P), allocatable          :: b4_h(:,:,:,:)             !< Array on host memory, lbound=[-1,-2,-3,-4].
   real(R8P), allocatable          :: b5_h(:,:,:,:,:)           !< Array on host memory, lbound=[-1,-2,-3,-4,-5].
   real(R8P), allocatable          :: b6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6].
   real(R8P), allocatable          :: b7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P)                    :: ierr                      !< Error status.
   integer(I4P)                    :: lbounds1(1), ubounds1(1)  !< Bounds, 1D.
   integer(I4P)                    :: lbounds2(2), ubounds2(2)  !< Bounds, 2D.
   integer(I4P)                    :: lbounds3(3), ubounds3(3)  !< Bounds, 3D.
   integer(I4P)                    :: lbounds4(4), ubounds4(4)  !< Bounds, 4D.
   integer(I4P)                    :: lbounds5(5), ubounds5(5)  !< Bounds, 5D.
   integer(I4P)                    :: lbounds6(6), ubounds6(6)  !< Bounds, 6D.
   integer(I4P)                    :: lbounds7(7), ubounds7(7)  !< Bounds, 7D.

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
   print '(A)', 'test R8P'
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
      print '("    a1 initial value: [",1(F12.9,X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1(F12.9,X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1(F12.9,X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1(F12.9,X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1(F12.9,X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1(F12.9,X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1(F12.9,X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1(F12.9,X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1(F12.9,X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1(F12.9,X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1(F12.9,X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1(F12.9,X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1(F12.9,X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1(F12.9,X),"]")', maxval(b7_h)
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
      print '("    a1 initial value: [",1(F12.9,X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1(F12.9,X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1(F12.9,X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1(F12.9,X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1(F12.9,X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1(F12.9,X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1(F12.9,X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1(F12.9,X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1(F12.9,X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1(F12.9,X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1(F12.9,X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1(F12.9,X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1(F12.9,X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1(F12.9,X),"]")', maxval(b7_h)
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
   endsubroutine test_R8P

   subroutine test_R4P(init_value)
   !< Test R4P kind.
   real(R4P), intent(in), optional :: init_value                !< Initial value.
   real(R4P), pointer              :: a1(:)=>null()             !< Array on device memory, lbound=[1].
   real(R4P), pointer              :: a2(:,:)=>null()           !< Array on device memory, lbound=[1,1].
   real(R4P), pointer              :: a3(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
   real(R4P), pointer              :: a4(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
   real(R4P), pointer              :: a5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
   real(R4P), pointer              :: a6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
   real(R4P), pointer              :: a7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
   real(R4P), pointer              :: b1(:)=>null()             !< Array on device memory, lbound=[-1].
   real(R4P), pointer              :: b2(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
   real(R4P), pointer              :: b3(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
   real(R4P), pointer              :: b4(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
   real(R4P), pointer              :: b5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
   real(R4P), pointer              :: b6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
   real(R4P), pointer              :: b7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   real(R4P), allocatable          :: a1_h(:)                   !< Array on host memory, lbound=[1].
   real(R4P), allocatable          :: a2_h(:,:)                 !< Array on host memory, lbound=[1,1].
   real(R4P), allocatable          :: a3_h(:,:,:)               !< Array on host memory, lbound=[1,1,1].
   real(R4P), allocatable          :: a4_h(:,:,:,:)             !< Array on host memory, lbound=[1,1,1,1].
   real(R4P), allocatable          :: a5_h(:,:,:,:,:)           !< Array on host memory, lbound=[1,1,1,1,1].
   real(R4P), allocatable          :: a6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[1,1,1,1,1,1].
   real(R4P), allocatable          :: a7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[1,1,1,1,1,1,1].
   real(R4P), allocatable          :: b1_h(:)                   !< Array on host memory, lbound=[-1].
   real(R4P), allocatable          :: b2_h(:,:)                 !< Array on host memory, lbound=[-1,-2].
   real(R4P), allocatable          :: b3_h(:,:,:)               !< Array on host memory, lbound=[-1,-2,-3].
   real(R4P), allocatable          :: b4_h(:,:,:,:)             !< Array on host memory, lbound=[-1,-2,-3,-4].
   real(R4P), allocatable          :: b5_h(:,:,:,:,:)           !< Array on host memory, lbound=[-1,-2,-3,-4,-5].
   real(R4P), allocatable          :: b6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6].
   real(R4P), allocatable          :: b7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P)                    :: ierr                      !< Error status.
   integer(I4P)                    :: lbounds1(1), ubounds1(1)  !< Bounds, 1D.
   integer(I4P)                    :: lbounds2(2), ubounds2(2)  !< Bounds, 2D.
   integer(I4P)                    :: lbounds3(3), ubounds3(3)  !< Bounds, 3D.
   integer(I4P)                    :: lbounds4(4), ubounds4(4)  !< Bounds, 4D.
   integer(I4P)                    :: lbounds5(5), ubounds5(5)  !< Bounds, 5D.
   integer(I4P)                    :: lbounds6(6), ubounds6(6)  !< Bounds, 6D.
   integer(I4P)                    :: lbounds7(7), ubounds7(7)  !< Bounds, 7D.

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
   print '(A)', 'test R4P'
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
      print '("    a1 initial value: [",1(F12.9,X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1(F12.9,X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1(F12.9,X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1(F12.9,X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1(F12.9,X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1(F12.9,X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1(F12.9,X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1(F12.9,X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1(F12.9,X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1(F12.9,X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1(F12.9,X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1(F12.9,X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1(F12.9,X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1(F12.9,X),"]")', maxval(b7_h)
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
      print '("    a1 initial value: [",1(F12.9,X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1(F12.9,X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1(F12.9,X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1(F12.9,X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1(F12.9,X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1(F12.9,X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1(F12.9,X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1(F12.9,X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1(F12.9,X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1(F12.9,X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1(F12.9,X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1(F12.9,X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1(F12.9,X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1(F12.9,X),"]")', maxval(b7_h)
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
   endsubroutine test_R4P

   subroutine test_I8P(init_value)
   !< Test I8P kind.
   integer(I8P), intent(in), optional :: init_value                !< Initial value.
   integer(I8P), pointer              :: a1(:)=>null()             !< Array on device memory, lbound=[1].
   integer(I8P), pointer              :: a2(:,:)=>null()           !< Array on device memory, lbound=[1,1].
   integer(I8P), pointer              :: a3(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
   integer(I8P), pointer              :: a4(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
   integer(I8P), pointer              :: a5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
   integer(I8P), pointer              :: a6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
   integer(I8P), pointer              :: a7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
   integer(I8P), pointer              :: b1(:)=>null()             !< Array on device memory, lbound=[-1].
   integer(I8P), pointer              :: b2(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
   integer(I8P), pointer              :: b3(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
   integer(I8P), pointer              :: b4(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
   integer(I8P), pointer              :: b5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
   integer(I8P), pointer              :: b6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I8P), pointer              :: b7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I8P), allocatable          :: a1_h(:)                   !< Array on host memory, lbound=[1].
   integer(I8P), allocatable          :: a2_h(:,:)                 !< Array on host memory, lbound=[1,1].
   integer(I8P), allocatable          :: a3_h(:,:,:)               !< Array on host memory, lbound=[1,1,1].
   integer(I8P), allocatable          :: a4_h(:,:,:,:)             !< Array on host memory, lbound=[1,1,1,1].
   integer(I8P), allocatable          :: a5_h(:,:,:,:,:)           !< Array on host memory, lbound=[1,1,1,1,1].
   integer(I8P), allocatable          :: a6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[1,1,1,1,1,1].
   integer(I8P), allocatable          :: a7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[1,1,1,1,1,1,1].
   integer(I8P), allocatable          :: b1_h(:)                   !< Array on host memory, lbound=[-1].
   integer(I8P), allocatable          :: b2_h(:,:)                 !< Array on host memory, lbound=[-1,-2].
   integer(I8P), allocatable          :: b3_h(:,:,:)               !< Array on host memory, lbound=[-1,-2,-3].
   integer(I8P), allocatable          :: b4_h(:,:,:,:)             !< Array on host memory, lbound=[-1,-2,-3,-4].
   integer(I8P), allocatable          :: b5_h(:,:,:,:,:)           !< Array on host memory, lbound=[-1,-2,-3,-4,-5].
   integer(I8P), allocatable          :: b6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I8P), allocatable          :: b7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P)                       :: ierr                      !< Error status.
   integer(I4P)                       :: lbounds1(1), ubounds1(1)  !< Bounds, 1D.
   integer(I4P)                       :: lbounds2(2), ubounds2(2)  !< Bounds, 2D.
   integer(I4P)                       :: lbounds3(3), ubounds3(3)  !< Bounds, 3D.
   integer(I4P)                       :: lbounds4(4), ubounds4(4)  !< Bounds, 4D.
   integer(I4P)                       :: lbounds5(5), ubounds5(5)  !< Bounds, 5D.
   integer(I4P)                       :: lbounds6(6), ubounds6(6)  !< Bounds, 6D.
   integer(I4P)                       :: lbounds7(7), ubounds7(7)  !< Bounds, 7D.

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
   print '(A)', 'test I8P'
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
      print '("    a1 initial value: [",1(I3,X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1(I3,X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1(I3,X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1(I3,X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1(I3,X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1(I3,X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1(I3,X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1(I3,X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1(I3,X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1(I3,X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1(I3,X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1(I3,X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1(I3,X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1(I3,X),"]")', maxval(b7_h)
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
      print '("    a1 initial value: [",1(I3,X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1(I3,X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1(I3,X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1(I3,X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1(I3,X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1(I3,X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1(I3,X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1(I3,X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1(I3,X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1(I3,X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1(I3,X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1(I3,X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1(I3,X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1(I3,X),"]")', maxval(b7_h)
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
   endsubroutine test_I8P

   subroutine test_I4P(init_value)
   !< Test I4P kind.
   integer(I4P), intent(in), optional :: init_value                !< Initial value.
   integer(I4P), pointer              :: a1(:)=>null()             !< Array on device memory, lbound=[1].
   integer(I4P), pointer              :: a2(:,:)=>null()           !< Array on device memory, lbound=[1,1].
   integer(I4P), pointer              :: a3(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
   integer(I4P), pointer              :: a4(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
   integer(I4P), pointer              :: a5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
   integer(I4P), pointer              :: a6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
   integer(I4P), pointer              :: a7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
   integer(I4P), pointer              :: b1(:)=>null()             !< Array on device memory, lbound=[-1].
   integer(I4P), pointer              :: b2(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
   integer(I4P), pointer              :: b3(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
   integer(I4P), pointer              :: b4(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
   integer(I4P), pointer              :: b5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
   integer(I4P), pointer              :: b6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I4P), pointer              :: b7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P), allocatable          :: a1_h(:)                   !< Array on host memory, lbound=[1].
   integer(I4P), allocatable          :: a2_h(:,:)                 !< Array on host memory, lbound=[1,1].
   integer(I4P), allocatable          :: a3_h(:,:,:)               !< Array on host memory, lbound=[1,1,1].
   integer(I4P), allocatable          :: a4_h(:,:,:,:)             !< Array on host memory, lbound=[1,1,1,1].
   integer(I4P), allocatable          :: a5_h(:,:,:,:,:)           !< Array on host memory, lbound=[1,1,1,1,1].
   integer(I4P), allocatable          :: a6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[1,1,1,1,1,1].
   integer(I4P), allocatable          :: a7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[1,1,1,1,1,1,1].
   integer(I4P), allocatable          :: b1_h(:)                   !< Array on host memory, lbound=[-1].
   integer(I4P), allocatable          :: b2_h(:,:)                 !< Array on host memory, lbound=[-1,-2].
   integer(I4P), allocatable          :: b3_h(:,:,:)               !< Array on host memory, lbound=[-1,-2,-3].
   integer(I4P), allocatable          :: b4_h(:,:,:,:)             !< Array on host memory, lbound=[-1,-2,-3,-4].
   integer(I4P), allocatable          :: b5_h(:,:,:,:,:)           !< Array on host memory, lbound=[-1,-2,-3,-4,-5].
   integer(I4P), allocatable          :: b6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I4P), allocatable          :: b7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P)                       :: ierr                      !< Error status.
   integer(I4P)                       :: lbounds1(1), ubounds1(1)  !< Bounds, 1D.
   integer(I4P)                       :: lbounds2(2), ubounds2(2)  !< Bounds, 2D.
   integer(I4P)                       :: lbounds3(3), ubounds3(3)  !< Bounds, 3D.
   integer(I4P)                       :: lbounds4(4), ubounds4(4)  !< Bounds, 4D.
   integer(I4P)                       :: lbounds5(5), ubounds5(5)  !< Bounds, 5D.
   integer(I4P)                       :: lbounds6(6), ubounds6(6)  !< Bounds, 6D.
   integer(I4P)                       :: lbounds7(7), ubounds7(7)  !< Bounds, 7D.

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
   print '(A)', 'test I4P'
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
      print '("    a1 initial value: [",1(I3,X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1(I3,X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1(I3,X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1(I3,X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1(I3,X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1(I3,X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1(I3,X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1(I3,X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1(I3,X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1(I3,X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1(I3,X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1(I3,X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1(I3,X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1(I3,X),"]")', maxval(b7_h)
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
      print '("    a1 initial value: [",1(I3,X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1(I3,X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1(I3,X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1(I3,X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1(I3,X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1(I3,X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1(I3,X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1(I3,X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1(I3,X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1(I3,X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1(I3,X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1(I3,X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1(I3,X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1(I3,X),"]")', maxval(b7_h)
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
   endsubroutine test_I4P

   subroutine test_I2P(init_value)
   !< Test I2P kind.
   integer(I2P), intent(in), optional :: init_value                !< Initial value.
   integer(I2P), pointer              :: a1(:)=>null()             !< Array on device memory, lbound=[1].
   integer(I2P), pointer              :: a2(:,:)=>null()           !< Array on device memory, lbound=[1,1].
   integer(I2P), pointer              :: a3(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
   integer(I2P), pointer              :: a4(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
   integer(I2P), pointer              :: a5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
   integer(I2P), pointer              :: a6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
   integer(I2P), pointer              :: a7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
   integer(I2P), pointer              :: b1(:)=>null()             !< Array on device memory, lbound=[-1].
   integer(I2P), pointer              :: b2(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
   integer(I2P), pointer              :: b3(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
   integer(I2P), pointer              :: b4(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
   integer(I2P), pointer              :: b5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
   integer(I2P), pointer              :: b6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I2P), pointer              :: b7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I2P), allocatable          :: a1_h(:)                   !< Array on host memory, lbound=[1].
   integer(I2P), allocatable          :: a2_h(:,:)                 !< Array on host memory, lbound=[1,1].
   integer(I2P), allocatable          :: a3_h(:,:,:)               !< Array on host memory, lbound=[1,1,1].
   integer(I2P), allocatable          :: a4_h(:,:,:,:)             !< Array on host memory, lbound=[1,1,1,1].
   integer(I2P), allocatable          :: a5_h(:,:,:,:,:)           !< Array on host memory, lbound=[1,1,1,1,1].
   integer(I2P), allocatable          :: a6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[1,1,1,1,1,1].
   integer(I2P), allocatable          :: a7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[1,1,1,1,1,1,1].
   integer(I2P), allocatable          :: b1_h(:)                   !< Array on host memory, lbound=[-1].
   integer(I2P), allocatable          :: b2_h(:,:)                 !< Array on host memory, lbound=[-1,-2].
   integer(I2P), allocatable          :: b3_h(:,:,:)               !< Array on host memory, lbound=[-1,-2,-3].
   integer(I2P), allocatable          :: b4_h(:,:,:,:)             !< Array on host memory, lbound=[-1,-2,-3,-4].
   integer(I2P), allocatable          :: b5_h(:,:,:,:,:)           !< Array on host memory, lbound=[-1,-2,-3,-4,-5].
   integer(I2P), allocatable          :: b6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I2P), allocatable          :: b7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P)                       :: ierr                      !< Error status.
   integer(I4P)                       :: lbounds1(1), ubounds1(1)  !< Bounds, 1D.
   integer(I4P)                       :: lbounds2(2), ubounds2(2)  !< Bounds, 2D.
   integer(I4P)                       :: lbounds3(3), ubounds3(3)  !< Bounds, 3D.
   integer(I4P)                       :: lbounds4(4), ubounds4(4)  !< Bounds, 4D.
   integer(I4P)                       :: lbounds5(5), ubounds5(5)  !< Bounds, 5D.
   integer(I4P)                       :: lbounds6(6), ubounds6(6)  !< Bounds, 6D.
   integer(I4P)                       :: lbounds7(7), ubounds7(7)  !< Bounds, 7D.

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
   print '(A)', 'test I2P'
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
      print '("    a1 initial value: [",1(I3,X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1(I3,X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1(I3,X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1(I3,X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1(I3,X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1(I3,X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1(I3,X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1(I3,X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1(I3,X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1(I3,X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1(I3,X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1(I3,X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1(I3,X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1(I3,X),"]")', maxval(b7_h)
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
      print '("    a1 initial value: [",1(I3,X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1(I3,X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1(I3,X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1(I3,X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1(I3,X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1(I3,X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1(I3,X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1(I3,X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1(I3,X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1(I3,X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1(I3,X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1(I3,X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1(I3,X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1(I3,X),"]")', maxval(b7_h)
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
   endsubroutine test_I2P

   subroutine test_I1P(init_value)
   !< Test I8P kind.
   integer(I1P), intent(in), optional :: init_value                !< Initial value.
   integer(I1P), pointer              :: a1(:)=>null()             !< Array on device memory, lbound=[1].
   integer(I1P), pointer              :: a2(:,:)=>null()           !< Array on device memory, lbound=[1,1].
   integer(I1P), pointer              :: a3(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
   integer(I1P), pointer              :: a4(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
   integer(I1P), pointer              :: a5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
   integer(I1P), pointer              :: a6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
   integer(I1P), pointer              :: a7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
   integer(I1P), pointer              :: b1(:)=>null()             !< Array on device memory, lbound=[-1].
   integer(I1P), pointer              :: b2(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
   integer(I1P), pointer              :: b3(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
   integer(I1P), pointer              :: b4(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
   integer(I1P), pointer              :: b5(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
   integer(I1P), pointer              :: b6(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I1P), pointer              :: b7(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I1P), allocatable          :: a1_h(:)                   !< Array on host memory, lbound=[1].
   integer(I1P), allocatable          :: a2_h(:,:)                 !< Array on host memory, lbound=[1,1].
   integer(I1P), allocatable          :: a3_h(:,:,:)               !< Array on host memory, lbound=[1,1,1].
   integer(I1P), allocatable          :: a4_h(:,:,:,:)             !< Array on host memory, lbound=[1,1,1,1].
   integer(I1P), allocatable          :: a5_h(:,:,:,:,:)           !< Array on host memory, lbound=[1,1,1,1,1].
   integer(I1P), allocatable          :: a6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[1,1,1,1,1,1].
   integer(I1P), allocatable          :: a7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[1,1,1,1,1,1,1].
   integer(I1P), allocatable          :: b1_h(:)                   !< Array on host memory, lbound=[-1].
   integer(I1P), allocatable          :: b2_h(:,:)                 !< Array on host memory, lbound=[-1,-2].
   integer(I1P), allocatable          :: b3_h(:,:,:)               !< Array on host memory, lbound=[-1,-2,-3].
   integer(I1P), allocatable          :: b4_h(:,:,:,:)             !< Array on host memory, lbound=[-1,-2,-3,-4].
   integer(I1P), allocatable          :: b5_h(:,:,:,:,:)           !< Array on host memory, lbound=[-1,-2,-3,-4,-5].
   integer(I1P), allocatable          :: b6_h(:,:,:,:,:,:)         !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I1P), allocatable          :: b7_h(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P)                       :: ierr                      !< Error status.
   integer(I4P)                       :: lbounds1(1), ubounds1(1)  !< Bounds, 1D.
   integer(I4P)                       :: lbounds2(2), ubounds2(2)  !< Bounds, 2D.
   integer(I4P)                       :: lbounds3(3), ubounds3(3)  !< Bounds, 3D.
   integer(I4P)                       :: lbounds4(4), ubounds4(4)  !< Bounds, 4D.
   integer(I4P)                       :: lbounds5(5), ubounds5(5)  !< Bounds, 5D.
   integer(I4P)                       :: lbounds6(6), ubounds6(6)  !< Bounds, 6D.
   integer(I4P)                       :: lbounds7(7), ubounds7(7)  !< Bounds, 7D.

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
   print '(A)', 'test I1P'
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
      print '("    a1 initial value: [",1(I3,X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1(I3,X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1(I3,X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1(I3,X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1(I3,X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1(I3,X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1(I3,X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1(I3,X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1(I3,X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1(I3,X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1(I3,X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1(I3,X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1(I3,X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1(I3,X),"]")', maxval(b7_h)
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
      print '("    a1 initial value: [",1(I3,X),"]")', maxval(a1_h)
      print '("    a2 initial value: [",1(I3,X),"]")', maxval(a2_h)
      print '("    a3 initial value: [",1(I3,X),"]")', maxval(a3_h)
      print '("    a4 initial value: [",1(I3,X),"]")', maxval(a4_h)
      print '("    a5 initial value: [",1(I3,X),"]")', maxval(a5_h)
      print '("    a6 initial value: [",1(I3,X),"]")', maxval(a6_h)
      print '("    a7 initial value: [",1(I3,X),"]")', maxval(a7_h)
      print '("    b1 initial value: [",1(I3,X),"]")', maxval(b1_h)
      print '("    b2 initial value: [",1(I3,X),"]")', maxval(b2_h)
      print '("    b3 initial value: [",1(I3,X),"]")', maxval(b3_h)
      print '("    b4 initial value: [",1(I3,X),"]")', maxval(b4_h)
      print '("    b5 initial value: [",1(I3,X),"]")', maxval(b5_h)
      print '("    b6 initial value: [",1(I3,X),"]")', maxval(b6_h)
      print '("    b7 initial value: [",1(I3,X),"]")', maxval(b7_h)
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
   endsubroutine test_I1P
endprogram fundal_alloc_free_test
