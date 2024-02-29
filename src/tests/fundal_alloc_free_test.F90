!< FUNDAL, device memory alloc test.
program fundal_alloc_free_test
!< FUNDAL, device memory alloc test.

use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: fundal

implicit none

! initialize device
myhos = dev_get_host_num()
mydev = dev_get_device_num()
call dev_init_device(dev_num=mydev)

call test_R8P
call test_R8P(init_value=8._R8P)
call test_R4P
call test_R4P(init_value=4._R4P)
call test_I8P
call test_I8P(init_value=8_I8P)
call test_I4P
call test_I4P(init_value=4_I4P)
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
   real(R8P), intent(in), optional :: init_value                   !< Initial value.
   real(R8P), pointer              :: a1_R8(:)=>null()             !< Array on device memory, lbound=[1].
   real(R8P), pointer              :: b1_R8(:)=>null()             !< Array on device memory, lbound=[-1].
   real(R8P), pointer              :: a2_R8(:,:)=>null()           !< Array on device memory, lbound=[1,1].
   real(R8P), pointer              :: b2_R8(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
   real(R8P), pointer              :: a3_R8(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
   real(R8P), pointer              :: b3_R8(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
   real(R8P), pointer              :: a4_R8(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
   real(R8P), pointer              :: b4_R8(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
   real(R8P), pointer              :: a5_R8(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
   real(R8P), pointer              :: b5_R8(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
   real(R8P), pointer              :: a6_R8(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
   real(R8P), pointer              :: b6_R8(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
   real(R8P), pointer              :: a7_R8(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
   real(R8P), pointer              :: b7_R8(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   real(R8P), allocatable          :: a1_h_R8(:)                   !< Array on host memory, lbound=[1].
   real(R8P), allocatable          :: b1_h_R8(:)                   !< Array on host memory, lbound=[-1].
   real(R8P), allocatable          :: a2_h_R8(:,:)                 !< Array on host memory, lbound=[1,1].
   real(R8P), allocatable          :: b2_h_R8(:,:)                 !< Array on host memory, lbound=[-1,-2].
   real(R8P), allocatable          :: a3_h_R8(:,:,:)               !< Array on host memory, lbound=[1,1,1].
   real(R8P), allocatable          :: b3_h_R8(:,:,:)               !< Array on host memory, lbound=[-1,-2,-3].
   real(R8P), allocatable          :: a4_h_R8(:,:,:,:)             !< Array on host memory, lbound=[1,1,1,1].
   real(R8P), allocatable          :: b4_h_R8(:,:,:,:)             !< Array on host memory, lbound=[-1,-2,-3,-4].
   real(R8P), allocatable          :: a5_h_R8(:,:,:,:,:)           !< Array on host memory, lbound=[1,1,1,1,1].
   real(R8P), allocatable          :: b5_h_R8(:,:,:,:,:)           !< Array on host memory, lbound=[-1,-2,-3,-4,-5].
   real(R8P), allocatable          :: a6_h_R8(:,:,:,:,:,:)         !< Array on host memory, lbound=[1,1,1,1,1,1].
   real(R8P), allocatable          :: b6_h_R8(:,:,:,:,:,:)         !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6].
   real(R8P), allocatable          :: a7_h_R8(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[1,1,1,1,1,1,1].
   real(R8P), allocatable          :: b7_h_R8(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P)                    :: ierr                         !< Error status.

   if (present(init_value)) then
      print '(A)', 'test dev_alloc R8P with initial value'
      call dev_alloc(fptr_dev=a1_R8,                               ubounds=[1            ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a1_R8')
      call dev_alloc(fptr_dev=b1_R8,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b1_R8')
      call dev_alloc(fptr_dev=a2_R8,                               ubounds=[1,2          ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a2_R8')
      call dev_alloc(fptr_dev=b2_R8,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b2_R8')
      call dev_alloc(fptr_dev=a3_R8,                               ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a3_R8')
      call dev_alloc(fptr_dev=b3_R8,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b3_R8')
      call dev_alloc(fptr_dev=a4_R8,                               ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a4_R8')
      call dev_alloc(fptr_dev=b4_R8,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b4_R8')
      call dev_alloc(fptr_dev=a5_R8,                               ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a5_R8')
      call dev_alloc(fptr_dev=b5_R8,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b5_R8')
      call dev_alloc(fptr_dev=a6_R8,                               ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a6_R8')
      call dev_alloc(fptr_dev=b6_R8,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b6_R8')
      call dev_alloc(fptr_dev=a7_R8,                               ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a7_R8')
      call dev_alloc(fptr_dev=b7_R8,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b7_R8')
   else
      print '(A)', 'test dev_alloc R8P without initial value'
      call dev_alloc(fptr_dev=a1_R8,                               ubounds=[1            ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a1_R8')
      call dev_alloc(fptr_dev=b1_R8,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b1_R8')
      call dev_alloc(fptr_dev=a2_R8,                               ubounds=[1,2          ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a2_R8')
      call dev_alloc(fptr_dev=b2_R8,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b2_R8')
      call dev_alloc(fptr_dev=a3_R8,                               ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a3_R8')
      call dev_alloc(fptr_dev=b3_R8,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b3_R8')
      call dev_alloc(fptr_dev=a4_R8,                               ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a4_R8')
      call dev_alloc(fptr_dev=b4_R8,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b4_R8')
      call dev_alloc(fptr_dev=a5_R8,                               ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a5_R8')
      call dev_alloc(fptr_dev=b5_R8,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b5_R8')
      call dev_alloc(fptr_dev=a6_R8,                               ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a6_R8')
      call dev_alloc(fptr_dev=b6_R8,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b6_R8')
      call dev_alloc(fptr_dev=a7_R8,                               ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a7_R8')
      call dev_alloc(fptr_dev=b7_R8,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b7_R8')
   endif
   print '("a1_R8 bounds: [",1(i2,X),"]/[",1(i2,X),"]")', lbound(a1_R8), ubound(a1_R8)
   print '("b1_R8 bounds: [",1(i2,X),"]/[",1(i2,X),"]")', lbound(b1_R8), ubound(b1_R8)
   print '("a2_R8 bounds: [",2(i2,X),"]/[",2(i2,X),"]")', lbound(a2_R8), ubound(a2_R8)
   print '("b2_R8 bounds: [",2(i2,X),"]/[",2(i2,X),"]")', lbound(b2_R8), ubound(b2_R8)
   print '("a3_R8 bounds: [",3(i2,X),"]/[",3(i2,X),"]")', lbound(a3_R8), ubound(a3_R8)
   print '("b3_R8 bounds: [",3(i2,X),"]/[",3(i2,X),"]")', lbound(b3_R8), ubound(b3_R8)
   print '("a4_R8 bounds: [",4(i2,X),"]/[",4(i2,X),"]")', lbound(a4_R8), ubound(a4_R8)
   print '("b4_R8 bounds: [",4(i2,X),"]/[",4(i2,X),"]")', lbound(b4_R8), ubound(b4_R8)
   print '("a5_R8 bounds: [",5(i2,X),"]/[",5(i2,X),"]")', lbound(a5_R8), ubound(a5_R8)
   print '("b5_R8 bounds: [",5(i2,X),"]/[",5(i2,X),"]")', lbound(b5_R8), ubound(b5_R8)
   print '("a6_R8 bounds: [",6(i2,X),"]/[",6(i2,X),"]")', lbound(a6_R8), ubound(a6_R8)
   print '("b6_R8 bounds: [",6(i2,X),"]/[",6(i2,X),"]")', lbound(b6_R8), ubound(b6_R8)
   print '("a7_R8 bounds: [",7(i2,X),"]/[",7(i2,X),"]")', lbound(a7_R8), ubound(a7_R8)
   print '("b7_R8 bounds: [",7(i2,X),"]/[",7(i2,X),"]")', lbound(b7_R8), ubound(b7_R8)
   if (present(init_value)) then
      allocate(a1_h_R8( 1:1                              )) ; call dev_memcpy_from_device(fptr_src=a1_R8, fptr_dst=a1_h_R8)
      allocate(b1_h_R8(-1:1                              )) ; call dev_memcpy_from_device(fptr_src=b1_R8, fptr_dst=b1_h_R8)
      allocate(a2_h_R8( 1:1, 1:2                         )) ; call dev_memcpy_from_device(fptr_src=a2_R8, fptr_dst=a2_h_R8)
      allocate(b2_h_R8(-1:1,-2:2                         )) ; call dev_memcpy_from_device(fptr_src=b2_R8, fptr_dst=b2_h_R8)
      allocate(a3_h_R8( 1:1, 1:2, 1:3                    )) ; call dev_memcpy_from_device(fptr_src=a3_R8, fptr_dst=a3_h_R8)
      allocate(b3_h_R8(-1:1,-2:2,-3:3                    )) ; call dev_memcpy_from_device(fptr_src=b3_R8, fptr_dst=b3_h_R8)
      allocate(a4_h_R8( 1:1, 1:2, 1:3, 1:4               )) ; call dev_memcpy_from_device(fptr_src=a4_R8, fptr_dst=a4_h_R8)
      allocate(b4_h_R8(-1:1,-2:2,-3:3,-4:4               )) ; call dev_memcpy_from_device(fptr_src=b4_R8, fptr_dst=b4_h_R8)
      allocate(a5_h_R8( 1:1, 1:2, 1:3, 1:4, 1:5          )) ; call dev_memcpy_from_device(fptr_src=a5_R8, fptr_dst=a5_h_R8)
      allocate(b5_h_R8(-1:1,-2:2,-3:3,-4:4,-5:5          )) ; call dev_memcpy_from_device(fptr_src=b5_R8, fptr_dst=b5_h_R8)
      allocate(a6_h_R8( 1:1, 1:2, 1:3, 1:4, 1:5, 1:6     )) ; call dev_memcpy_from_device(fptr_src=a6_R8, fptr_dst=a6_h_R8)
      allocate(b6_h_R8(-1:1,-2:2,-3:3,-4:4,-5:5,-6:6     )) ; call dev_memcpy_from_device(fptr_src=b6_R8, fptr_dst=b6_h_R8)
      allocate(a7_h_R8( 1:1, 1:2, 1:3, 1:4, 1:5, 1:6, 1:7)) ; call dev_memcpy_from_device(fptr_src=a7_R8, fptr_dst=a7_h_R8)
      allocate(b7_h_R8(-1:1,-2:2,-3:3,-4:4,-5:5,-6:6,-7:7)) ; call dev_memcpy_from_device(fptr_src=b7_R8, fptr_dst=b7_h_R8)
      print '("a1_R8 initial value: [",1(F12.9,X),"]")', maxval(a1_h_R8)
      print '("b1_R8 initial value: [",1(F12.9,X),"]")', maxval(b1_h_R8)
      print '("a2_R8 initial value: [",1(F12.9,X),"]")', maxval(a2_h_R8)
      print '("b2_R8 initial value: [",1(F12.9,X),"]")', maxval(b2_h_R8)
      print '("a3_R8 initial value: [",1(F12.9,X),"]")', maxval(a3_h_R8)
      print '("b3_R8 initial value: [",1(F12.9,X),"]")', maxval(b3_h_R8)
      print '("a4_R8 initial value: [",1(F12.9,X),"]")', maxval(a4_h_R8)
      print '("b4_R8 initial value: [",1(F12.9,X),"]")', maxval(b4_h_R8)
      print '("a5_R8 initial value: [",1(F12.9,X),"]")', maxval(a5_h_R8)
      print '("b5_R8 initial value: [",1(F12.9,X),"]")', maxval(b5_h_R8)
      print '("a6_R8 initial value: [",1(F12.9,X),"]")', maxval(a6_h_R8)
      print '("b6_R8 initial value: [",1(F12.9,X),"]")', maxval(b6_h_R8)
      print '("a7_R8 initial value: [",1(F12.9,X),"]")', maxval(a7_h_R8)
      print '("b7_R8 initial value: [",1(F12.9,X),"]")', maxval(b7_h_R8)
   endif
   print '(A)', 'test dev_free R8P'
   call dev_free(a1_R8,dev_id=mydev)
   call dev_free(a2_R8,dev_id=mydev)
   call dev_free(a3_R8,dev_id=mydev)
   call dev_free(a4_R8,dev_id=mydev)
   call dev_free(a5_R8,dev_id=mydev)
   call dev_free(a6_R8,dev_id=mydev)
   call dev_free(a7_R8,dev_id=mydev)
   call dev_free(b1_R8,dev_id=mydev)
   call dev_free(b2_R8,dev_id=mydev)
   call dev_free(b3_R8,dev_id=mydev)
   call dev_free(b4_R8,dev_id=mydev)
   call dev_free(b5_R8,dev_id=mydev)
   call dev_free(b6_R8,dev_id=mydev)
   call dev_free(b7_R8,dev_id=mydev)
   endsubroutine test_R8P

   subroutine test_R4P(init_value)
   !< Test R4P kind.
   real(R4P), intent(in), optional :: init_value                   !< Initial value.
   real(R4P), pointer              :: a1_R4(:)=>null()             !< Array on device memory, lbound=[1].
   real(R4P), pointer              :: b1_R4(:)=>null()             !< Array on device memory, lbound=[-1].
   real(R4P), pointer              :: a2_R4(:,:)=>null()           !< Array on device memory, lbound=[1,1].
   real(R4P), pointer              :: b2_R4(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
   real(R4P), pointer              :: a3_R4(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
   real(R4P), pointer              :: b3_R4(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
   real(R4P), pointer              :: a4_R4(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
   real(R4P), pointer              :: b4_R4(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
   real(R4P), pointer              :: a5_R4(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
   real(R4P), pointer              :: b5_R4(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
   real(R4P), pointer              :: a6_R4(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
   real(R4P), pointer              :: b6_R4(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
   real(R4P), pointer              :: a7_R4(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
   real(R4P), pointer              :: b7_R4(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   real(R4P), allocatable          :: a1_h_R4(:)                   !< Array on host memory, lbound=[1].
   real(R4P), allocatable          :: b1_h_R4(:)                   !< Array on host memory, lbound=[-1].
   real(R4P), allocatable          :: a2_h_R4(:,:)                 !< Array on host memory, lbound=[1,1].
   real(R4P), allocatable          :: b2_h_R4(:,:)                 !< Array on host memory, lbound=[-1,-2].
   real(R4P), allocatable          :: a3_h_R4(:,:,:)               !< Array on host memory, lbound=[1,1,1].
   real(R4P), allocatable          :: b3_h_R4(:,:,:)               !< Array on host memory, lbound=[-1,-2,-3].
   real(R4P), allocatable          :: a4_h_R4(:,:,:,:)             !< Array on host memory, lbound=[1,1,1,1].
   real(R4P), allocatable          :: b4_h_R4(:,:,:,:)             !< Array on host memory, lbound=[-1,-2,-3,-4].
   real(R4P), allocatable          :: a5_h_R4(:,:,:,:,:)           !< Array on host memory, lbound=[1,1,1,1,1].
   real(R4P), allocatable          :: b5_h_R4(:,:,:,:,:)           !< Array on host memory, lbound=[-1,-2,-3,-4,-5].
   real(R4P), allocatable          :: a6_h_R4(:,:,:,:,:,:)         !< Array on host memory, lbound=[1,1,1,1,1,1].
   real(R4P), allocatable          :: b6_h_R4(:,:,:,:,:,:)         !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6].
   real(R4P), allocatable          :: a7_h_R4(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[1,1,1,1,1,1,1].
   real(R4P), allocatable          :: b7_h_R4(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P)                    :: ierr                         !< Error status.

   if (present(init_value)) then
      print '(A)', 'test dev_alloc R4P with initial value'
      call dev_alloc(fptr_dev=a1_R4,                               ubounds=[1            ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a1_R4')
      call dev_alloc(fptr_dev=b1_R4,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b1_R4')
      call dev_alloc(fptr_dev=a2_R4,                               ubounds=[1,2          ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a2_R4')
      call dev_alloc(fptr_dev=b2_R4,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b2_R4')
      call dev_alloc(fptr_dev=a3_R4,                               ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a3_R4')
      call dev_alloc(fptr_dev=b3_R4,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b3_R4')
      call dev_alloc(fptr_dev=a4_R4,                               ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a4_R4')
      call dev_alloc(fptr_dev=b4_R4,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b4_R4')
      call dev_alloc(fptr_dev=a5_R4,                               ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a5_R4')
      call dev_alloc(fptr_dev=b5_R4,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b5_R4')
      call dev_alloc(fptr_dev=a6_R4,                               ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a6_R4')
      call dev_alloc(fptr_dev=b6_R4,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b6_R4')
      call dev_alloc(fptr_dev=a7_R4,                               ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a7_R4')
      call dev_alloc(fptr_dev=b7_R4,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b7_R4')
   else
      print '(A)', 'test dev_alloc R4P without initial value'
      call dev_alloc(fptr_dev=a1_R4,                               ubounds=[1            ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a1_R4')
      call dev_alloc(fptr_dev=b1_R4,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b1_R4')
      call dev_alloc(fptr_dev=a2_R4,                               ubounds=[1,2          ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a2_R4')
      call dev_alloc(fptr_dev=b2_R4,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b2_R4')
      call dev_alloc(fptr_dev=a3_R4,                               ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a3_R4')
      call dev_alloc(fptr_dev=b3_R4,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b3_R4')
      call dev_alloc(fptr_dev=a4_R4,                               ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a4_R4')
      call dev_alloc(fptr_dev=b4_R4,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b4_R4')
      call dev_alloc(fptr_dev=a5_R4,                               ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a5_R4')
      call dev_alloc(fptr_dev=b5_R4,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b5_R4')
      call dev_alloc(fptr_dev=a6_R4,                               ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a6_R4')
      call dev_alloc(fptr_dev=b6_R4,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b6_R4')
      call dev_alloc(fptr_dev=a7_R4,                               ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a7_R4')
      call dev_alloc(fptr_dev=b7_R4,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b7_R4')
   endif
   print '("a1_R4 bounds: [",1(i2,X),"]/[",1(i2,X),"]")', lbound(a1_R4), ubound(a1_R4)
   print '("b1_R4 bounds: [",1(i2,X),"]/[",1(i2,X),"]")', lbound(b1_R4), ubound(b1_R4)
   print '("a2_R4 bounds: [",2(i2,X),"]/[",2(i2,X),"]")', lbound(a2_R4), ubound(a2_R4)
   print '("b2_R4 bounds: [",2(i2,X),"]/[",2(i2,X),"]")', lbound(b2_R4), ubound(b2_R4)
   print '("a3_R4 bounds: [",3(i2,X),"]/[",3(i2,X),"]")', lbound(a3_R4), ubound(a3_R4)
   print '("b3_R4 bounds: [",3(i2,X),"]/[",3(i2,X),"]")', lbound(b3_R4), ubound(b3_R4)
   print '("a4_R4 bounds: [",4(i2,X),"]/[",4(i2,X),"]")', lbound(a4_R4), ubound(a4_R4)
   print '("b4_R4 bounds: [",4(i2,X),"]/[",4(i2,X),"]")', lbound(b4_R4), ubound(b4_R4)
   print '("a5_R4 bounds: [",5(i2,X),"]/[",5(i2,X),"]")', lbound(a5_R4), ubound(a5_R4)
   print '("b5_R4 bounds: [",5(i2,X),"]/[",5(i2,X),"]")', lbound(b5_R4), ubound(b5_R4)
   print '("a6_R4 bounds: [",6(i2,X),"]/[",6(i2,X),"]")', lbound(a6_R4), ubound(a6_R4)
   print '("b6_R4 bounds: [",6(i2,X),"]/[",6(i2,X),"]")', lbound(b6_R4), ubound(b6_R4)
   print '("a7_R4 bounds: [",7(i2,X),"]/[",7(i2,X),"]")', lbound(a7_R4), ubound(a7_R4)
   print '("b7_R4 bounds: [",7(i2,X),"]/[",7(i2,X),"]")', lbound(b7_R4), ubound(b7_R4)
   if (present(init_value)) then
      allocate(a1_h_R4( 1:1                              )) ; call dev_memcpy_from_device(fptr_src=a1_R4, fptr_dst=a1_h_R4)
      allocate(b1_h_R4(-1:1                              )) ; call dev_memcpy_from_device(fptr_src=b1_R4, fptr_dst=b1_h_R4)
      allocate(a2_h_R4( 1:1, 1:2                         )) ; call dev_memcpy_from_device(fptr_src=a2_R4, fptr_dst=a2_h_R4)
      allocate(b2_h_R4(-1:1,-2:2                         )) ; call dev_memcpy_from_device(fptr_src=b2_R4, fptr_dst=b2_h_R4)
      allocate(a3_h_R4( 1:1, 1:2, 1:3                    )) ; call dev_memcpy_from_device(fptr_src=a3_R4, fptr_dst=a3_h_R4)
      allocate(b3_h_R4(-1:1,-2:2,-3:3                    )) ; call dev_memcpy_from_device(fptr_src=b3_R4, fptr_dst=b3_h_R4)
      allocate(a4_h_R4( 1:1, 1:2, 1:3, 1:4               )) ; call dev_memcpy_from_device(fptr_src=a4_R4, fptr_dst=a4_h_R4)
      allocate(b4_h_R4(-1:1,-2:2,-3:3,-4:4               )) ; call dev_memcpy_from_device(fptr_src=b4_R4, fptr_dst=b4_h_R4)
      allocate(a5_h_R4( 1:1, 1:2, 1:3, 1:4, 1:5          )) ; call dev_memcpy_from_device(fptr_src=a5_R4, fptr_dst=a5_h_R4)
      allocate(b5_h_R4(-1:1,-2:2,-3:3,-4:4,-5:5          )) ; call dev_memcpy_from_device(fptr_src=b5_R4, fptr_dst=b5_h_R4)
      allocate(a6_h_R4( 1:1, 1:2, 1:3, 1:4, 1:5, 1:6     )) ; call dev_memcpy_from_device(fptr_src=a6_R4, fptr_dst=a6_h_R4)
      allocate(b6_h_R4(-1:1,-2:2,-3:3,-4:4,-5:5,-6:6     )) ; call dev_memcpy_from_device(fptr_src=b6_R4, fptr_dst=b6_h_R4)
      allocate(a7_h_R4( 1:1, 1:2, 1:3, 1:4, 1:5, 1:6, 1:7)) ; call dev_memcpy_from_device(fptr_src=a7_R4, fptr_dst=a7_h_R4)
      allocate(b7_h_R4(-1:1,-2:2,-3:3,-4:4,-5:5,-6:6,-7:7)) ; call dev_memcpy_from_device(fptr_src=b7_R4, fptr_dst=b7_h_R4)
      print '("a1_R4 initial value: [",1(F12.9,X),"]")', maxval(a1_h_R4)
      print '("b1_R4 initial value: [",1(F12.9,X),"]")', maxval(b1_h_R4)
      print '("a2_R4 initial value: [",1(F12.9,X),"]")', maxval(a2_h_R4)
      print '("b2_R4 initial value: [",1(F12.9,X),"]")', maxval(b2_h_R4)
      print '("a3_R4 initial value: [",1(F12.9,X),"]")', maxval(a3_h_R4)
      print '("b3_R4 initial value: [",1(F12.9,X),"]")', maxval(b3_h_R4)
      print '("a4_R4 initial value: [",1(F12.9,X),"]")', maxval(a4_h_R4)
      print '("b4_R4 initial value: [",1(F12.9,X),"]")', maxval(b4_h_R4)
      print '("a5_R4 initial value: [",1(F12.9,X),"]")', maxval(a5_h_R4)
      print '("b5_R4 initial value: [",1(F12.9,X),"]")', maxval(b5_h_R4)
      print '("a6_R4 initial value: [",1(F12.9,X),"]")', maxval(a6_h_R4)
      print '("b6_R4 initial value: [",1(F12.9,X),"]")', maxval(b6_h_R4)
      print '("a7_R4 initial value: [",1(F12.9,X),"]")', maxval(a7_h_R4)
      print '("b7_R4 initial value: [",1(F12.9,X),"]")', maxval(b7_h_R4)
   endif
   print '(A)', 'test dev_free R4P'
   call dev_free(a1_R4,dev_id=mydev)
   call dev_free(a2_R4,dev_id=mydev)
   call dev_free(a3_R4,dev_id=mydev)
   call dev_free(a4_R4,dev_id=mydev)
   call dev_free(a5_R4,dev_id=mydev)
   call dev_free(a6_R4,dev_id=mydev)
   call dev_free(a7_R4,dev_id=mydev)
   call dev_free(b1_R4,dev_id=mydev)
   call dev_free(b2_R4,dev_id=mydev)
   call dev_free(b3_R4,dev_id=mydev)
   call dev_free(b4_R4,dev_id=mydev)
   call dev_free(b5_R4,dev_id=mydev)
   call dev_free(b6_R4,dev_id=mydev)
   call dev_free(b7_R4,dev_id=mydev)
   endsubroutine test_R4P

   subroutine test_I8P(init_value)
   !< Test I8P kind.
   integer(I8P), intent(in), optional :: init_value                   !< Initial value.
   integer(I8P), pointer              :: a1_I8(:)=>null()             !< Array on device memory, lbound=[1].
   integer(I8P), pointer              :: b1_I8(:)=>null()             !< Array on device memory, lbound=[-1].
   integer(I8P), pointer              :: a2_I8(:,:)=>null()           !< Array on device memory, lbound=[1,1].
   integer(I8P), pointer              :: b2_I8(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
   integer(I8P), pointer              :: a3_I8(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
   integer(I8P), pointer              :: b3_I8(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
   integer(I8P), pointer              :: a4_I8(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
   integer(I8P), pointer              :: b4_I8(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
   integer(I8P), pointer              :: a5_I8(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
   integer(I8P), pointer              :: b5_I8(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
   integer(I8P), pointer              :: a6_I8(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
   integer(I8P), pointer              :: b6_I8(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I8P), pointer              :: a7_I8(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
   integer(I8P), pointer              :: b7_I8(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I8P), allocatable          :: a1_h_I8(:)                   !< Array on host memory, lbound=[1].
   integer(I8P), allocatable          :: b1_h_I8(:)                   !< Array on host memory, lbound=[-1].
   integer(I8P), allocatable          :: a2_h_I8(:,:)                 !< Array on host memory, lbound=[1,1].
   integer(I8P), allocatable          :: b2_h_I8(:,:)                 !< Array on host memory, lbound=[-1,-2].
   integer(I8P), allocatable          :: a3_h_I8(:,:,:)               !< Array on host memory, lbound=[1,1,1].
   integer(I8P), allocatable          :: b3_h_I8(:,:,:)               !< Array on host memory, lbound=[-1,-2,-3].
   integer(I8P), allocatable          :: a4_h_I8(:,:,:,:)             !< Array on host memory, lbound=[1,1,1,1].
   integer(I8P), allocatable          :: b4_h_I8(:,:,:,:)             !< Array on host memory, lbound=[-1,-2,-3,-4].
   integer(I8P), allocatable          :: a5_h_I8(:,:,:,:,:)           !< Array on host memory, lbound=[1,1,1,1,1].
   integer(I8P), allocatable          :: b5_h_I8(:,:,:,:,:)           !< Array on host memory, lbound=[-1,-2,-3,-4,-5].
   integer(I8P), allocatable          :: a6_h_I8(:,:,:,:,:,:)         !< Array on host memory, lbound=[1,1,1,1,1,1].
   integer(I8P), allocatable          :: b6_h_I8(:,:,:,:,:,:)         !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I8P), allocatable          :: a7_h_I8(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[1,1,1,1,1,1,1].
   integer(I8P), allocatable          :: b7_h_I8(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P)                       :: ierr                         !< Error status.

   if (present(init_value)) then
      print '(A)', 'test dev_alloc I8P with initial value'
      call dev_alloc(fptr_dev=a1_I8,                               ubounds=[1            ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a1_I8')
      call dev_alloc(fptr_dev=b1_I8,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b1_I8')
      call dev_alloc(fptr_dev=a2_I8,                               ubounds=[1,2          ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a2_I8')
      call dev_alloc(fptr_dev=b2_I8,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b2_I8')
      call dev_alloc(fptr_dev=a3_I8,                               ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a3_I8')
      call dev_alloc(fptr_dev=b3_I8,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b3_I8')
      call dev_alloc(fptr_dev=a4_I8,                               ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a4_I8')
      call dev_alloc(fptr_dev=b4_I8,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b4_I8')
      call dev_alloc(fptr_dev=a5_I8,                               ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a5_I8')
      call dev_alloc(fptr_dev=b5_I8,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b5_I8')
      call dev_alloc(fptr_dev=a6_I8,                               ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a6_I8')
      call dev_alloc(fptr_dev=b6_I8,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b6_I8')
      call dev_alloc(fptr_dev=a7_I8,                               ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a7_I8')
      call dev_alloc(fptr_dev=b7_I8,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b7_I8')
   else
      print '(A)', 'test dev_alloc I8P without initial value'
      call dev_alloc(fptr_dev=a1_I8,                               ubounds=[1            ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a1_I8')
      call dev_alloc(fptr_dev=b1_I8,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b1_I8')
      call dev_alloc(fptr_dev=a2_I8,                               ubounds=[1,2          ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a2_I8')
      call dev_alloc(fptr_dev=b2_I8,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b2_I8')
      call dev_alloc(fptr_dev=a3_I8,                               ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a3_I8')
      call dev_alloc(fptr_dev=b3_I8,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b3_I8')
      call dev_alloc(fptr_dev=a4_I8,                               ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a4_I8')
      call dev_alloc(fptr_dev=b4_I8,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b4_I8')
      call dev_alloc(fptr_dev=a5_I8,                               ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a5_I8')
      call dev_alloc(fptr_dev=b5_I8,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b5_I8')
      call dev_alloc(fptr_dev=a6_I8,                               ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a6_I8')
      call dev_alloc(fptr_dev=b6_I8,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b6_I8')
      call dev_alloc(fptr_dev=a7_I8,                               ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a7_I8')
      call dev_alloc(fptr_dev=b7_I8,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b7_I8')
   endif
   print '("a1_I8 bounds: [",1(i2,X),"]/[",1(i2,X),"]")', lbound(a1_I8), ubound(a1_I8)
   print '("b1_I8 bounds: [",1(i2,X),"]/[",1(i2,X),"]")', lbound(b1_I8), ubound(b1_I8)
   print '("a2_I8 bounds: [",2(i2,X),"]/[",2(i2,X),"]")', lbound(a2_I8), ubound(a2_I8)
   print '("b2_I8 bounds: [",2(i2,X),"]/[",2(i2,X),"]")', lbound(b2_I8), ubound(b2_I8)
   print '("a3_I8 bounds: [",3(i2,X),"]/[",3(i2,X),"]")', lbound(a3_I8), ubound(a3_I8)
   print '("b3_I8 bounds: [",3(i2,X),"]/[",3(i2,X),"]")', lbound(b3_I8), ubound(b3_I8)
   print '("a4_I8 bounds: [",4(i2,X),"]/[",4(i2,X),"]")', lbound(a4_I8), ubound(a4_I8)
   print '("b4_I8 bounds: [",4(i2,X),"]/[",4(i2,X),"]")', lbound(b4_I8), ubound(b4_I8)
   print '("a5_I8 bounds: [",5(i2,X),"]/[",5(i2,X),"]")', lbound(a5_I8), ubound(a5_I8)
   print '("b5_I8 bounds: [",5(i2,X),"]/[",5(i2,X),"]")', lbound(b5_I8), ubound(b5_I8)
   print '("a6_I8 bounds: [",6(i2,X),"]/[",6(i2,X),"]")', lbound(a6_I8), ubound(a6_I8)
   print '("b6_I8 bounds: [",6(i2,X),"]/[",6(i2,X),"]")', lbound(b6_I8), ubound(b6_I8)
   print '("a7_I8 bounds: [",7(i2,X),"]/[",7(i2,X),"]")', lbound(a7_I8), ubound(a7_I8)
   print '("b7_I8 bounds: [",7(i2,X),"]/[",7(i2,X),"]")', lbound(b7_I8), ubound(b7_I8)
   if (present(init_value)) then
      allocate(a1_h_I8( 1:1                              )) ; call dev_memcpy_from_device(fptr_src=a1_I8, fptr_dst=a1_h_I8)
      allocate(b1_h_I8(-1:1                              )) ; call dev_memcpy_from_device(fptr_src=b1_I8, fptr_dst=b1_h_I8)
      allocate(a2_h_I8( 1:1, 1:2                         )) ; call dev_memcpy_from_device(fptr_src=a2_I8, fptr_dst=a2_h_I8)
      allocate(b2_h_I8(-1:1,-2:2                         )) ; call dev_memcpy_from_device(fptr_src=b2_I8, fptr_dst=b2_h_I8)
      allocate(a3_h_I8( 1:1, 1:2, 1:3                    )) ; call dev_memcpy_from_device(fptr_src=a3_I8, fptr_dst=a3_h_I8)
      allocate(b3_h_I8(-1:1,-2:2,-3:3                    )) ; call dev_memcpy_from_device(fptr_src=b3_I8, fptr_dst=b3_h_I8)
      allocate(a4_h_I8( 1:1, 1:2, 1:3, 1:4               )) ; call dev_memcpy_from_device(fptr_src=a4_I8, fptr_dst=a4_h_I8)
      allocate(b4_h_I8(-1:1,-2:2,-3:3,-4:4               )) ; call dev_memcpy_from_device(fptr_src=b4_I8, fptr_dst=b4_h_I8)
      allocate(a5_h_I8( 1:1, 1:2, 1:3, 1:4, 1:5          )) ; call dev_memcpy_from_device(fptr_src=a5_I8, fptr_dst=a5_h_I8)
      allocate(b5_h_I8(-1:1,-2:2,-3:3,-4:4,-5:5          )) ; call dev_memcpy_from_device(fptr_src=b5_I8, fptr_dst=b5_h_I8)
      allocate(a6_h_I8( 1:1, 1:2, 1:3, 1:4, 1:5, 1:6     )) ; call dev_memcpy_from_device(fptr_src=a6_I8, fptr_dst=a6_h_I8)
      allocate(b6_h_I8(-1:1,-2:2,-3:3,-4:4,-5:5,-6:6     )) ; call dev_memcpy_from_device(fptr_src=b6_I8, fptr_dst=b6_h_I8)
      allocate(a7_h_I8( 1:1, 1:2, 1:3, 1:4, 1:5, 1:6, 1:7)) ; call dev_memcpy_from_device(fptr_src=a7_I8, fptr_dst=a7_h_I8)
      allocate(b7_h_I8(-1:1,-2:2,-3:3,-4:4,-5:5,-6:6,-7:7)) ; call dev_memcpy_from_device(fptr_src=b7_I8, fptr_dst=b7_h_I8)
      print '("a1_I8 initial value: [",1(I12,X),"]")', maxval(a1_h_I8)
      print '("b1_I8 initial value: [",1(I12,X),"]")', maxval(b1_h_I8)
      print '("a2_I8 initial value: [",1(I12,X),"]")', maxval(a2_h_I8)
      print '("b2_I8 initial value: [",1(I12,X),"]")', maxval(b2_h_I8)
      print '("a3_I8 initial value: [",1(I12,X),"]")', maxval(a3_h_I8)
      print '("b3_I8 initial value: [",1(I12,X),"]")', maxval(b3_h_I8)
      print '("a4_I8 initial value: [",1(I12,X),"]")', maxval(a4_h_I8)
      print '("b4_I8 initial value: [",1(I12,X),"]")', maxval(b4_h_I8)
      print '("a5_I8 initial value: [",1(I12,X),"]")', maxval(a5_h_I8)
      print '("b5_I8 initial value: [",1(I12,X),"]")', maxval(b5_h_I8)
      print '("a6_I8 initial value: [",1(I12,X),"]")', maxval(a6_h_I8)
      print '("b6_I8 initial value: [",1(I12,X),"]")', maxval(b6_h_I8)
      print '("a7_I8 initial value: [",1(I12,X),"]")', maxval(a7_h_I8)
      print '("b7_I8 initial value: [",1(I12,X),"]")', maxval(b7_h_I8)
   endif
   print '(A)', 'test dev_free I8P'
   call dev_free(a1_I8,dev_id=mydev)
   call dev_free(a2_I8,dev_id=mydev)
   call dev_free(a3_I8,dev_id=mydev)
   call dev_free(a4_I8,dev_id=mydev)
   call dev_free(a5_I8,dev_id=mydev)
   call dev_free(a6_I8,dev_id=mydev)
   call dev_free(a7_I8,dev_id=mydev)
   call dev_free(b1_I8,dev_id=mydev)
   call dev_free(b2_I8,dev_id=mydev)
   call dev_free(b3_I8,dev_id=mydev)
   call dev_free(b4_I8,dev_id=mydev)
   call dev_free(b5_I8,dev_id=mydev)
   call dev_free(b6_I8,dev_id=mydev)
   call dev_free(b7_I8,dev_id=mydev)
   endsubroutine test_I8P

   subroutine test_I4P(init_value)
   !< Test I4P kind.
   integer(I4P), intent(in), optional :: init_value                   !< Initial value.
   integer(I4P), pointer              :: a1_I4(:)=>null()             !< Array on device memory, lbound=[1].
   integer(I4P), pointer              :: b1_I4(:)=>null()             !< Array on device memory, lbound=[-1].
   integer(I4P), pointer              :: a2_I4(:,:)=>null()           !< Array on device memory, lbound=[1,1].
   integer(I4P), pointer              :: b2_I4(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
   integer(I4P), pointer              :: a3_I4(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
   integer(I4P), pointer              :: b3_I4(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
   integer(I4P), pointer              :: a4_I4(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
   integer(I4P), pointer              :: b4_I4(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
   integer(I4P), pointer              :: a5_I4(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
   integer(I4P), pointer              :: b5_I4(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
   integer(I4P), pointer              :: a6_I4(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
   integer(I4P), pointer              :: b6_I4(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I4P), pointer              :: a7_I4(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
   integer(I4P), pointer              :: b7_I4(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P), allocatable          :: a1_h_I4(:)                   !< Array on host memory, lbound=[1].
   integer(I4P), allocatable          :: b1_h_I4(:)                   !< Array on host memory, lbound=[-1].
   integer(I4P), allocatable          :: a2_h_I4(:,:)                 !< Array on host memory, lbound=[1,1].
   integer(I4P), allocatable          :: b2_h_I4(:,:)                 !< Array on host memory, lbound=[-1,-2].
   integer(I4P), allocatable          :: a3_h_I4(:,:,:)               !< Array on host memory, lbound=[1,1,1].
   integer(I4P), allocatable          :: b3_h_I4(:,:,:)               !< Array on host memory, lbound=[-1,-2,-3].
   integer(I4P), allocatable          :: a4_h_I4(:,:,:,:)             !< Array on host memory, lbound=[1,1,1,1].
   integer(I4P), allocatable          :: b4_h_I4(:,:,:,:)             !< Array on host memory, lbound=[-1,-2,-3,-4].
   integer(I4P), allocatable          :: a5_h_I4(:,:,:,:,:)           !< Array on host memory, lbound=[1,1,1,1,1].
   integer(I4P), allocatable          :: b5_h_I4(:,:,:,:,:)           !< Array on host memory, lbound=[-1,-2,-3,-4,-5].
   integer(I4P), allocatable          :: a6_h_I4(:,:,:,:,:,:)         !< Array on host memory, lbound=[1,1,1,1,1,1].
   integer(I4P), allocatable          :: b6_h_I4(:,:,:,:,:,:)         !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I4P), allocatable          :: a7_h_I4(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[1,1,1,1,1,1,1].
   integer(I4P), allocatable          :: b7_h_I4(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P)                       :: ierr                         !< Error status.

   if (present(init_value)) then
      print '(A)', 'test dev_alloc I4P with initial value'
      call dev_alloc(fptr_dev=a1_I4,                               ubounds=[1            ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a1_I4')
      call dev_alloc(fptr_dev=b1_I4,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b1_I4')
      call dev_alloc(fptr_dev=a2_I4,                               ubounds=[1,2          ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a2_I4')
      call dev_alloc(fptr_dev=b2_I4,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b2_I4')
      call dev_alloc(fptr_dev=a3_I4,                               ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a3_I4')
      call dev_alloc(fptr_dev=b3_I4,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b3_I4')
      call dev_alloc(fptr_dev=a4_I4,                               ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a4_I4')
      call dev_alloc(fptr_dev=b4_I4,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b4_I4')
      call dev_alloc(fptr_dev=a5_I4,                               ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a5_I4')
      call dev_alloc(fptr_dev=b5_I4,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b5_I4')
      call dev_alloc(fptr_dev=a6_I4,                               ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a6_I4')
      call dev_alloc(fptr_dev=b6_I4,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b6_I4')
      call dev_alloc(fptr_dev=a7_I4,                               ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a7_I4')
      call dev_alloc(fptr_dev=b7_I4,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b7_I4')
   else
      print '(A)', 'test dev_alloc I4P without initial value'
      call dev_alloc(fptr_dev=a1_I4,                               ubounds=[1            ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a1_I4')
      call dev_alloc(fptr_dev=b1_I4,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b1_I4')
      call dev_alloc(fptr_dev=a2_I4,                               ubounds=[1,2          ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a2_I4')
      call dev_alloc(fptr_dev=b2_I4,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b2_I4')
      call dev_alloc(fptr_dev=a3_I4,                               ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a3_I4')
      call dev_alloc(fptr_dev=b3_I4,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b3_I4')
      call dev_alloc(fptr_dev=a4_I4,                               ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a4_I4')
      call dev_alloc(fptr_dev=b4_I4,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b4_I4')
      call dev_alloc(fptr_dev=a5_I4,                               ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a5_I4')
      call dev_alloc(fptr_dev=b5_I4,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b5_I4')
      call dev_alloc(fptr_dev=a6_I4,                               ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a6_I4')
      call dev_alloc(fptr_dev=b6_I4,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b6_I4')
      call dev_alloc(fptr_dev=a7_I4,                               ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a7_I4')
      call dev_alloc(fptr_dev=b7_I4,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b7_I4')
   endif
   print '("a1_I4 bounds: [",1(i2,X),"]/[",1(i2,X),"]")', lbound(a1_I4), ubound(a1_I4)
   print '("b1_I4 bounds: [",1(i2,X),"]/[",1(i2,X),"]")', lbound(b1_I4), ubound(b1_I4)
   print '("a2_I4 bounds: [",2(i2,X),"]/[",2(i2,X),"]")', lbound(a2_I4), ubound(a2_I4)
   print '("b2_I4 bounds: [",2(i2,X),"]/[",2(i2,X),"]")', lbound(b2_I4), ubound(b2_I4)
   print '("a3_I4 bounds: [",3(i2,X),"]/[",3(i2,X),"]")', lbound(a3_I4), ubound(a3_I4)
   print '("b3_I4 bounds: [",3(i2,X),"]/[",3(i2,X),"]")', lbound(b3_I4), ubound(b3_I4)
   print '("a4_I4 bounds: [",4(i2,X),"]/[",4(i2,X),"]")', lbound(a4_I4), ubound(a4_I4)
   print '("b4_I4 bounds: [",4(i2,X),"]/[",4(i2,X),"]")', lbound(b4_I4), ubound(b4_I4)
   print '("a5_I4 bounds: [",5(i2,X),"]/[",5(i2,X),"]")', lbound(a5_I4), ubound(a5_I4)
   print '("b5_I4 bounds: [",5(i2,X),"]/[",5(i2,X),"]")', lbound(b5_I4), ubound(b5_I4)
   print '("a6_I4 bounds: [",6(i2,X),"]/[",6(i2,X),"]")', lbound(a6_I4), ubound(a6_I4)
   print '("b6_I4 bounds: [",6(i2,X),"]/[",6(i2,X),"]")', lbound(b6_I4), ubound(b6_I4)
   print '("a7_I4 bounds: [",7(i2,X),"]/[",7(i2,X),"]")', lbound(a7_I4), ubound(a7_I4)
   print '("b7_I4 bounds: [",7(i2,X),"]/[",7(i2,X),"]")', lbound(b7_I4), ubound(b7_I4)
   if (present(init_value)) then
      allocate(a1_h_I4( 1:1                              )) ; call dev_memcpy_from_device(fptr_src=a1_I4, fptr_dst=a1_h_I4)
      allocate(b1_h_I4(-1:1                              )) ; call dev_memcpy_from_device(fptr_src=b1_I4, fptr_dst=b1_h_I4)
      allocate(a2_h_I4( 1:1, 1:2                         )) ; call dev_memcpy_from_device(fptr_src=a2_I4, fptr_dst=a2_h_I4)
      allocate(b2_h_I4(-1:1,-2:2                         )) ; call dev_memcpy_from_device(fptr_src=b2_I4, fptr_dst=b2_h_I4)
      allocate(a3_h_I4( 1:1, 1:2, 1:3                    )) ; call dev_memcpy_from_device(fptr_src=a3_I4, fptr_dst=a3_h_I4)
      allocate(b3_h_I4(-1:1,-2:2,-3:3                    )) ; call dev_memcpy_from_device(fptr_src=b3_I4, fptr_dst=b3_h_I4)
      allocate(a4_h_I4( 1:1, 1:2, 1:3, 1:4               )) ; call dev_memcpy_from_device(fptr_src=a4_I4, fptr_dst=a4_h_I4)
      allocate(b4_h_I4(-1:1,-2:2,-3:3,-4:4               )) ; call dev_memcpy_from_device(fptr_src=b4_I4, fptr_dst=b4_h_I4)
      allocate(a5_h_I4( 1:1, 1:2, 1:3, 1:4, 1:5          )) ; call dev_memcpy_from_device(fptr_src=a5_I4, fptr_dst=a5_h_I4)
      allocate(b5_h_I4(-1:1,-2:2,-3:3,-4:4,-5:5          )) ; call dev_memcpy_from_device(fptr_src=b5_I4, fptr_dst=b5_h_I4)
      allocate(a6_h_I4( 1:1, 1:2, 1:3, 1:4, 1:5, 1:6     )) ; call dev_memcpy_from_device(fptr_src=a6_I4, fptr_dst=a6_h_I4)
      allocate(b6_h_I4(-1:1,-2:2,-3:3,-4:4,-5:5,-6:6     )) ; call dev_memcpy_from_device(fptr_src=b6_I4, fptr_dst=b6_h_I4)
      allocate(a7_h_I4( 1:1, 1:2, 1:3, 1:4, 1:5, 1:6, 1:7)) ; call dev_memcpy_from_device(fptr_src=a7_I4, fptr_dst=a7_h_I4)
      allocate(b7_h_I4(-1:1,-2:2,-3:3,-4:4,-5:5,-6:6,-7:7)) ; call dev_memcpy_from_device(fptr_src=b7_I4, fptr_dst=b7_h_I4)
      print '("a1_I4 initial value: [",1(I12,X),"]")', maxval(a1_h_I4)
      print '("b1_I4 initial value: [",1(I12,X),"]")', maxval(b1_h_I4)
      print '("a2_I4 initial value: [",1(I12,X),"]")', maxval(a2_h_I4)
      print '("b2_I4 initial value: [",1(I12,X),"]")', maxval(b2_h_I4)
      print '("a3_I4 initial value: [",1(I12,X),"]")', maxval(a3_h_I4)
      print '("b3_I4 initial value: [",1(I12,X),"]")', maxval(b3_h_I4)
      print '("a4_I4 initial value: [",1(I12,X),"]")', maxval(a4_h_I4)
      print '("b4_I4 initial value: [",1(I12,X),"]")', maxval(b4_h_I4)
      print '("a5_I4 initial value: [",1(I12,X),"]")', maxval(a5_h_I4)
      print '("b5_I4 initial value: [",1(I12,X),"]")', maxval(b5_h_I4)
      print '("a6_I4 initial value: [",1(I12,X),"]")', maxval(a6_h_I4)
      print '("b6_I4 initial value: [",1(I12,X),"]")', maxval(b6_h_I4)
      print '("a7_I4 initial value: [",1(I12,X),"]")', maxval(a7_h_I4)
      print '("b7_I4 initial value: [",1(I12,X),"]")', maxval(b7_h_I4)
   endif
   print '(A)', 'test dev_free I4P'
   call dev_free(a1_I4,dev_id=mydev)
   call dev_free(a2_I4,dev_id=mydev)
   call dev_free(a3_I4,dev_id=mydev)
   call dev_free(a4_I4,dev_id=mydev)
   call dev_free(a5_I4,dev_id=mydev)
   call dev_free(a6_I4,dev_id=mydev)
   call dev_free(a7_I4,dev_id=mydev)
   call dev_free(b1_I4,dev_id=mydev)
   call dev_free(b2_I4,dev_id=mydev)
   call dev_free(b3_I4,dev_id=mydev)
   call dev_free(b4_I4,dev_id=mydev)
   call dev_free(b5_I4,dev_id=mydev)
   call dev_free(b6_I4,dev_id=mydev)
   call dev_free(b7_I4,dev_id=mydev)
   endsubroutine test_I4P

   subroutine test_I1P(init_value)
   !< Test I1P kind.
   integer(I1P), intent(in), optional :: init_value                   !< Initial value.
   integer(I1P), pointer              :: a1_I1(:)=>null()             !< Array on device memory, lbound=[1].
   integer(I1P), pointer              :: b1_I1(:)=>null()             !< Array on device memory, lbound=[-1].
   integer(I1P), pointer              :: a2_I1(:,:)=>null()           !< Array on device memory, lbound=[1,1].
   integer(I1P), pointer              :: b2_I1(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
   integer(I1P), pointer              :: a3_I1(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
   integer(I1P), pointer              :: b3_I1(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
   integer(I1P), pointer              :: a4_I1(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
   integer(I1P), pointer              :: b4_I1(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
   integer(I1P), pointer              :: a5_I1(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
   integer(I1P), pointer              :: b5_I1(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
   integer(I1P), pointer              :: a6_I1(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
   integer(I1P), pointer              :: b6_I1(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I1P), pointer              :: a7_I1(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
   integer(I1P), pointer              :: b7_I1(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I1P), allocatable          :: a1_h_I1(:)                   !< Array on host memory, lbound=[1].
   integer(I1P), allocatable          :: b1_h_I1(:)                   !< Array on host memory, lbound=[-1].
   integer(I1P), allocatable          :: a2_h_I1(:,:)                 !< Array on host memory, lbound=[1,1].
   integer(I1P), allocatable          :: b2_h_I1(:,:)                 !< Array on host memory, lbound=[-1,-2].
   integer(I1P), allocatable          :: a3_h_I1(:,:,:)               !< Array on host memory, lbound=[1,1,1].
   integer(I1P), allocatable          :: b3_h_I1(:,:,:)               !< Array on host memory, lbound=[-1,-2,-3].
   integer(I1P), allocatable          :: a4_h_I1(:,:,:,:)             !< Array on host memory, lbound=[1,1,1,1].
   integer(I1P), allocatable          :: b4_h_I1(:,:,:,:)             !< Array on host memory, lbound=[-1,-2,-3,-4].
   integer(I1P), allocatable          :: a5_h_I1(:,:,:,:,:)           !< Array on host memory, lbound=[1,1,1,1,1].
   integer(I1P), allocatable          :: b5_h_I1(:,:,:,:,:)           !< Array on host memory, lbound=[-1,-2,-3,-4,-5].
   integer(I1P), allocatable          :: a6_h_I1(:,:,:,:,:,:)         !< Array on host memory, lbound=[1,1,1,1,1,1].
   integer(I1P), allocatable          :: b6_h_I1(:,:,:,:,:,:)         !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6].
   integer(I1P), allocatable          :: a7_h_I1(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[1,1,1,1,1,1,1].
   integer(I1P), allocatable          :: b7_h_I1(:,:,:,:,:,:,:)       !< Array on host memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
   integer(I4P)                       :: ierr                         !< Error status.

   if (present(init_value)) then
      print '(A)', 'test dev_alloc I1P with initial value'
      call dev_alloc(fptr_dev=a1_I1,                               ubounds=[1            ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a1_I1')
      call dev_alloc(fptr_dev=b1_I1,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b1_I1')
      call dev_alloc(fptr_dev=a2_I1,                               ubounds=[1,2          ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a2_I1')
      call dev_alloc(fptr_dev=b2_I1,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b2_I1')
      call dev_alloc(fptr_dev=a3_I1,                               ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a3_I1')
      call dev_alloc(fptr_dev=b3_I1,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b3_I1')
      call dev_alloc(fptr_dev=a4_I1,                               ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a4_I1')
      call dev_alloc(fptr_dev=b4_I1,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b4_I1')
      call dev_alloc(fptr_dev=a5_I1,                               ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a5_I1')
      call dev_alloc(fptr_dev=b5_I1,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b5_I1')
      call dev_alloc(fptr_dev=a6_I1,                               ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a6_I1')
      call dev_alloc(fptr_dev=b6_I1,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b6_I1')
      call dev_alloc(fptr_dev=a7_I1,                               ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'a7_I1')
      call dev_alloc(fptr_dev=b7_I1,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev,&
                     init_value=init_value)
      call error_print(ierr,'b7_I1')
   else
      print '(A)', 'test dev_alloc I1P without initial value'
      call dev_alloc(fptr_dev=a1_I1,                               ubounds=[1            ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a1_I1')
      call dev_alloc(fptr_dev=b1_I1,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b1_I1')
      call dev_alloc(fptr_dev=a2_I1,                               ubounds=[1,2          ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a2_I1')
      call dev_alloc(fptr_dev=b2_I1,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b2_I1')
      call dev_alloc(fptr_dev=a3_I1,                               ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a3_I1')
      call dev_alloc(fptr_dev=b3_I1,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b3_I1')
      call dev_alloc(fptr_dev=a4_I1,                               ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a4_I1')
      call dev_alloc(fptr_dev=b4_I1,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b4_I1')
      call dev_alloc(fptr_dev=a5_I1,                               ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a5_I1')
      call dev_alloc(fptr_dev=b5_I1,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b5_I1')
      call dev_alloc(fptr_dev=a6_I1,                               ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a6_I1')
      call dev_alloc(fptr_dev=b6_I1,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b6_I1')
      call dev_alloc(fptr_dev=a7_I1,                               ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'a7_I1')
      call dev_alloc(fptr_dev=b7_I1,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr,dev_id=mydev)
      call error_print(ierr,'b7_I1')
   endif
   print '("a1_I1 bounds: [",1(i2,X),"]/[",1(i2,X),"]")', lbound(a1_I1), ubound(a1_I1)
   print '("b1_I1 bounds: [",1(i2,X),"]/[",1(i2,X),"]")', lbound(b1_I1), ubound(b1_I1)
   print '("a2_I1 bounds: [",2(i2,X),"]/[",2(i2,X),"]")', lbound(a2_I1), ubound(a2_I1)
   print '("b2_I1 bounds: [",2(i2,X),"]/[",2(i2,X),"]")', lbound(b2_I1), ubound(b2_I1)
   print '("a3_I1 bounds: [",3(i2,X),"]/[",3(i2,X),"]")', lbound(a3_I1), ubound(a3_I1)
   print '("b3_I1 bounds: [",3(i2,X),"]/[",3(i2,X),"]")', lbound(b3_I1), ubound(b3_I1)
   print '("a4_I1 bounds: [",4(i2,X),"]/[",4(i2,X),"]")', lbound(a4_I1), ubound(a4_I1)
   print '("b4_I1 bounds: [",4(i2,X),"]/[",4(i2,X),"]")', lbound(b4_I1), ubound(b4_I1)
   print '("a5_I1 bounds: [",5(i2,X),"]/[",5(i2,X),"]")', lbound(a5_I1), ubound(a5_I1)
   print '("b5_I1 bounds: [",5(i2,X),"]/[",5(i2,X),"]")', lbound(b5_I1), ubound(b5_I1)
   print '("a6_I1 bounds: [",6(i2,X),"]/[",6(i2,X),"]")', lbound(a6_I1), ubound(a6_I1)
   print '("b6_I1 bounds: [",6(i2,X),"]/[",6(i2,X),"]")', lbound(b6_I1), ubound(b6_I1)
   print '("a7_I1 bounds: [",7(i2,X),"]/[",7(i2,X),"]")', lbound(a7_I1), ubound(a7_I1)
   print '("b7_I1 bounds: [",7(i2,X),"]/[",7(i2,X),"]")', lbound(b7_I1), ubound(b7_I1)
   if (present(init_value)) then
      allocate(a1_h_I1( 1:1                              )) ; call dev_memcpy_from_device(fptr_src=a1_I1, fptr_dst=a1_h_I1)
      allocate(b1_h_I1(-1:1                              )) ; call dev_memcpy_from_device(fptr_src=b1_I1, fptr_dst=b1_h_I1)
      allocate(a2_h_I1( 1:1, 1:2                         )) ; call dev_memcpy_from_device(fptr_src=a2_I1, fptr_dst=a2_h_I1)
      allocate(b2_h_I1(-1:1,-2:2                         )) ; call dev_memcpy_from_device(fptr_src=b2_I1, fptr_dst=b2_h_I1)
      allocate(a3_h_I1( 1:1, 1:2, 1:3                    )) ; call dev_memcpy_from_device(fptr_src=a3_I1, fptr_dst=a3_h_I1)
      allocate(b3_h_I1(-1:1,-2:2,-3:3                    )) ; call dev_memcpy_from_device(fptr_src=b3_I1, fptr_dst=b3_h_I1)
      allocate(a4_h_I1( 1:1, 1:2, 1:3, 1:4               )) ; call dev_memcpy_from_device(fptr_src=a4_I1, fptr_dst=a4_h_I1)
      allocate(b4_h_I1(-1:1,-2:2,-3:3,-4:4               )) ; call dev_memcpy_from_device(fptr_src=b4_I1, fptr_dst=b4_h_I1)
      allocate(a5_h_I1( 1:1, 1:2, 1:3, 1:4, 1:5          )) ; call dev_memcpy_from_device(fptr_src=a5_I1, fptr_dst=a5_h_I1)
      allocate(b5_h_I1(-1:1,-2:2,-3:3,-4:4,-5:5          )) ; call dev_memcpy_from_device(fptr_src=b5_I1, fptr_dst=b5_h_I1)
      allocate(a6_h_I1( 1:1, 1:2, 1:3, 1:4, 1:5, 1:6     )) ; call dev_memcpy_from_device(fptr_src=a6_I1, fptr_dst=a6_h_I1)
      allocate(b6_h_I1(-1:1,-2:2,-3:3,-4:4,-5:5,-6:6     )) ; call dev_memcpy_from_device(fptr_src=b6_I1, fptr_dst=b6_h_I1)
      allocate(a7_h_I1( 1:1, 1:2, 1:3, 1:4, 1:5, 1:6, 1:7)) ; call dev_memcpy_from_device(fptr_src=a7_I1, fptr_dst=a7_h_I1)
      allocate(b7_h_I1(-1:1,-2:2,-3:3,-4:4,-5:5,-6:6,-7:7)) ; call dev_memcpy_from_device(fptr_src=b7_I1, fptr_dst=b7_h_I1)
      print '("a1_I1 initial value: [",1(I12,X),"]")', maxval(a1_h_I1)
      print '("b1_I1 initial value: [",1(I12,X),"]")', maxval(b1_h_I1)
      print '("a2_I1 initial value: [",1(I12,X),"]")', maxval(a2_h_I1)
      print '("b2_I1 initial value: [",1(I12,X),"]")', maxval(b2_h_I1)
      print '("a3_I1 initial value: [",1(I12,X),"]")', maxval(a3_h_I1)
      print '("b3_I1 initial value: [",1(I12,X),"]")', maxval(b3_h_I1)
      print '("a4_I1 initial value: [",1(I12,X),"]")', maxval(a4_h_I1)
      print '("b4_I1 initial value: [",1(I12,X),"]")', maxval(b4_h_I1)
      print '("a5_I1 initial value: [",1(I12,X),"]")', maxval(a5_h_I1)
      print '("b5_I1 initial value: [",1(I12,X),"]")', maxval(b5_h_I1)
      print '("a6_I1 initial value: [",1(I12,X),"]")', maxval(a6_h_I1)
      print '("b6_I1 initial value: [",1(I12,X),"]")', maxval(b6_h_I1)
      print '("a7_I1 initial value: [",1(I12,X),"]")', maxval(a7_h_I1)
      print '("b7_I1 initial value: [",1(I12,X),"]")', maxval(b7_h_I1)
   endif
   print '(A)', 'test dev_free I1P'
   call dev_free(a1_I1,dev_id=mydev)
   call dev_free(a2_I1,dev_id=mydev)
   call dev_free(a3_I1,dev_id=mydev)
   call dev_free(a4_I1,dev_id=mydev)
   call dev_free(a5_I1,dev_id=mydev)
   call dev_free(a6_I1,dev_id=mydev)
   call dev_free(a7_I1,dev_id=mydev)
   call dev_free(b1_I1,dev_id=mydev)
   call dev_free(b2_I1,dev_id=mydev)
   call dev_free(b3_I1,dev_id=mydev)
   call dev_free(b4_I1,dev_id=mydev)
   call dev_free(b5_I1,dev_id=mydev)
   call dev_free(b6_I1,dev_id=mydev)
   call dev_free(b7_I1,dev_id=mydev)
   endsubroutine test_I1P
endprogram fundal_alloc_free_test
