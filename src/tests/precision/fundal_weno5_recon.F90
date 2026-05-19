!< FUNDAL, WENO5-JS reconstruction helpers for the precision benchmark.
!<
!< Lifted to a module so OpenACC `routine seq` (and OpenMP `declare target`,
!< should it ever be added) annotations attach at module scope, which is the
!< form most reliably accepted across compilers. Kept out of src/lib/ because
!< this is a test-only helper, not part of the FUNDAL public API.

#include "fundal.H"

module fundal_weno5_recon
use, intrinsic :: iso_fortran_env, only : R4P=>real32, R8P=>real64

implicit none
private
public :: weno5_recon_r8, weno5_recon_r4, weno5_recon_r4_beta8

contains

   pure function weno5_recon_r8(vm2, vm1, v0, vp1, vp2) result(vL)
   !< Classic Jiang-Shu WENO5 reconstruction at i+1/2 from the left, double precision.
   !$acc routine seq
   real(R8P), intent(in) :: vm2, vm1, v0, vp1, vp2
   real(R8P) :: vL
   real(R8P) :: b0, b1, b2, a0, a1, a2, w0, w1, w2, p0, p1, p2, sw
   real(R8P), parameter :: eps = 1.0e-12_R8P
   real(R8P), parameter :: c13_12 = 13.0_R8P / 12.0_R8P
   real(R8P), parameter :: c1_4 = 0.25_R8P

   b0 = c13_12*(vm2 - 2.0_R8P*vm1 + v0 )**2 + c1_4*(vm2 - 4.0_R8P*vm1 + 3.0_R8P*v0 )**2
   b1 = c13_12*(vm1 - 2.0_R8P*v0  + vp1)**2 + c1_4*(vm1 - vp1)**2
   b2 = c13_12*(v0  - 2.0_R8P*vp1 + vp2)**2 + c1_4*(3.0_R8P*v0 - 4.0_R8P*vp1 + vp2)**2

   a0 = 0.1_R8P / (eps + b0)**2
   a1 = 0.6_R8P / (eps + b1)**2
   a2 = 0.3_R8P / (eps + b2)**2
   sw = a0 + a1 + a2
   w0 = a0 / sw; w1 = a1 / sw; w2 = a2 / sw

   p0 = ( 2.0_R8P*vm2 - 7.0_R8P*vm1 + 11.0_R8P*v0 ) / 6.0_R8P
   p1 = (-vm1         + 5.0_R8P*v0  +  2.0_R8P*vp1) / 6.0_R8P
   p2 = ( 2.0_R8P*v0  + 5.0_R8P*vp1 -          vp2) / 6.0_R8P

   vL = w0*p0 + w1*p1 + w2*p2
   endfunction weno5_recon_r8

   pure function weno5_recon_r4(vm2, vm1, v0, vp1, vp2) result(vL)
   !$acc routine seq
   real(R4P), intent(in) :: vm2, vm1, v0, vp1, vp2
   real(R4P) :: vL
   real(R4P) :: b0, b1, b2, a0, a1, a2, w0, w1, w2, p0, p1, p2, sw
   real(R4P), parameter :: eps = 1.0e-6_R4P
   real(R4P), parameter :: c13_12 = 13.0_R4P / 12.0_R4P
   real(R4P), parameter :: c1_4 = 0.25_R4P

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

   vL = w0*p0 + w1*p1 + w2*p2
   endfunction weno5_recon_r4

   pure function weno5_recon_r4_beta8(vm2, vm1, v0, vp1, vp2) result(vL)
   !< WENO5 reconstruction with FP32 inputs/output but the cancellation-sensitive
   !< smoothness indicators (b0, b1, b2 — squared differences) and the weight
   !< normalisation computed in FP64. Tests whether surgical promotion of the
   !< precision-sensitive sub-expression recovers accuracy at lower cost than
   !< blanket FP64 promotion of the whole reconstruction.
   !$acc routine seq
   real(R4P), intent(in) :: vm2, vm1, v0, vp1, vp2
   real(R4P) :: vL
   real(R8P) :: vm2_8, vm1_8, v0_8, vp1_8, vp2_8
   real(R8P) :: b0, b1, b2, a0, a1, a2, w0, w1, w2, sw
   real(R4P) :: p0, p1, p2
   real(R8P), parameter :: eps    = 1.0e-12_R8P
   real(R8P), parameter :: c13_12 = 13.0_R8P / 12.0_R8P
   real(R8P), parameter :: c1_4   = 0.25_R8P

   vm2_8 = real(vm2, R8P); vm1_8 = real(vm1, R8P)
   v0_8  = real(v0,  R8P); vp1_8 = real(vp1, R8P); vp2_8 = real(vp2, R8P)

   b0 = c13_12*(vm2_8 - 2.0_R8P*vm1_8 + v0_8 )**2 + c1_4*(vm2_8 - 4.0_R8P*vm1_8 + 3.0_R8P*v0_8 )**2
   b1 = c13_12*(vm1_8 - 2.0_R8P*v0_8  + vp1_8)**2 + c1_4*(vm1_8 - vp1_8)**2
   b2 = c13_12*(v0_8  - 2.0_R8P*vp1_8 + vp2_8)**2 + c1_4*(3.0_R8P*v0_8 - 4.0_R8P*vp1_8 + vp2_8)**2

   a0 = 0.1_R8P / (eps + b0)**2
   a1 = 0.6_R8P / (eps + b1)**2
   a2 = 0.3_R8P / (eps + b2)**2
   sw = a0 + a1 + a2
   w0 = a0 / sw; w1 = a1 / sw; w2 = a2 / sw

   p0 = ( 2.0_R4P*vm2 - 7.0_R4P*vm1 + 11.0_R4P*v0 ) / 6.0_R4P
   p1 = (-vm1         + 5.0_R4P*v0  +  2.0_R4P*vp1) / 6.0_R4P
   p2 = ( 2.0_R4P*v0  + 5.0_R4P*vp1 -          vp2) / 6.0_R4P

   vL = real(w0, R4P)*p0 + real(w1, R4P)*p1 + real(w2, R4P)*p2
   endfunction weno5_recon_r4_beta8

endmodule fundal_weno5_recon
