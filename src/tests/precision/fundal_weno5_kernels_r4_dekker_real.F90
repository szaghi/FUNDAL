!< FUNDAL, "realistic" Dekker double-FP32 kernels with the c-component
!< loop made sequential (as it must be in a real nonlinear CFD solver
!< where coupling across conservative variables prevents per-c
!< parallelism). The parallel surface is therefore at most `collapse(4)`
!< over the spatial-block indices (b, i, j, k).
!<
!< Four variants, spanning two storage shapes x two loop orders:
!<
!<   shape A  =  U(b, i, j, k, c)   (b is leftmost / stride-1)
!<   shape B  =  U(c, i, j, k, b)   (c is leftmost / stride-1, nc=5 small)
!<
!<   order F  =  Fortran-compliant: stride-1 array dimension lexically
!<               innermost in the parallel loop set
!<   order G  =  GPU-convention: biggest-stride array dimension lexically
!<               outermost ("largest stride first")
!<
!< Cross-product:
!<   shape A x order F  =>  parallel do k, j, i, b ; seq do c
!<                          (b innermost = stride-1)            ← V3fA-F
!<   shape A x order G  =>  parallel do b, k, j, i ; seq do c
!<                          (b outermost, biggest stride first) ← V3fA-G
!<   shape B x order F  =>  parallel do b, k, j, i ; seq do c
!<                          (i innermost; c is stride-1 but seq) ← V3fB-F
!<   shape B x order G  =>  parallel do i, j, k, b ; seq do c
!<                          (b outermost in parallel set)        ← V3fB-G
!<
!< Numerical algorithm (Dekker pair + compensated TwoSum update) is
!< identical to V3f / V3f' — only the storage layout, loop order, and
!< parallelism boundary differ. All four variants should produce the
!< same numerical output to the working precision of the kernel.
!<
!< Note: shape B uses a separate set of `_b` helper subroutines for the
!< split / recombine / ghost fill, since the array signature differs.

#include "fundal.H"

module fundal_weno5_kernels_r4_dekker_real
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R4P=>real32, R8P=>real64
use fundal_weno5_recon, only : weno5_recon_r4

implicit none
private
public :: dekker_from_r8_a, dekker_to_r8_a, &
          ghost_fill_r4_dekker_a, &
          weno5_rhs_r4_dekker_af, weno5_rhs_r4_dekker_ag, &
          rk1_update_r4_dekker_af, rk1_update_r4_dekker_ag, &
          dekker_from_r8_b, dekker_to_r8_b, &
          ghost_fill_r4_dekker_b, &
          weno5_rhs_r4_dekker_bf, weno5_rhs_r4_dekker_bg, &
          rk1_update_r4_dekker_bf, rk1_update_r4_dekker_bg

contains

   ! ========================================================================
   ! Shape A: U(b, i, j, k, c)
   ! ========================================================================

   subroutine dekker_from_r8_a(U_in, U_hi, U_lo, nb, ni, ng, nc)
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R8P),    intent(in)  :: U_in(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(out) :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(out) :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: b, i, j, k, c
   real(R8P) :: hi8
   do c = 1, nc
      do k = 1-ng, ni+ng
         do j = 1-ng, ni+ng
            do i = 1-ng, ni+ng
               do b = 1, nb
                  hi8 = real(real(U_in(b,i,j,k,c), R4P), R8P)
                  U_hi(b,i,j,k,c) = real(hi8, R4P)
                  U_lo(b,i,j,k,c) = real(U_in(b,i,j,k,c) - hi8, R4P)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine dekker_from_r8_a

   subroutine dekker_to_r8_a(U_hi, U_lo, U_out, nb, ni, ng, nc)
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R4P),    intent(in)  :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)  :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P),    intent(out) :: U_out(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: b, i, j, k, c
   do c = 1, nc
      do k = 1-ng, ni+ng
         do j = 1-ng, ni+ng
            do i = 1-ng, ni+ng
               do b = 1, nb
                  U_out(b,i,j,k,c) = real(U_hi(b,i,j,k,c), R8P) + real(U_lo(b,i,j,k,c), R8P)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine dekker_to_r8_a

   subroutine ghost_fill_r4_dekker_a(U_hi, U_lo, nb, ni, ng, nc)
   integer(I4P), intent(in)    :: nb, ni, ng, nc
   real(R4P),    intent(inout) :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(inout) :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: g, b, j, k, c
   do g = 1, ng
      !$acc parallel loop collapse(4) present(U_hi, U_lo)
      do c = 1, nc
         do k = 1-ng, ni+ng
            do j = 1-ng, ni+ng
               do b = 1, nb
                  U_hi(b, 1-g,  j, k, c) = U_hi(b, ni-g+1, j, k, c)
                  U_lo(b, 1-g,  j, k, c) = U_lo(b, ni-g+1, j, k, c)
                  U_hi(b, ni+g, j, k, c) = U_hi(b, g,      j, k, c)
                  U_lo(b, ni+g, j, k, c) = U_lo(b, g,      j, k, c)
               enddo
            enddo
         enddo
      enddo
      !$acc parallel loop collapse(4) present(U_hi, U_lo)
      do c = 1, nc
         do k = 1-ng, ni+ng
            do b = 1, nb
               do j = 1-ng, ni+ng
                  U_hi(b, j, 1-g,  k, c) = U_hi(b, j, ni-g+1, k, c)
                  U_lo(b, j, 1-g,  k, c) = U_lo(b, j, ni-g+1, k, c)
                  U_hi(b, j, ni+g, k, c) = U_hi(b, j, g,      k, c)
                  U_lo(b, j, ni+g, k, c) = U_lo(b, j, g,      k, c)
               enddo
            enddo
         enddo
      enddo
      !$acc parallel loop collapse(4) present(U_hi, U_lo)
      do c = 1, nc
         do k = 1-ng, ni+ng
            do j = 1-ng, ni+ng
               do b = 1, nb
                  U_hi(b, j, k, 1-g,  c) = U_hi(b, j, k, ni-g+1, c)
                  U_lo(b, j, k, 1-g,  c) = U_lo(b, j, k, ni-g+1, c)
                  U_hi(b, j, k, ni+g, c) = U_hi(b, j, k, g,      c)
                  U_lo(b, j, k, ni+g, c) = U_lo(b, j, k, g,      c)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine ghost_fill_r4_dekker_a

   subroutine weno5_rhs_r4_dekker_af(U_hi, U_lo, rhs, nb, ni, ng, nc)
   !< Shape A, order F: parallel loop k,j,i,b ; sequential c.
   !< b innermost = stride-1.
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R4P),    intent(in)  :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)  :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(out) :: rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: fL_im, fL_ip, fL_jm, fL_jp, fL_km, fL_kp
   real(R4P), parameter :: dx_inv = 1.0_R4P

   !$acc parallel loop collapse(4) present(U_hi, U_lo, rhs) &
   !$acc                          private(fL_im,fL_ip,fL_jm,fL_jp,fL_km,fL_kp)
   do k = 1, ni
      do j = 1, ni
         do i = 1, ni
            do b = 1, nb
               do c = 1, nc
                  fL_im = weno5_recon_r4(U_hi(b,i-3,j,k,c) + U_lo(b,i-3,j,k,c), &
                                          U_hi(b,i-2,j,k,c) + U_lo(b,i-2,j,k,c), &
                                          U_hi(b,i-1,j,k,c) + U_lo(b,i-1,j,k,c), &
                                          U_hi(b,i,  j,k,c) + U_lo(b,i,  j,k,c), &
                                          U_hi(b,i+1,j,k,c) + U_lo(b,i+1,j,k,c))
                  fL_ip = weno5_recon_r4(U_hi(b,i-2,j,k,c) + U_lo(b,i-2,j,k,c), &
                                          U_hi(b,i-1,j,k,c) + U_lo(b,i-1,j,k,c), &
                                          U_hi(b,i,  j,k,c) + U_lo(b,i,  j,k,c), &
                                          U_hi(b,i+1,j,k,c) + U_lo(b,i+1,j,k,c), &
                                          U_hi(b,i+2,j,k,c) + U_lo(b,i+2,j,k,c))
                  fL_jm = weno5_recon_r4(U_hi(b,i,j-3,k,c) + U_lo(b,i,j-3,k,c), &
                                          U_hi(b,i,j-2,k,c) + U_lo(b,i,j-2,k,c), &
                                          U_hi(b,i,j-1,k,c) + U_lo(b,i,j-1,k,c), &
                                          U_hi(b,i,j,  k,c) + U_lo(b,i,j,  k,c), &
                                          U_hi(b,i,j+1,k,c) + U_lo(b,i,j+1,k,c))
                  fL_jp = weno5_recon_r4(U_hi(b,i,j-2,k,c) + U_lo(b,i,j-2,k,c), &
                                          U_hi(b,i,j-1,k,c) + U_lo(b,i,j-1,k,c), &
                                          U_hi(b,i,j,  k,c) + U_lo(b,i,j,  k,c), &
                                          U_hi(b,i,j+1,k,c) + U_lo(b,i,j+1,k,c), &
                                          U_hi(b,i,j+2,k,c) + U_lo(b,i,j+2,k,c))
                  fL_km = weno5_recon_r4(U_hi(b,i,j,k-3,c) + U_lo(b,i,j,k-3,c), &
                                          U_hi(b,i,j,k-2,c) + U_lo(b,i,j,k-2,c), &
                                          U_hi(b,i,j,k-1,c) + U_lo(b,i,j,k-1,c), &
                                          U_hi(b,i,j,k,  c) + U_lo(b,i,j,k,  c), &
                                          U_hi(b,i,j,k+1,c) + U_lo(b,i,j,k+1,c))
                  fL_kp = weno5_recon_r4(U_hi(b,i,j,k-2,c) + U_lo(b,i,j,k-2,c), &
                                          U_hi(b,i,j,k-1,c) + U_lo(b,i,j,k-1,c), &
                                          U_hi(b,i,j,k,  c) + U_lo(b,i,j,k,  c), &
                                          U_hi(b,i,j,k+1,c) + U_lo(b,i,j,k+1,c), &
                                          U_hi(b,i,j,k+2,c) + U_lo(b,i,j,k+2,c))
                  rhs(b,i,j,k,c) = -dx_inv * ((fL_ip - fL_im) + (fL_jp - fL_jm) + (fL_kp - fL_km))
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine weno5_rhs_r4_dekker_af

   subroutine weno5_rhs_r4_dekker_ag(U_hi, U_lo, rhs, nb, ni, ng, nc)
   !< Shape A, order G: parallel loop b,k,j,i ; sequential c.
   !< b outermost in parallel set ("biggest stride first" GPU convention).
   !< i innermost in parallel set (i is interior stride in the array).
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R4P),    intent(in)  :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)  :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(out) :: rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: fL_im, fL_ip, fL_jm, fL_jp, fL_km, fL_kp
   real(R4P), parameter :: dx_inv = 1.0_R4P

   !$acc parallel loop collapse(4) present(U_hi, U_lo, rhs) &
   !$acc                          private(fL_im,fL_ip,fL_jm,fL_jp,fL_km,fL_kp)
   do b = 1, nb
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               do c = 1, nc
                  fL_im = weno5_recon_r4(U_hi(b,i-3,j,k,c) + U_lo(b,i-3,j,k,c), &
                                          U_hi(b,i-2,j,k,c) + U_lo(b,i-2,j,k,c), &
                                          U_hi(b,i-1,j,k,c) + U_lo(b,i-1,j,k,c), &
                                          U_hi(b,i,  j,k,c) + U_lo(b,i,  j,k,c), &
                                          U_hi(b,i+1,j,k,c) + U_lo(b,i+1,j,k,c))
                  fL_ip = weno5_recon_r4(U_hi(b,i-2,j,k,c) + U_lo(b,i-2,j,k,c), &
                                          U_hi(b,i-1,j,k,c) + U_lo(b,i-1,j,k,c), &
                                          U_hi(b,i,  j,k,c) + U_lo(b,i,  j,k,c), &
                                          U_hi(b,i+1,j,k,c) + U_lo(b,i+1,j,k,c), &
                                          U_hi(b,i+2,j,k,c) + U_lo(b,i+2,j,k,c))
                  fL_jm = weno5_recon_r4(U_hi(b,i,j-3,k,c) + U_lo(b,i,j-3,k,c), &
                                          U_hi(b,i,j-2,k,c) + U_lo(b,i,j-2,k,c), &
                                          U_hi(b,i,j-1,k,c) + U_lo(b,i,j-1,k,c), &
                                          U_hi(b,i,j,  k,c) + U_lo(b,i,j,  k,c), &
                                          U_hi(b,i,j+1,k,c) + U_lo(b,i,j+1,k,c))
                  fL_jp = weno5_recon_r4(U_hi(b,i,j-2,k,c) + U_lo(b,i,j-2,k,c), &
                                          U_hi(b,i,j-1,k,c) + U_lo(b,i,j-1,k,c), &
                                          U_hi(b,i,j,  k,c) + U_lo(b,i,j,  k,c), &
                                          U_hi(b,i,j+1,k,c) + U_lo(b,i,j+1,k,c), &
                                          U_hi(b,i,j+2,k,c) + U_lo(b,i,j+2,k,c))
                  fL_km = weno5_recon_r4(U_hi(b,i,j,k-3,c) + U_lo(b,i,j,k-3,c), &
                                          U_hi(b,i,j,k-2,c) + U_lo(b,i,j,k-2,c), &
                                          U_hi(b,i,j,k-1,c) + U_lo(b,i,j,k-1,c), &
                                          U_hi(b,i,j,k,  c) + U_lo(b,i,j,k,  c), &
                                          U_hi(b,i,j,k+1,c) + U_lo(b,i,j,k+1,c))
                  fL_kp = weno5_recon_r4(U_hi(b,i,j,k-2,c) + U_lo(b,i,j,k-2,c), &
                                          U_hi(b,i,j,k-1,c) + U_lo(b,i,j,k-1,c), &
                                          U_hi(b,i,j,k,  c) + U_lo(b,i,j,k,  c), &
                                          U_hi(b,i,j,k+1,c) + U_lo(b,i,j,k+1,c), &
                                          U_hi(b,i,j,k+2,c) + U_lo(b,i,j,k+2,c))
                  rhs(b,i,j,k,c) = -dx_inv * ((fL_ip - fL_im) + (fL_jp - fL_jm) + (fL_kp - fL_km))
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine weno5_rhs_r4_dekker_ag

   subroutine rk1_update_r4_dekker_af(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   !< Shape A, order F update: parallel loop k,j,i,b ; sequential c.
   integer(I4P), intent(in)    :: nb, ni, ng, nc
   real(R4P),    intent(inout) :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(inout) :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)    :: rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)    :: dt
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: incr, s1, e1, s2, e2, lo_new, bb, hi_new

   !$acc parallel loop collapse(4) present(U_hi, U_lo, rhs) &
   !$acc                          private(incr, s1, e1, s2, e2, lo_new, bb, hi_new)
   do k = 1, ni
      do j = 1, ni
         do i = 1, ni
            do b = 1, nb
               do c = 1, nc
                  incr = dt * rhs(b,i,j,k,c)
                  s1 = U_hi(b,i,j,k,c) + incr
                  bb = s1 - U_hi(b,i,j,k,c)
                  e1 = (U_hi(b,i,j,k,c) - (s1 - bb)) + (incr - bb)
                  lo_new = U_lo(b,i,j,k,c) + e1
                  s2 = s1 + lo_new
                  bb = s2 - s1
                  e2 = (s1 - (s2 - bb)) + (lo_new - bb)
                  hi_new = s2
                  U_hi(b,i,j,k,c) = hi_new
                  U_lo(b,i,j,k,c) = e2
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine rk1_update_r4_dekker_af

   subroutine rk1_update_r4_dekker_ag(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   !< Shape A, order G update: parallel loop b,k,j,i ; sequential c.
   integer(I4P), intent(in)    :: nb, ni, ng, nc
   real(R4P),    intent(inout) :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(inout) :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)    :: rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)    :: dt
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: incr, s1, e1, s2, e2, lo_new, bb, hi_new

   !$acc parallel loop collapse(4) present(U_hi, U_lo, rhs) &
   !$acc                          private(incr, s1, e1, s2, e2, lo_new, bb, hi_new)
   do b = 1, nb
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               do c = 1, nc
                  incr = dt * rhs(b,i,j,k,c)
                  s1 = U_hi(b,i,j,k,c) + incr
                  bb = s1 - U_hi(b,i,j,k,c)
                  e1 = (U_hi(b,i,j,k,c) - (s1 - bb)) + (incr - bb)
                  lo_new = U_lo(b,i,j,k,c) + e1
                  s2 = s1 + lo_new
                  bb = s2 - s1
                  e2 = (s1 - (s2 - bb)) + (lo_new - bb)
                  hi_new = s2
                  U_hi(b,i,j,k,c) = hi_new
                  U_lo(b,i,j,k,c) = e2
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine rk1_update_r4_dekker_ag

   ! ========================================================================
   ! Shape B: U(c, i, j, k, b)
   ! ========================================================================

   subroutine dekker_from_r8_b(U_in, U_hi, U_lo, nb, ni, ng, nc)
   !< Translate from canonical R8 shape (b,i,j,k,c) into shape B (c,i,j,k,b).
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R8P),    intent(in)  :: U_in(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(out) :: U_hi(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R4P),    intent(out) :: U_lo(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   integer(I4P) :: b, i, j, k, c
   real(R8P) :: hi8
   do b = 1, nb
      do k = 1-ng, ni+ng
         do j = 1-ng, ni+ng
            do i = 1-ng, ni+ng
               do c = 1, nc
                  hi8 = real(real(U_in(b,i,j,k,c), R4P), R8P)
                  U_hi(c,i,j,k,b) = real(hi8, R4P)
                  U_lo(c,i,j,k,b) = real(U_in(b,i,j,k,c) - hi8, R4P)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine dekker_from_r8_b

   subroutine dekker_to_r8_b(U_hi, U_lo, U_out, nb, ni, ng, nc)
   !< Translate from shape B (c,i,j,k,b) back to canonical R8 (b,i,j,k,c).
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R4P),    intent(in)  :: U_hi(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R4P),    intent(in)  :: U_lo(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R8P),    intent(out) :: U_out(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: b, i, j, k, c
   do b = 1, nb
      do k = 1-ng, ni+ng
         do j = 1-ng, ni+ng
            do i = 1-ng, ni+ng
               do c = 1, nc
                  U_out(b,i,j,k,c) = real(U_hi(c,i,j,k,b), R8P) + real(U_lo(c,i,j,k,b), R8P)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine dekker_to_r8_b

   subroutine ghost_fill_r4_dekker_b(U_hi, U_lo, nb, ni, ng, nc)
   !< Ghost fill on shape B. The parallel loop is collapse(4) over (b,k,j,c)
   !< for the i-faces, etc. Use the same loop order as the rhs/update kernels
   !< of variant BF (i.e. "Fortran-compliant" with c innermost = stride-1
   !< for shape B) since this is the natural reference order for shape B.
   integer(I4P), intent(in)    :: nb, ni, ng, nc
   real(R4P),    intent(inout) :: U_hi(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R4P),    intent(inout) :: U_lo(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   integer(I4P) :: g, b, j, k, c
   do g = 1, ng
      !$acc parallel loop collapse(4) present(U_hi, U_lo)
      do b = 1, nb
         do k = 1-ng, ni+ng
            do j = 1-ng, ni+ng
               do c = 1, nc
                  U_hi(c, 1-g,  j, k, b) = U_hi(c, ni-g+1, j, k, b)
                  U_lo(c, 1-g,  j, k, b) = U_lo(c, ni-g+1, j, k, b)
                  U_hi(c, ni+g, j, k, b) = U_hi(c, g,      j, k, b)
                  U_lo(c, ni+g, j, k, b) = U_lo(c, g,      j, k, b)
               enddo
            enddo
         enddo
      enddo
      !$acc parallel loop collapse(4) present(U_hi, U_lo)
      do b = 1, nb
         do k = 1-ng, ni+ng
            do j = 1-ng, ni+ng
               do c = 1, nc
                  U_hi(c, j, 1-g,  k, b) = U_hi(c, j, ni-g+1, k, b)
                  U_lo(c, j, 1-g,  k, b) = U_lo(c, j, ni-g+1, k, b)
                  U_hi(c, j, ni+g, k, b) = U_hi(c, j, g,      k, b)
                  U_lo(c, j, ni+g, k, b) = U_lo(c, j, g,      k, b)
               enddo
            enddo
         enddo
      enddo
      !$acc parallel loop collapse(4) present(U_hi, U_lo)
      do b = 1, nb
         do k = 1-ng, ni+ng
            do j = 1-ng, ni+ng
               do c = 1, nc
                  U_hi(c, j, k, 1-g,  b) = U_hi(c, j, k, ni-g+1, b)
                  U_lo(c, j, k, 1-g,  b) = U_lo(c, j, k, ni-g+1, b)
                  U_hi(c, j, k, ni+g, b) = U_hi(c, j, k, g,      b)
                  U_lo(c, j, k, ni+g, b) = U_lo(c, j, k, g,      b)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine ghost_fill_r4_dekker_b

   subroutine weno5_rhs_r4_dekker_bf(U_hi, U_lo, rhs, nb, ni, ng, nc)
   !< Shape B, order F: parallel loop b,k,j,i ; sequential c.
   !< i innermost in parallel set (i has stride nc in shape B; c is stride-1
   !< but is sequential because of the nonlinear coupling constraint).
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R4P),    intent(in)  :: U_hi(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R4P),    intent(in)  :: U_lo(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R4P),    intent(out) :: rhs (1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: fL_im, fL_ip, fL_jm, fL_jp, fL_km, fL_kp
   real(R4P), parameter :: dx_inv = 1.0_R4P

   !$acc parallel loop collapse(4) present(U_hi, U_lo, rhs) &
   !$acc                          private(fL_im,fL_ip,fL_jm,fL_jp,fL_km,fL_kp)
   do b = 1, nb
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               do c = 1, nc
                  fL_im = weno5_recon_r4(U_hi(c,i-3,j,k,b) + U_lo(c,i-3,j,k,b), &
                                          U_hi(c,i-2,j,k,b) + U_lo(c,i-2,j,k,b), &
                                          U_hi(c,i-1,j,k,b) + U_lo(c,i-1,j,k,b), &
                                          U_hi(c,i,  j,k,b) + U_lo(c,i,  j,k,b), &
                                          U_hi(c,i+1,j,k,b) + U_lo(c,i+1,j,k,b))
                  fL_ip = weno5_recon_r4(U_hi(c,i-2,j,k,b) + U_lo(c,i-2,j,k,b), &
                                          U_hi(c,i-1,j,k,b) + U_lo(c,i-1,j,k,b), &
                                          U_hi(c,i,  j,k,b) + U_lo(c,i,  j,k,b), &
                                          U_hi(c,i+1,j,k,b) + U_lo(c,i+1,j,k,b), &
                                          U_hi(c,i+2,j,k,b) + U_lo(c,i+2,j,k,b))
                  fL_jm = weno5_recon_r4(U_hi(c,i,j-3,k,b) + U_lo(c,i,j-3,k,b), &
                                          U_hi(c,i,j-2,k,b) + U_lo(c,i,j-2,k,b), &
                                          U_hi(c,i,j-1,k,b) + U_lo(c,i,j-1,k,b), &
                                          U_hi(c,i,j,  k,b) + U_lo(c,i,j,  k,b), &
                                          U_hi(c,i,j+1,k,b) + U_lo(c,i,j+1,k,b))
                  fL_jp = weno5_recon_r4(U_hi(c,i,j-2,k,b) + U_lo(c,i,j-2,k,b), &
                                          U_hi(c,i,j-1,k,b) + U_lo(c,i,j-1,k,b), &
                                          U_hi(c,i,j,  k,b) + U_lo(c,i,j,  k,b), &
                                          U_hi(c,i,j+1,k,b) + U_lo(c,i,j+1,k,b), &
                                          U_hi(c,i,j+2,k,b) + U_lo(c,i,j+2,k,b))
                  fL_km = weno5_recon_r4(U_hi(c,i,j,k-3,b) + U_lo(c,i,j,k-3,b), &
                                          U_hi(c,i,j,k-2,b) + U_lo(c,i,j,k-2,b), &
                                          U_hi(c,i,j,k-1,b) + U_lo(c,i,j,k-1,b), &
                                          U_hi(c,i,j,k,  b) + U_lo(c,i,j,k,  b), &
                                          U_hi(c,i,j,k+1,b) + U_lo(c,i,j,k+1,b))
                  fL_kp = weno5_recon_r4(U_hi(c,i,j,k-2,b) + U_lo(c,i,j,k-2,b), &
                                          U_hi(c,i,j,k-1,b) + U_lo(c,i,j,k-1,b), &
                                          U_hi(c,i,j,k,  b) + U_lo(c,i,j,k,  b), &
                                          U_hi(c,i,j,k+1,b) + U_lo(c,i,j,k+1,b), &
                                          U_hi(c,i,j,k+2,b) + U_lo(c,i,j,k+2,b))
                  rhs(c,i,j,k,b) = -dx_inv * ((fL_ip - fL_im) + (fL_jp - fL_jm) + (fL_kp - fL_km))
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine weno5_rhs_r4_dekker_bf

   subroutine weno5_rhs_r4_dekker_bg(U_hi, U_lo, rhs, nb, ni, ng, nc)
   !< Shape B, order G: parallel loop i,j,k,b ; sequential c.
   !< b innermost in parallel set ("biggest stride first" => i outermost,
   !< the smallest parallel dimension; b innermost, the largest parallel
   !< dimension after c is removed).
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R4P),    intent(in)  :: U_hi(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R4P),    intent(in)  :: U_lo(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R4P),    intent(out) :: rhs (1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: fL_im, fL_ip, fL_jm, fL_jp, fL_km, fL_kp
   real(R4P), parameter :: dx_inv = 1.0_R4P

   !$acc parallel loop collapse(4) present(U_hi, U_lo, rhs) &
   !$acc                          private(fL_im,fL_ip,fL_jm,fL_jp,fL_km,fL_kp)
   do i = 1, ni
      do j = 1, ni
         do k = 1, ni
            do b = 1, nb
               do c = 1, nc
                  fL_im = weno5_recon_r4(U_hi(c,i-3,j,k,b) + U_lo(c,i-3,j,k,b), &
                                          U_hi(c,i-2,j,k,b) + U_lo(c,i-2,j,k,b), &
                                          U_hi(c,i-1,j,k,b) + U_lo(c,i-1,j,k,b), &
                                          U_hi(c,i,  j,k,b) + U_lo(c,i,  j,k,b), &
                                          U_hi(c,i+1,j,k,b) + U_lo(c,i+1,j,k,b))
                  fL_ip = weno5_recon_r4(U_hi(c,i-2,j,k,b) + U_lo(c,i-2,j,k,b), &
                                          U_hi(c,i-1,j,k,b) + U_lo(c,i-1,j,k,b), &
                                          U_hi(c,i,  j,k,b) + U_lo(c,i,  j,k,b), &
                                          U_hi(c,i+1,j,k,b) + U_lo(c,i+1,j,k,b), &
                                          U_hi(c,i+2,j,k,b) + U_lo(c,i+2,j,k,b))
                  fL_jm = weno5_recon_r4(U_hi(c,i,j-3,k,b) + U_lo(c,i,j-3,k,b), &
                                          U_hi(c,i,j-2,k,b) + U_lo(c,i,j-2,k,b), &
                                          U_hi(c,i,j-1,k,b) + U_lo(c,i,j-1,k,b), &
                                          U_hi(c,i,j,  k,b) + U_lo(c,i,j,  k,b), &
                                          U_hi(c,i,j+1,k,b) + U_lo(c,i,j+1,k,b))
                  fL_jp = weno5_recon_r4(U_hi(c,i,j-2,k,b) + U_lo(c,i,j-2,k,b), &
                                          U_hi(c,i,j-1,k,b) + U_lo(c,i,j-1,k,b), &
                                          U_hi(c,i,j,  k,b) + U_lo(c,i,j,  k,b), &
                                          U_hi(c,i,j+1,k,b) + U_lo(c,i,j+1,k,b), &
                                          U_hi(c,i,j+2,k,b) + U_lo(c,i,j+2,k,b))
                  fL_km = weno5_recon_r4(U_hi(c,i,j,k-3,b) + U_lo(c,i,j,k-3,b), &
                                          U_hi(c,i,j,k-2,b) + U_lo(c,i,j,k-2,b), &
                                          U_hi(c,i,j,k-1,b) + U_lo(c,i,j,k-1,b), &
                                          U_hi(c,i,j,k,  b) + U_lo(c,i,j,k,  b), &
                                          U_hi(c,i,j,k+1,b) + U_lo(c,i,j,k+1,b))
                  fL_kp = weno5_recon_r4(U_hi(c,i,j,k-2,b) + U_lo(c,i,j,k-2,b), &
                                          U_hi(c,i,j,k-1,b) + U_lo(c,i,j,k-1,b), &
                                          U_hi(c,i,j,k,  b) + U_lo(c,i,j,k,  b), &
                                          U_hi(c,i,j,k+1,b) + U_lo(c,i,j,k+1,b), &
                                          U_hi(c,i,j,k+2,b) + U_lo(c,i,j,k+2,b))
                  rhs(c,i,j,k,b) = -dx_inv * ((fL_ip - fL_im) + (fL_jp - fL_jm) + (fL_kp - fL_km))
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine weno5_rhs_r4_dekker_bg

   subroutine rk1_update_r4_dekker_bf(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   !< Shape B, order F update: parallel loop b,k,j,i ; sequential c.
   integer(I4P), intent(in)    :: nb, ni, ng, nc
   real(R4P),    intent(inout) :: U_hi(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R4P),    intent(inout) :: U_lo(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R4P),    intent(in)    :: rhs (1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R4P),    intent(in)    :: dt
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: incr, s1, e1, s2, e2, lo_new, bb, hi_new

   !$acc parallel loop collapse(4) present(U_hi, U_lo, rhs) &
   !$acc                          private(incr, s1, e1, s2, e2, lo_new, bb, hi_new)
   do b = 1, nb
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               do c = 1, nc
                  incr = dt * rhs(c,i,j,k,b)
                  s1 = U_hi(c,i,j,k,b) + incr
                  bb = s1 - U_hi(c,i,j,k,b)
                  e1 = (U_hi(c,i,j,k,b) - (s1 - bb)) + (incr - bb)
                  lo_new = U_lo(c,i,j,k,b) + e1
                  s2 = s1 + lo_new
                  bb = s2 - s1
                  e2 = (s1 - (s2 - bb)) + (lo_new - bb)
                  hi_new = s2
                  U_hi(c,i,j,k,b) = hi_new
                  U_lo(c,i,j,k,b) = e2
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine rk1_update_r4_dekker_bf

   subroutine rk1_update_r4_dekker_bg(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   !< Shape B, order G update: parallel loop i,j,k,b ; sequential c.
   integer(I4P), intent(in)    :: nb, ni, ng, nc
   real(R4P),    intent(inout) :: U_hi(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R4P),    intent(inout) :: U_lo(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R4P),    intent(in)    :: rhs (1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R4P),    intent(in)    :: dt
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: incr, s1, e1, s2, e2, lo_new, bb, hi_new

   !$acc parallel loop collapse(4) present(U_hi, U_lo, rhs) &
   !$acc                          private(incr, s1, e1, s2, e2, lo_new, bb, hi_new)
   do i = 1, ni
      do j = 1, ni
         do k = 1, ni
            do b = 1, nb
               do c = 1, nc
                  incr = dt * rhs(c,i,j,k,b)
                  s1 = U_hi(c,i,j,k,b) + incr
                  bb = s1 - U_hi(c,i,j,k,b)
                  e1 = (U_hi(c,i,j,k,b) - (s1 - bb)) + (incr - bb)
                  lo_new = U_lo(c,i,j,k,b) + e1
                  s2 = s1 + lo_new
                  bb = s2 - s1
                  e2 = (s1 - (s2 - bb)) + (lo_new - bb)
                  hi_new = s2
                  U_hi(c,i,j,k,b) = hi_new
                  U_lo(c,i,j,k,b) = e2
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine rk1_update_r4_dekker_bg

endmodule fundal_weno5_kernels_r4_dekker_real
