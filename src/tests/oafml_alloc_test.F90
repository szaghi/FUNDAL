!< OAFML, device memory alloc test.
program oafml_alloc_test
!< OAFML, device memory alloc test.

use, intrinsic :: iso_fortran_env, only : I1P=>int8, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use oafml

implicit none

real(R8P), pointer :: a1_dev(:)=>null() !< Array on device memory, lbound=1.
real(R8P), pointer :: a2_dev(:)=>null() !< Array on device memory, lbound=-1.
integer(I4P)       :: error             !< Error status.

call oac_alloc(fptr_dev=a1_dev, ubounds=[1000], ierr=error)
if (error == 0) then
   print*, 'a1_dev bounds: [', lbound(a1_dev), ']-[', ubound(a1_dev), ']'
else
   print*, 'error: a1_dev not allocated!'
endif

call oac_alloc(fptr_dev=a2_dev, lbounds=[-1], ubounds=[1000], ierr=error)
if (error == 0) then
   print*, 'a2_dev bounds: [', lbound(a2_dev), ']-[', ubound(a2_dev), ']'
else
   print*, 'error: a1_dev not allocated!'
endif
endprogram oafml_alloc_test
