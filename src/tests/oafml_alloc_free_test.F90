!< OAFML, device memory alloc test.
program oafml_alloc_free_test
!< OAFML, device memory alloc test.

use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use oafml

implicit none

real(R8P),    pointer :: a1_R8(:)=>null()             !< Array on device memory, lbound=[1].
real(R8P),    pointer :: b1_R8(:)=>null()             !< Array on device memory, lbound=[-1].
real(R8P),    pointer :: a2_R8(:,:)=>null()           !< Array on device memory, lbound=[1,1].
real(R8P),    pointer :: b2_R8(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
real(R8P),    pointer :: a3_R8(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
real(R8P),    pointer :: b3_R8(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
real(R8P),    pointer :: a4_R8(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
real(R8P),    pointer :: b4_R8(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
real(R8P),    pointer :: a5_R8(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
real(R8P),    pointer :: b5_R8(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
real(R8P),    pointer :: a6_R8(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
real(R8P),    pointer :: b6_R8(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
real(R8P),    pointer :: a7_R8(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
real(R8P),    pointer :: b7_R8(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
real(R4P),    pointer :: a1_R4(:)=>null()             !< Array on device memory, lbound=[1].
real(R4P),    pointer :: b1_R4(:)=>null()             !< Array on device memory, lbound=[-1].
real(R4P),    pointer :: a2_R4(:,:)=>null()           !< Array on device memory, lbound=[1,1].
real(R4P),    pointer :: b2_R4(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
real(R4P),    pointer :: a3_R4(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
real(R4P),    pointer :: b3_R4(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
real(R4P),    pointer :: a4_R4(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
real(R4P),    pointer :: b4_R4(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
real(R4P),    pointer :: a5_R4(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
real(R4P),    pointer :: b5_R4(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
real(R4P),    pointer :: a6_R4(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
real(R4P),    pointer :: b6_R4(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
real(R4P),    pointer :: a7_R4(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
real(R4P),    pointer :: b7_R4(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
integer(I8P), pointer :: a1_I8(:)=>null()             !< Array on device memory, lbound=[1].
integer(I8P), pointer :: b1_I8(:)=>null()             !< Array on device memory, lbound=[-1].
integer(I8P), pointer :: a2_I8(:,:)=>null()           !< Array on device memory, lbound=[1,1].
integer(I8P), pointer :: b2_I8(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
integer(I8P), pointer :: a3_I8(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
integer(I8P), pointer :: b3_I8(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
integer(I8P), pointer :: a4_I8(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
integer(I8P), pointer :: b4_I8(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
integer(I8P), pointer :: a5_I8(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
integer(I8P), pointer :: b5_I8(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
integer(I8P), pointer :: a6_I8(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
integer(I8P), pointer :: b6_I8(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
integer(I8P), pointer :: a7_I8(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
integer(I8P), pointer :: b7_I8(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
integer(I4P), pointer :: a1_I4(:)=>null()             !< Array on device memory, lbound=[1].
integer(I4P), pointer :: b1_I4(:)=>null()             !< Array on device memory, lbound=[-1].
integer(I4P), pointer :: a2_I4(:,:)=>null()           !< Array on device memory, lbound=[1,1].
integer(I4P), pointer :: b2_I4(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
integer(I4P), pointer :: a3_I4(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
integer(I4P), pointer :: b3_I4(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
integer(I4P), pointer :: a4_I4(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
integer(I4P), pointer :: b4_I4(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
integer(I4P), pointer :: a5_I4(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
integer(I4P), pointer :: b5_I4(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
integer(I4P), pointer :: a6_I4(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
integer(I4P), pointer :: b6_I4(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
integer(I4P), pointer :: a7_I4(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
integer(I4P), pointer :: b7_I4(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
integer(I1P), pointer :: a1_I1(:)=>null()             !< Array on device memory, lbound=[1].
integer(I1P), pointer :: b1_I1(:)=>null()             !< Array on device memory, lbound=[-1].
integer(I1P), pointer :: a2_I1(:,:)=>null()           !< Array on device memory, lbound=[1,1].
integer(I1P), pointer :: b2_I1(:,:)=>null()           !< Array on device memory, lbound=[-1,-2].
integer(I1P), pointer :: a3_I1(:,:,:)=>null()         !< Array on device memory, lbound=[1,1,1].
integer(I1P), pointer :: b3_I1(:,:,:)=>null()         !< Array on device memory, lbound=[-1,-2,-3].
integer(I1P), pointer :: a4_I1(:,:,:,:)=>null()       !< Array on device memory, lbound=[1,1,1,1].
integer(I1P), pointer :: b4_I1(:,:,:,:)=>null()       !< Array on device memory, lbound=[-1,-2,-3,-4].
integer(I1P), pointer :: a5_I1(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[1,1,1,1,1].
integer(I1P), pointer :: b5_I1(:,:,:,:,:)=>null()     !< Array on device memory, lbound=[-1,-2,-3,-4,-5].
integer(I1P), pointer :: a6_I1(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[1,1,1,1,1,1].
integer(I1P), pointer :: b6_I1(:,:,:,:,:,:)=>null()   !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6].
integer(I1P), pointer :: a7_I1(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[1,1,1,1,1,1,1].
integer(I1P), pointer :: b7_I1(:,:,:,:,:,:,:)=>null() !< Array on device memory, lbound=[-1,-2,-3,-4,-5,-6,-7].
integer(I4P)          :: ierr                         !< Error status.

print '(A)', 'test oac_alloc'
! kind R8P
call oac_alloc(fptr_dev=a1_R8,                               ubounds=[1            ],ierr=ierr);call error_print(ierr,'a1_R8')
call oac_alloc(fptr_dev=b1_R8,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr);call error_print(ierr,'b1_R8')
call oac_alloc(fptr_dev=a2_R8,                               ubounds=[1,2          ],ierr=ierr);call error_print(ierr,'a2_R8')
call oac_alloc(fptr_dev=b2_R8,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr);call error_print(ierr,'b2_R8')
call oac_alloc(fptr_dev=a3_R8,                               ubounds=[1,2,3        ],ierr=ierr);call error_print(ierr,'a3_R8')
call oac_alloc(fptr_dev=b3_R8,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr);call error_print(ierr,'b3_R8')
call oac_alloc(fptr_dev=a4_R8,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a4_R8')
call oac_alloc(fptr_dev=b4_R8,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'b4_R8')
call oac_alloc(fptr_dev=a5_R8,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a5_R8')
call oac_alloc(fptr_dev=b5_R8,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr);call error_print(ierr,'b5_R8')
call oac_alloc(fptr_dev=a6_R8,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a6_R8')
call oac_alloc(fptr_dev=b6_R8,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr);call error_print(ierr,'b6_R8')
call oac_alloc(fptr_dev=a7_R8,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a7_R8')
call oac_alloc(fptr_dev=b7_R8,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr);call error_print(ierr,'b7_R8')
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
! kind R4P
call oac_alloc(fptr_dev=a1_R4,                               ubounds=[1            ],ierr=ierr);call error_print(ierr,'a1_R4')
call oac_alloc(fptr_dev=b1_R4,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr);call error_print(ierr,'b1_R4')
call oac_alloc(fptr_dev=a2_R4,                               ubounds=[1,2          ],ierr=ierr);call error_print(ierr,'a2_R4')
call oac_alloc(fptr_dev=b2_R4,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr);call error_print(ierr,'b2_R4')
call oac_alloc(fptr_dev=a3_R4,                               ubounds=[1,2,3        ],ierr=ierr);call error_print(ierr,'a3_R4')
call oac_alloc(fptr_dev=b3_R4,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr);call error_print(ierr,'b3_R4')
call oac_alloc(fptr_dev=a4_R4,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a4_R4')
call oac_alloc(fptr_dev=b4_R4,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'b4_R4')
call oac_alloc(fptr_dev=a5_R4,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a5_R4')
call oac_alloc(fptr_dev=b5_R4,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr);call error_print(ierr,'b5_R4')
call oac_alloc(fptr_dev=a6_R4,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a6_R4')
call oac_alloc(fptr_dev=b6_R4,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr);call error_print(ierr,'b6_R4')
call oac_alloc(fptr_dev=a7_R4,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a7_R4')
call oac_alloc(fptr_dev=b7_R4,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr);call error_print(ierr,'b7_R4')
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
! kind I8P
call oac_alloc(fptr_dev=a1_I8,                               ubounds=[1            ],ierr=ierr);call error_print(ierr,'a1_I8')
call oac_alloc(fptr_dev=b1_I8,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr);call error_print(ierr,'b1_I8')
call oac_alloc(fptr_dev=a2_I8,                               ubounds=[1,2          ],ierr=ierr);call error_print(ierr,'a2_I8')
call oac_alloc(fptr_dev=b2_I8,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr);call error_print(ierr,'b2_I8')
call oac_alloc(fptr_dev=a3_I8,                               ubounds=[1,2,3        ],ierr=ierr);call error_print(ierr,'a3_I8')
call oac_alloc(fptr_dev=b3_I8,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr);call error_print(ierr,'b3_I8')
call oac_alloc(fptr_dev=a4_I8,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a4_I8')
call oac_alloc(fptr_dev=b4_I8,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'b4_I8')
call oac_alloc(fptr_dev=a5_I8,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a5_I8')
call oac_alloc(fptr_dev=b5_I8,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr);call error_print(ierr,'b5_I8')
call oac_alloc(fptr_dev=a6_I8,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a6_I8')
call oac_alloc(fptr_dev=b6_I8,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr);call error_print(ierr,'b6_I8')
call oac_alloc(fptr_dev=a7_I8,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a7_I8')
call oac_alloc(fptr_dev=b7_I8,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr);call error_print(ierr,'b7_I8')
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
! kind I4P
call oac_alloc(fptr_dev=a1_I4,                               ubounds=[1            ],ierr=ierr);call error_print(ierr,'a1_I4')
call oac_alloc(fptr_dev=b1_I4,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr);call error_print(ierr,'b1_I4')
call oac_alloc(fptr_dev=a2_I4,                               ubounds=[1,2          ],ierr=ierr);call error_print(ierr,'a2_I4')
call oac_alloc(fptr_dev=b2_I4,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr);call error_print(ierr,'b2_I4')
call oac_alloc(fptr_dev=a3_I4,                               ubounds=[1,2,3        ],ierr=ierr);call error_print(ierr,'a3_I4')
call oac_alloc(fptr_dev=b3_I4,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr);call error_print(ierr,'b3_I4')
call oac_alloc(fptr_dev=a4_I4,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a4_I4')
call oac_alloc(fptr_dev=b4_I4,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'b4_I4')
call oac_alloc(fptr_dev=a5_I4,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a5_I4')
call oac_alloc(fptr_dev=b5_I4,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr);call error_print(ierr,'b5_I4')
call oac_alloc(fptr_dev=a6_I4,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a6_I4')
call oac_alloc(fptr_dev=b6_I4,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr);call error_print(ierr,'b6_I4')
call oac_alloc(fptr_dev=a7_I4,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a7_I4')
call oac_alloc(fptr_dev=b7_I4,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr);call error_print(ierr,'b7_I4')
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
! kind I1P
call oac_alloc(fptr_dev=a1_I1,                               ubounds=[1            ],ierr=ierr);call error_print(ierr,'a1_I1')
call oac_alloc(fptr_dev=b1_I1,lbounds=[-1                  ],ubounds=[1            ],ierr=ierr);call error_print(ierr,'b1_I1')
call oac_alloc(fptr_dev=a2_I1,                               ubounds=[1,2          ],ierr=ierr);call error_print(ierr,'a2_I1')
call oac_alloc(fptr_dev=b2_I1,lbounds=[-1,-2               ],ubounds=[1,2          ],ierr=ierr);call error_print(ierr,'b2_I1')
call oac_alloc(fptr_dev=a3_I1,                               ubounds=[1,2,3        ],ierr=ierr);call error_print(ierr,'a3_I1')
call oac_alloc(fptr_dev=b3_I1,lbounds=[-1,-2,-3            ],ubounds=[1,2,3        ],ierr=ierr);call error_print(ierr,'b3_I1')
call oac_alloc(fptr_dev=a4_I1,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a4_I1')
call oac_alloc(fptr_dev=b4_I1,lbounds=[-1,-2,-3,-4         ],ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'b4_I1')
call oac_alloc(fptr_dev=a5_I1,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a5_I1')
call oac_alloc(fptr_dev=b5_I1,lbounds=[-1,-2,-3,-4,-5      ],ubounds=[1,2,3,4,5    ],ierr=ierr);call error_print(ierr,'b5_I1')
call oac_alloc(fptr_dev=a6_I1,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a6_I1')
call oac_alloc(fptr_dev=b6_I1,lbounds=[-1,-2,-3,-4,-5,-6   ],ubounds=[1,2,3,4,5,6  ],ierr=ierr);call error_print(ierr,'b6_I1')
call oac_alloc(fptr_dev=a7_I1,                               ubounds=[1,2,3,4      ],ierr=ierr);call error_print(ierr,'a7_I1')
call oac_alloc(fptr_dev=b7_I1,lbounds=[-1,-2,-3,-4,-5,-6,-7],ubounds=[1,2,3,4,5,6,7],ierr=ierr);call error_print(ierr,'b7_I1')
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

print '(A)', 'test oac_free'
call oac_free(a1_R8)
call oac_free(a2_R8)
call oac_free(a3_R8)
call oac_free(a4_R8)
call oac_free(a5_R8)
call oac_free(a6_R8)
call oac_free(a7_R8)
call oac_free(a1_R4)
call oac_free(a2_R4)
call oac_free(a3_R4)
call oac_free(a4_R4)
call oac_free(a5_R4)
call oac_free(a6_R4)
call oac_free(a7_R4)
call oac_free(a1_I8)
call oac_free(a2_I8)
call oac_free(a3_I8)
call oac_free(a4_I8)
call oac_free(a5_I8)
call oac_free(a6_I8)
call oac_free(a7_I8)
call oac_free(a1_I4)
call oac_free(a2_I4)
call oac_free(a3_I4)
call oac_free(a4_I4)
call oac_free(a5_I4)
call oac_free(a6_I4)
call oac_free(a7_I4)
call oac_free(a1_I1)
call oac_free(a2_I1)
call oac_free(a3_I1)
call oac_free(a4_I1)
call oac_free(a5_I1)
call oac_free(a6_I1)
call oac_free(a7_I1)

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
endprogram oafml_alloc_free_test
