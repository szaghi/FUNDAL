!< FUNDAL, V2 — FP32 storage with blanket FP64 compute. Every load is
!< promoted to R8P, the WENO5 reconstruction and RK1 update run in R8P,
!< the result is demoted to R4P on store. Tests the textbook "halve
!< bandwidth, keep FP64 ALU precision" middle path. Empirically a trap on
!< consumer GPU (RTX 4070, FP64:FP32 = 1:64) — any FP64 work in the inner
!< loop engages the slow datapath, and the storage round-trip dominates
!< the residual FP32 error anyway.

#include "fundal.H"

module fundal_weno5_kernels_r4store_r8comp
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R4P=>real32, R8P=>real64
use fundal_weno5_recon, only : weno5_recon_r8

implicit none
private
public :: weno5_rhs_r4store_r8comp, rk1_update_r4store_r8comp

contains

   subroutine weno5_rhs_r4store_r8comp(U, rhs, nb, ni, ng, nc)
   integer(I4P), intent(in) :: nb, ni, ng, nc
   real(R4P), intent(in)  :: U  (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P), intent(out) :: rhs(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: b, i, j, k, c
   real(R8P) :: fL_im, fL_ip, fL_jm, fL_jp, fL_km, fL_kp, val
   real(R8P), parameter :: dx_inv = 1.0_R8P

   !$acc parallel loop collapse(4) present(U, rhs) private(fL_im,fL_ip,fL_jm,fL_jp,fL_km,fL_kp,val)
   do c = 1, nc
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               !$acc loop vector
               do b = 1, nb
                  fL_im = weno5_recon_r8(real(U(b,i-3,j,k,c),R8P), real(U(b,i-2,j,k,c),R8P), &
                                          real(U(b,i-1,j,k,c),R8P), real(U(b,i,  j,k,c),R8P), &
                                          real(U(b,i+1,j,k,c),R8P))
                  fL_ip = weno5_recon_r8(real(U(b,i-2,j,k,c),R8P), real(U(b,i-1,j,k,c),R8P), &
                                          real(U(b,i,  j,k,c),R8P), real(U(b,i+1,j,k,c),R8P), &
                                          real(U(b,i+2,j,k,c),R8P))
                  fL_jm = weno5_recon_r8(real(U(b,i,j-3,k,c),R8P), real(U(b,i,j-2,k,c),R8P), &
                                          real(U(b,i,j-1,k,c),R8P), real(U(b,i,j,  k,c),R8P), &
                                          real(U(b,i,j+1,k,c),R8P))
                  fL_jp = weno5_recon_r8(real(U(b,i,j-2,k,c),R8P), real(U(b,i,j-1,k,c),R8P), &
                                          real(U(b,i,j,  k,c),R8P), real(U(b,i,j+1,k,c),R8P), &
                                          real(U(b,i,j+2,k,c),R8P))
                  fL_km = weno5_recon_r8(real(U(b,i,j,k-3,c),R8P), real(U(b,i,j,k-2,c),R8P), &
                                          real(U(b,i,j,k-1,c),R8P), real(U(b,i,j,k,  c),R8P), &
                                          real(U(b,i,j,k+1,c),R8P))
                  fL_kp = weno5_recon_r8(real(U(b,i,j,k-2,c),R8P), real(U(b,i,j,k-1,c),R8P), &
                                          real(U(b,i,j,k,  c),R8P), real(U(b,i,j,k+1,c),R8P), &
                                          real(U(b,i,j,k+2,c),R8P))
                  val = -dx_inv * ((fL_ip - fL_im) + (fL_jp - fL_jm) + (fL_kp - fL_km))
                  rhs(b,i,j,k,c) = real(val, R4P)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine weno5_rhs_r4store_r8comp

   subroutine rk1_update_r4store_r8comp(U, rhs, dt, nb, ni, ng, nc)
   integer(I4P), intent(in) :: nb, ni, ng, nc
   real(R4P), intent(inout) :: U  (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P), intent(in)    :: rhs(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(in)    :: dt
   integer(I4P) :: b, i, j, k, c
   real(R8P) :: val

   !$acc parallel loop collapse(5) present(U, rhs) private(val)
   do c = 1, nc
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               do b = 1, nb
                  val = real(U(b,i,j,k,c), R8P) + dt * real(rhs(b,i,j,k,c), R8P)
                  U(b,i,j,k,c) = real(val, R4P)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine rk1_update_r4store_r8comp

endmodule fundal_weno5_kernels_r4store_r8comp
