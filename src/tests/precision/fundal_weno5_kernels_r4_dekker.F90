!< FUNDAL, V3f/V3g — Dekker double-FP32 storage WENO5 kernels.
!<
!< U is stored as a pair (U_hi, U_lo) of FP32 arrays. Each load
!< reconstructs the value as U_hi + U_lo with ~48-bit effective mantissa;
!< the WENO5 reconstruction is computed in plain FP32 (to keep register
!< pressure manageable); the RK1 update writes back to the pair using
!< TwoSum so the carry that would otherwise be lost to FP32 storage
!< rounding is preserved between steps.
!<
!< Two flavours:
!<   V3f: rhs uses plain weno5_recon_r4
!<   V3g: rhs uses weno5_recon_r4_compdot (Graillat-Langlois compensated dot)
!<
!< rhs itself stays plain FP32 — it is recomputed each step from U, so
!< storing it as a pair adds 2x bandwidth for no precision benefit.
!<
!< Reference: Cai, Higham, Rump (SISC 2020) "Error-Free Transformations
!< of Sums and Dot Products and Simulations of Higher Precision."
!< Dekker (1971) for the original (hi, lo) representation.

#include "fundal.H"

module fundal_weno5_kernels_r4_dekker
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R4P=>real32, R8P=>real64
use fundal_weno5_recon,         only : weno5_recon_r4
use fundal_weno5_recon_compdot, only : weno5_recon_r4_compdot

implicit none
private
public :: ghost_fill_r4_dekker, weno5_rhs_r4_dekker, weno5_rhs_r4_dekker_compdot, &
          rk1_update_r4_dekker, dekker_from_r8, dekker_to_r8

contains

   subroutine dekker_from_r8(U_in, U_hi, U_lo, nb, ni, ng, nc)
   !< Split a R8 array into a Dekker (hi, lo) pair of R4 arrays:
   !< hi = real(U_in, R4P), lo = real(U_in - real(hi, R8P), R4P). Lo
   !< captures the FP64 bits that don't fit in FP32, giving the pair
   !< ~48-bit effective precision on reconstruction.
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
   endsubroutine dekker_from_r8

   subroutine dekker_to_r8(U_hi, U_lo, U_out, nb, ni, ng, nc)
   !< Reassemble a Dekker pair into a R8 array: U_out = real(hi, R8P) + real(lo, R8P).
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
   endsubroutine dekker_to_r8

   subroutine ghost_fill_r4_dekker(U_hi, U_lo, nb, ni, ng, nc)
   !< Periodic ghost fill on both halves of the Dekker pair.
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
   endsubroutine ghost_fill_r4_dekker

   subroutine weno5_rhs_r4_dekker(U_hi, U_lo, rhs, nb, ni, ng, nc)
   !< WENO5 rhs reading from a Dekker pair. Stencil values reconstructed
   !< as `U_hi + U_lo` inline at the call site (avoids reusing named
   !< scratch across faces, which nvfortran can miscompile when scratch
   !< vars are private on the outer gang loop but rewritten 6 times in
   !< the inner vector loop — observed to yield 5e-5 per-step bias).
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R4P),    intent(in)  :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)  :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(out) :: rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: fL_im, fL_ip, fL_jm, fL_jp, fL_km, fL_kp
   real(R4P), parameter :: dx_inv = 1.0_R4P

   !$acc parallel loop collapse(4) present(U_hi, U_lo, rhs) &
   !$acc                          private(fL_im,fL_ip,fL_jm,fL_jp,fL_km,fL_kp)
   do c = 1, nc
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               !$acc loop vector
               do b = 1, nb
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
   endsubroutine weno5_rhs_r4_dekker

   subroutine weno5_rhs_r4_dekker_compdot(U_hi, U_lo, rhs, nb, ni, ng, nc)
   !< V3g: Dekker storage + Graillat-Langlois compdot reconstruction.
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R4P),    intent(in)  :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)  :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(out) :: rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: fL_im, fL_ip, fL_jm, fL_jp, fL_km, fL_kp
   real(R4P), parameter :: dx_inv = 1.0_R4P

   !$acc parallel loop collapse(4) present(U_hi, U_lo, rhs) &
   !$acc                          private(fL_im,fL_ip,fL_jm,fL_jp,fL_km,fL_kp)
   do c = 1, nc
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               !$acc loop vector
               do b = 1, nb
                  fL_im = weno5_recon_r4_compdot(U_hi(b,i-3,j,k,c) + U_lo(b,i-3,j,k,c), &
                                                  U_hi(b,i-2,j,k,c) + U_lo(b,i-2,j,k,c), &
                                                  U_hi(b,i-1,j,k,c) + U_lo(b,i-1,j,k,c), &
                                                  U_hi(b,i,  j,k,c) + U_lo(b,i,  j,k,c), &
                                                  U_hi(b,i+1,j,k,c) + U_lo(b,i+1,j,k,c))
                  fL_ip = weno5_recon_r4_compdot(U_hi(b,i-2,j,k,c) + U_lo(b,i-2,j,k,c), &
                                                  U_hi(b,i-1,j,k,c) + U_lo(b,i-1,j,k,c), &
                                                  U_hi(b,i,  j,k,c) + U_lo(b,i,  j,k,c), &
                                                  U_hi(b,i+1,j,k,c) + U_lo(b,i+1,j,k,c), &
                                                  U_hi(b,i+2,j,k,c) + U_lo(b,i+2,j,k,c))
                  fL_jm = weno5_recon_r4_compdot(U_hi(b,i,j-3,k,c) + U_lo(b,i,j-3,k,c), &
                                                  U_hi(b,i,j-2,k,c) + U_lo(b,i,j-2,k,c), &
                                                  U_hi(b,i,j-1,k,c) + U_lo(b,i,j-1,k,c), &
                                                  U_hi(b,i,j,  k,c) + U_lo(b,i,j,  k,c), &
                                                  U_hi(b,i,j+1,k,c) + U_lo(b,i,j+1,k,c))
                  fL_jp = weno5_recon_r4_compdot(U_hi(b,i,j-2,k,c) + U_lo(b,i,j-2,k,c), &
                                                  U_hi(b,i,j-1,k,c) + U_lo(b,i,j-1,k,c), &
                                                  U_hi(b,i,j,  k,c) + U_lo(b,i,j,  k,c), &
                                                  U_hi(b,i,j+1,k,c) + U_lo(b,i,j+1,k,c), &
                                                  U_hi(b,i,j+2,k,c) + U_lo(b,i,j+2,k,c))
                  fL_km = weno5_recon_r4_compdot(U_hi(b,i,j,k-3,c) + U_lo(b,i,j,k-3,c), &
                                                  U_hi(b,i,j,k-2,c) + U_lo(b,i,j,k-2,c), &
                                                  U_hi(b,i,j,k-1,c) + U_lo(b,i,j,k-1,c), &
                                                  U_hi(b,i,j,k,  c) + U_lo(b,i,j,k,  c), &
                                                  U_hi(b,i,j,k+1,c) + U_lo(b,i,j,k+1,c))
                  fL_kp = weno5_recon_r4_compdot(U_hi(b,i,j,k-2,c) + U_lo(b,i,j,k-2,c), &
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
   endsubroutine weno5_rhs_r4_dekker_compdot

   subroutine rk1_update_r4_dekker(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   !< Dekker pair update: (U_hi, U_lo) <- (U_hi, U_lo) + dt * rhs.
   !< Two-step compensated add: first absorb dt*rhs into the existing lo
   !< via TwoSum, then renormalise (hi, lo) so |lo| <= 0.5 ulp(hi).
   integer(I4P), intent(in)    :: nb, ni, ng, nc
   real(R4P),    intent(inout) :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(inout) :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)    :: rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)    :: dt
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: incr, s1, e1, s2, e2, lo_new, bb, hi_new

   !$acc parallel loop collapse(5) present(U_hi, U_lo, rhs) &
   !$acc                          private(incr, s1, e1, s2, e2, lo_new, bb, hi_new)
   do c = 1, nc
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               do b = 1, nb
                  incr = dt * rhs(b,i,j,k,c)
                  ! TwoSum(U_hi, incr) -> (s1, e1)
                  s1 = U_hi(b,i,j,k,c) + incr
                  bb = s1 - U_hi(b,i,j,k,c)
                  e1 = (U_hi(b,i,j,k,c) - (s1 - bb)) + (incr - bb)
                  ! Fold old lo + rounding error into a single low term
                  lo_new = U_lo(b,i,j,k,c) + e1
                  ! Renormalise (s1, lo_new) so |lo| <= 0.5 ulp(hi)
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
   endsubroutine rk1_update_r4_dekker

endmodule fundal_weno5_kernels_r4_dekker
