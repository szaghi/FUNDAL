!< FUNDAL, V3f' (V3f-collapse5) — same Dekker double-FP32 storage and
!< compensated TwoSum update as V3f, but with `!$acc parallel loop
!< collapse(5)` over (c, k, j, i, b) instead of `collapse(4)` on
!< (c, k, j, i) with an inner `!$acc loop vector` on b.
!<
!< Hypothesis under test: a single 5-way collapsed iteration space lets
!< nvfortran's mapping heuristic flatten the entire kernel into one
!< gang-vector grid, potentially saturating more SMs and hiding latency
!< better than the two-level mapping. The risk is increased register
!< pressure (larger per-thread live set) which could cut occupancy.
!<
!< Mathematically identical to V3f — the difference is purely the
!< OpenACC loop scheduling. Numerical output should match V3f to the
!< last bit; the comparison is wall-clock speed only.

#include "fundal.H"

module fundal_weno5_kernels_r4_dekker_c5
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R4P=>real32
use fundal_weno5_recon, only : weno5_recon_r4

implicit none
private
public :: ghost_fill_r4_dekker_c5, weno5_rhs_r4_dekker_c5, rk1_update_r4_dekker_c5

contains

   subroutine ghost_fill_r4_dekker_c5(U_hi, U_lo, nb, ni, ng, nc)
   !< Periodic ghost fill on both halves of the Dekker pair.
   !< Already a single-level `collapse(4)` loop in V3f — kept identical
   !< here because the ghost fill is memory-bound and the parallelisation
   !< experiment targets the WENO5 rhs and RK1 update, not the ghosts.
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
   endsubroutine ghost_fill_r4_dekker_c5

   subroutine weno5_rhs_r4_dekker_c5(U_hi, U_lo, rhs, nb, ni, ng, nc)
   !< Single `collapse(5)` parallel loop spanning (c, k, j, i, b). The
   !< b loop is the inner (rightmost in the source nest) so the
   !< collapsed iteration index has b as its fastest-varying coordinate,
   !< which lets nvfortran map b to the vector dimension — same coalesced
   !< access on stride-1 nb as in V3f.
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R4P),    intent(in)  :: U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(in)  :: U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P),    intent(out) :: rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: fL_im, fL_ip, fL_jm, fL_jp, fL_km, fL_kp
   real(R4P), parameter :: dx_inv = 1.0_R4P

   !$acc parallel loop collapse(5) present(U_hi, U_lo, rhs) &
   !$acc                          private(fL_im,fL_ip,fL_jm,fL_jp,fL_km,fL_kp)
   do c = 1, nc
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
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
   endsubroutine weno5_rhs_r4_dekker_c5

   subroutine rk1_update_r4_dekker_c5(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   !< Same compensated TwoSum update as rk1_update_r4_dekker — already
   !< collapse(5) in V3f, repeated here for self-containment so the V3f'
   !< variant uses only its own module's kernels.
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
   endsubroutine rk1_update_r4_dekker_c5

endmodule fundal_weno5_kernels_r4_dekker_c5
