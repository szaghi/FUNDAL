!< FUNDAL, V3h — WENO5 rhs kernel using compensated Horner reconstruction.

#include "fundal.H"

module fundal_weno5_kernels_r4_horner
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R4P=>real32
use fundal_weno5_recon_horner, only : weno5_recon_r4_horner

implicit none
private
public :: weno5_rhs_r4_horner

contains

   subroutine weno5_rhs_r4_horner(U, rhs, nb, ni, ng, nc)
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
                  fL_im = weno5_recon_r4_horner(U(b,i-3,j,k,c), U(b,i-2,j,k,c), U(b,i-1,j,k,c), U(b,i,j,k,c), U(b,i+1,j,k,c))
                  fL_ip = weno5_recon_r4_horner(U(b,i-2,j,k,c), U(b,i-1,j,k,c), U(b,i,j,k,c), U(b,i+1,j,k,c), U(b,i+2,j,k,c))
                  fL_jm = weno5_recon_r4_horner(U(b,i,j-3,k,c), U(b,i,j-2,k,c), U(b,i,j-1,k,c), U(b,i,j,k,c), U(b,i,j+1,k,c))
                  fL_jp = weno5_recon_r4_horner(U(b,i,j-2,k,c), U(b,i,j-1,k,c), U(b,i,j,k,c), U(b,i,j+1,k,c), U(b,i,j+2,k,c))
                  fL_km = weno5_recon_r4_horner(U(b,i,j,k-3,c), U(b,i,j,k-2,c), U(b,i,j,k-1,c), U(b,i,j,k,c), U(b,i,j,k+1,c))
                  fL_kp = weno5_recon_r4_horner(U(b,i,j,k-2,c), U(b,i,j,k-1,c), U(b,i,j,k,c), U(b,i,j,k+1,c), U(b,i,j,k+2,c))
                  rhs(b,i,j,k,c) = -dx_inv * ((fL_ip - fL_im) + (fL_jp - fL_jm) + (fL_kp - fL_km))
               enddo
            enddo
         enddo
      enddo
   enddo
   endsubroutine weno5_rhs_r4_horner

endmodule fundal_weno5_kernels_r4_horner
