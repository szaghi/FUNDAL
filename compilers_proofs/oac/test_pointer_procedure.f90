program test_pointer_procedure

use openacc
implicit none

integer, parameter :: ni = 1000
integer            :: i
real               :: a(ni)

procedure(subroutine_template), pointer :: do_work

interface
   subroutine subroutine_template(i, x)
   integer, intent(in)  :: i
   real,    intent(out) :: x
   endsubroutine subroutine_template
endinterface

do_work => do_work_ok
!$acc enter data create(a, do_work)
!$acc parallel loop present(a)
do i=1, ni
   call do_work(i=i, x=a(i))
enddo
!$acc exit data copyout(a) delete(do_work)
print *, ' work ok', maxval(a)
do_work => do_work_ko
!$acc enter data create(a)
!$acc parallel loop present(a, do_work)
do i=1, ni
   call do_work(i=i, x=a(i))
enddo
!$acc exit data copyout(a) delete(do_work)
print *, ' work ko', maxval(a)

contains
   subroutine do_work_ok(i, x)
   integer, intent(in)  :: i
   real,    intent(out) :: x
   !$acc routine(do_work_ok)
   x = real(i)
   endsubroutine do_work_ok

   subroutine do_work_ko(i, x)
   integer, intent(in)  :: i
   real,    intent(out) :: x
   !$acc routine(do_work_ko)
   x = -real(i)
   endsubroutine do_work_ko
endprogram test_pointer_procedure
