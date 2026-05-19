!< FUNDAL, FP32 WENO5+RK1 device kernels for the precision benchmark (V3).
!<
!< Storage and arithmetic both in real(R4P). Naive baseline for the FP32
!< family — no compensation on the time integrator, no precision tricks in
!< the reconstruction. Shared across variants V3, V2b, V3b, V3c, V3d, V3e,
!< V3h via the common ghost_fill_r4 (storage layout is identical) and the
!< rhs/update entry points specialised here.

#include "fundal.H"

module fundal_weno5_kernels_r4
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R4P=>real32
use fundal_weno5_recon, only : weno5_recon_r4

implicit none
private
public :: ghost_fill_r4, weno5_rhs_r4, rk1_update_r4

contains

   subroutine ghost_fill_r4(U, nb, ni, ng, nc)
   integer(I4P), intent(in) :: nb, ni, ng, nc
   real(R4P), intent(inout) :: U(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: g, b, j, k, c
   do g = 1, ng
      !$acc parallel loop collapse(4) present(U)
      do c = 1, nc
         do k = 1-ng, ni+ng
            do j = 1-ng, ni+ng
               do b = 1, nb
                  U(b, 1-g,  j, k, c) = U(b, ni-g+1, j, k, c)
                  U(b, ni+g, j, k, c) = U(b, g,      j, k, c)
               enddo
            enddo
         enddo
      enddo
      !$acc parallel loop collapse(4) present(U)
      do c = 1, nc
         do k = 1-ng, ni+ng
            do b = 1, nb
               do j = 1-ng, ni+ng
                  U(b, j, 1-g,  k, c) = U(b, j, ni-g+1, k, c)
                  U(b, j, ni+g, k, c) = U(b, j, g,      k, c)
               enddo
            enddo
         enddo
      enddo
      !$acc parallel loop collapse(4) present(U)
      do c = 1, nc
         do k = 1-ng, ni+ng
            do j = 1-ng, ni+ng
               do b = 1, nb
                  U(b, j, k, 1-g,  c) = U(b, j, k, ni-g+1, c)
                  U(b, j, k, ni+g, c) = U(b, j, k, g,      c)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine ghost_fill_r4

   subroutine weno5_rhs_r4(U, rhs, nb, ni, ng, nc)
   integer(I4P), intent(in) :: nb, ni, ng, nc
   real(R4P), intent(in)  :: U  (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P), intent(out) :: rhs(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: b, i, j, k, c
   real(R4P) :: fL_im, fL_ip, fL_jm, fL_jp, fL_km, fL_kp
   real(R4P), parameter :: dx_inv = 1.0_R4P

   !$acc parallel loop collapse(4) present(U, rhs) private(fL_im,fL_ip,fL_jm,fL_jp,fL_km,fL_kp)
   do c = 1, nc
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               !$acc loop vector
               do b = 1, nb
                  fL_im = weno5_recon_r4(U(b,i-3,j,k,c), U(b,i-2,j,k,c), U(b,i-1,j,k,c), U(b,i,j,k,c), U(b,i+1,j,k,c))
                  fL_ip = weno5_recon_r4(U(b,i-2,j,k,c), U(b,i-1,j,k,c), U(b,i,j,k,c), U(b,i+1,j,k,c), U(b,i+2,j,k,c))
                  fL_jm = weno5_recon_r4(U(b,i,j-3,k,c), U(b,i,j-2,k,c), U(b,i,j-1,k,c), U(b,i,j,k,c), U(b,i,j+1,k,c))
                  fL_jp = weno5_recon_r4(U(b,i,j-2,k,c), U(b,i,j-1,k,c), U(b,i,j,k,c), U(b,i,j+1,k,c), U(b,i,j+2,k,c))
                  fL_km = weno5_recon_r4(U(b,i,j,k-3,c), U(b,i,j,k-2,c), U(b,i,j,k-1,c), U(b,i,j,k,c), U(b,i,j,k+1,c))
                  fL_kp = weno5_recon_r4(U(b,i,j,k-2,c), U(b,i,j,k-1,c), U(b,i,j,k,c), U(b,i,j,k+1,c), U(b,i,j,k+2,c))
                  rhs(b,i,j,k,c) = -dx_inv * ((fL_ip - fL_im) + (fL_jp - fL_jm) + (fL_kp - fL_km))
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine weno5_rhs_r4

   subroutine rk1_update_r4(U, rhs, dt, nb, ni, ng, nc)
   integer(I4P), intent(in) :: nb, ni, ng, nc
   real(R4P), intent(inout) :: U  (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P), intent(in)    :: rhs(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R4P), intent(in)    :: dt
   integer(I4P) :: b, i, j, k, c
   !$acc parallel loop collapse(5) present(U, rhs)
   do c = 1, nc
      do k = 1, ni
         do j = 1, ni
            do i = 1, ni
               do b = 1, nb
                  U(b,i,j,k,c) = U(b,i,j,k,c) + dt * rhs(b,i,j,k,c)
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine rk1_update_r4

endmodule fundal_weno5_kernels_r4
