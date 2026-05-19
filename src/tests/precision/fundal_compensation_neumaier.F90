!< FUNDAL, V3b — Kahan-Babuska-Neumaier (KBN) single-carry compensated RK1
!< update. The carry array `comp` retains the bits lost in each FP32
!< addition for restoration on the next step. Cost relative to naive
!< rk1_update_r4: one extra subtract, one extra add, one abs comparison
!< per cell per step, and 1x extra storage bandwidth for the carry.
!<
!< Reference: Neumaier (1974) "Rundungsfehleranalyse einiger Verfahren
!< zur Summation endlicher Summen." The branched form is the canonical
!< KBN; see fundal_compensation_fasttwosum for an unconditional variant
!< that trades a small algebraic loss for elimination of warp divergence.

#include "fundal.H"

module fundal_compensation_neumaier
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R4P=>real32

implicit none
private
public :: rk1_update_r4_kahan

contains

   subroutine rk1_update_r4_kahan(U, rhs, comp, dt, nb, ni, ng, nc)
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
                  if (abs(u_old) >= abs(y)) then
                     comp(b,i,j,k,c) = (u_old - t) + y
                  else
                     comp(b,i,j,k,c) = (y - t) + u_old
                  endif
                  U(b,i,j,k,c) = t
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine rk1_update_r4_kahan

endmodule fundal_compensation_neumaier
