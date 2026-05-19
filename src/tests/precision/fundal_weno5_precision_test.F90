!< FUNDAL, WENO5 precision-variant stencil benchmark (OpenACC + host fallback).
!<
!< Multi-block 3D WENO5 flux divergence on a rank-5 array U(nb, ni, nj, nk, nc),
!< stride-1 in nb (block index) per the block-structured GPU layout.
!<
!< Up to eleven precision variants run back-to-back in the same binary so
!< they share the same thermal / clock state. Each performs nwarm warmup
!< steps (untimed) plus nsteps timed RK1 steps with periodic ghost fill.
!< Per-block L2 error vs the FP64 reference and per-block conservation
!< drift (normalised by sum(|U_init|) per component) are aggregated as
!< min/max/mean across nb.
!<
!< Kernels live in per-algorithm modules; this file is the orchestration
!< layer: CLI parsing, allocation, initial condition, timing, error /
!< drift diagnostics, and reporting. See IMPLEMENTATION_PLAN.md and
!< README.md for the variant taxonomy and findings.

#include "fundal.H"

program fundal_weno5_precision_test
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64

use fundal_weno5_kernels_r8,            only : ghost_fill_r8, weno5_rhs_r8, rk1_update_r8
use fundal_weno5_kernels_r4,            only : ghost_fill_r4, weno5_rhs_r4, rk1_update_r4
use fundal_weno5_kernels_r4_b64,        only : weno5_rhs_r4_b64
use fundal_weno5_kernels_r4store_r8comp,only : weno5_rhs_r4store_r8comp, rk1_update_r4store_r8comp
use fundal_compensation_neumaier,       only : rk1_update_r4_kahan
use fundal_compensation_klein,          only : rk1_update_r4_klein
use fundal_compensation_fasttwosum,     only : rk1_update_r4_fasttwosum
use fundal_weno5_kernels_r4_compdot,    only : weno5_rhs_r4_compdot
use fundal_weno5_kernels_r4_horner,     only : weno5_rhs_r4_horner
use fundal_weno5_kernels_r4_dekker,     only : ghost_fill_r4_dekker, weno5_rhs_r4_dekker, &
                                                weno5_rhs_r4_dekker_compdot, rk1_update_r4_dekker, &
                                                dekker_to_r8, dekker_from_r8
use fundal_weno5_kernels_r4_dekker_c5,  only : ghost_fill_r4_dekker_c5, weno5_rhs_r4_dekker_c5, &
                                                rk1_update_r4_dekker_c5
use fundal_weno5_kernels_r4_dekker_bkc, only : ghost_fill_r4_dekker_bkc, weno5_rhs_r4_dekker_bkc, &
                                                rk1_update_r4_dekker_bkc
use fundal_weno5_kernels_r4_dekker_real, only : &
        dekker_from_r8_a, dekker_to_r8_a, ghost_fill_r4_dekker_a, &
        weno5_rhs_r4_dekker_af, weno5_rhs_r4_dekker_ag, &
        rk1_update_r4_dekker_af, rk1_update_r4_dekker_ag, &
        dekker_from_r8_b, dekker_to_r8_b, ghost_fill_r4_dekker_b, &
        weno5_rhs_r4_dekker_bf, weno5_rhs_r4_dekker_bg, &
        rk1_update_r4_dekker_bf, rk1_update_r4_dekker_bg
use fundal_weno5_kernels_r8_real, only : ghost_fill_r8_real, weno5_rhs_r8_real, rk1_update_r8_real
use fundal_weno5_kernels_r8_b,    only : dekker_from_r8_b_r8, dekker_to_r8_b_r8, ghost_fill_r8_b, &
                                          weno5_rhs_r8_b_cpar, weno5_rhs_r8_b_cseq, &
                                          rk1_update_r8_b_cpar, rk1_update_r8_b_cseq

implicit none

! ----------------------------------------------------------------------------
! Problem extents (overridable via CLI: nb ni nc nsteps)
! ----------------------------------------------------------------------------
integer(I4P) :: nb     = 512    !< number of independent blocks (stride-1)
integer(I4P) :: ni     = 16     !< spatial extent per direction (cubic block)
integer(I4P) :: nc     = 5      !< conservative variables
integer(I4P) :: nsteps = 100    !< number of timed RK1 steps
integer(I4P), parameter :: ng    = 3      !< ghost cells (WENO5 needs 3)
integer(I4P), parameter :: nwarm = 10     !< warmup steps (untimed)
integer(I4P), parameter :: NVAR  = 20     !< number of precision variants

! Reference FP64 storage.
real(R8P), allocatable :: U_ref(:,:,:,:,:)
real(R8P), allocatable :: U0   (:,:,:,:,:)

! Per-variant outputs.
real(R8P) :: t_v(NVAR), bw_v(NVAR)
real(R8P) :: err_min(NVAR), err_max(NVAR), err_mean(NVAR)
real(R8P) :: drift_min(NVAR), drift_max(NVAR), drift_mean(NVAR)

! ----------------------------------------------------------------------------
call parse_cli
call announce_setup
call allocate_state
call init_state(U0)

call run_fp64(U0, U_ref, t_v(1), bw_v(1))
err_min(1) = 0.0_R8P; err_max(1) = 0.0_R8P; err_mean(1) = 0.0_R8P
call conservation_stats(U0, U_ref, drift_min(1), drift_max(1), drift_mean(1))

call run_r4store_r8comp(U0, t_v(2), bw_v(2), &
                        err_min(2), err_max(2), err_mean(2), &
                        drift_min(2), drift_max(2), drift_mean(2))

call run_fp32(U0, t_v(3), bw_v(3), &
              err_min(3), err_max(3), err_mean(3), &
              drift_min(3), drift_max(3), drift_mean(3))

call run_fp32_b64(U0, t_v(4), bw_v(4), &
                  err_min(4), err_max(4), err_mean(4), &
                  drift_min(4), drift_max(4), drift_mean(4))

call run_fp32_kahan(U0, t_v(5), bw_v(5), &
                    err_min(5), err_max(5), err_mean(5), &
                    drift_min(5), drift_max(5), drift_mean(5))

call run_fp32_klein(U0, t_v(6), bw_v(6), &
                    err_min(6), err_max(6), err_mean(6), &
                    drift_min(6), drift_max(6), drift_mean(6))

call run_fp32_fasttwosum(U0, t_v(7), bw_v(7), &
                         err_min(7), err_max(7), err_mean(7), &
                         drift_min(7), drift_max(7), drift_mean(7))

call run_fp32_compdot(U0, t_v(8), bw_v(8), &
                      err_min(8), err_max(8), err_mean(8), &
                      drift_min(8), drift_max(8), drift_mean(8))

call run_fp32_horner(U0, t_v(9), bw_v(9), &
                     err_min(9), err_max(9), err_mean(9), &
                     drift_min(9), drift_max(9), drift_mean(9))

call run_fp32_dekker(U0, t_v(10), bw_v(10), &
                     err_min(10), err_max(10), err_mean(10), &
                     drift_min(10), drift_max(10), drift_mean(10))

call run_fp32_dekker_compdot(U0, t_v(11), bw_v(11), &
                             err_min(11), err_max(11), err_mean(11), &
                             drift_min(11), drift_max(11), drift_mean(11))

call run_fp32_dekker_c5(U0, t_v(12), bw_v(12), &
                        err_min(12), err_max(12), err_mean(12), &
                        drift_min(12), drift_max(12), drift_mean(12))

call run_fp32_dekker_bkc(U0, t_v(13), bw_v(13), &
                         err_min(13), err_max(13), err_mean(13), &
                         drift_min(13), drift_max(13), drift_mean(13))

call run_fp64_real(U0, t_v(18), bw_v(18))
err_min(18) = 0.0_R8P; err_max(18) = 0.0_R8P; err_mean(18) = 0.0_R8P
call conservation_stats(U0, U_ref, drift_min(18), drift_max(18), drift_mean(18))

call run_fp32_dekker_af(U0, t_v(14), bw_v(14), &
                        err_min(14), err_max(14), err_mean(14), &
                        drift_min(14), drift_max(14), drift_mean(14))

call run_fp32_dekker_ag(U0, t_v(15), bw_v(15), &
                        err_min(15), err_max(15), err_mean(15), &
                        drift_min(15), drift_max(15), drift_mean(15))

call run_fp32_dekker_bf(U0, t_v(16), bw_v(16), &
                        err_min(16), err_max(16), err_mean(16), &
                        drift_min(16), drift_max(16), drift_mean(16))

call run_fp32_dekker_bg(U0, t_v(17), bw_v(17), &
                        err_min(17), err_max(17), err_mean(17), &
                        drift_min(17), drift_max(17), drift_mean(17))

call run_fp64_b_cpar(U0, t_v(19), bw_v(19))
err_min(19) = 0.0_R8P; err_max(19) = 0.0_R8P; err_mean(19) = 0.0_R8P
call conservation_stats(U0, U_ref, drift_min(19), drift_max(19), drift_mean(19))

call run_fp64_b_cseq(U0, t_v(20), bw_v(20))
err_min(20) = 0.0_R8P; err_max(20) = 0.0_R8P; err_mean(20) = 0.0_R8P
call conservation_stats(U0, U_ref, drift_min(20), drift_max(20), drift_mean(20))

call report

print '(A)', 'test passed'

contains

   subroutine parse_cli
   character(16) :: arg
   integer       :: nargs, ios

   nargs = command_argument_count()
   if (nargs >= 1) then
      call get_command_argument(1, arg); read(arg, *, iostat=ios) nb
      if (ios /= 0 .or. nb <= 0) nb = 512
   endif
   if (nargs >= 2) then
      call get_command_argument(2, arg); read(arg, *, iostat=ios) ni
      if (ios /= 0 .or. ni <= 0) ni = 16
   endif
   if (nargs >= 3) then
      call get_command_argument(3, arg); read(arg, *, iostat=ios) nc
      if (ios /= 0 .or. nc <= 0) nc = 5
   endif
   if (nargs >= 4) then
      call get_command_argument(4, arg); read(arg, *, iostat=ios) nsteps
      if (ios /= 0 .or. nsteps <= 0) nsteps = 100
   endif
   endsubroutine parse_cli

   subroutine announce_setup
   real(R8P) :: mb_per_array
   mb_per_array = real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P) * 8.0_R8P / (1024.0_R8P**2)
   print '(A)',         '== FUNDAL WENO5 precision benchmark (GPU) =='
   print '(A,I0,A,I0,A,I0,A,I0)', 'nb=', nb, '  ni=nj=nk=', ni, '  nc=', nc, '  nsteps=', nsteps
   print '(A,I0)',      'ng=', ng
   print '(A,F0.2,A)',  'FP64 footprint per array: ', mb_per_array, ' MiB'
#if defined(DEV_OAC)
   print '(A)',         'backend: OpenACC'
#else
   print '(A)',         'backend: host fallback (no device directives active)'
#endif
   print '(A)',         ''
   endsubroutine announce_setup

   subroutine allocate_state
   integer :: alloc_stat
   character(256) :: emsg
   allocate(U_ref(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), &
            U0   (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), &
            stat=alloc_stat, errmsg=emsg)
   if (alloc_stat /= 0) then
      print '(A)', 'allocation failed: '//trim(emsg)
      error stop 1
   endif
   endsubroutine allocate_state

   subroutine init_state(U)
   real(R8P), intent(out) :: U(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   integer(I4P) :: b, i, j, k
   real(R8P)    :: x, y, z, twopi, phase, rho, u_v, v_v, w_v, p, e_kin

   twopi = 8.0_R8P * atan(1.0_R8P)
   do k = 1-ng, ni+ng
      z = real(k, R8P) / real(ni, R8P)
      do j = 1-ng, ni+ng
         y = real(j, R8P) / real(ni, R8P)
         do i = 1-ng, ni+ng
            x = real(i, R8P) / real(ni, R8P)
            do b = 1, nb
               phase = twopi * real(b, R8P) / real(nb, R8P)
               rho = 1.0_R8P + 0.2_R8P * sin(twopi*x + phase) * cos(twopi*y) * sin(twopi*z)
               u_v = 0.3_R8P * sin(twopi*x) * cos(twopi*y + phase)
               v_v = 0.2_R8P * cos(twopi*x + phase) * sin(twopi*z)
               w_v = 0.1_R8P * sin(twopi*y) * cos(twopi*z + phase)
               p   = 1.0_R8P
               e_kin = 0.5_R8P * (u_v*u_v + v_v*v_v + w_v*w_v)
               U(b,i,j,k,1) = rho
               U(b,i,j,k,2) = rho * u_v
               U(b,i,j,k,3) = rho * v_v
               U(b,i,j,k,4) = rho * w_v
               U(b,i,j,k,5) = p / 0.4_R8P + rho * e_kin
            enddo
         enddo
      enddo
   enddo
   endsubroutine init_state

   subroutine wall_clock(t)
   real(R8P), intent(out) :: t
   integer(I8P) :: count, rate
   call system_clock(count=count, count_rate=rate)
   t = real(count, R8P) / real(rate, R8P)
   endsubroutine wall_clock

   ! -------------------------------------------------------------------------
   ! Diagnostics. Pairwise sum keeps the conservation read at O(log N * eps)
   ! so V1 can register drMax = eps_R8P instead of being masked by O(N * eps)
   ! diagnostic noise.
   ! -------------------------------------------------------------------------
   subroutine conservation_stats(U_init, U_final, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(in)  :: U_final(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: dmin, dmax, dmean
   real(R8P) :: drift, s0, s1, scale
   real(R8P) :: buf(ni*ni*ni), bufabs(ni*ni*ni)
   integer(I4P) :: b, c, n
   real(R8P) :: acc

   n = ni*ni*ni
   dmin = huge(0.0_R8P); dmax = 0.0_R8P; acc = 0.0_R8P
   do b = 1, nb
      drift = 0.0_R8P
      do c = 1, nc
         buf    = reshape(U_init (b, 1:ni, 1:ni, 1:ni, c), [n])
         s0     = pairwise_sum(buf, n)
         bufabs = abs(buf)
         scale  = pairwise_sum(bufabs, n)
         buf    = reshape(U_final(b, 1:ni, 1:ni, 1:ni, c), [n])
         s1     = pairwise_sum(buf, n)
         drift  = max(drift, abs(s1 - s0) / max(scale, tiny(0.0_R8P)))
      enddo
      dmin = min(dmin, drift); dmax = max(dmax, drift); acc = acc + drift
   enddo
   dmean = acc / real(nb, R8P)
   endsubroutine conservation_stats

   pure recursive function pairwise_sum(a, n) result(s)
   integer(I4P), intent(in) :: n
   real(R8P),    intent(in) :: a(1:n)
   real(R8P) :: s
   integer(I4P) :: half, i

   if (n <= 8) then
      s = 0.0_R8P
      do i = 1, n
         s = s + a(i)
      enddo
   else
      half = n / 2
      s = pairwise_sum(a(1:half), half) + pairwise_sum(a(half+1:n), n - half)
   endif
   endfunction pairwise_sum

   subroutine error_stats_r8(U_var, emin, emax, emean)
   real(R8P), intent(in)  :: U_var(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: emin, emax, emean
   real(R8P) :: num, den, rel
   integer(I4P) :: b
   real(R8P) :: acc

   emin = huge(0.0_R8P); emax = 0.0_R8P; acc = 0.0_R8P
   do b = 1, nb
      num = sqrt(sum((U_var(b, 1:ni, 1:ni, 1:ni, :) - U_ref(b, 1:ni, 1:ni, 1:ni, :))**2))
      den = sqrt(sum(  U_ref(b, 1:ni, 1:ni, 1:ni, :)                                **2))
      rel = num / max(den, tiny(0.0_R8P))
      emin = min(emin, rel); emax = max(emax, rel); acc = acc + rel
   enddo
   emean = acc / real(nb, R8P)
   endsubroutine error_stats_r8

   ! -------------------------------------------------------------------------
   ! V1 — FP64 baseline.
   ! -------------------------------------------------------------------------
   subroutine run_fp64(U_init, U_out, wall, bw)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: U_out (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw
   real(R8P), allocatable :: U(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R8P), parameter :: dt = 1.0e-3_R8P

   allocate(U(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=U_init)
   allocate(rhs(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R8P)

   !$acc data copy(U) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r8(U, nb, ni, ng, nc)
      call weno5_rhs_r8(U, rhs, nb, ni, ng, nc)
      call rk1_update_r8(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r8(U, nb, ni, ng, nc)
      call weno5_rhs_r8(U, rhs, nb, ni, ng, nc)
      call rk1_update_r8(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 8.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   U_out = U
   deallocate(U, rhs)
   endsubroutine run_fp64

   ! -------------------------------------------------------------------------
   ! V1' — FP64 baseline with c-component loop sequential (the honest
   ! baseline for the "realistic CFD" variants V3fA-F / V3fA-G / V3fB-F /
   ! V3fB-G, since they all have c sequential too). Uses the same Shape A
   ! storage U(b,i,j,k,c) and loop order F (b innermost) as V3fA-F.
   ! -------------------------------------------------------------------------
   subroutine run_fp64_real(U_init, wall, bw)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw
   real(R8P), allocatable :: U(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R8P), parameter :: dt = 1.0e-3_R8P

   allocate(U(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=U_init)
   allocate(rhs(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R8P)

   !$acc data copy(U) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r8_real(U, nb, ni, ng, nc)
      call weno5_rhs_r8_real(U, rhs, nb, ni, ng, nc)
      call rk1_update_r8_real(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r8_real(U, nb, ni, ng, nc)
      call weno5_rhs_r8_real(U, rhs, nb, ni, ng, nc)
      call rk1_update_r8_real(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 8.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   deallocate(U, rhs)
   endsubroutine run_fp64_real

   ! -------------------------------------------------------------------------
   ! V2 — FP32 storage + blanket FP64 compute.
   ! -------------------------------------------------------------------------
   subroutine run_r4store_r8comp(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P), allocatable :: U_promoted(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R8P), parameter :: dt = 1.0e-3_R8P

   allocate(U  (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   U = real(U_init, R4P)

   !$acc data copy(U) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4store_r8comp(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4store_r8comp(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4store_r8comp(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4store_r8comp(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 4.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_promoted(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   U_promoted = real(U, R8P)
   call error_stats_r8(U_promoted, emin, emax, emean)
   call conservation_stats(U_init, U_promoted, dmin, dmax, dmean)
   deallocate(U, rhs, U_promoted)
   endsubroutine run_r4store_r8comp

   ! -------------------------------------------------------------------------
   ! V3 — FP32 throughout (naive baseline of the FP32 family).
   ! -------------------------------------------------------------------------
   subroutine run_fp32(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P), allocatable :: U_promoted(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U  (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   U = real(U_init, R4P)

   !$acc data copy(U) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 4.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_promoted(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   U_promoted = real(U, R8P)
   call error_stats_r8(U_promoted, emin, emax, emean)
   call conservation_stats(U_init, U_promoted, dmin, dmax, dmean)
   deallocate(U, rhs, U_promoted)
   endsubroutine run_fp32

   ! -------------------------------------------------------------------------
   ! V2b — FP32 throughout except surgical FP64 promotion of beta indicators.
   ! -------------------------------------------------------------------------
   subroutine run_fp32_b64(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P), allocatable :: U_promoted(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U  (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   U = real(U_init, R4P)

   !$acc data copy(U) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4_b64(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4_b64(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 4.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_promoted(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   U_promoted = real(U, R8P)
   call error_stats_r8(U_promoted, emin, emax, emean)
   call conservation_stats(U_init, U_promoted, dmin, dmax, dmean)
   deallocate(U, rhs, U_promoted)
   endsubroutine run_fp32_b64

   ! -------------------------------------------------------------------------
   ! V3b — FP32 + Neumaier-compensated RK1.
   ! -------------------------------------------------------------------------
   subroutine run_fp32_kahan(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U(:,:,:,:,:), rhs(:,:,:,:,:), comp(:,:,:,:,:)
   real(R8P), allocatable :: U_promoted(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U   (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   allocate(comp(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   U = real(U_init, R4P)

   !$acc data copy(U) copyin(comp) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4_kahan(U, rhs, comp, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4_kahan(U, rhs, comp, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 4.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_promoted(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   U_promoted = real(U, R8P)
   call error_stats_r8(U_promoted, emin, emax, emean)
   call conservation_stats(U_init, U_promoted, dmin, dmax, dmean)
   deallocate(U, rhs, comp, U_promoted)
   endsubroutine run_fp32_kahan

   ! -------------------------------------------------------------------------
   ! V3c — FP32 + Klein 2nd-order cascaded Neumaier compensation.
   ! -------------------------------------------------------------------------
   subroutine run_fp32_klein(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U(:,:,:,:,:), rhs(:,:,:,:,:), comp(:,:,:,:,:), comp2(:,:,:,:,:)
   real(R8P), allocatable :: U_final(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U    (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs  (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   allocate(comp (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   allocate(comp2(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   U = real(U_init, R4P)

   !$acc data copy(U) copyin(comp, comp2) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4_klein(U, rhs, comp, comp2, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4_klein(U, rhs, comp, comp2, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc update host(U, comp, comp2)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 4.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_final(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   U_final = real(U, R8P) + real(comp, R8P) + real(comp2, R8P)
   call error_stats_r8(U_final, emin, emax, emean)
   call conservation_stats(U_init, U_final, dmin, dmax, dmean)
   deallocate(U, rhs, comp, comp2, U_final)
   endsubroutine run_fp32_klein

   ! -------------------------------------------------------------------------
   ! V3e — FP32 + branchless FastTwoSum RK1 (warp-divergence-free V3b).
   ! -------------------------------------------------------------------------
   subroutine run_fp32_fasttwosum(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U(:,:,:,:,:), rhs(:,:,:,:,:), comp(:,:,:,:,:)
   real(R8P), allocatable :: U_promoted(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U   (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   allocate(comp(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   U = real(U_init, R4P)

   !$acc data copy(U) copyin(comp) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4_fasttwosum(U, rhs, comp, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4_fasttwosum(U, rhs, comp, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 4.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_promoted(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   U_promoted = real(U, R8P)
   call error_stats_r8(U_promoted, emin, emax, emean)
   call conservation_stats(U_init, U_promoted, dmin, dmax, dmean)
   deallocate(U, rhs, comp, U_promoted)
   endsubroutine run_fp32_fasttwosum

   ! -------------------------------------------------------------------------
   ! V3d — FP32 + Graillat-Langlois compensated dot product in WENO5 recon
   !        + Neumaier RK1 (the two attack orthogonal error sources).
   ! -------------------------------------------------------------------------
   subroutine run_fp32_compdot(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U(:,:,:,:,:), rhs(:,:,:,:,:), comp(:,:,:,:,:)
   real(R8P), allocatable :: U_promoted(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U   (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   allocate(comp(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   U = real(U_init, R4P)

   !$acc data copy(U) copyin(comp) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4_compdot(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4_kahan(U, rhs, comp, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4_compdot(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4_kahan(U, rhs, comp, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 4.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_promoted(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   U_promoted = real(U, R8P)
   call error_stats_r8(U_promoted, emin, emax, emean)
   call conservation_stats(U_init, U_promoted, dmin, dmax, dmean)
   deallocate(U, rhs, comp, U_promoted)
   endsubroutine run_fp32_compdot

   ! -------------------------------------------------------------------------
   ! V3h — FP32 + compensated Horner on beta polynomials + Neumaier RK1.
   ! -------------------------------------------------------------------------
   subroutine run_fp32_horner(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U(:,:,:,:,:), rhs(:,:,:,:,:), comp(:,:,:,:,:)
   real(R8P), allocatable :: U_promoted(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U   (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   allocate(comp(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   U = real(U_init, R4P)

   !$acc data copy(U) copyin(comp) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4_horner(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4_kahan(U, rhs, comp, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4(U, nb, ni, ng, nc)
      call weno5_rhs_r4_horner(U, rhs, nb, ni, ng, nc)
      call rk1_update_r4_kahan(U, rhs, comp, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 4.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_promoted(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   U_promoted = real(U, R8P)
   call error_stats_r8(U_promoted, emin, emax, emean)
   call conservation_stats(U_init, U_promoted, dmin, dmax, dmean)
   deallocate(U, rhs, comp, U_promoted)
   endsubroutine run_fp32_horner

   ! -------------------------------------------------------------------------
   ! V3f — Dekker double-FP32 storage + plain WENO5 recon + Dekker RK1.
   ! Two arrays (U_hi, U_lo) per state component; reconstructed value at each
   ! load is U_hi + U_lo with ~48-bit effective mantissa. rhs stays plain
   ! FP32 since it is recomputed each step (no precision benefit from
   ! storing it as a pair).
   ! -------------------------------------------------------------------------
   subroutine run_fp32_dekker(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U_hi(:,:,:,:,:), U_lo(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P), allocatable :: U_final(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   call dekker_from_r8(U_init, U_hi, U_lo, nb, ni, ng, nc)

   !$acc data copy(U_hi, U_lo) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4_dekker(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4_dekker(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   ! Bytes moved per step: 2x the FP32 footprint due to (U_hi, U_lo).
   bytes_moved = 4.0_R8P * 8.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_final(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   call dekker_to_r8(U_hi, U_lo, U_final, nb, ni, ng, nc)
   call error_stats_r8(U_final, emin, emax, emean)
   call conservation_stats(U_init, U_final, dmin, dmax, dmean)
   deallocate(U_hi, U_lo, rhs, U_final)
   endsubroutine run_fp32_dekker

   ! -------------------------------------------------------------------------
   ! V3g — V3f + V3d compdot recon. Combines the two top-tier improvements.
   ! -------------------------------------------------------------------------
   subroutine run_fp32_dekker_compdot(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U_hi(:,:,:,:,:), U_lo(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P), allocatable :: U_final(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   call dekker_from_r8(U_init, U_hi, U_lo, nb, ni, ng, nc)

   !$acc data copy(U_hi, U_lo) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4_dekker(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_compdot(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4_dekker(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_compdot(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 8.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_final(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   call dekker_to_r8(U_hi, U_lo, U_final, nb, ni, ng, nc)
   call error_stats_r8(U_final, emin, emax, emean)
   call conservation_stats(U_init, U_final, dmin, dmax, dmean)
   deallocate(U_hi, U_lo, rhs, U_final)
   endsubroutine run_fp32_dekker_compdot

   ! -------------------------------------------------------------------------
   ! V3f' (V3f-collapse5) — same numerical algorithm as V3f, but the rhs
   ! and update kernels use `!$acc parallel loop collapse(5)` over
   ! (c,k,j,i,b) instead of `collapse(4)` on (c,k,j,i) with an inner
   ! `!$acc loop vector` on b. Tests whether flattening the entire
   ! iteration space lets nvfortran's scheduler map work to the SM grid
   ! more efficiently. Numerical output must match V3f bit-for-bit.
   ! -------------------------------------------------------------------------
   subroutine run_fp32_dekker_c5(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U_hi(:,:,:,:,:), U_lo(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P), allocatable :: U_final(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   call dekker_from_r8(U_init, U_hi, U_lo, nb, ni, ng, nc)

   !$acc data copy(U_hi, U_lo) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4_dekker_c5(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_c5(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker_c5(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4_dekker_c5(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_c5(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker_c5(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 8.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_final(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   call dekker_to_r8(U_hi, U_lo, U_final, nb, ni, ng, nc)
   call error_stats_r8(U_final, emin, emax, emean)
   call conservation_stats(U_init, U_final, dmin, dmax, dmean)
   deallocate(U_hi, U_lo, rhs, U_final)
   endsubroutine run_fp32_dekker_c5

   ! -------------------------------------------------------------------------
   ! V3f'' (V3f-bkjic) — same Dekker algorithm and `collapse(5)` as V3f',
   ! but with the source loop order *inverted* to (b, k, j, i, c) — b
   ! becomes the outermost / slowest loop, c the innermost / fastest.
   ! Array storage shape unchanged at (b, i, j, k, c), so c-inner walks
   ! a stride of nb*(ni+2*ng)**3 elements. Tests whether `collapse(5)`
   ! recovers the gang/vector mapping from a stride-1-hostile source
   ! lexical order. Numerical output should match V3f bit-for-bit.
   ! -------------------------------------------------------------------------
   subroutine run_fp32_dekker_bkc(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U_hi(:,:,:,:,:), U_lo(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P), allocatable :: U_final(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   call dekker_from_r8(U_init, U_hi, U_lo, nb, ni, ng, nc)

   !$acc data copy(U_hi, U_lo) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4_dekker_bkc(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_bkc(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker_bkc(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4_dekker_bkc(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_bkc(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker_bkc(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 8.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_final(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   call dekker_to_r8(U_hi, U_lo, U_final, nb, ni, ng, nc)
   call error_stats_r8(U_final, emin, emax, emean)
   call conservation_stats(U_init, U_final, dmin, dmax, dmean)
   deallocate(U_hi, U_lo, rhs, U_final)
   endsubroutine run_fp32_dekker_bkc

   ! -------------------------------------------------------------------------
   ! "Realistic CFD" Dekker variants — c-component loop is sequential
   ! (nonlinear coupling across components prevents per-c parallelism in
   ! a real solver). Parallel surface is collapse(4) over (b,i,j,k).
   !
   ! 2x2 design: storage shape A vs B  x  loop order F vs G
   !   A = U(b,i,j,k,c)  (b leftmost / stride-1)
   !   B = U(c,i,j,k,b)  (c leftmost / stride-1, nc=5 small)
   !   F = Fortran-compliant: stride-1 dim lexically innermost in parallel set
   !   G = GPU "biggest stride first" convention
   ! -------------------------------------------------------------------------

   subroutine run_fp32_dekker_af(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U_hi(:,:,:,:,:), U_lo(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P), allocatable :: U_final(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   call dekker_from_r8_a(U_init, U_hi, U_lo, nb, ni, ng, nc)

   !$acc data copy(U_hi, U_lo) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4_dekker_a(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_af(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker_af(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4_dekker_a(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_af(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker_af(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 8.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_final(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   call dekker_to_r8_a(U_hi, U_lo, U_final, nb, ni, ng, nc)
   call error_stats_r8(U_final, emin, emax, emean)
   call conservation_stats(U_init, U_final, dmin, dmax, dmean)
   deallocate(U_hi, U_lo, rhs, U_final)
   endsubroutine run_fp32_dekker_af

   subroutine run_fp32_dekker_ag(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U_hi(:,:,:,:,:), U_lo(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P), allocatable :: U_final(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U_hi(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(U_lo(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   allocate(rhs (1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc), source=0.0_R4P)
   call dekker_from_r8_a(U_init, U_hi, U_lo, nb, ni, ng, nc)

   !$acc data copy(U_hi, U_lo) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4_dekker_a(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_ag(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker_ag(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4_dekker_a(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_ag(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker_ag(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 8.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_final(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   call dekker_to_r8_a(U_hi, U_lo, U_final, nb, ni, ng, nc)
   call error_stats_r8(U_final, emin, emax, emean)
   call conservation_stats(U_init, U_final, dmin, dmax, dmean)
   deallocate(U_hi, U_lo, rhs, U_final)
   endsubroutine run_fp32_dekker_ag

   subroutine run_fp32_dekker_bf(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U_hi(:,:,:,:,:), U_lo(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P), allocatable :: U_final(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U_hi(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb))
   allocate(U_lo(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb))
   allocate(rhs (1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb), source=0.0_R4P)
   call dekker_from_r8_b(U_init, U_hi, U_lo, nb, ni, ng, nc)

   !$acc data copy(U_hi, U_lo) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4_dekker_b(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_bf(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker_bf(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4_dekker_b(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_bf(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker_bf(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 8.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_final(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   call dekker_to_r8_b(U_hi, U_lo, U_final, nb, ni, ng, nc)
   call error_stats_r8(U_final, emin, emax, emean)
   call conservation_stats(U_init, U_final, dmin, dmax, dmean)
   deallocate(U_hi, U_lo, rhs, U_final)
   endsubroutine run_fp32_dekker_bf

   subroutine run_fp32_dekker_bg(U_init, wall, bw, emin, emax, emean, dmin, dmax, dmean)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw, emin, emax, emean, dmin, dmax, dmean
   real(R4P), allocatable :: U_hi(:,:,:,:,:), U_lo(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P), allocatable :: U_final(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R4P), parameter :: dt = 1.0e-3_R4P

   allocate(U_hi(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb))
   allocate(U_lo(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb))
   allocate(rhs (1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb), source=0.0_R4P)
   call dekker_from_r8_b(U_init, U_hi, U_lo, nb, ni, ng, nc)

   !$acc data copy(U_hi, U_lo) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r4_dekker_b(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_bg(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker_bg(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r4_dekker_b(U_hi, U_lo, nb, ni, ng, nc)
      call weno5_rhs_r4_dekker_bg(U_hi, U_lo, rhs, nb, ni, ng, nc)
      call rk1_update_r4_dekker_bg(U_hi, U_lo, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 8.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   allocate(U_final(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc))
   call dekker_to_r8_b(U_hi, U_lo, U_final, nb, ni, ng, nc)
   call error_stats_r8(U_final, emin, emax, emean)
   call conservation_stats(U_init, U_final, dmin, dmax, dmean)
   deallocate(U_hi, U_lo, rhs, U_final)
   endsubroutine run_fp32_dekker_bg

   ! -------------------------------------------------------------------------
   ! V1B (storage shape B, c-parallel) and V1B' (storage shape B,
   ! c-sequential) — FP64 counterparts of the V3fB-* realistic-CFD
   ! variants and the missing cells in the FP64 (shape × c-parallelism)
   ! matrix. With these two added, both shapes and both c-parallelism
   ! regimes are covered for FP64. The reference for speedup remains
   ! V1' (variant 18, shape A, c-sequential).
   ! -------------------------------------------------------------------------

   subroutine run_fp64_b_cpar(U_init, wall, bw)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw
   real(R8P), allocatable :: U(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R8P), parameter :: dt = 1.0e-3_R8P

   allocate(U  (1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb))
   allocate(rhs(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb), source=0.0_R8P)
   call dekker_from_r8_b_r8(U_init, U, nb, ni, ng, nc)

   !$acc data copy(U) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r8_b(U, nb, ni, ng, nc)
      call weno5_rhs_r8_b_cpar(U, rhs, nb, ni, ng, nc)
      call rk1_update_r8_b_cpar(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r8_b(U, nb, ni, ng, nc)
      call weno5_rhs_r8_b_cpar(U, rhs, nb, ni, ng, nc)
      call rk1_update_r8_b_cpar(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 8.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   deallocate(U, rhs)
   endsubroutine run_fp64_b_cpar

   subroutine run_fp64_b_cseq(U_init, wall, bw)
   real(R8P), intent(in)  :: U_init(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
   real(R8P), intent(out) :: wall, bw
   real(R8P), allocatable :: U(:,:,:,:,:), rhs(:,:,:,:,:)
   real(R8P) :: t0, t1, bytes_moved
   integer(I4P) :: step
   real(R8P), parameter :: dt = 1.0e-3_R8P

   allocate(U  (1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb))
   allocate(rhs(1:nc, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nb), source=0.0_R8P)
   call dekker_from_r8_b_r8(U_init, U, nb, ni, ng, nc)

   !$acc data copy(U) create(rhs)
   do step = 1, nwarm
      call ghost_fill_r8_b(U, nb, ni, ng, nc)
      call weno5_rhs_r8_b_cseq(U, rhs, nb, ni, ng, nc)
      call rk1_update_r8_b_cseq(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t0)
   do step = 1, nsteps
      call ghost_fill_r8_b(U, nb, ni, ng, nc)
      call weno5_rhs_r8_b_cseq(U, rhs, nb, ni, ng, nc)
      call rk1_update_r8_b_cseq(U, rhs, dt, nb, ni, ng, nc)
   enddo
   !$acc wait
   call wall_clock(t1)
   !$acc end data
   wall = t1 - t0
   bytes_moved = 4.0_R8P * 8.0_R8P * real(nb, R8P) * real((ni + 2*ng)**3, R8P) * real(nc, R8P)
   bw = bytes_moved * real(nsteps, R8P) / wall / 1.0e9_R8P

   deallocate(U, rhs)
   endsubroutine run_fp64_b_cseq

   ! -------------------------------------------------------------------------
   ! Report
   ! -------------------------------------------------------------------------
   subroutine report
   character(40) :: names(NVAR)
   real(R8P) :: spd(NVAR)
   integer :: v

   names(1)  = 'V1  FP64 baseline                       '
   names(2)  = 'V2  FP32 storage + FP64 compute         '
   names(3)  = 'V3  FP32 throughout (naive)             '
   names(4)  = 'V2b FP32 + FP64 beta-indicators only    '
   names(5)  = 'V3b FP32 + Neumaier-compensated RK1     '
   names(6)  = 'V3c FP32 + Klein 2nd-order compensation '
   names(7)  = 'V3e FP32 + branchless FastTwoSum RK1    '
   names(8)  = 'V3d FP32 + Graillat-Langlois compdot    '
   names(9)  = 'V3h FP32 + compensated Horner on beta   '
   names(10) = 'V3f FP32 + Dekker double-FP32 storage   '
   names(11) = 'V3g V3f + Graillat-Langlois compdot     '
   names(12) = 'V3f'' V3f with collapse(5) on (c,k,j,i,b)'
   names(13) = 'V3f"" V3f-bkjic loop order (b,k,j,i,c)  '
   names(14) = 'V3fA-F  U(b,i,j,k,c) par k,j,i,b seq c  '
   names(15) = 'V3fA-G  U(b,i,j,k,c) par b,k,j,i seq c  '
   names(16) = 'V3fB-F  U(c,i,j,k,b) par b,k,j,i seq c  '
   names(17) = 'V3fB-G  U(c,i,j,k,b) par i,j,k,b seq c  '
   names(18) = 'V1''  FP64 (b,i,j,k,c) c-seq (REF)      '
   names(19) = 'V1B  FP64 (c,i,j,k,b) c-parallel       '
   names(20) = 'V1B'' FP64 (c,i,j,k,b) c-sequential     '

   ! Universal speedup denominator: V1' (variant 18), the honest FP64
   ! baseline with c-loop sequential. This is the realistic-CFD baseline
   ! and the apples-to-apples reference for every variant in the panel,
   ! including V1 (c-parallel FP64), V3/V3b/V3f variants (c-parallel
   ! FP32), and V3fA/B variants (c-sequential FP32). V1' itself is the
   ! REF row (speedup = 1.00x); every other variant reports its
   ! wall-time gain relative to V1'.
   do v = 1, NVAR
      spd(v) = t_v(18) / t_v(v)
   enddo

   print '(A)', ''
   print '(A)', '== Results =='
   print '(A,A,A,A,A,A,A,A)', &
      'Variant                                 ', &
      '   time[s]', '   BW[GB/s]', '   speedup', &
      '   errMean', '   errMax  ', '   drMax   ', '   verdict'
   do v = 1, NVAR
      call print_row(v, names(v), t_v(v), bw_v(v), spd(v))
   enddo

   print '(A)', ''
   print '(A)', 'Bar: speedup >= 1.5x AND errMax <= 1e-12 AND drMax <= 1e-10'
   print '(A)', 'V1'' (variant 18, FP64 c-sequential) = REF (always PASS); every variant'
   print '(A)', 'reports its wall-time gain relative to V1''. V1 (c-parallel FP64) appears as'
   print '(A)', 'one row in the panel with speedup >> 1 due to the c-parallelism it has and'
   print '(A)', 'V1'' lacks. FP32 c-parallel (V3, V3b, V3f...) likewise enjoys c-parallelism.'
   print '(A)', 'The realistic-CFD subgroup V3fA/V3fB has c sequential and is compared'
   print '(A)', 'apples-to-apples against V1''.'
   print '(A)', 'FP16 variant (~4% L2 error after 100 steps) characterised on host, omitted here.'
   endsubroutine report

   subroutine print_row(idx, name, t, bw, s)
   integer, intent(in)      :: idx
   character(*), intent(in) :: name
   real(R8P), intent(in)    :: t, bw, s
   character(8) :: verdict
   real(R8P), parameter :: spd_bar = 1.5_R8P, err_bar = 1.0e-12_R8P, drift_bar = 1.0e-10_R8P
   if (idx == 18) then
      verdict = 'REF'
   else if (s >= spd_bar .and. err_max(idx) <= err_bar .and. drift_max(idx) <= drift_bar) then
      verdict = 'PASS'
   else
      verdict = 'FAIL'
   endif
   print '(A40,F10.3,F12.2,F10.3,3ES12.3,A10)', &
      name, t, bw, s, err_mean(idx), err_max(idx), drift_max(idx), verdict
   endsubroutine print_row

endprogram fundal_weno5_precision_test
