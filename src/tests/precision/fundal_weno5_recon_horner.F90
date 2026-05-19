!< FUNDAL, V3h — WENO5 reconstruction with compensated Horner evaluation
!< of the smoothness indicators beta_k.
!<
!< Each beta_k is a polynomial in three neighbour values; the canonical
!< form computes the two squared differences with intermediate
!< cancellation. Compensated Horner (Graillat-Louvet 2007) evaluates the
!< polynomial with TwoSum-based running compensation at the cost of ~3x
!< the FLOPs on the beta computation.
!<
!< This is the *low-expectation* variant. The V2b experiment already
!< established that promoting beta to FP64 leaves errMax unchanged to
!< three digits — beta cancellation is NOT where the FP32 error lives on
!< this kernel. V3h tests whether compensated FP32 beta can do better
!< than FP64 beta (which it cannot, on this kernel, if the storage
!< round-trip hypothesis is right). Documented as a controlled negative
!< result.
!<
!< Reference: Graillat & Louvet (2007) "Compensated Horner scheme."

#include "fundal.H"

module fundal_weno5_recon_horner
use, intrinsic :: iso_fortran_env, only : R4P=>real32

implicit none
private
public :: weno5_recon_r4_horner

contains

   pure function weno5_recon_r4_horner(vm2, vm1, v0, vp1, vp2) result(vL)
   !$acc routine seq
   real(R4P), intent(in) :: vm2, vm1, v0, vp1, vp2
   real(R4P) :: vL
   real(R4P) :: b0, b1, b2, a0, a1, a2, w0, w1, w2, p0, p1, p2, sw
   real(R4P) :: d1, d2, sq1, sq2, lo1, lo2, b_hi, b_lo
   real(R4P), parameter :: eps    = 1.0e-6_R4P
   real(R4P), parameter :: c13_12 = 13.0_R4P / 12.0_R4P
   real(R4P), parameter :: c1_4   = 0.25_R4P

   ! beta_0: c13_12*(vm2 - 2 vm1 + v0)^2 + c1_4*(vm2 - 4 vm1 + 3 v0)^2
   d1 = vm2 - 2.0_R4P*vm1 + v0
   d2 = vm2 - 4.0_R4P*vm1 + 3.0_R4P*v0
   call two_prod(d1, d1, sq1, lo1)
   call two_prod(d2, d2, sq2, lo2)
   call comp_two_term(c13_12, sq1, lo1, c1_4, sq2, lo2, b_hi, b_lo)
   b0 = b_hi + b_lo

   d1 = vm1 - 2.0_R4P*v0 + vp1
   d2 = vm1 - vp1
   call two_prod(d1, d1, sq1, lo1)
   call two_prod(d2, d2, sq2, lo2)
   call comp_two_term(c13_12, sq1, lo1, c1_4, sq2, lo2, b_hi, b_lo)
   b1 = b_hi + b_lo

   d1 = v0 - 2.0_R4P*vp1 + vp2
   d2 = 3.0_R4P*v0 - 4.0_R4P*vp1 + vp2
   call two_prod(d1, d1, sq1, lo1)
   call two_prod(d2, d2, sq2, lo2)
   call comp_two_term(c13_12, sq1, lo1, c1_4, sq2, lo2, b_hi, b_lo)
   b2 = b_hi + b_lo

   a0 = 0.1_R4P / (eps + b0)**2
   a1 = 0.6_R4P / (eps + b1)**2
   a2 = 0.3_R4P / (eps + b2)**2
   sw = a0 + a1 + a2
   w0 = a0 / sw; w1 = a1 / sw; w2 = a2 / sw

   p0 = ( 2.0_R4P*vm2 - 7.0_R4P*vm1 + 11.0_R4P*v0 ) / 6.0_R4P
   p1 = (-vm1         + 5.0_R4P*v0  +  2.0_R4P*vp1) / 6.0_R4P
   p2 = ( 2.0_R4P*v0  + 5.0_R4P*vp1 -          vp2) / 6.0_R4P

   vL = w0*p0 + w1*p1 + w2*p2
   endfunction weno5_recon_r4_horner

   pure subroutine two_prod(a, b, hi, lo)
   !$acc routine seq
   real(R4P), intent(in)  :: a, b
   real(R4P), intent(out) :: hi, lo
   real(R4P) :: ah, al, bh, bl, tmp
   real(R4P), parameter :: splitter = 4097.0_R4P
   tmp = splitter * a; ah = tmp - (tmp - a); al = a - ah
   tmp = splitter * b; bh = tmp - (tmp - b); bl = b - bh
   hi  = a * b
   lo  = ((ah*bh - hi) + ah*bl + al*bh) + al*bl
   endsubroutine two_prod

   pure subroutine two_sum(a, b, s, e)
   !$acc routine seq
   real(R4P), intent(in)  :: a, b
   real(R4P), intent(out) :: s, e
   real(R4P) :: bb
   s  = a + b
   bb = s - a
   e  = (a - (s - bb)) + (b - bb)
   endsubroutine two_sum

   pure subroutine comp_two_term(k1, x1_hi, x1_lo, k2, x2_hi, x2_lo, r_hi, r_lo)
   !< Compensated evaluation of k1*(x1_hi + x1_lo) + k2*(x2_hi + x2_lo).
   !< k1, k2 are scalar constants (no rounding from them). x1_lo, x2_lo are
   !< low-order tails of the squared differences. Result split as (r_hi, r_lo)
   !< so the caller can reassemble at the final read with no intermediate
   !< rounding loss.
   !$acc routine seq
   real(R4P), intent(in)  :: k1, x1_hi, x1_lo, k2, x2_hi, x2_lo
   real(R4P), intent(out) :: r_hi, r_lo
   real(R4P) :: t1_hi, t1_lo, t2_hi, t2_lo, e
   call two_prod(k1, x1_hi, t1_hi, t1_lo); t1_lo = t1_lo + k1*x1_lo
   call two_prod(k2, x2_hi, t2_hi, t2_lo); t2_lo = t2_lo + k2*x2_lo
   call two_sum(t1_hi, t2_hi, r_hi, e)
   r_lo = e + t1_lo + t2_lo
   endsubroutine comp_two_term

endmodule fundal_weno5_recon_horner
