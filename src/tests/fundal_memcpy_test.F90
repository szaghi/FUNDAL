!< FUNDAL, device memory copy test.

#include "fundal.H"

program fundal_memcpy_test
!< FUNDAL, device memory copy test.

use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use fundal

implicit none

real(R8P), pointer                :: a1_dev_R8(:)=>null()             !< Array on device memory.
real(R8P), pointer                :: b1_dev_R8(:)=>null()             !< Array on device memory.
real(R8P), pointer                :: a2_dev_R8(:,:)=>null()           !< Array on device memory.
real(R8P), pointer                :: b2_dev_R8(:,:)=>null()           !< Array on device memory.
real(R8P), pointer                :: a3_dev_R8(:,:,:)=>null()         !< Array on device memory.
real(R8P), pointer                :: b3_dev_R8(:,:,:)=>null()         !< Array on device memory.
real(R8P), pointer                :: a4_dev_R8(:,:,:,:)=>null()       !< Array on device memory.
real(R8P), pointer                :: b4_dev_R8(:,:,:,:)=>null()       !< Array on device memory.
real(R8P), pointer                :: a5_dev_R8(:,:,:,:,:)=>null()     !< Array on device memory.
real(R8P), pointer                :: b5_dev_R8(:,:,:,:,:)=>null()     !< Array on device memory.
real(R8P), pointer                :: a6_dev_R8(:,:,:,:,:,:)=>null()   !< Array on device memory.
real(R8P), pointer                :: b6_dev_R8(:,:,:,:,:,:)=>null()   !< Array on device memory.
real(R8P), pointer                :: a7_dev_R8(:,:,:,:,:,:,:)=>null() !< Array on device memory.
real(R8P), pointer                :: b7_dev_R8(:,:,:,:,:,:,:)=>null() !< Array on device memory.
real(R8P), allocatable, target    :: a1_R8(:)                         !< Array on host memory.
real(R8P), allocatable, target    :: b1_R8(:)                         !< Array on host memory.
real(R8P), allocatable, target    :: a2_R8(:,:)                       !< Array on host memory.
real(R8P), allocatable, target    :: b2_R8(:,:)                       !< Array on host memory.
real(R8P), allocatable, target    :: a3_R8(:,:,:)                     !< Array on host memory.
real(R8P), allocatable, target    :: b3_R8(:,:,:)                     !< Array on host memory.
real(R8P), allocatable, target    :: a4_R8(:,:,:,:)                   !< Array on host memory.
real(R8P), allocatable, target    :: b4_R8(:,:,:,:)                   !< Array on host memory.
real(R8P), allocatable, target    :: a5_R8(:,:,:,:,:)                 !< Array on host memory.
real(R8P), allocatable, target    :: b5_R8(:,:,:,:,:)                 !< Array on host memory.
real(R8P), allocatable, target    :: a6_R8(:,:,:,:,:,:)               !< Array on host memory.
real(R8P), allocatable, target    :: b6_R8(:,:,:,:,:,:)               !< Array on host memory.
real(R8P), allocatable, target    :: a7_R8(:,:,:,:,:,:,:)             !< Array on host memory.
real(R8P), allocatable, target    :: b7_R8(:,:,:,:,:,:,:)             !< Array on host memory.
real(R4P), pointer                :: a1_dev_R4(:)=>null()             !< Array on device memory.
real(R4P), pointer                :: b1_dev_R4(:)=>null()             !< Array on device memory.
real(R4P), pointer                :: a2_dev_R4(:,:)=>null()           !< Array on device memory.
real(R4P), pointer                :: b2_dev_R4(:,:)=>null()           !< Array on device memory.
real(R4P), pointer                :: a3_dev_R4(:,:,:)=>null()         !< Array on device memory.
real(R4P), pointer                :: b3_dev_R4(:,:,:)=>null()         !< Array on device memory.
real(R4P), pointer                :: a4_dev_R4(:,:,:,:)=>null()       !< Array on device memory.
real(R4P), pointer                :: b4_dev_R4(:,:,:,:)=>null()       !< Array on device memory.
real(R4P), pointer                :: a5_dev_R4(:,:,:,:,:)=>null()     !< Array on device memory.
real(R4P), pointer                :: b5_dev_R4(:,:,:,:,:)=>null()     !< Array on device memory.
real(R4P), pointer                :: a6_dev_R4(:,:,:,:,:,:)=>null()   !< Array on device memory.
real(R4P), pointer                :: b6_dev_R4(:,:,:,:,:,:)=>null()   !< Array on device memory.
real(R4P), pointer                :: a7_dev_R4(:,:,:,:,:,:,:)=>null() !< Array on device memory.
real(R4P), pointer                :: b7_dev_R4(:,:,:,:,:,:,:)=>null() !< Array on device memory.
real(R4P), allocatable, target    :: a1_R4(:)                         !< Array on host memory.
real(R4P), allocatable, target    :: b1_R4(:)                         !< Array on host memory.
real(R4P), allocatable, target    :: a2_R4(:,:)                       !< Array on host memory.
real(R4P), allocatable, target    :: b2_R4(:,:)                       !< Array on host memory.
real(R4P), allocatable, target    :: a3_R4(:,:,:)                     !< Array on host memory.
real(R4P), allocatable, target    :: b3_R4(:,:,:)                     !< Array on host memory.
real(R4P), allocatable, target    :: a4_R4(:,:,:,:)                   !< Array on host memory.
real(R4P), allocatable, target    :: b4_R4(:,:,:,:)                   !< Array on host memory.
real(R4P), allocatable, target    :: a5_R4(:,:,:,:,:)                 !< Array on host memory.
real(R4P), allocatable, target    :: b5_R4(:,:,:,:,:)                 !< Array on host memory.
real(R4P), allocatable, target    :: a6_R4(:,:,:,:,:,:)               !< Array on host memory.
real(R4P), allocatable, target    :: b6_R4(:,:,:,:,:,:)               !< Array on host memory.
real(R4P), allocatable, target    :: a7_R4(:,:,:,:,:,:,:)             !< Array on host memory.
real(R4P), allocatable, target    :: b7_R4(:,:,:,:,:,:,:)             !< Array on host memory.
integer(I8P), pointer             :: a1_dev_I8(:)=>null()             !< Array on device memory.
integer(I8P), pointer             :: b1_dev_I8(:)=>null()             !< Array on device memory.
integer(I8P), pointer             :: a2_dev_I8(:,:)=>null()           !< Array on device memory.
integer(I8P), pointer             :: b2_dev_I8(:,:)=>null()           !< Array on device memory.
integer(I8P), pointer             :: a3_dev_I8(:,:,:)=>null()         !< Array on device memory.
integer(I8P), pointer             :: b3_dev_I8(:,:,:)=>null()         !< Array on device memory.
integer(I8P), pointer             :: a4_dev_I8(:,:,:,:)=>null()       !< Array on device memory.
integer(I8P), pointer             :: b4_dev_I8(:,:,:,:)=>null()       !< Array on device memory.
integer(I8P), pointer             :: a5_dev_I8(:,:,:,:,:)=>null()     !< Array on device memory.
integer(I8P), pointer             :: b5_dev_I8(:,:,:,:,:)=>null()     !< Array on device memory.
integer(I8P), pointer             :: a6_dev_I8(:,:,:,:,:,:)=>null()   !< Array on device memory.
integer(I8P), pointer             :: b6_dev_I8(:,:,:,:,:,:)=>null()   !< Array on device memory.
integer(I8P), pointer             :: a7_dev_I8(:,:,:,:,:,:,:)=>null() !< Array on device memory.
integer(I8P), pointer             :: b7_dev_I8(:,:,:,:,:,:,:)=>null() !< Array on device memory.
integer(I8P), allocatable, target :: a1_I8(:)                         !< Array on host memory.
integer(I8P), allocatable, target :: b1_I8(:)                         !< Array on host memory.
integer(I8P), allocatable, target :: a2_I8(:,:)                       !< Array on host memory.
integer(I8P), allocatable, target :: b2_I8(:,:)                       !< Array on host memory.
integer(I8P), allocatable, target :: a3_I8(:,:,:)                     !< Array on host memory.
integer(I8P), allocatable, target :: b3_I8(:,:,:)                     !< Array on host memory.
integer(I8P), allocatable, target :: a4_I8(:,:,:,:)                   !< Array on host memory.
integer(I8P), allocatable, target :: b4_I8(:,:,:,:)                   !< Array on host memory.
integer(I8P), allocatable, target :: a5_I8(:,:,:,:,:)                 !< Array on host memory.
integer(I8P), allocatable, target :: b5_I8(:,:,:,:,:)                 !< Array on host memory.
integer(I8P), allocatable, target :: a6_I8(:,:,:,:,:,:)               !< Array on host memory.
integer(I8P), allocatable, target :: b6_I8(:,:,:,:,:,:)               !< Array on host memory.
integer(I8P), allocatable, target :: a7_I8(:,:,:,:,:,:,:)             !< Array on host memory.
integer(I8P), allocatable, target :: b7_I8(:,:,:,:,:,:,:)             !< Array on host memory.
integer(I4P), pointer             :: a1_dev_I4(:)=>null()             !< Array on device memory.
integer(I4P), pointer             :: b1_dev_I4(:)=>null()             !< Array on device memory.
integer(I4P), pointer             :: a2_dev_I4(:,:)=>null()           !< Array on device memory.
integer(I4P), pointer             :: b2_dev_I4(:,:)=>null()           !< Array on device memory.
integer(I4P), pointer             :: a3_dev_I4(:,:,:)=>null()         !< Array on device memory.
integer(I4P), pointer             :: b3_dev_I4(:,:,:)=>null()         !< Array on device memory.
integer(I4P), pointer             :: a4_dev_I4(:,:,:,:)=>null()       !< Array on device memory.
integer(I4P), pointer             :: b4_dev_I4(:,:,:,:)=>null()       !< Array on device memory.
integer(I4P), pointer             :: a5_dev_I4(:,:,:,:,:)=>null()     !< Array on device memory.
integer(I4P), pointer             :: b5_dev_I4(:,:,:,:,:)=>null()     !< Array on device memory.
integer(I4P), pointer             :: a6_dev_I4(:,:,:,:,:,:)=>null()   !< Array on device memory.
integer(I4P), pointer             :: b6_dev_I4(:,:,:,:,:,:)=>null()   !< Array on device memory.
integer(I4P), pointer             :: a7_dev_I4(:,:,:,:,:,:,:)=>null() !< Array on device memory.
integer(I4P), pointer             :: b7_dev_I4(:,:,:,:,:,:,:)=>null() !< Array on device memory.
integer(I4P), allocatable, target :: a1_I4(:)                         !< Array on host memory.
integer(I4P), allocatable, target :: b1_I4(:)                         !< Array on host memory.
integer(I4P), allocatable, target :: a2_I4(:,:)                       !< Array on host memory.
integer(I4P), allocatable, target :: b2_I4(:,:)                       !< Array on host memory.
integer(I4P), allocatable, target :: a3_I4(:,:,:)                     !< Array on host memory.
integer(I4P), allocatable, target :: b3_I4(:,:,:)                     !< Array on host memory.
integer(I4P), allocatable, target :: a4_I4(:,:,:,:)                   !< Array on host memory.
integer(I4P), allocatable, target :: b4_I4(:,:,:,:)                   !< Array on host memory.
integer(I4P), allocatable, target :: a5_I4(:,:,:,:,:)                 !< Array on host memory.
integer(I4P), allocatable, target :: b5_I4(:,:,:,:,:)                 !< Array on host memory.
integer(I4P), allocatable, target :: a6_I4(:,:,:,:,:,:)               !< Array on host memory.
integer(I4P), allocatable, target :: b6_I4(:,:,:,:,:,:)               !< Array on host memory.
integer(I4P), allocatable, target :: a7_I4(:,:,:,:,:,:,:)             !< Array on host memory.
integer(I4P), allocatable, target :: b7_I4(:,:,:,:,:,:,:)             !< Array on host memory.
integer(I1P), pointer             :: a1_dev_I1(:)=>null()             !< Array on device memory.
integer(I1P), pointer             :: b1_dev_I1(:)=>null()             !< Array on device memory.
integer(I1P), pointer             :: a2_dev_I1(:,:)=>null()           !< Array on device memory.
integer(I1P), pointer             :: b2_dev_I1(:,:)=>null()           !< Array on device memory.
integer(I1P), pointer             :: a3_dev_I1(:,:,:)=>null()         !< Array on device memory.
integer(I1P), pointer             :: b3_dev_I1(:,:,:)=>null()         !< Array on device memory.
integer(I1P), pointer             :: a4_dev_I1(:,:,:,:)=>null()       !< Array on device memory.
integer(I1P), pointer             :: b4_dev_I1(:,:,:,:)=>null()       !< Array on device memory.
integer(I1P), pointer             :: a5_dev_I1(:,:,:,:,:)=>null()     !< Array on device memory.
integer(I1P), pointer             :: b5_dev_I1(:,:,:,:,:)=>null()     !< Array on device memory.
integer(I1P), pointer             :: a6_dev_I1(:,:,:,:,:,:)=>null()   !< Array on device memory.
integer(I1P), pointer             :: b6_dev_I1(:,:,:,:,:,:)=>null()   !< Array on device memory.
integer(I1P), pointer             :: a7_dev_I1(:,:,:,:,:,:,:)=>null() !< Array on device memory.
integer(I1P), pointer             :: b7_dev_I1(:,:,:,:,:,:,:)=>null() !< Array on device memory.
integer(I1P), allocatable, target :: a1_I1(:)                         !< Array on host memory.
integer(I1P), allocatable, target :: b1_I1(:)                         !< Array on host memory.
integer(I1P), allocatable, target :: a2_I1(:,:)                       !< Array on host memory.
integer(I1P), allocatable, target :: b2_I1(:,:)                       !< Array on host memory.
integer(I1P), allocatable, target :: a3_I1(:,:,:)                     !< Array on host memory.
integer(I1P), allocatable, target :: b3_I1(:,:,:)                     !< Array on host memory.
integer(I1P), allocatable, target :: a4_I1(:,:,:,:)                   !< Array on host memory.
integer(I1P), allocatable, target :: b4_I1(:,:,:,:)                   !< Array on host memory.
integer(I1P), allocatable, target :: a5_I1(:,:,:,:,:)                 !< Array on host memory.
integer(I1P), allocatable, target :: b5_I1(:,:,:,:,:)                 !< Array on host memory.
integer(I1P), allocatable, target :: a6_I1(:,:,:,:,:,:)               !< Array on host memory.
integer(I1P), allocatable, target :: b6_I1(:,:,:,:,:,:)               !< Array on host memory.
integer(I1P), allocatable, target :: a7_I1(:,:,:,:,:,:,:)             !< Array on host memory.
integer(I1P), allocatable, target :: b7_I1(:,:,:,:,:,:,:)             !< Array on host memory.
integer(I4P)                      :: ierr                             !< Error status.
integer(I4P)                      :: n                                !< Number of elements of arrays.
integer(I4P)                      :: i1,i2,i3,i4,i5,i6,i7             !< Counter.

! initialize environment global variables
myhos = dev_get_host_num()
devtype = dev_get_device_type()
call dev_set_device_num(0)
mydev = dev_get_device_num()

call get_n_cli

! allocate host memory and initialize it
allocate(a1_R8(n            ),b1_R8(n            ),&
         a2_R8(n,n          ),b2_R8(n,n          ),&
         a3_R8(n,n,n        ),b3_R8(n,n,n        ),&
         a4_R8(n,n,n,n      ),b4_R8(n,n,n,n      ),&
         a5_R8(n,n,n,n,n    ),b5_R8(n,n,n,n,n    ),&
         a6_R8(n,n,n,n,n,n  ),b6_R8(n,n,n,n,n,n  ),&
         a7_R8(n,n,n,n,n,n,n),b7_R8(n,n,n,n,n,n,n),&
         a1_R4(n            ),b1_R4(n            ),&
         a2_R4(n,n          ),b2_R4(n,n          ),&
         a3_R4(n,n,n        ),b3_R4(n,n,n        ),&
         a4_R4(n,n,n,n      ),b4_R4(n,n,n,n      ),&
         a5_R4(n,n,n,n,n    ),b5_R4(n,n,n,n,n    ),&
         a6_R4(n,n,n,n,n,n  ),b6_R4(n,n,n,n,n,n  ),&
         a7_R4(n,n,n,n,n,n,n),b7_R4(n,n,n,n,n,n,n),&
         a1_I8(n            ),b1_I8(n            ),&
         a2_I8(n,n          ),b2_I8(n,n          ),&
         a3_I8(n,n,n        ),b3_I8(n,n,n        ),&
         a4_I8(n,n,n,n      ),b4_I8(n,n,n,n      ),&
         a5_I8(n,n,n,n,n    ),b5_I8(n,n,n,n,n    ),&
         a6_I8(n,n,n,n,n,n  ),b6_I8(n,n,n,n,n,n  ),&
         a7_I8(n,n,n,n,n,n,n),b7_I8(n,n,n,n,n,n,n),&
         a1_I4(n            ),b1_I4(n            ),&
         a2_I4(n,n          ),b2_I4(n,n          ),&
         a3_I4(n,n,n        ),b3_I4(n,n,n        ),&
         a4_I4(n,n,n,n      ),b4_I4(n,n,n,n      ),&
         a5_I4(n,n,n,n,n    ),b5_I4(n,n,n,n,n    ),&
         a6_I4(n,n,n,n,n,n  ),b6_I4(n,n,n,n,n,n  ),&
         a7_I4(n,n,n,n,n,n,n),b7_I4(n,n,n,n,n,n,n),&
         a1_I1(n            ),b1_I1(n            ),&
         a2_I1(n,n          ),b2_I1(n,n          ),&
         a3_I1(n,n,n        ),b3_I1(n,n,n        ),&
         a4_I1(n,n,n,n      ),b4_I1(n,n,n,n      ),&
         a5_I1(n,n,n,n,n    ),b5_I1(n,n,n,n,n    ),&
         a6_I1(n,n,n,n,n,n  ),b6_I1(n,n,n,n,n,n  ),&
         a7_I1(n,n,n,n,n,n,n),b7_I1(n,n,n,n,n,n,n))
do i1= 1, n
   a1_R8(i1) = i1
   a1_R4(i1) = i1
   a1_I8(i1) = i1
   a1_I4(i1) = i1
   a1_I1(i1) = i1
enddo
do i2= 1, n
do i1= 1, n
   a2_R8(i1,i2) = i1
   a2_R4(i1,i2) = i1
   a2_I8(i1,i2) = i1
   a2_I4(i1,i2) = i1
   a2_I1(i1,i2) = i1
enddo
enddo
do i3= 1, n
do i2= 1, n
do i1= 1, n
   a3_R8(i1,i2,i3) = i1
   a3_R4(i1,i2,i3) = i1
   a3_I8(i1,i2,i3) = i1
   a3_I4(i1,i2,i3) = i1
   a3_I1(i1,i2,i3) = i1
enddo
enddo
enddo
do i4= 1, n
do i3= 1, n
do i2= 1, n
do i1= 1, n
   a4_R8(i1,i2,i3,i4) = i1
   a4_R4(i1,i2,i3,i4) = i1
   a4_I8(i1,i2,i3,i4) = i1
   a4_I4(i1,i2,i3,i4) = i1
   a4_I1(i1,i2,i3,i4) = i1
enddo
enddo
enddo
enddo
do i5= 1, n
do i4= 1, n
do i3= 1, n
do i2= 1, n
do i1= 1, n
   a5_R8(i1,i2,i3,i4,i5) = i1
   a5_R4(i1,i2,i3,i4,i5) = i1
   a5_I8(i1,i2,i3,i4,i5) = i1
   a5_I4(i1,i2,i3,i4,i5) = i1
   a5_I1(i1,i2,i3,i4,i5) = i1
enddo
enddo
enddo
enddo
enddo
do i6= 1, n
do i5= 1, n
do i4= 1, n
do i3= 1, n
do i2= 1, n
do i1= 1, n
   a6_R8(i1,i2,i3,i4,i5,i6) = i1
   a6_R4(i1,i2,i3,i4,i5,i6) = i1
   a6_I8(i1,i2,i3,i4,i5,i6) = i1
   a6_I4(i1,i2,i3,i4,i5,i6) = i1
   a6_I1(i1,i2,i3,i4,i5,i6) = i1
enddo
enddo
enddo
enddo
enddo
enddo
do i7= 1, n
do i6= 1, n
do i5= 1, n
do i4= 1, n
do i3= 1, n
do i2= 1, n
do i1= 1, n
   a7_R8(i1,i2,i3,i4,i5,i6,i7) = i1
   a7_R4(i1,i2,i3,i4,i5,i6,i7) = i1
   a7_I8(i1,i2,i3,i4,i5,i6,i7) = i1
   a7_I4(i1,i2,i3,i4,i5,i6,i7) = i1
   a7_I1(i1,i2,i3,i4,i5,i6,i7) = i1
enddo
enddo
enddo
enddo
enddo
enddo
enddo

! allocate device memory
call dev_alloc(fptr_dev=a1_dev_R8, ubounds=[n            ],ierr=ierr);call error_print(ierr,'a1_dev_R8')
call dev_alloc(fptr_dev=b1_dev_R8, ubounds=[n            ],ierr=ierr);call error_print(ierr,'b1_dev_R8')
call dev_alloc(fptr_dev=a2_dev_R8, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'a2_dev_R8')
call dev_alloc(fptr_dev=b2_dev_R8, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'b2_dev_R8')
call dev_alloc(fptr_dev=a3_dev_R8, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'a3_dev_R8')
call dev_alloc(fptr_dev=b3_dev_R8, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'b3_dev_R8')
call dev_alloc(fptr_dev=a4_dev_R8, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'a4_dev_R8')
call dev_alloc(fptr_dev=b4_dev_R8, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'b4_dev_R8')
call dev_alloc(fptr_dev=a5_dev_R8, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'a5_dev_R8')
call dev_alloc(fptr_dev=b5_dev_R8, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'b5_dev_R8')
call dev_alloc(fptr_dev=a6_dev_R8, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'a6_dev_R8')
call dev_alloc(fptr_dev=b6_dev_R8, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'b6_dev_R8')
call dev_alloc(fptr_dev=a7_dev_R8, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'a7_dev_R8')
call dev_alloc(fptr_dev=b7_dev_R8, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'b7_dev_R8')
call dev_alloc(fptr_dev=a1_dev_R4, ubounds=[n            ],ierr=ierr);call error_print(ierr,'a1_dev_R4')
call dev_alloc(fptr_dev=b1_dev_R4, ubounds=[n            ],ierr=ierr);call error_print(ierr,'b1_dev_R4')
call dev_alloc(fptr_dev=a2_dev_R4, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'a2_dev_R4')
call dev_alloc(fptr_dev=b2_dev_R4, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'b2_dev_R4')
call dev_alloc(fptr_dev=a3_dev_R4, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'a3_dev_R4')
call dev_alloc(fptr_dev=b3_dev_R4, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'b3_dev_R4')
call dev_alloc(fptr_dev=a4_dev_R4, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'a4_dev_R4')
call dev_alloc(fptr_dev=b4_dev_R4, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'b4_dev_R4')
call dev_alloc(fptr_dev=a5_dev_R4, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'a5_dev_R4')
call dev_alloc(fptr_dev=b5_dev_R4, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'b5_dev_R4')
call dev_alloc(fptr_dev=a6_dev_R4, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'a6_dev_R4')
call dev_alloc(fptr_dev=b6_dev_R4, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'b6_dev_R4')
call dev_alloc(fptr_dev=a7_dev_R4, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'a7_dev_R4')
call dev_alloc(fptr_dev=b7_dev_R4, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'b7_dev_R4')
call dev_alloc(fptr_dev=a1_dev_I8, ubounds=[n            ],ierr=ierr);call error_print(ierr,'a1_dev_I8')
call dev_alloc(fptr_dev=b1_dev_I8, ubounds=[n            ],ierr=ierr);call error_print(ierr,'b1_dev_I8')
call dev_alloc(fptr_dev=a2_dev_I8, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'a2_dev_I8')
call dev_alloc(fptr_dev=b2_dev_I8, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'b2_dev_I8')
call dev_alloc(fptr_dev=a3_dev_I8, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'a3_dev_I8')
call dev_alloc(fptr_dev=b3_dev_I8, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'b3_dev_I8')
call dev_alloc(fptr_dev=a4_dev_I8, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'a4_dev_I8')
call dev_alloc(fptr_dev=b4_dev_I8, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'b4_dev_I8')
call dev_alloc(fptr_dev=a5_dev_I8, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'a5_dev_I8')
call dev_alloc(fptr_dev=b5_dev_I8, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'b5_dev_I8')
call dev_alloc(fptr_dev=a6_dev_I8, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'a6_dev_I8')
call dev_alloc(fptr_dev=b6_dev_I8, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'b6_dev_I8')
call dev_alloc(fptr_dev=a7_dev_I8, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'a7_dev_I8')
call dev_alloc(fptr_dev=b7_dev_I8, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'b7_dev_I8')
call dev_alloc(fptr_dev=a1_dev_I4, ubounds=[n            ],ierr=ierr);call error_print(ierr,'a1_dev_I4')
call dev_alloc(fptr_dev=b1_dev_I4, ubounds=[n            ],ierr=ierr);call error_print(ierr,'b1_dev_I4')
call dev_alloc(fptr_dev=a2_dev_I4, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'a2_dev_I4')
call dev_alloc(fptr_dev=b2_dev_I4, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'b2_dev_I4')
call dev_alloc(fptr_dev=a3_dev_I4, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'a3_dev_I4')
call dev_alloc(fptr_dev=b3_dev_I4, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'b3_dev_I4')
call dev_alloc(fptr_dev=a4_dev_I4, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'a4_dev_I4')
call dev_alloc(fptr_dev=b4_dev_I4, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'b4_dev_I4')
call dev_alloc(fptr_dev=a5_dev_I4, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'a5_dev_I4')
call dev_alloc(fptr_dev=b5_dev_I4, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'b5_dev_I4')
call dev_alloc(fptr_dev=a6_dev_I4, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'a6_dev_I4')
call dev_alloc(fptr_dev=b6_dev_I4, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'b6_dev_I4')
call dev_alloc(fptr_dev=a7_dev_I4, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'a7_dev_I4')
call dev_alloc(fptr_dev=b7_dev_I4, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'b7_dev_I4')
call dev_alloc(fptr_dev=a1_dev_I1, ubounds=[n            ],ierr=ierr);call error_print(ierr,'a1_dev_I1')
call dev_alloc(fptr_dev=b1_dev_I1, ubounds=[n            ],ierr=ierr);call error_print(ierr,'b1_dev_I1')
call dev_alloc(fptr_dev=a2_dev_I1, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'a2_dev_I1')
call dev_alloc(fptr_dev=b2_dev_I1, ubounds=[n,n          ],ierr=ierr);call error_print(ierr,'b2_dev_I1')
call dev_alloc(fptr_dev=a3_dev_I1, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'a3_dev_I1')
call dev_alloc(fptr_dev=b3_dev_I1, ubounds=[n,n,n        ],ierr=ierr);call error_print(ierr,'b3_dev_I1')
call dev_alloc(fptr_dev=a4_dev_I1, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'a4_dev_I1')
call dev_alloc(fptr_dev=b4_dev_I1, ubounds=[n,n,n,n      ],ierr=ierr);call error_print(ierr,'b4_dev_I1')
call dev_alloc(fptr_dev=a5_dev_I1, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'a5_dev_I1')
call dev_alloc(fptr_dev=b5_dev_I1, ubounds=[n,n,n,n,n    ],ierr=ierr);call error_print(ierr,'b5_dev_I1')
call dev_alloc(fptr_dev=a6_dev_I1, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'a6_dev_I1')
call dev_alloc(fptr_dev=b6_dev_I1, ubounds=[n,n,n,n,n,n  ],ierr=ierr);call error_print(ierr,'b6_dev_I1')
call dev_alloc(fptr_dev=a7_dev_I1, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'a7_dev_I1')
call dev_alloc(fptr_dev=b7_dev_I1, ubounds=[n,n,n,n,n,n,n],ierr=ierr);call error_print(ierr,'b7_dev_I1')

! copy host memory to device one
print '(A)', 'copy memory to device'
call dev_memcpy_to_device(fptr_src=a1_R8, fptr_dst=a1_dev_R8)
call dev_memcpy_to_device(fptr_src=a2_R8, fptr_dst=a2_dev_R8)
call dev_memcpy_to_device(fptr_src=a3_R8, fptr_dst=a3_dev_R8)
call dev_memcpy_to_device(fptr_src=a4_R8, fptr_dst=a4_dev_R8)
call dev_memcpy_to_device(fptr_src=a5_R8, fptr_dst=a5_dev_R8)
call dev_memcpy_to_device(fptr_src=a6_R8, fptr_dst=a6_dev_R8)
call dev_memcpy_to_device(fptr_src=a7_R8, fptr_dst=a7_dev_R8)
call dev_memcpy_to_device(fptr_src=a1_R4, fptr_dst=a1_dev_R4)
call dev_memcpy_to_device(fptr_src=a2_R4, fptr_dst=a2_dev_R4)
call dev_memcpy_to_device(fptr_src=a3_R4, fptr_dst=a3_dev_R4)
call dev_memcpy_to_device(fptr_src=a4_R4, fptr_dst=a4_dev_R4)
call dev_memcpy_to_device(fptr_src=a5_R4, fptr_dst=a5_dev_R4)
call dev_memcpy_to_device(fptr_src=a6_R4, fptr_dst=a6_dev_R4)
call dev_memcpy_to_device(fptr_src=a7_R4, fptr_dst=a7_dev_R4)
call dev_memcpy_to_device(fptr_src=a1_I8, fptr_dst=a1_dev_I8)
call dev_memcpy_to_device(fptr_src=a2_I8, fptr_dst=a2_dev_I8)
call dev_memcpy_to_device(fptr_src=a3_I8, fptr_dst=a3_dev_I8)
call dev_memcpy_to_device(fptr_src=a4_I8, fptr_dst=a4_dev_I8)
call dev_memcpy_to_device(fptr_src=a5_I8, fptr_dst=a5_dev_I8)
call dev_memcpy_to_device(fptr_src=a6_I8, fptr_dst=a6_dev_I8)
call dev_memcpy_to_device(fptr_src=a7_I8, fptr_dst=a7_dev_I8)
call dev_memcpy_to_device(fptr_src=a1_I4, fptr_dst=a1_dev_I4)
call dev_memcpy_to_device(fptr_src=a2_I4, fptr_dst=a2_dev_I4)
call dev_memcpy_to_device(fptr_src=a3_I4, fptr_dst=a3_dev_I4)
call dev_memcpy_to_device(fptr_src=a4_I4, fptr_dst=a4_dev_I4)
call dev_memcpy_to_device(fptr_src=a5_I4, fptr_dst=a5_dev_I4)
call dev_memcpy_to_device(fptr_src=a6_I4, fptr_dst=a6_dev_I4)
call dev_memcpy_to_device(fptr_src=a7_I4, fptr_dst=a7_dev_I4)
call dev_memcpy_to_device(fptr_src=a1_I1, fptr_dst=a1_dev_I1)
call dev_memcpy_to_device(fptr_src=a2_I1, fptr_dst=a2_dev_I1)
call dev_memcpy_to_device(fptr_src=a3_I1, fptr_dst=a3_dev_I1)
call dev_memcpy_to_device(fptr_src=a4_I1, fptr_dst=a4_dev_I1)
call dev_memcpy_to_device(fptr_src=a5_I1, fptr_dst=a5_dev_I1)
call dev_memcpy_to_device(fptr_src=a6_I1, fptr_dst=a6_dev_I1)
call dev_memcpy_to_device(fptr_src=a7_I1, fptr_dst=a7_dev_I1)

! do some operation on device
print '(A)', 'compute on device'
!$acc parallel loop independent DEVICEVAR(a1_dev_R8, b1_dev_R8, &
!$acc&                                    a1_dev_R4, b1_dev_R4, &
!$acc&                                    a1_dev_I8, b1_dev_I8, &
!$acc&                                    a1_dev_I4, b1_dev_I4, &
!$acc&                                    a1_dev_I1, b1_dev_I1)
!$omp OMPLOOP DEVICEVAR(a1_dev_R8, b1_dev_R8, &
!$omp&                  a1_dev_R4, b1_dev_R4, &
!$omp&                  a1_dev_I8, b1_dev_I8, &
!$omp&                  a1_dev_I4, b1_dev_I4, &
!$omp&                  a1_dev_I1, b1_dev_I1)
do i1 = 1, n
   b1_dev_R8(i1) = a1_dev_R8(i1) + 10
   b1_dev_R4(i1) = a1_dev_R4(i1) + 10
   b1_dev_I8(i1) = a1_dev_I8(i1) + 10
   b1_dev_I4(i1) = a1_dev_I4(i1) + 10
   b1_dev_I1(i1) = a1_dev_I1(i1) + 10
enddo
!$acc parallel loop independent DEVICEVAR(a2_dev_R8, b2_dev_R8, &
!$acc&                                    a2_dev_R4, b2_dev_R4, &
!$acc&                                    a2_dev_I8, b2_dev_I8, &
!$acc&                                    a2_dev_I4, b2_dev_I4, &
!$acc&                                    a2_dev_I1, b2_dev_I1)
!$omp OMPLOOP DEVICEVAR(a2_dev_R8, b2_dev_R8, &
!$omp&                  a2_dev_R4, b2_dev_R4, &
!$omp&                  a2_dev_I8, b2_dev_I8, &
!$omp&                  a2_dev_I4, b2_dev_I4, &
!$omp&                  a2_dev_I1, b2_dev_I1)
do i2 = 1, n
!$acc loop
do i1 = 1, n
   b2_dev_R8(i1,i2) = a2_dev_R8(i1,i2) + 10
   b2_dev_R4(i1,i2) = a2_dev_R4(i1,i2) + 10
   b2_dev_I8(i1,i2) = a2_dev_I8(i1,i2) + 10
   b2_dev_I4(i1,i2) = a2_dev_I4(i1,i2) + 10
   b2_dev_I1(i1,i2) = a2_dev_I1(i1,i2) + 10
enddo
enddo
!$acc parallel loop independent DEVICEVAR(a3_dev_R8, b3_dev_R8, &
!$acc&                                    a3_dev_R4, b3_dev_R4, &
!$acc&                                    a3_dev_I8, b3_dev_I8, &
!$acc&                                    a3_dev_I4, b3_dev_I4, &
!$acc&                                    a3_dev_I1, b3_dev_I1)
!$omp OMPLOOP DEVICEVAR(a3_dev_R8, b3_dev_R8, &
!$omp&                  a3_dev_R4, b3_dev_R4, &
!$omp&                  a3_dev_I8, b3_dev_I8, &
!$omp&                  a3_dev_I4, b3_dev_I4, &
!$omp&                  a3_dev_I1, b3_dev_I1)
do i3 = 1, n
!$acc loop
do i2 = 1, n
!$acc loop
do i1 = 1, n
   b3_dev_R8(i1,i2,i3) = a3_dev_R8(i1,i2,i3) + 10
   b3_dev_R4(i1,i2,i3) = a3_dev_R4(i1,i2,i3) + 10
   b3_dev_I8(i1,i2,i3) = a3_dev_I8(i1,i2,i3) + 10
   b3_dev_I4(i1,i2,i3) = a3_dev_I4(i1,i2,i3) + 10
   b3_dev_I1(i1,i2,i3) = a3_dev_I1(i1,i2,i3) + 10
enddo
enddo
enddo
!$acc parallel loop independent DEVICEVAR(a4_dev_R8, b4_dev_R8, &
!$acc&                                    a4_dev_R4, b4_dev_R4, &
!$acc&                                    a4_dev_I8, b4_dev_I8, &
!$acc&                                    a4_dev_I4, b4_dev_I4, &
!$acc&                                    a4_dev_I1, b4_dev_I1)
!$omp OMPLOOP DEVICEVAR(a4_dev_R8, b4_dev_R8, &
!$omp&                  a4_dev_R4, b4_dev_R4, &
!$omp&                  a4_dev_I8, b4_dev_I8, &
!$omp&                  a4_dev_I4, b4_dev_I4, &
!$omp&                  a4_dev_I1, b4_dev_I1)
do i4 = 1, n
!$acc loop
do i3 = 1, n
!$acc loop
do i2 = 1, n
!$acc loop
do i1 = 1, n
   b4_dev_R8(i1,i2,i3,i4) = a4_dev_R8(i1,i2,i3,i4) + 10
   b4_dev_R4(i1,i2,i3,i4) = a4_dev_R4(i1,i2,i3,i4) + 10
   b4_dev_I8(i1,i2,i3,i4) = a4_dev_I8(i1,i2,i3,i4) + 10
   b4_dev_I4(i1,i2,i3,i4) = a4_dev_I4(i1,i2,i3,i4) + 10
   b4_dev_I1(i1,i2,i3,i4) = a4_dev_I1(i1,i2,i3,i4) + 10
enddo
enddo
enddo
enddo
!$acc parallel loop independent DEVICEVAR(a5_dev_R8, b5_dev_R8, &
!$acc&                                    a5_dev_R4, b5_dev_R4, &
!$acc&                                    a5_dev_I8, b5_dev_I8, &
!$acc&                                    a5_dev_I4, b5_dev_I4, &
!$acc&                                    a5_dev_I1, b5_dev_I1)
!$omp OMPLOOP DEVICEVAR(a5_dev_R8, b5_dev_R8, &
!$omp&                  a5_dev_R4, b5_dev_R4, &
!$omp&                  a5_dev_I8, b5_dev_I8, &
!$omp&                  a5_dev_I4, b5_dev_I4, &
!$omp&                  a5_dev_I1, b5_dev_I1)
do i5 = 1, n
!$acc loop
do i4 = 1, n
!$acc loop
do i3 = 1, n
!$acc loop
do i2 = 1, n
!$acc loop
do i1 = 1, n
   b5_dev_R8(i1,i2,i3,i4,i5) = a5_dev_R8(i1,i2,i3,i4,i5) + 10
   b5_dev_R4(i1,i2,i3,i4,i5) = a5_dev_R4(i1,i2,i3,i4,i5) + 10
   b5_dev_I8(i1,i2,i3,i4,i5) = a5_dev_I8(i1,i2,i3,i4,i5) + 10
   b5_dev_I4(i1,i2,i3,i4,i5) = a5_dev_I4(i1,i2,i3,i4,i5) + 10
   b5_dev_I1(i1,i2,i3,i4,i5) = a5_dev_I1(i1,i2,i3,i4,i5) + 10
enddo
enddo
enddo
enddo
enddo
!$acc parallel loop independent DEVICEVAR(a6_dev_R8, b6_dev_R8, &
!$acc&                                    a6_dev_R4, b6_dev_R4, &
!$acc&                                    a6_dev_I8, b6_dev_I8, &
!$acc&                                    a6_dev_I4, b6_dev_I4, &
!$acc&                                    a6_dev_I1, b6_dev_I1)
!$omp OMPLOOP DEVICEVAR(a6_dev_R8, b6_dev_R8, &
!$omp&                  a6_dev_R4, b6_dev_R4, &
!$omp&                  a6_dev_I8, b6_dev_I8, &
!$omp&                  a6_dev_I4, b6_dev_I4, &
!$omp&                  a6_dev_I1, b6_dev_I1)
do i6 = 1, n
!$acc loop
do i5 = 1, n
!$acc loop
do i4 = 1, n
!$acc loop
do i3 = 1, n
!$acc loop
do i2 = 1, n
!$acc loop
do i1 = 1, n
   b6_dev_R8(i1,i2,i3,i4,i5,i6) = a6_dev_R8(i1,i2,i3,i4,i5,i6) + 10
   b6_dev_R4(i1,i2,i3,i4,i5,i6) = a6_dev_R4(i1,i2,i3,i4,i5,i6) + 10
   b6_dev_I8(i1,i2,i3,i4,i5,i6) = a6_dev_I8(i1,i2,i3,i4,i5,i6) + 10
   b6_dev_I4(i1,i2,i3,i4,i5,i6) = a6_dev_I4(i1,i2,i3,i4,i5,i6) + 10
   b6_dev_I1(i1,i2,i3,i4,i5,i6) = a6_dev_I1(i1,i2,i3,i4,i5,i6) + 10
enddo
enddo
enddo
enddo
enddo
enddo
!$acc parallel loop independent DEVICEVAR(a7_dev_R8, b7_dev_R8, &
!$acc&                                    a7_dev_R4, b7_dev_R4, &
!$acc&                                    a7_dev_I8, b7_dev_I8, &
!$acc&                                    a7_dev_I4, b7_dev_I4, &
!$acc&                                    a7_dev_I1, b7_dev_I1)
!$omp OMPLOOP DEVICEVAR(a7_dev_R8, b7_dev_R8, &
!$omp&                  a7_dev_R4, b7_dev_R4, &
!$omp&                  a7_dev_I8, b7_dev_I8, &
!$omp&                  a7_dev_I4, b7_dev_I4, &
!$omp&                  a7_dev_I1, b7_dev_I1)
do i7 = 1, n
!$acc loop
do i6 = 1, n
!$acc loop
do i5 = 1, n
!$acc loop
do i4 = 1, n
!$acc loop
do i3 = 1, n
!$acc loop
do i2 = 1, n
!$acc loop
do i1 = 1, n
   b7_dev_R8(i1,i2,i3,i4,i5,i6,i7) = a7_dev_R8(i1,i2,i3,i4,i5,i6,i7) + 10
   b7_dev_R4(i1,i2,i3,i4,i5,i6,i7) = a7_dev_R4(i1,i2,i3,i4,i5,i6,i7) + 10
   b7_dev_I8(i1,i2,i3,i4,i5,i6,i7) = a7_dev_I8(i1,i2,i3,i4,i5,i6,i7) + 10
   b7_dev_I4(i1,i2,i3,i4,i5,i6,i7) = a7_dev_I4(i1,i2,i3,i4,i5,i6,i7) + 10
   b7_dev_I1(i1,i2,i3,i4,i5,i6,i7) = a7_dev_I1(i1,i2,i3,i4,i5,i6,i7) + 10
enddo
enddo
enddo
enddo
enddo
enddo
enddo

! copy device memory to host one
print '(A)', 'copy memory from device'
call dev_memcpy_from_device(fptr_src=b1_dev_R8, fptr_dst=b1_R8)
call dev_memcpy_from_device(fptr_src=b2_dev_R8, fptr_dst=b2_R8)
call dev_memcpy_from_device(fptr_src=b3_dev_R8, fptr_dst=b3_R8)
call dev_memcpy_from_device(fptr_src=b4_dev_R8, fptr_dst=b4_R8)
call dev_memcpy_from_device(fptr_src=b5_dev_R8, fptr_dst=b5_R8)
call dev_memcpy_from_device(fptr_src=b6_dev_R8, fptr_dst=b6_R8)
call dev_memcpy_from_device(fptr_src=b7_dev_R8, fptr_dst=b7_R8)
call dev_memcpy_from_device(fptr_src=b1_dev_R4, fptr_dst=b1_R4)
call dev_memcpy_from_device(fptr_src=b2_dev_R4, fptr_dst=b2_R4)
call dev_memcpy_from_device(fptr_src=b3_dev_R4, fptr_dst=b3_R4)
call dev_memcpy_from_device(fptr_src=b4_dev_R4, fptr_dst=b4_R4)
call dev_memcpy_from_device(fptr_src=b5_dev_R4, fptr_dst=b5_R4)
call dev_memcpy_from_device(fptr_src=b6_dev_R4, fptr_dst=b6_R4)
call dev_memcpy_from_device(fptr_src=b7_dev_R4, fptr_dst=b7_R4)
call dev_memcpy_from_device(fptr_src=b1_dev_I8, fptr_dst=b1_I8)
call dev_memcpy_from_device(fptr_src=b2_dev_I8, fptr_dst=b2_I8)
call dev_memcpy_from_device(fptr_src=b3_dev_I8, fptr_dst=b3_I8)
call dev_memcpy_from_device(fptr_src=b4_dev_I8, fptr_dst=b4_I8)
call dev_memcpy_from_device(fptr_src=b5_dev_I8, fptr_dst=b5_I8)
call dev_memcpy_from_device(fptr_src=b6_dev_I8, fptr_dst=b6_I8)
call dev_memcpy_from_device(fptr_src=b7_dev_I8, fptr_dst=b7_I8)
call dev_memcpy_from_device(fptr_src=b1_dev_I4, fptr_dst=b1_I4)
call dev_memcpy_from_device(fptr_src=b2_dev_I4, fptr_dst=b2_I4)
call dev_memcpy_from_device(fptr_src=b3_dev_I4, fptr_dst=b3_I4)
call dev_memcpy_from_device(fptr_src=b4_dev_I4, fptr_dst=b4_I4)
call dev_memcpy_from_device(fptr_src=b5_dev_I4, fptr_dst=b5_I4)
call dev_memcpy_from_device(fptr_src=b6_dev_I4, fptr_dst=b6_I4)
call dev_memcpy_from_device(fptr_src=b7_dev_I4, fptr_dst=b7_I4)
call dev_memcpy_from_device(fptr_src=b1_dev_I1, fptr_dst=b1_I1)
call dev_memcpy_from_device(fptr_src=b2_dev_I1, fptr_dst=b2_I1)
call dev_memcpy_from_device(fptr_src=b3_dev_I1, fptr_dst=b3_I1)
call dev_memcpy_from_device(fptr_src=b4_dev_I1, fptr_dst=b4_I1)
call dev_memcpy_from_device(fptr_src=b5_dev_I1, fptr_dst=b5_I1)
call dev_memcpy_from_device(fptr_src=b6_dev_I1, fptr_dst=b6_I1)
call dev_memcpy_from_device(fptr_src=b7_dev_I1, fptr_dst=b7_I1)

! check results
print '(A)', 'chek results'
do i1=1, n
   if (int(b1_R8(i1) - a1_R8(i1),I4P) /= 10_I4P.or.&
       int(b1_R4(i1) - a1_R4(i1),I4P) /= 10_I4P.or.&
       int(b1_I8(i1) - a1_I8(i1),I4P) /= 10_I4P.or.&
       int(b1_I4(i1) - a1_I4(i1),I4P) /= 10_I4P.or.&
       int(b1_I1(i1) - a1_I1(i1),I4P) /= 10_I4P) then
      print '(A)', 'error: something is not working...'
      stop
   endif
enddo
do i2=1, n
do i1=1, n
   if (int(b2_R8(i1,i2) - a2_R8(i1,i2),I4P) /= 10_I4P.or.&
       int(b2_R4(i1,i2) - a2_R4(i1,i2),I4P) /= 10_I4P.or.&
       int(b2_I8(i1,i2) - a2_I8(i1,i2),I4P) /= 10_I4P.or.&
       int(b2_I4(i1,i2) - a2_I4(i1,i2),I4P) /= 10_I4P.or.&
       int(b2_I1(i1,i2) - a2_I1(i1,i2),I4P) /= 10_I4P) then
      print '(A)', 'error: something is not working...'
      stop
   endif
enddo
enddo
do i3=1, n
do i2=1, n
do i1=1, n
   if (int(b3_R8(i1,i2,i3) - a3_R8(i1,i2,i3),I4P) /= 10_I4P.or.&
       int(b3_R4(i1,i2,i3) - a3_R4(i1,i2,i3),I4P) /= 10_I4P.or.&
       int(b3_I8(i1,i2,i3) - a3_I8(i1,i2,i3),I4P) /= 10_I4P.or.&
       int(b3_I4(i1,i2,i3) - a3_I4(i1,i2,i3),I4P) /= 10_I4P.or.&
       int(b3_I1(i1,i2,i3) - a3_I1(i1,i2,i3),I4P) /= 10_I4P) then
      print '(A)', 'error: something is not working...'
      stop
   endif
enddo
enddo
enddo
do i4=1, n
do i3=1, n
do i2=1, n
do i1=1, n
   if (int(b4_R8(i1,i2,i3,i4) - a4_R8(i1,i2,i3,i4),I4P) /= 10_I4P.or.&
       int(b4_R4(i1,i2,i3,i4) - a4_R4(i1,i2,i3,i4),I4P) /= 10_I4P.or.&
       int(b4_I8(i1,i2,i3,i4) - a4_I8(i1,i2,i3,i4),I4P) /= 10_I4P.or.&
       int(b4_I4(i1,i2,i3,i4) - a4_I4(i1,i2,i3,i4),I4P) /= 10_I4P.or.&
       int(b4_I1(i1,i2,i3,i4) - a4_I1(i1,i2,i3,i4),I4P) /= 10_I4P) then
      print '(A)', 'error: something is not working...'
      stop
   endif
enddo
enddo
enddo
enddo
do i5=1, n
do i4=1, n
do i3=1, n
do i2=1, n
do i1=1, n
   if (int(b5_R8(i1,i2,i3,i4,i5) - a5_R8(i1,i2,i3,i4,i5),I4P) /= 10_I4P.or.&
       int(b5_R4(i1,i2,i3,i4,i5) - a5_R4(i1,i2,i3,i4,i5),I4P) /= 10_I4P.or.&
       int(b5_I8(i1,i2,i3,i4,i5) - a5_I8(i1,i2,i3,i4,i5),I4P) /= 10_I4P.or.&
       int(b5_I4(i1,i2,i3,i4,i5) - a5_I4(i1,i2,i3,i4,i5),I4P) /= 10_I4P.or.&
       int(b5_I1(i1,i2,i3,i4,i5) - a5_I1(i1,i2,i3,i4,i5),I4P) /= 10_I4P) then
      print '(A)', 'error: something is not working...'
      stop
   endif
enddo
enddo
enddo
enddo
enddo
do i6=1, n
do i5=1, n
do i4=1, n
do i3=1, n
do i2=1, n
do i1=1, n
   if (int(b6_R8(i1,i2,i3,i4,i5,i6) - a6_R8(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P.or.&
       int(b6_R4(i1,i2,i3,i4,i5,i6) - a6_R4(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P.or.&
       int(b6_I8(i1,i2,i3,i4,i5,i6) - a6_I8(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P.or.&
       int(b6_I4(i1,i2,i3,i4,i5,i6) - a6_I4(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P.or.&
       int(b6_I1(i1,i2,i3,i4,i5,i6) - a6_I1(i1,i2,i3,i4,i5,i6),I4P) /= 10_I4P) then
      print '(A)', 'error: something is not working...'
      stop
   endif
enddo
enddo
enddo
enddo
enddo
enddo
do i7=1, n
do i6=1, n
do i5=1, n
do i4=1, n
do i3=1, n
do i2=1, n
do i1=1, n
   if (int(b7_R8(i1,i2,i3,i4,i5,i6,i7) - a7_R8(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P.or.&
       int(b7_R4(i1,i2,i3,i4,i5,i6,i7) - a7_R4(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P.or.&
       int(b7_I8(i1,i2,i3,i4,i5,i6,i7) - a7_I8(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P.or.&
       int(b7_I4(i1,i2,i3,i4,i5,i6,i7) - a7_I4(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P.or.&
       int(b7_I1(i1,i2,i3,i4,i5,i6,i7) - a7_I1(i1,i2,i3,i4,i5,i6,i7),I4P) /= 10_I4P) then
      print '(A)', 'error: something is not working...'
      stop
   endif
enddo
enddo
enddo
enddo
enddo
enddo
enddo

print '(A)', 'test passed'
contains
   subroutine get_n_cli
   !< Get n from Command Line Interface.
   character(10) :: nstr !< Number of elements of arrays, stringified.

   n = 10
   if(command_argument_count() >= 1)then
      call get_command_argument(1, nstr)
      read(nstr, *) n
      if (n <= 0) n = 10
   endif
   endsubroutine get_n_cli

   subroutine error_print(error, msg)
   !< Print error message.
   integer(I4P), intent(in) :: error !< Error status.
   character(*), intent(in) :: msg   !< Error message.

   if (error /= 0) then
      print '(A)', 'error: '//trim(adjustl(msg))//' not allocated!'
      stop
   endif
   endsubroutine error_print
endprogram fundal_memcpy_test
