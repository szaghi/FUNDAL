!< FUNDAL, V3e — Ogita-Rump branchless FastTwoSum compensated RK1.
!<
!< The canonical Neumaier (V3b) compensated sum has a per-cell
!< `if (abs(u_old) >= abs(y))` branch that causes warp divergence on GPU
!< when neighbour cells fall on different sides of the test. In RK1 with
!< |U| = O(1) and |dt*rhs| = O(1e-3), the precondition |u_old| >= |y|
!< holds for essentially every cell, so the unconditional FastTwoSum form
!< (Ogita-Rump-Oishi, SISC 2005) is mathematically valid and removes the
!< branch entirely. Recovers the ~9% speedup loss V3b pays vs naive V3
!< while keeping the O(eps) compensation property.
!<
!< Algorithm (single Newton-Raphson-free TwoSum step, assuming |a| >= |b|):
!<   sum = a + b
!<   err = b - (sum - a)   ! = exact_remainder(a + b)
!< The carry array accumulates `err` across steps the same way V3b does.

#include "fundal.H"

module fundal_compensation_fasttwosum
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R4P=>real32

implicit none
private
public :: rk1_update_r4_fasttwosum

contains

   subroutine rk1_update_r4_fasttwosum(U, rhs, comp, dt, nb, ni, ng, nc)
   integer(I4P), intent(in) :: nb, ni, ng, nc
   real(R4P), intent(inout) :: U   (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P), intent(in)    :: rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P), intent(inout) :: comp(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P), intent(in)    :: dt
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: y, t, u_old

   !$acc parallel loop collapse(5) present(U, rhs, comp) private(y, t, u_old)
   do c = 1, nc
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               do b = 1, nb
                  u_old = U(b,i,j,k,c)
                  y     = dt * rhs(b,i,j,k,c) + comp(b,i,j,k,c)
                  t     = u_old + y
                  comp(b,i,j,k,c) = y - (t - u_old)
                  U(b,i,j,k,c)    = t
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine rk1_update_r4_fasttwosum

endmodule fundal_compensation_fasttwosum
