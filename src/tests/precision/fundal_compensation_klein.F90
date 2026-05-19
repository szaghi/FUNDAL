!< FUNDAL, V3c — Klein second-order cascaded Neumaier compensation. Two
!< carry levels: `comp` accumulates the bits lost in the primary U += y
!< add (as in V3b); `comp2` accumulates the bits lost in the comp += c_inc
!< add itself. The true state is U + comp + comp2, reconstituted at the
!< final read.
!<
!< Error per add: O(eps^2) instead of Neumaier's O(eps). On consumer GPU
!< at typical step counts (100-1000) the first-level carry doesn't
!< saturate, so the second-level catches little and V3c is observed to be
!< WORSE than V3b. The crossover is at ~10^4 steps.
!<
!< Reference: Klein (2006) "A generalized Kahan-Babuska-summation
!< algorithm."

#include "fundal.H"

module fundal_compensation_klein
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R4P=>real32

implicit none
private
public :: rk1_update_r4_klein

contains

   subroutine rk1_update_r4_klein(U, rhs, comp, comp2, dt, nb, ni, ng, nc)
   integer(I4P), intent(in) :: nb, ni, ng, nc
   real(R4P), intent(inout) :: U    (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P), intent(in)    :: rhs  (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P), intent(inout) :: comp (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P), intent(inout) :: comp2(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P), intent(in)    :: dt
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: y, t, u_old, c_inc, c_old, t2

   !$acc parallel loop collapse(5) present(U, rhs, comp, comp2) &
   !$acc                          private(y, t, u_old, c_inc, c_old, t2)
   do c = 1, nc
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               do b = 1, nb
                  u_old = U(b,i,j,k,c)
                  y     = dt * rhs(b,i,j,k,c)
                  t     = u_old + y
                  if (abs(u_old) >= abs(y)) then
                     c_inc = (u_old - t) + y
                  else
                     c_inc = (y - t) + u_old
                  endif
                  U(b,i,j,k,c) = t

                  c_old = comp(b,i,j,k,c)
                  t2    = c_old + c_inc
                  if (abs(c_old) >= abs(c_inc)) then
                     comp2(b,i,j,k,c) = comp2(b,i,j,k,c) + ((c_old - t2) + c_inc)
                  else
                     comp2(b,i,j,k,c) = comp2(b,i,j,k,c) + ((c_inc - t2) + c_old)
                  endif
                  comp(b,i,j,k,c) = t2
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine rk1_update_r4_klein

endmodule fundal_compensation_klein
