!< FUNDAL, V3f'' (V3f-bkjic) — same Dekker double-FP32 storage and
!< compensated TwoSum update as V3f / V3f', but with the loop nest
!< reordered as `do b, do k, do j, do i, do c` (b outermost / slowest,
!< c innermost / fastest). Array storage shape is unchanged at
!< (b, i, j, k, c), so this loop order is *inverted* relative to
!< Fortran column-major stride-1 access:
!<
!<   c (innermost loop) walks stride = nb*(ni+2*ng)**3   ← non-unit, large
!<   i,j,k (middle)     walk strides nb, nb*(ni+2*ng), nb*(ni+2*ng)**2
!<   b (outermost)      walks stride 1                   ← unit, but slowest loop
!<
!< Used with `!$acc parallel loop collapse(5)`, the compiler flattens
!< the 5-way iteration space and remaps the index. The empirical
!< question is whether `collapse(5)` recovers from the source-order
!< inversion or whether the lexical loop order still leaks into the
!< generated SASS (gang/vector mapping defaults).
!<
!< Mathematically identical to V3f / V3f' — numerical output should
!< match V3f bit-for-bit. The comparison is wall-clock speed only.

#include "fundal.H"

module fundal_weno5_kernels_r4_dekker_bkc
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R4P=>real32
use fundal_weno5_recon, only : weno5_recon_r4

implicit none
private
public :: ghost_fill_r4_dekker_bkc, weno5_rhs_r4_dekker_bkc, rk1_update_r4_dekker_bkc

contains

   subroutine ghost_fill_r4_dekker_bkc(U_hi, U_lo, nb, ni, ng, nc)
   !< Periodic ghost fill, b-outer / c-inner loop order with collapse(4).
   integer(I4P), intent(in)    :: nb, ni, ng, nc
   real(R4P),    intent(inout) :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(inout) :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: g, b, j, k, c
   do g = 1, ng
      !$acc parallel loop collapse(4) present(U_hi, U_lo)
      do b = 1, nb
         do k = 1-ng, ni+ng
            do j = 1-ng, ni+ng
               do c = 1, nc
                  U_hi(b, 1-g,  j, k, c) = U_hi(b, ni-g+1, j, k, c)
                  U_lo(b, 1-g,  j, k, c) = U_lo(b, ni-g+1, j, k, c)
                  U_hi(b, ni+g, j, k, c) = U_hi(b, g,      j, k, c)
                  U_lo(b, ni+g, j, k, c) = U_lo(b, g,      j, k, c)
               enddo
            enddo
         enddo
      enddo
      !$acc parallel loop collapse(4) present(U_hi, U_lo)
      do b = 1, nb
         do k = 1-ng, ni+ng
            do j = 1-ng, ni+ng
               do c = 1, nc
                  U_hi(b, j, 1-g,  k, c) = U_hi(b, j, ni-g+1, k, c)
                  U_lo(b, j, 1-g,  k, c) = U_lo(b, j, ni-g+1, k, c)
                  U_hi(b, j, ni+g, k, c) = U_hi(b, j, g,      k, c)
                  U_lo(b, j, ni+g, k, c) = U_lo(b, j, g,      k, c)
               enddo
            enddo
         enddo
      enddo
      !$acc parallel loop collapse(4) present(U_hi, U_lo)
      do b = 1, nb
         do k = 1-ng, ni+ng
            do j = 1-ng, ni+ng
               do c = 1, nc
                  U_hi(b, j, k, 1-g,  c) = U_hi(b, j, k, ni-g+1, c)
                  U_lo(b, j, k, 1-g,  c) = U_lo(b, j, k, ni-g+1, c)
                  U_hi(b, j, k, ni+g, c) = U_hi(b, j, k, g,      c)
                  U_lo(b, j, k, ni+g, c) = U_lo(b, j, k, g,      c)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine ghost_fill_r4_dekker_bkc

   subroutine weno5_rhs_r4_dekker_bkc(U_hi, U_lo, rhs, nb, ni, ng, nc)
   !< collapse(5) over (b, k, j, i, c). Source loop order inverted vs V3f'.
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R4P),    intent(in)  :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)  :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(out) :: rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: fL_im, fL_ip, fL_jm, fL_jp, fL_km, fL_kp
   real(R4P), parameter :: dx_inv = 1.0_R4P

   !$acc parallel loop collapse(5) present(U_hi, U_lo, rhs) &
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
   endsubroutine weno5_rhs_r4_dekker_bkc

   subroutine rk1_update_r4_dekker_bkc(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   !< collapse(5) update, b-outer / c-inner loop order.
   integer(I4P), intent(in)    :: nb, ni, ng, nc
   real(R4P),    intent(inout) :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(inout) :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)    :: rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)    :: dt
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: incr, s1, e1, s2, e2, lo_new, bb, hi_new

   !$acc parallel loop collapse(5) present(U_hi, U_lo, rhs) &
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
   endsubroutine rk1_update_r4_dekker_bkc

endmodule fundal_weno5_kernels_r4_dekker_bkc
