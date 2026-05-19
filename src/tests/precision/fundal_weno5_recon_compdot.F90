!< FUNDAL, V3d — WENO5 reconstruction with Graillat-Langlois compensated
!< dot product on the final 3-term nonlinear combination
!< vL = w0*p0 + w1*p1 + w2*p2.
!<
!< Uses Veltkamp-Dekker software TwoProd (no FMA dependency — keeps the
!< module portable across nvfortran/gfortran/ifx/amd-flang where the
!< ieee_fma intrinsic is not uniformly available in 2026). Each
!< multiplication is split into (hi, lo) where lo is the exact rounding
!< error of the FP32 product; the sum is then accumulated with running
!< compensation. Approximately one extra decimal digit of accuracy on
!< the 3-term dot.
!<
!< Reference: Graillat & Langlois (2008) "More accurate algorithm for
!< sum and dot product"; Veltkamp (1969) for the splitting; Dekker (1971)
!< for the exact-product transform.

#include "fundal.H"

module fundal_weno5_recon_compdot
use, intrinsic :: iso_fortran_env, only : R4P=>real32

implicit none
private
public :: weno5_recon_r4_compdot

contains

   pure function weno5_recon_r4_compdot(vm2, vm1, v0, vp1, vp2) result(vL)
   !< WENO5-JS reconstruction at i+1/2 from the left with compensated final dot.
   !$acc routine seq
   real(R4P), intent(in) :: vm2, vm1, v0, vp1, vp2
   real(R4P) :: vL
   real(R4P) :: b0, b1, b2, a0, a1, a2, w0, w1, w2, p0, p1, p2, sw
   real(R4P) :: h0, l0, h1, l1, h2, l2
   real(R4P) :: s, e1, t, e2, lo_sum
   real(R4P), parameter :: eps    = 1.0e-6_R4P
   real(R4P), parameter :: c13_12 = 13.0_R4P / 12.0_R4P
   real(R4P), parameter :: c1_4   = 0.25_R4P

   b0 = c13_12*(vm2 - 2.0_R4P*vm1 + v0 )**2 + c1_4*(vm2 - 4.0_R4P*vm1 + 3.0_R4P*v0 )**2
   b1 = c13_12*(vm1 - 2.0_R4P*v0  + vp1)**2 + c1_4*(vm1 - vp1)**2
   b2 = c13_12*(v0  - 2.0_R4P*vp1 + vp2)**2 + c1_4*(3.0_R4P*v0 - 4.0_R4P*vp1 + vp2)**2

   a0 = 0.1_R4P / (eps + b0)**2
   a1 = 0.6_R4P / (eps + b1)**2
   a2 = 0.3_R4P / (eps + b2)**2
   sw = a0 + a1 + a2
   w0 = a0 / sw; w1 = a1 / sw; w2 = a2 / sw

   p0 = ( 2.0_R4P*vm2 - 7.0_R4P*vm1 + 11.0_R4P*v0 ) / 6.0_R4P
   p1 = (-vm1         + 5.0_R4P*v0  +  2.0_R4P*vp1) / 6.0_R4P
   p2 = ( 2.0_R4P*v0  + 5.0_R4P*vp1 -          vp2) / 6.0_R4P

   ! Veltkamp-Dekker TwoProd on each multiply: (hi, lo) = a*b exactly.
   call two_prod(w0, p0, h0, l0)
   call two_prod(w1, p1, h1, l1)
   call two_prod(w2, p2, h2, l2)

   ! TwoSum chain over the hi parts; collect compensation in e1, e2.
   call two_sum(h0, h1, s, e1)
   call two_sum(s,  h2, t, e2)

   lo_sum = e1 + e2 + l0 + l1 + l2
   vL     = t + lo_sum
   endfunction weno5_recon_r4_compdot

   pure subroutine two_prod(a, b, hi, lo)
   !< Veltkamp split + Dekker TwoProd, FP32, no FMA dependency. Returns
   !< (hi, lo) such that a*b = hi + lo exactly in unbounded precision,
   !< with hi = fl(a*b) and lo the exact rounding error.
   !$acc routine seq
   real(R4P), intent(in)  :: a, b
   real(R4P), intent(out) :: hi, lo
   real(R4P) :: ah, al, bh, bl, tmp
   real(R4P), parameter :: splitter = 4097.0_R4P    ! 2^12 + 1 for FP32 (24-bit mantissa)

   tmp = splitter * a; ah = tmp - (tmp - a); al = a - ah
   tmp = splitter * b; bh = tmp - (tmp - b); bl = b - bh
   hi  = a * b
   lo  = ((ah*bh - hi) + ah*bl + al*bh) + al*bl
   endsubroutine two_prod

   pure subroutine two_sum(a, b, s, e)
   !< Knuth/Moller TwoSum, FP32, branchless. Returns (s, e) such that
   !< a + b = s + e exactly, with s = fl(a + b).
   !$acc routine seq
   real(R4P), intent(in)  :: a, b
   real(R4P), intent(out) :: s, e
   real(R4P) :: bb
   s  = a + b
   bb = s - a
   e  = (a - (s - bb)) + (b - bb)
   endsubroutine two_sum

endmodule fundal_weno5_recon_compdot
