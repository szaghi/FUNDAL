!< FUNDAL, FP64 WENO5+RK1 device kernels for storage shape B
!< U(c, i, j, k, b) — c leftmost / stride-1, b rightmost / largest
!< stride. Provides both c-parallel (V1B) and c-sequential (V1B')
!< variants so the FP64 storage-shape matrix is symmetric:
!<
!<     | shape A (b,i,j,k,c) | shape B (c,i,j,k,b) |
!<  ---+---------------------+---------------------+
!<  c-par |        V1        |        V1B          |
!<  c-seq |        V1'       |       V1B'          |
!<
!< Reference for speedup remains V1' (shape A, c-sequential).
!<
!< Both kernels use loop order F (Fortran-compliant: stride-1 array
!< dimension lexically innermost in the parallel set) — the empirically
!< established best order from the V3fA-F vs V3fA-G / V3fB-F vs V3fB-G
!< comparison.

#include "fundal.H"

module fundal_weno5_kernels_r8_b
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use fundal_weno5_recon, only : weno5_recon_r8

implicit none
private
public :: dekker_from_r8_b_r8, dekker_to_r8_b_r8, &
          ghost_fill_r8_b, &
          weno5_rhs_r8_b_cpar, weno5_rhs_r8_b_cseq, &
          rk1_update_r8_b_cpar, rk1_update_r8_b_cseq

contains

   subroutine dekker_from_r8_b_r8(U_in, U_out, nb, ni, ng, nc)
   !< Reshape from canonical shape A (b,i,j,k,c) into shape B (c,i,j,k,b).
   !< Both arrays are R8P here (Dekker has nothing to do with it; the
   !< name suffix _r8 disambiguates from the FP32 dekker_from_r8_b in
   !< the realistic Dekker module).
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R8P),    intent(in)  :: U_in (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P),    intent(out) :: U_out(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   integer(I4P) :: b, i, j, k, c
   do b = 1, nb
      do k = 1-ng, ni+ng
         do j = 1-ng, ni+ng
            do i = 1-ng, ni+ng
               do c = 1, nc
                  U_out(c,i,j,k,b) = U_in(b,i,j,k,c)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine dekker_from_r8_b_r8

   subroutine dekker_to_r8_b_r8(U_in, U_out, nb, ni, ng, nc)
   !< Reshape from shape B (c,i,j,k,b) back to canonical (b,i,j,k,c).
   integer(I4P), intent(in)  :: nb, ni, ng, nc
   real(R8P),    intent(in)  :: U_in (1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R8P),    intent(out) :: U_out(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: b, i, j, k, c
   do b = 1, nb
      do k = 1-ng, ni+ng
         do j = 1-ng, ni+ng
            do i = 1-ng, ni+ng
               do c = 1, nc
                  U_out(b,i,j,k,c) = U_in(c,i,j,k,b)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine dekker_to_r8_b_r8

   subroutine ghost_fill_r8_b(U, nb, ni, ng, nc)
   !< Periodic ghost fill on shape B. Loop order F (b outermost in the
   !< parallel set, c innermost in the body — but since c is part of
   !< the collapsed parallel surface here, the loop runs c lexically
   !< innermost = vector dimension, which is also stride-1 in shape B).
   integer(I4P), intent(in)    :: nb, ni, ng, nc
   real(R8P),    intent(inout) :: U(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   integer(I4P) :: g, b, j, k, c
   do g = 1, ng
      !$acc parallel loop collapse(4) present(U)
      do b = 1, nb
         do k = 1-ng, ni+ng
            do j = 1-ng, ni+ng
               do c = 1, nc
                  U(c, 1-g,  j, k, b) = U(c, ni-g+1, j, k, b)
                  U(c, ni+g, j, k, b) = U(c, g,      j, k, b)
               enddo
            enddo
         enddo
      enddo
      !$acc parallel loop collapse(4) present(U)
      do b = 1, nb
         do k = 1-ng, ni+ng
            do j = 1-ng, ni+ng
               do c = 1, nc
                  U(c, j, 1-g,  k, b) = U(c, j, ni-g+1, k, b)
                  U(c, j, ni+g, k, b) = U(c, j, g,      k, b)
               enddo
            enddo
         enddo
      enddo
      !$acc parallel loop collapse(4) present(U)
      do b = 1, nb
         do k = 1-ng, ni+ng
            do j = 1-ng, ni+ng
               do c = 1, nc
                  U(c, j, k, 1-g,  b) = U(c, j, k, ni-g+1, b)
                  U(c, j, k, ni+g, b) = U(c, j, k, g,      b)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine ghost_fill_r8_b

   subroutine weno5_rhs_r8_b_cpar(U, rhs, nb, ni, ng, nc)
   !< V1B: shape B, c-parallel.
   !< `!$acc parallel loop collapse(5)` over (b, k, j, i, c) — c
   !< lexically innermost = vector dim = stride-1 in shape B. This is
   !< the analogue of V3f' on shape B for FP64.
   integer(I4P), intent(in) :: nb, ni, ng, nc
   real(R8P), intent(in)  :: U  (1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R8P), intent(out) :: rhs(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   integer(I4P) :: b, i, j, k, c
   real(R8P) :: fL_im, fL_ip, fL_jm, fL_jp, fL_km, fL_kp
   real(R8P), parameter :: dx_inv = 1.0_R8P

   !$acc parallel loop collapse(5) present(U, rhs) &
   !$acc                          private(fL_im,fL_ip,fL_jm,fL_jp,fL_km,fL_kp)
   do b = 1, nb
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               do c = 1, nc
                  fL_im = weno5_recon_r8(U(c,i-3,j,k,b), U(c,i-2,j,k,b), U(c,i-1,j,k,b), &
                                          U(c,i,  j,k,b), U(c,i+1,j,k,b))
                  fL_ip = weno5_recon_r8(U(c,i-2,j,k,b), U(c,i-1,j,k,b), U(c,i,  j,k,b), &
                                          U(c,i+1,j,k,b), U(c,i+2,j,k,b))
                  fL_jm = weno5_recon_r8(U(c,i,j-3,k,b), U(c,i,j-2,k,b), U(c,i,j-1,k,b), &
                                          U(c,i,j,  k,b), U(c,i,j+1,k,b))
                  fL_jp = weno5_recon_r8(U(c,i,j-2,k,b), U(c,i,j-1,k,b), U(c,i,j,  k,b), &
                                          U(c,i,j+1,k,b), U(c,i,j+2,k,b))
                  fL_km = weno5_recon_r8(U(c,i,j,k-3,b), U(c,i,j,k-2,b), U(c,i,j,k-1,b), &
                                          U(c,i,j,k,  b), U(c,i,j,k+1,b))
                  fL_kp = weno5_recon_r8(U(c,i,j,k-2,b), U(c,i,j,k-1,b), U(c,i,j,k,  b), &
                                          U(c,i,j,k+1,b), U(c,i,j,k+2,b))
                  rhs(c,i,j,k,b) = -dx_inv * ((fL_ip - fL_im) + (fL_jp - fL_jm) + (fL_kp - fL_km))
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine weno5_rhs_r8_b_cpar

   subroutine weno5_rhs_r8_b_cseq(U, rhs, nb, ni, ng, nc)
   !< V1B': shape B, c-sequential. Realistic-CFD constraint applied to
   !< FP64 with shape B. `!$acc parallel loop collapse(4)` over
   !< (b, k, j, i), inner `do c` sequential. i is the lexically
   !< innermost dim in the parallel set — order F for shape B (since c
   !< is removed from the parallel surface, the next stride-1 candidate
   !< in the parallel set is i with stride nc=5).
   integer(I4P), intent(in) :: nb, ni, ng, nc
   real(R8P), intent(in)  :: U  (1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R8P), intent(out) :: rhs(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   integer(I4P) :: b, i, j, k, c
   real(R8P) :: fL_im, fL_ip, fL_jm, fL_jp, fL_km, fL_kp
   real(R8P), parameter :: dx_inv = 1.0_R8P

   !$acc parallel loop collapse(4) present(U, rhs) &
   !$acc                          private(fL_im,fL_ip,fL_jm,fL_jp,fL_km,fL_kp)
   do b = 1, nb
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               do c = 1, nc
                  fL_im = weno5_recon_r8(U(c,i-3,j,k,b), U(c,i-2,j,k,b), U(c,i-1,j,k,b), &
                                          U(c,i,  j,k,b), U(c,i+1,j,k,b))
                  fL_ip = weno5_recon_r8(U(c,i-2,j,k,b), U(c,i-1,j,k,b), U(c,i,  j,k,b), &
                                          U(c,i+1,j,k,b), U(c,i+2,j,k,b))
                  fL_jm = weno5_recon_r8(U(c,i,j-3,k,b), U(c,i,j-2,k,b), U(c,i,j-1,k,b), &
                                          U(c,i,j,  k,b), U(c,i,j+1,k,b))
                  fL_jp = weno5_recon_r8(U(c,i,j-2,k,b), U(c,i,j-1,k,b), U(c,i,j,  k,b), &
                                          U(c,i,j+1,k,b), U(c,i,j+2,k,b))
                  fL_km = weno5_recon_r8(U(c,i,j,k-3,b), U(c,i,j,k-2,b), U(c,i,j,k-1,b), &
                                          U(c,i,j,k,  b), U(c,i,j,k+1,b))
                  fL_kp = weno5_recon_r8(U(c,i,j,k-2,b), U(c,i,j,k-1,b), U(c,i,j,k,  b), &
                                          U(c,i,j,k+1,b), U(c,i,j,k+2,b))
                  rhs(c,i,j,k,b) = -dx_inv * ((fL_ip - fL_im) + (fL_jp - fL_jm) + (fL_kp - fL_km))
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine weno5_rhs_r8_b_cseq

   subroutine rk1_update_r8_b_cpar(U, rhs, dt, nb, ni, ng, nc)
   !< V1B: collapse(5) update on shape B, c parallel.
   integer(I4P), intent(in) :: nb, ni, ng, nc
   real(R8P), intent(inout) :: U  (1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R8P), intent(in)    :: rhs(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R8P), intent(in)    :: dt
   integer(I4P) :: b, i, j, k, c

   !$acc parallel loop collapse(5) present(U, rhs)
   do b = 1, nb
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               do c = 1, nc
                  U(c,i,j,k,b) = U(c,i,j,k,b) + dt * rhs(c,i,j,k,b)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine rk1_update_r8_b_cpar

   subroutine rk1_update_r8_b_cseq(U, rhs, dt, nb, ni, ng, nc)
   !< V1B': collapse(4) over (b,k,j,i) + inner seq c, shape B.
   integer(I4P), intent(in) :: nb, ni, ng, nc
   real(R8P), intent(inout) :: U  (1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R8P), intent(in)    :: rhs(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb)
   real(R8P), intent(in)    :: dt
   integer(I4P) :: b, i, j, k, c

   !$acc parallel loop collapse(4) present(U, rhs)
   do b = 1, nb
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               do c = 1, nc
                  U(c,i,j,k,b) = U(c,i,j,k,b) + dt * rhs(c,i,j,k,b)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine rk1_update_r8_b_cseq

endmodule fundal_weno5_kernels_r8_b
