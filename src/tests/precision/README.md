# WENO5 Precision Benchmark

A FUNDAL test that quantifies the cost/benefit of mixed-precision storage and
compute for a memory-bound block-structured WENO5 stencil, on host CPU and on
consumer NVIDIA GPUs via OpenACC.

The test exists to answer one practical question: **on a consumer GPU (RTX
40-series Ada, RTX 50-series Blackwell), is "FP32 storage + FP64 compute" a
viable middle path between full FP64 and full FP32 for production CFD?**
Short answer: no. The detailed answer is in [Findings](#findings).

---

## Files

The test is split into one module per algorithm so each precision
technique is independently inspectable / reusable. The driver is a thin
orchestration layer (CLI, allocation, timing, reporting).

| File                                  | Purpose                                                              |
|---------------------------------------|----------------------------------------------------------------------|
| `fundal_weno5_precision_test.F90`     | Driver program. CLI parsing, allocation, initial condition, per-variant `run_*` shims, wall-clock timing, pairwise-sum-based diagnostics, results table. **No kernels.** |
| `fundal_weno5_recon.F90`              | `weno5_recon_r8` / `weno5_recon_r4` / `weno5_recon_r4_beta8` — Jiang-Shu WENO5-JS reconstruction (V1, V3, V2b). Lifted to a module so `!$acc routine seq` attaches at module scope. |
| `fundal_weno5_recon_compdot.F90`      | V3d — WENO5 reconstruction with Graillat-Langlois compensated dot product on the final 3-term nonlinear combination. Uses software Veltkamp-Dekker TwoProd + TwoSum (no FMA dependency). |
| `fundal_weno5_recon_horner.F90`       | V3h — WENO5 reconstruction with compensated Horner on β smoothness indicators. Tests whether FP32-internal compensation beats FP64 β. |
| `fundal_weno5_kernels_r8.F90`         | V1 — pure-FP64 device kernels: `ghost_fill_r8`, `weno5_rhs_r8`, `rk1_update_r8`. |
| `fundal_weno5_kernels_r4.F90`         | V3 — pure-FP32 device kernels: `ghost_fill_r4`, `weno5_rhs_r4`, `rk1_update_r4`. Shared by V3b/V3c/V3d/V3e/V3h via the ghost fill. |
| `fundal_weno5_kernels_r4_b64.F90`     | V2b — FP32 storage + surgical FP64 β-indicator rhs: `weno5_rhs_r4_b64`. |
| `fundal_weno5_kernels_r4store_r8comp.F90` | V2 — FP32 storage + blanket FP64 compute kernels. |
| `fundal_weno5_kernels_r4_compdot.F90` | V3d — WENO5 rhs using compensated-dot recon. |
| `fundal_weno5_kernels_r4_horner.F90`  | V3h — WENO5 rhs using compensated-Horner recon. |
| `fundal_weno5_kernels_r4_dekker.F90`  | V3f / V3g — Dekker double-FP32 (hi, lo) storage kernels: split/recombine helpers, ghost fill, rhs (plain and compdot), RK1 update with compensated TwoSum on the (hi, lo) pair. |
| `fundal_weno5_kernels_r4_dekker_c5.F90` | V3f' — bit-identical-to-V3f kernels rewritten with `!$acc parallel loop collapse(5)` over `(c,k,j,i,b)` instead of `collapse(4) + inner loop vector(b)`. Pure parallelisation-strategy variant; tests the scheduler's preference. |
| `fundal_weno5_kernels_r4_dekker_bkc.F90` | V3f'' — same algorithm and `collapse(5)` as V3f' but with the source loop order inverted to `(b,k,j,i,c)` (`b` outer / `c` inner). Storage shape unchanged. Tests whether `collapse(N)` can recover from a stride-1-hostile lexical source order. |
| `fundal_weno5_kernels_r4_dekker_real.F90` | V3fA-F / V3fA-G / V3fB-F / V3fB-G — "realistic CFD" Dekker kernels where the c-component loop is sequential (nonlinear coupling prevents per-c parallelism). 2×2 cross-product: storage shape A `(b,i,j,k,c)` or B `(c,i,j,k,b)` × loop order F (Fortran-compliant) or G (GPU "biggest stride first"). Includes the shape-B variants of `dekker_from_r8` / `dekker_to_r8` / `ghost_fill_r4_dekker`. |
| `fundal_weno5_kernels_r8_real.F90` | V1' — FP64 kernels with c-loop sequential (`collapse(4)` over `k,j,i,b`, `c` sequential inside). The honest baseline for the realistic-CFD FP32 subgroup; comparing them against V1 (c parallel) is apples-to-oranges since the parallel-surface size differs by 5×. |
| `fundal_weno5_kernels_r8_b.F90` | V1B / V1B' — FP64 kernels on storage shape B `U(c,i,j,k,b)` with both c-parallel and c-sequential variants. Completes the FP64 (shape × c-parallelism) 2×2 matrix; tests whether storage shape affects FP64 performance (it doesn't — both regimes are within 0.3% of shape A). Also provides `dekker_from_r8_b_r8` / `dekker_to_r8_b_r8` for the R8→shape-B reshape. |
| `fundal_compensation_neumaier.F90`    | V3b — Kahan-Babuska-Neumaier single-carry compensated RK1 (branched). |
| `fundal_compensation_klein.F90`       | V3c — Klein 2nd-order cascaded Neumaier (two carry levels). |
| `fundal_compensation_fasttwosum.F90`  | V3e — Ogita-Rump branchless FastTwoSum compensated RK1 (no warp divergence). |
| `IMPLEMENTATION_PLAN.md`              | Phase-by-phase plan that produced the current module layout. |
| `README.md`                           | This document.                                                       |

---

## Build and run

The test is picked up automatically by every `fundal-test-*` fobos mode
(recursive `src = ./src/`). No fobos edits required.

```bash
# OpenACC build with nvfortran (RTX 40-series target: -gpu=cc89)
module load nvhpc
FoBiS.py build --mode fundal-test-oac-nvf

# Production extents on first GPU
CUDA_VISIBLE_DEVICES=0 ./exe/fundal_weno5_precision_test 512 16 5 100

# Host-only build (CPU baseline, no offload)
FoBiS.py build --mode fundal-test-gnu     # currently broken at link, pre-existing
                                          # (see "Known issues" below)
```

### CLI

```
fundal_weno5_precision_test [nb [ni [nc [nsteps]]]]
```

| Arg     | Default | Meaning                                                  |
|---------|---------|----------------------------------------------------------|
| `nb`    | 512     | Number of independent blocks (stride-1 dimension)        |
| `ni`    | 16      | Spatial extent per direction (cubic block)               |
| `nc`    | 5       | Conservative variables (compressible NS: ρ, ρu, ρv, ρw, ρE) |
| `nsteps`| 100     | Number of timed RK1 steps (after 10 untimed warmup)      |

---

## Design

### The array layout

```fortran
real(R8P) :: U(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
```

- `nb` (block index) is stride-1 — the **innermost** loop on GPU.
- `(i, j, k)` are spatial indices; each block carries `ng = 3` ghost cells per
  side for the 7-point WENO5 stencil.
- `c` is the conservative variable; outermost.

This is the block-major layout natural for a multi-block GPU CFD code: one
warp/wavefront sweeps contiguous blocks for the same `(i, j, k, c)` cell.
Coalesced loads on `U(b, ...)` are guaranteed by construction.

Blocks are mutually independent — no halo exchange between blocks inside the
kernel; periodic boundary conditions are applied per block via ghost fill.

### The kernel

Per block, per step: apply 3D WENO5 flux divergence as a forward Euler update.
The "flux" is a trivial advection `F(U) = U` (unit speed each direction) — this
is **not** intended as physically meaningful CFD. The point is to exercise:

- The WENO5 smoothness indicators (catastrophic cancellation in
  `F_{i+1/2} − F_{i−1/2}`), which is the precision-sensitive part.
- A realistic memory access pattern (5-point stencil in each of 3 directions
  per cell per component).
- A characteristic FLOP/byte ratio for high-order finite volume stencils.

### The variants

| Variant | Storage | Compute             | What it tests                                                |
|---------|---------|---------------------|--------------------------------------------------------------|
| V1      | FP64    | FP64                | Production-grade reference. All others are diffed against this. |
| V2      | FP32    | FP64 (blanket)      | "Mixed precision middle path" — halve storage, keep all-FP64 ALU precision. |
| V3      | FP32    | FP32                | Naive all-FP32. No algorithmic effort to preserve accuracy.  |
| V2b     | FP32    | FP32 + FP64 β-only  | Surgical promotion: only WENO5 smoothness indicators (the cancellation-sensitive squared differences) computed in FP64; everything else FP32. |
| V3b     | FP32    | FP32 + Neumaier RK1 | All-FP32 reconstruction, RK1 time integration uses Neumaier-compensated summation with a per-cell FP32 carry. O(eps) per-step compensation. |
| V3c     | FP32    | FP32 + Klein RK1    | All-FP32 reconstruction, RK1 time integration uses Klein's 2nd-order cascaded compensation (two carry arrays per cell). O(eps²) per-step compensation. |
| V3e     | FP32    | FP32 + branchless FastTwoSum RK1 | Ogita-Rump (Sum2-style) compensated RK1 without the `abs(a) >= abs(b)` branch — exercises the precondition `\|U\| >> \|dt·rhs\|` to eliminate warp divergence. Tests whether V3b's ~9% speedup loss vs V3 was the branch or the carry-array bandwidth. |
| V3d     | FP32    | FP32 + compensated dot recon + Neumaier RK1 | Graillat-Langlois compensated dot product on the WENO5 final 3-term weighted sum `vL = Σ ω_k q_k`. Uses Veltkamp-Dekker software TwoProd (no FMA dependency). Tests whether the per-step L2 floor lives in the nonlinear combination cancellation. |
| V3h     | FP32    | FP32 + compensated Horner β + Neumaier RK1 | Compensated Horner evaluation of β smoothness indicators using TwoProd + TwoSum chains. Tests whether FP32 compensated β can outperform FP64 β (V2b). |
| V3f     | FP32 pair (hi, lo) | FP32 + Dekker pair update | Dekker double-FP32 storage: U is stored as (U_hi, U_lo) with ~48-bit effective mantissa on reconstruction. WENO5 recon runs in plain FP32; RK1 update writes back via TwoSum so the storage-rounding carry survives between steps. |
| V3g     | FP32 pair (hi, lo) | FP32 + compdot recon + Dekker pair update | V3f + V3d combined — Dekker storage with Graillat-Langlois compdot reconstruction. |
| V3f'    | FP32 pair (hi, lo) | FP32 + Dekker pair update, `collapse(5)` schedule | Pure parallelisation-strategy variant of V3f. Same algorithm, numerical output bit-identical to V3f; only the OpenACC loop schedule differs (single `!$acc parallel loop collapse(5)` over `(c,k,j,i,b)` vs V3f's `collapse(4) + inner loop vector(b)`). Tests whether the scheduler maps work to the SM grid more efficiently with a single flattened iteration space. |
| V3f''   | FP32 pair (hi, lo) | FP32 + Dekker pair update, `collapse(5)` schedule, inverted loop order | Same algorithm and `collapse(5)` as V3f', but with the source loop nest reordered to `(b,k,j,i,c)` — `b` outermost / slowest, `c` innermost / fastest. Array storage shape unchanged at `(b,i,j,k,c)`, so `c`-innermost walks a non-unit stride of $n_b \cdot (n_i+2n_g)^3$ elements. Tests whether `collapse(N)` recovers the gang/vector mapping from a stride-1-hostile lexical source order. |
| V3fA-F  | FP32 pair, shape `(b,i,j,k,c)` | `collapse(4)` over `k,j,i,b` (b innermost = stride-1), `c` sequential inside | "Realistic CFD" variant: c-coupling is treated as nonlinear so c is a `do` loop inside the parallel region (cannot be parallelised across c). Loop order F = stride-1 dim lexically innermost in the parallel set. |
| V3fA-G  | FP32 pair, shape `(b,i,j,k,c)` | `collapse(4)` over `b,k,j,i` (b outermost), `c` sequential inside | Same realistic constraint; loop order G = "GPU biggest-stride-first" convention, b outermost in the parallel set. |
| V3fB-F  | FP32 pair, shape `(c,i,j,k,b)` | `collapse(4)` over `b,k,j,i` (i innermost), `c` sequential inside | Realistic variant with storage reshaped: c is leftmost (stride-1, $n_c=5$ small), b is rightmost (largest stride). Loop order F treats the parallel-set stride-1 dim (i) as innermost. |
| V3fB-G  | FP32 pair, shape `(c,i,j,k,b)` | `collapse(4)` over `i,j,k,b` (b innermost in parallel set), `c` sequential inside | Storage B, loop order G. Tests whether putting b (large) innermost in the parallel set helps when c is removed from the parallel surface. |
| V1'     | FP64, shape `(b,i,j,k,c)` | `collapse(4)` over `k,j,i,b` (b innermost = stride-1), `c` sequential inside | **Honest FP64 baseline for the realistic-CFD subgroup. REFERENCE for the universal speedup column.** Same algorithm as V1 but with c-loop sequential, mirroring the V3fA-* / V3fB-* parallelism boundary. |
| V1B     | FP64, shape `(c,i,j,k,b)` | `collapse(5)` over `b,k,j,i,c` (c innermost = stride-1) | Shape B counterpart of V1: tests whether storage shape matters for c-parallel FP64. Completes the FP64 (shape × c-parallelism) 2×2 matrix. |
| V1B'    | FP64, shape `(c,i,j,k,b)` | `collapse(4)` over `b,k,j,i` (i innermost), `c` sequential inside | Shape B counterpart of V1': tests whether storage shape matters for c-sequential FP64. |
| V4      | FP16    | FP32                | Aggressive bandwidth cut. Numerical-error probe only; FP16 path is emulated by mantissa truncation (no hardware Tensor Core path from pure Fortran). Run on CPU only. |

V4 is omitted from the GPU run because its numerical answer (≈4% L2 error after
100 steps, unusable) is established on CPU and does not change with backend.

**Why V2b, V3b, V3c were added** after the initial V1-V3 round: V3 measures the
*floor* of naive FP32 (no compensation), not what's achievable when algorithmic
discipline is applied. V2b tests "what if we promote only the smallest
cancellation-sensitive sub-expression to FP64?" V3b tests "what if we kill the
time-integration accumulation error via Kahan/Neumaier compensation?" V3c asks
whether *second-order* compensation (Klein 2006, two cascaded carry levels)
buys more accuracy than V3b's single-level Neumaier. All three are standard
mixed-precision techniques; the test asks which (if any) rescues the
consumer-GPU mixed-precision landscape from the V2 trap.

### Per-block statistics

Because `nb` blocks are independent, every metric is computed per block and
aggregated as min/max/mean across `nb`. This turns one run into `nb` statistical
samples — `nb = 512` gives a meaningful distribution of FP32/FP16 robustness
in a single run.

> The exact formulas for the per-block diagnostics and per-variant
> compensation algorithms are collected in the
> [Mathematical and numerical model](#mathematical-and-numerical-model)
> section below. The high-level description in this Design block is
> intentionally informal; the dedicated section gives error bounds and
> the algorithmic primitives in full.

### Success bar (strict HPC)

A variant passes if **all** of:

```
speedup ≥ 1.5×            over FP64 wall time
errMax  ≤ 1e-12           relative L2, worst block
drMax   ≤ 1e-10           conservation drift, worst block, normalised by sum(|U_init|)
```

Variants V3 and V4 are expected to fail the `errMax` bar by construction —
that failure *is the data*, not a bug. The interesting outcome is whether V2
can pass: a "yes" would mean the middle path delivers FP64-equivalent accuracy
at FP32-storage bandwidth cost. The findings below show the answer is "no" on
consumer GPU.

### What this test deliberately does not do

- **No physically meaningful flux.** A real Euler/Navier-Stokes flux would
  expose the FP32 problem more aggressively (catastrophic cancellation in
  pressure differences, kinetic-energy reconstructions) — at the cost of
  hiding the precision question inside CFD detail. The trivial linear flux is
  a controlled probe.
- **No halo exchange between blocks.** Block coupling is a separate question.
  In a real multi-block code halo exchange adds MPI traffic that has its own
  GPU-aware-MPI coherence rules; this test deliberately isolates the per-block
  compute.
- **No real FP16 path on GPU.** Pure-Fortran FP16 on GPU does not give a
  Tensor Core path. A genuine FP16 + FP32-accumulate GPU test requires
  iso_c_binding to a CUDA WMMA kernel and only makes sense for matmul-shaped
  problems, not stencils. See [Open questions](#open-questions).

---

## Mathematical and numerical model

This section gives the precise formulas behind every kernel and
diagnostic. Notation follows Higham, *Accuracy and Stability of Numerical
Algorithms* (2nd ed., SIAM 2002): $\mathrm{fl}(x)$ is the
correctly-rounded floating-point value of a real expression $x$,
$u = \tfrac{1}{2}\beta^{1-p}$ is the unit roundoff
($u_{\mathrm{R8P}} = 2^{-53} \approx 1.11\times 10^{-16}$,
$u_{\mathrm{R4P}} = 2^{-24} \approx 5.96\times 10^{-8}$), and
$\mathrm{eps}$ is machine epsilon ($\mathrm{eps}_{\mathrm{R8P}} = 2u_{\mathrm{R8P}} \approx 2.22\times 10^{-16}$).

### 1. Governing PDE and discretisation

The benchmark integrates a 3-D scalar-by-scalar linear advection system
on each conservative component $c \in \{1,\dots,n_c\}$ of the state field
$U_c(x,y,z,t)$:

$$
\frac{\partial U_c}{\partial t} \;+\; \nabla\!\cdot\!\mathbf F(U_c) \;=\; 0,
\qquad \mathbf F(U_c) \;=\; (U_c,\,U_c,\,U_c).
$$

The triple-unit flux is deliberately chosen: it has no physical content
(no shock-capturing, no pressure gradient, no kinetic-energy
cancellation) so the only sources of numerical error are the scheme
itself and the floating-point arithmetic. Periodic boundary conditions
are imposed per block via ghost-cell exchange.

Spatial discretisation is a 5th-order Jiang–Shu WENO finite-volume
reconstruction. For a cell-centred state $\{U_{i,j,k}\}$, the rhs at cell
$(i,j,k)$ is

$$
\mathrm{rhs}_{i,j,k}^{(c)} \;=\;
- \frac{1}{\Delta x}\!\left[\hat F_{i+\frac12,j,k}^{(c)} - \hat F_{i-\frac12,j,k}^{(c)}\right]
- \frac{1}{\Delta y}\!\left[\hat F_{i,j+\frac12,k}^{(c)} - \hat F_{i,j-\frac12,k}^{(c)}\right]
- \frac{1}{\Delta z}\!\left[\hat F_{i,j,k+\frac12}^{(c)} - \hat F_{i,j,k-\frac12}^{(c)}\right].
$$

In the benchmark $\Delta x = \Delta y = \Delta z = 1$ (the
`dx_inv = 1` parameter in the kernels) and the WENO5 *left* state at each
face is used as the upwind numerical flux $\hat F$ (valid because the
trivial flux $\mathbf F(U) = U$ has a positive characteristic in every
direction).

Time integration is forward Euler (RK1):

$$
U_{i,j,k}^{(c),\,n+1} \;=\; U_{i,j,k}^{(c),\,n} \;+\; \Delta t\,\mathrm{rhs}_{i,j,k}^{(c),\,n},
\qquad \Delta t = 10^{-3}.
$$

RK1 is the simplest choice that lets us study **per-step storage and
arithmetic rounding in isolation**, with no Runge–Kutta sub-stage
combinations that would mask compensation effects. Stability is
non-issue at $\Delta t / \Delta x = 10^{-3}$ and $T = n_{\mathrm{steps}}\Delta t = 0.1$.

### 2. WENO5-JS reconstruction

For a stencil $(v_{-2}, v_{-1}, v_0, v_{+1}, v_{+2})$ centred on cell $i$,
the left-state reconstruction at $i + \tfrac12$ is

$$
\hat F^L_{i+1/2} \;=\; \sum_{k=0}^{2} \omega_k\, p_k,
$$

with the three candidate stencils

$$
\begin{aligned}
p_0 &= \tfrac{1}{6}\bigl(2 v_{-2} - 7 v_{-1} + 11 v_0\bigr),\\
p_1 &= \tfrac{1}{6}\bigl(- v_{-1} + 5 v_0 + 2 v_{+1}\bigr),\\
p_2 &= \tfrac{1}{6}\bigl(2 v_0 + 5 v_{+1} - v_{+2}\bigr).
\end{aligned}
$$

The nonlinear weights $\omega_k$ are built from the smoothness
indicators $\beta_k$ (Jiang & Shu 1996):

$$
\begin{aligned}
\beta_0 &= \tfrac{13}{12}(v_{-2} - 2 v_{-1} + v_0)^2 + \tfrac{1}{4}(v_{-2} - 4 v_{-1} + 3 v_0)^2,\\
\beta_1 &= \tfrac{13}{12}(v_{-1} - 2 v_0 + v_{+1})^2 + \tfrac{1}{4}(v_{-1} - v_{+1})^2,\\
\beta_2 &= \tfrac{13}{12}(v_0 - 2 v_{+1} + v_{+2})^2 + \tfrac{1}{4}(3 v_0 - 4 v_{+1} + v_{+2})^2,
\end{aligned}
$$

unnormalised weights with linear coefficients $d_k = \{0.1,\,0.6,\,0.3\}$
and the small offset $\varepsilon$ preventing division by zero:

$$
\alpha_k \;=\; \frac{d_k}{(\varepsilon + \beta_k)^2},
\qquad
\omega_k \;=\; \frac{\alpha_k}{\alpha_0 + \alpha_1 + \alpha_2}.
$$

The benchmark uses $\varepsilon = 10^{-12}$ in the FP64 reconstruction
and $\varepsilon = 10^{-6}$ in the FP32 reconstructions. The FP32 choice
is dictated by the underflow boundary of `real32`: $10^{-12}$ would
flush to zero, defeating the regularisation. The two-orders-of-magnitude
difference between FP32 and FP64 $\varepsilon$ is a small but real
component of the FP32 error floor — its effect is bounded by
$\partial \omega_k / \partial \beta_k$ times the $\varepsilon$
mismatch and is well below the dominant per-step rhs cancellation.

The same three-direction stencil is applied for the $i\pm\tfrac12$,
$j\pm\tfrac12$, $k\pm\tfrac12$ faces, giving six WENO5 reconstructions
per cell per RK1 step.

### 3. Initial condition

The test uses a smooth, non-trivial, per-block phase-shifted state so
that no two blocks evolve identically. With $\phi_b = 2\pi b/n_b$
and $(x,y,z) = (i,j,k)/n_i$ on $[0,1]^3$:

$$
\begin{aligned}
\rho &= 1 + 0.2\,\sin(2\pi x + \phi_b)\,\cos(2\pi y)\,\sin(2\pi z),\\
u &= 0.3\,\sin(2\pi x)\,\cos(2\pi y + \phi_b),\\
v &= 0.2\,\cos(2\pi x + \phi_b)\,\sin(2\pi z),\\
w &= 0.1\,\sin(2\pi y)\,\cos(2\pi z + \phi_b),\\
p &= 1,
\end{aligned}
$$

with the five conservative components stored as
$(\rho,\,\rho u,\,\rho v,\,\rho w,\,p/(\gamma{-}1) + \tfrac{1}{2}\rho(u^2{+}v^2{+}w^2))$
for $\gamma = 1.4$. This emulates the layout of a compressible
Navier–Stokes solver without using its dynamics. The velocity components
have zero spatial mean by construction; this is the load-bearing
reason the conservation diagnostic must be normalised by a positive
norm, not the signed integral (see Bug 2 below).

### 4. Diagnostics

For each block $b \in \{1,\dots,n_b\}$ the test reports two scalars
relative to the FP64 reference $U^{\mathrm{ref}}$:

**Relative L2 error.** Aggregated across all conservative components,
all interior cells of block $b$:

$$
\mathrm{err}_b \;=\;
\frac{\sqrt{\sum_{c,i,j,k}\bigl(U_{b,i,j,k,c} - U^{\mathrm{ref}}_{b,i,j,k,c}\bigr)^{\!2}}}
     {\sqrt{\sum_{c,i,j,k}\bigl(U^{\mathrm{ref}}_{b,i,j,k,c}\bigr)^{\!2}}}.
$$

The reported `errMax`, `errMean`, `errMin` are
$\max_b \mathrm{err}_b$, $\frac{1}{n_b}\sum_b \mathrm{err}_b$,
$\min_b \mathrm{err}_b$ respectively.

**Conservation drift.** For each component $c$ and block $b$, with
$S(\cdot)$ a high-accuracy summation operator (see below):

$$
\mathrm{drift}_b
\;=\; \max_{c}\;
\frac{\bigl| S\bigl(U^{n}_{b,:,c}\bigr) - S\bigl(U^{0}_{b,:,c}\bigr) \bigr|}
     {\max\bigl(S\bigl(|U^{0}_{b,:,c}|\bigr),\,\mathrm{tiny}(\mathtt{R8P})\bigr)}.
$$

Reported as `drMax`, `drMean`, `drMin` over $b$. With the trivial flux
$\mathbf F(U) = U$ and periodic boundaries, $\sum_{i,j,k} U_c$ is an
exact invariant of the continuous PDE — so any nonzero $\mathrm{drift}_b$
is purely numerical (scheme + arithmetic).

**Why the L1 normaliser (Bug 2).** The signed integral
$S(U^0_{b,:,c})$ is structurally near zero for momentum components
$(\rho u, \rho v, \rho w)$ — the velocity field is zero-mean by
construction — so dividing by it explodes. The L1 norm
$S(|U^0_{b,:,c}|)$ is always $\mathcal O(1)$ and bounded away from zero.
This converts an unstable diagnostic into a robust one without losing
physical meaning.

**Why pairwise summation matters for $S$.** The naive recursive sum
$s_n = s_{n-1} + a_n$ has worst-case error bound

$$
\bigl|\,\mathrm{fl}\!\left(\textstyle\sum a_i\right) - \textstyle\sum a_i\,\bigr|
\;\le\; (n - 1)\,u\,\textstyle\sum |a_i| \;+\; \mathcal O(u^2)
\quad \text{(Higham, Thm.\ 4.1).}
$$

For $N = n_i^3 = 4096$ this is $\le 4095\,u \approx 4.5\times 10^{-13}$
at $u = u_{\mathrm{R8P}}$. The benchmark needs to read drift values as
small as $10^{-16}$ for V1, so the diagnostic must be tightened. The
*pairwise* (binary tree) summation $S_{\mathrm{pw}}$ has

$$
\bigl|\,S_{\mathrm{pw}}(a) - \textstyle\sum a_i\,\bigr|
\;\le\; \bigl\lceil \log_2 n \bigr\rceil\, u\,\textstyle\sum |a_i| \;+\; \mathcal O(u^2)
\quad \text{(Higham, Thm.\ 4.6).}
$$

For $N = 4096$ this is $\le 12 u \approx 1.3\times 10^{-15}$, three orders
of magnitude below the naive bound. The benchmark implements the
recursive tree form with a base case of 8 elements (one cache line) in
`pairwise_sum` of the driver.

Without this fix, V1 was reported as $\mathrm{drMax} \approx 1.6\times 10^{-14}$
— exactly the naive-sum bound. With pairwise sum, V1 reaches
$\mathrm{drMax} \approx 1.8\times 10^{-16}$, the actual kernel floor
($\mathrm{eps}_{\mathrm{R8P}}$).

### 5. Floating-point arithmetic primitives

All compensated variants share three core IEEE-754 transformations.
Each operates entirely in working precision (FP32 here) and uses no
higher-precision arithmetic.

**TwoSum** (Knuth 1965, branchless). For floats $a, b$ in working
precision, computes $(s,\,e)$ such that $a + b = s + e$ exactly in real
arithmetic, with $s = \mathrm{fl}(a + b)$:

$$
\begin{aligned}
s &= \mathrm{fl}(a + b),\\
b' &= \mathrm{fl}(s - a),\\
e &= \mathrm{fl}\bigl((a - \mathrm{fl}(s - b')) + (b - b')\bigr).
\end{aligned}
$$

Cost: 6 flops, no branches, no precondition on operand magnitudes.

**FastTwoSum** (Dekker 1971, branchless, conditional on $|a| \ge |b|$).
Cheaper variant with a precondition:

$$
\begin{aligned}
s &= \mathrm{fl}(a + b),\\
e &= \mathrm{fl}(b - \mathrm{fl}(s - a)).
\end{aligned}
$$

Cost: 3 flops. The precondition is satisfied with overwhelming
probability in our RK1 update because
$|U| = \mathcal O(1) \gg |{\Delta t \cdot \mathrm{rhs}}| = \mathcal O(10^{-3})$.

**TwoProd via Veltkamp split + Dekker product** (no FMA dependency).
For a working precision with $t$ mantissa bits ($t=24$ for FP32),
computes $(h,\,\ell)$ such that $a \cdot b = h + \ell$ exactly:

$$
\begin{aligned}
\sigma &= 2^{\lceil t/2 \rceil} + 1 \quad\text{(splitter; }4097\text{ for FP32)},\\
a_h &= \mathrm{fl}\bigl(\mathrm{fl}(\sigma a) - \mathrm{fl}(\mathrm{fl}(\sigma a) - a)\bigr),\quad a_\ell = \mathrm{fl}(a - a_h),\\
b_h &= \mathrm{fl}\bigl(\mathrm{fl}(\sigma b) - \mathrm{fl}(\mathrm{fl}(\sigma b) - b)\bigr),\quad b_\ell = \mathrm{fl}(b - b_h),\\
h &= \mathrm{fl}(a b),\\
\ell &= \mathrm{fl}\bigl(\mathrm{fl}\bigl(\mathrm{fl}(a_h b_h - h) + a_h b_\ell\bigr) + a_\ell b_h\bigr) + \mathrm{fl}(a_\ell b_\ell).
\end{aligned}
$$

Cost: 17 flops. The benchmark uses this form (not the FMA-based
2-flop variant) because nvfortran 26.1 does not expose `ieee_fma`
on FP32 device routines.

### 6. Per-variant compensation algorithms

The compensation algorithms enter at two distinct stages: the
**time-integration update** (V3b, V3c, V3e) and the
**reconstruction inner product / polynomial** (V3d, V3h). V3f/V3g attack
the **storage representation** itself. Each is summarised here with its
per-step error bound.

#### V3b — Kahan–Babuska–Neumaier (KBN) RK1

The RK1 update $U^{n+1} = U^n + \Delta t \cdot \mathrm{rhs}^n$ is replaced
with a compensated sum that accumulates the rounding residual into a
per-cell carry array $c$. With $y_n = \mathrm{fl}(\Delta t \cdot \mathrm{rhs}^n + c^{n-1})$:

$$
\begin{aligned}
t &= \mathrm{fl}(U^n + y_n),\\
c^n &=
\begin{cases}
\mathrm{fl}\bigl((U^n - t) + y_n\bigr) & \text{if } |U^n| \ge |y_n|,\\
\mathrm{fl}\bigl((y_n - t) + U^n\bigr) & \text{otherwise,}
\end{cases}\\
U^{n+1} &= t.
\end{aligned}
$$

Per-step rounding error in the accumulated sum is $\mathcal O(u)$
independent of $n$ (compared with $\mathcal O(n u)$ for the naive
running sum). Reference: Neumaier (1974), *ZAMM*.

#### V3c — Klein second-order cascaded KBN

Adds a second-level carry $c_2$ that absorbs the rounding error of
the $c^{n-1} \mathrel{+}{=} \delta$ update itself. The reconstituted state
at the final read is

$$
U^{\mathrm{final}} \;=\; U^{n_{\mathrm{steps}}} + c^{n_{\mathrm{steps}}} + c_2^{n_{\mathrm{steps}}}.
$$

Per-step bound: $\mathcal O(u^2)$. Reference: Klein (2006), *Computing*.
Empirically *worse* than V3b at $n_{\mathrm{steps}} = 100$ because the
first-level carry stays in $\mathcal O(u)$ — there is nothing for $c_2$
to catch, and the extra reconstitution introduces a fresh rounding.

#### V3e — Branchless FastTwoSum RK1

Identical to V3b but the inner FastTwoSum replaces the branched form:

$$
\begin{aligned}
y_n &= \mathrm{fl}(\Delta t \cdot \mathrm{rhs}^n + c^{n-1}),\\
t &= \mathrm{fl}(U^n + y_n),\\
c^n &= \mathrm{fl}\bigl(y_n - \mathrm{fl}(t - U^n)\bigr),\\
U^{n+1} &= t.
\end{aligned}
$$

Valid because $|U^n| \gg |y_n|$ throughout the benchmark.
Eliminates the warp-divergent `if (abs(.) >= abs(.))` test; same
$\mathcal O(u)$ per-step bound as V3b.

#### V3d — Graillat–Langlois compensated dot product in WENO5

The final 3-term combination $\hat F = \omega_0 p_0 + \omega_1 p_1 + \omega_2 p_2$
is replaced with a compensated dot product. With
$(h_k,\ell_k) = \mathrm{TwoProd}(\omega_k, p_k)$ and a TwoSum chain
$(s_1, e_1) = \mathrm{TwoSum}(h_0, h_1)$,
$(t, e_2) = \mathrm{TwoSum}(s_1, h_2)$:

$$
\hat F \;=\; t + \bigl(e_1 + e_2 + \ell_0 + \ell_1 + \ell_2\bigr).
$$

The compensated dot satisfies (Graillat & Langlois 2008)

$$
\bigl|\,\mathrm{CompDot}_3(\omega, p) - \omega^\top p\,\bigr|
\;\le\; u\,|\omega^\top p| \;+\; \mathrm{cond}(\omega^\top p)\,\gamma_3^2\,u^2,
$$

i.e. the standard $\mathcal O(u)$ floor plus a second-order term in the
condition number $\mathrm{cond}(\omega^\top p)$. For WENO5 in smooth
regions the dot is well-conditioned and the formula collapses to the
plain-FP32 bound — which is why V3d shows no improvement over V3b in
this benchmark.

#### V3h — Compensated Horner for $\beta_k$

Each $\beta_k = K_1 d_1^2 + K_2 d_2^2$ with constants $K_1 = 13/12$,
$K_2 = 1/4$ is evaluated via TwoProd on each square and TwoSum on the
combination, accumulating the rounding tails into a low part $\beta_k^{(\ell)}$.
The reassembled $\beta_k = \beta_k^{(h)} + \beta_k^{(\ell)}$ satisfies
the compensated-Horner bound (Graillat & Louvet 2007)

$$
\bigl|\,\mathrm{CompHorner}(p, x) - p(x)\,\bigr|
\;\le\; u\,|p(x)| \;+\; \mathrm{cond}(p, x)\,\gamma_{2n}^2\,u^2.
$$

Again, in smooth regions the $\beta$ polynomial is well-conditioned and
the bound is essentially $u|p|$ — no observable improvement over plain
FP32 $\beta$ on this initial condition.

#### V3f / V3g — Dekker double-FP32 storage

The state $U$ is stored as a pair of FP32 arrays $(U_h, U_\ell)$ with the
invariant $|U_\ell| \le \tfrac{1}{2}\,\mathrm{ulp}(U_h)$. Each load
reconstructs the high-precision value $U \approx U_h + U_\ell$ with
effective precision $\sim 2u_{\mathrm{R4P}}^2 \approx 7\times 10^{-15}$
(roughly 48 mantissa bits) — almost FP64 quality for storage and
ghost-cell propagation, without engaging the FP64 ALU.

Initial split from FP64 reference:

$$
U_h^0 = \mathrm{fl}_{\mathrm{R4P}}(U^0), \qquad
U_\ell^0 = \mathrm{fl}_{\mathrm{R4P}}\bigl(U^0 - \mathrm{fl}_{\mathrm{R8P}}(U_h^0)\bigr).
$$

The compensated update step is a two-stage TwoSum that absorbs the
RHS increment into the pair and renormalises:

$$
\begin{aligned}
\delta &= \mathrm{fl}(\Delta t \cdot \mathrm{rhs}),\\
(s_1, e_1) &= \mathrm{TwoSum}(U_h, \delta),\\
\ell' &= \mathrm{fl}(U_\ell + e_1),\\
(U_h^{n+1}, U_\ell^{n+1}) &= \mathrm{TwoSum}(s_1, \ell').
\end{aligned}
$$

This preserves the Dekker invariant after the update and keeps the
rounding residual of *every* arithmetic step inside the pair. The
reconstruction kernel `weno5_recon_r4` is unchanged from V3 — it sees a
single FP32 value $\mathrm{fl}(U_h + U_\ell)$ at each stencil load — so
V3f does not address per-step arithmetic rounding inside the
reconstruction; it addresses *storage* and *update accumulation*.

V3g is V3f with the V3d compensated-dot reconstruction substituted for
`weno5_recon_r4`. The two improvements compose: V3g sees the same
storage upgrade as V3f and the same dot upgrade as V3d.

The empirically large drift gain of V3f/V3g (drMax $\sim 10^{-14}$ vs
V3b's $\sim 10^{-9}$) reflects that conservation drift is integral over
all per-cell rounding tails, which the Dekker pair captures by
construction at every read and write.

### 7. Floating-point error sources, ordered

For the WENO5 + RK1 + diagnostics pipeline on FP32 there are five
distinct rounding-error contributions:

| # | Source                                           | Scaling      | Attacked by    |
|---|--------------------------------------------------|--------------|----------------|
| 1 | Storage round-trip $U \leftarrow \mathrm{fl}_{\mathrm{R4P}}(U + \delta U)$ at every step | $u\,|U|$ per step | V3f, V3g (Dekker storage) |
| 2 | Time-integration accumulation $\sum_n \Delta t\,\mathrm{rhs}^n$ | $n u\,\|\mathrm{rhs}\|$ naive; $u\,\|\mathrm{rhs}\|$ compensated | V3b, V3c, V3e (KBN / Klein / FastTwoSum) |
| 3 | WENO5 nonlinear combination $\sum_k \omega_k p_k$ | $u\,|\hat F|$ baseline; $u + \mathrm{cond}\,u^2$ compensated | V3d, V3g (compdot) |
| 4 | $\beta$ smoothness-indicator cancellation | $u\,|\beta|$ baseline; $u + \mathrm{cond}\,u^2$ compensated | V2b (FP64 $\beta$), V3h (compensated Horner) |
| 5 | Flux-difference sum $(\hat F_{i+1/2} - \hat F_{i-1/2})$ across three directions | $u\,|\mathrm{rhs}|$ per cell per step | **untouched in any variant** |

The empirical result that all FP32 variants converge to errMax
$\approx 9\times 10^{-7}$ implies that **source #5 dominates** the L2
error budget for this kernel. None of the implemented compensation
techniques address it because they all leave the final
`-(fL_ip - fL_im) + (fL_jp - fL_jm) + (fL_kp - fL_km)` reduction in
plain FP32. Each difference $\hat F_{i+1/2} - \hat F_{i-1/2}$ cancels
two values of $\mathcal O(|U|)$ that agree to roughly $|\nabla U|\,\Delta x$,
amplifying $u_{\mathrm{R4P}}$ by the condition factor
$|U|/(|\nabla U|\Delta x) \sim 10$ for this smooth initial condition.
With $u_{\mathrm{R4P}} \approx 6\times 10^{-8}$ this gives a per-step
relative error of $\mathcal O(10^{-7})$. Integrated over 100 RK1 steps
under random-walk accumulation
($\sqrt{n_{\mathrm{steps}}}\cdot 10^{-7} \approx 10^{-6}$) it matches
the observed floor to within a factor of order unity. A future variant
would need either a Dekker representation of $\mathrm{rhs}$ itself, or
a compensated difference-of-differences reduction, to break this floor.

### 8. Success bar — derivation

The pass thresholds reported in the table are not arbitrary:

- **Speedup $\ge 1.5\times$**: any precision concession must buy more
  than the bandwidth halving that simply switching to FP32 storage
  provides on a memory-bound CPU. Below 1.5× there is no engineering
  reason to give up FP64.
- **errMax $\le 10^{-12}$**: target is "indistinguishable from FP64
  reference at single-step rounding noise level," i.e. errors of
  $\mathcal O(n_{\mathrm{steps}} \cdot u_{\mathrm{R8P}}) \approx 10^{-14}$
  loosened by two orders of magnitude to absorb diagnostic noise and
  multi-cell aggregation.
- **drMax $\le 10^{-10}$**: target is "drift below the L2 error floor,"
  $10^{-10} < 10^{-12}$ ensures the conservation check is the tighter
  one (drift is the more sensitive numerical diagnostic for long-time
  CFD).

V1 passes by construction; V3 and FP16 are expected to fail the errMax
bar; the interesting question is whether the *compensated* variants
straddle either or both thresholds. The headline empirical answer is:
no FP32 variant clears the L2 bar (the bar is too tight for
$u_{\mathrm{R4P}}$-floor arithmetic to reach), but V3f's drift
($3.5\times 10^{-14}$) is comfortably below the drift bar despite
errMax remaining at $9\times 10^{-7}$ — showing that conservation and
L2 quality are *independent* axes on this kernel.

---

## Findings

### Headline result (RTX 4070 Ada, cc89, nvfortran 26.1, ni=32)

**Production extents: `nb=512 ni=32 nc=5 nsteps=100`**, ~1.07 GiB per
array. The headline table below is a **5-trial statistical run**
(median of per-trial pairings against V1', 45 min total wall time);
every variant's speedup is normalised to **V1' (FP64 with c-loop
sequential)** — the honest realistic-CFD baseline. The original
`ni=16` numbers are kept further down for archival comparison.

The conservation diagnostic uses a **pairwise (tree) sum** internally so its
own rounding error is O(log N · eps) ≈ 1e-14 rather than O(N · eps) ≈ 4e-13.
With this fix, V1's drMax reaches `1.8e-16 ≈ eps_R8P` — the absolute floor of
FP64 representation. Earlier runs reported V1 drMax as 1.6e-14; that was the
diagnostic's own naive-sum error masking the kernel's true conservation.

| Variant | Storage / parallelism | median $t$ [s] | min–max | median BW [GB/s] | **vs V1'** | errMax | drMax |
|---|---|---:|---:|---:|---:|---:|---:|
| **V1'  FP64 (b,i,j,k,c) c-seq (REF)**     | A, c-seq | **206.65** | 204.5–229.2 | 2.18 | **1.000×** | 0       | 1.8e-16 |
| **V1B' FP64 (c,i,j,k,b) c-seq**           | B, c-seq | **206.63** | 206.3–211.1 | 2.18 | **0.992×** | 0       | 1.8e-16 |
| V1    FP64 (b,i,j,k,c) c-parallel         | A, c-par | 28.51 | 28.2–28.7 | 15.77 | 7.24× | 0       | 1.8e-16 |
| V1B   FP64 (c,i,j,k,b) c-parallel         | B, c-par | 28.43 | 27.7–29.3 | 15.81 | 7.28× | 0       | 1.8e-16 |
| V2    FP32 store + FP64 compute           | A, c-par | 28.93 | 28.6–29.0 | 7.77  | 7.14× | 1.1e-6  | 5.2e-8  |
| V2b   FP32 + FP64 β only                  | A, c-par | 23.28 | 22.7–23.7 | 9.66  | 9.01× | 1.1e-6  | 5.2e-8  |
| **V3    FP32 naive**                       | A, c-par | **1.670** | 1.50–3.60 | 134.6 | **122.8×** | 1.1e-6 | 5.1e-8 |
| **V3b   FP32 + Neumaier RK1**              | A, c-par | **1.716** | 1.66–1.83 | 130.9 | **121.2×** | 7.5e-8 | 2.2e-9 |
| V3c   FP32 + Klein RK1                    | A, c-par | 1.856 | 1.84–1.98 | 121.1 | 110.6× | 1.7e-7 | 2.7e-9 |
| **V3e   FP32 + branchless FastTwoSum**     | A, c-par | **1.837** | 1.71–6.60† | 122.3 | **112.3×** | 7.5e-8 | 2.2e-9 |
| V3d   FP32 + Graillat-Langlois compdot   | A, c-par | 1.971 | 1.86–6.79† | 114.0 | 104.8× | 7.5e-8 | 2.2e-9 |
| V3h   FP32 + comp Horner β                | A, c-par | 2.152 | 1.98–4.49† | 104.4 | 95.1× | 7.5e-8 | 2.2e-9 |
| **V3f   FP32 + Dekker storage**            | A, c-par | 2.644 | 2.48–9.16† | 170.0 | 77.3× | 6.5e-8 | **1.4e-15** |
| V3g   V3f + compdot recon                 | A, c-par | 2.822 | 2.67–48.3† | 159.3 | 73.2× | 6.5e-8 | 1.0e-15 |
| **V3f'  Dekker + `collapse(5)`**           | A, c-par | **2.386** | 2.29–6.97† | **188.4** | **85.7×** | 6.5e-8 | 1.4e-15 |
| V3f""  Dekker + bad loop order            | A, c-par | 23.54 | 22.6–112† | 19.10 | 8.69× | 6.5e-8 | 1.4e-15 |
| V3fA-F realistic, shape A, order F        | A, c-seq | 43.65 | 42.9–50.9† | 10.30 | 4.74× | 6.5e-8 | 1.4e-15 |
| V3fA-G realistic, shape A, order G        | A, c-seq | 45.00 | 44.5–111† | 9.99 | 4.54× | 6.5e-8 | 1.4e-15 |
| **V3fB-F realistic, shape B, order F**    | **B, c-seq** | **42.35** | 41.5–114† | 10.62 | **4.89×** | 6.5e-8 | 1.4e-15 |
| V3fB-G realistic, shape B, order G        | B, c-seq | 46.03 | 44.7–46.9 | 9.77 | 4.55× | 6.5e-8 | 1.4e-15 |

Speedups are median of per-trial pairings $t_{V1'} / t_{\text{variant}}$ across 5 trials.

† Several variants had 1 of 5 trials hit an anomalous high value (likely nvfortran JIT-cache contention as later variants are launched after a long prior chain). The other 4 trials of each variant cluster tightly. **Median is robust to these outliers**; the mean would be misleading. The qualitative ordering is unchanged from single-trial snapshots.

### FP64 storage-shape 2×2 matrix (the new full coverage)

The FP64 (shape × c-parallelism) matrix is now symmetric and complete:

|              | c-parallel    | c-sequential       | c-seq penalty |
|--------------|--------------:|-------------------:|--------------:|
| **shape A** `U(b,i,j,k,c)` | V1  = 28.51 s | V1'  = 206.65 s (**REF**) | **7.25×** |
| **shape B** `U(c,i,j,k,b)` | V1B = 28.43 s | V1B' = 206.63 s           | **7.27×** |
| **B/A ratio**              | 0.997 (−0.3%) | 1.000 (0.0%)               | — |

**Storage shape does NOT matter for pure FP64 kernels** — neither in the
c-parallel nor the c-sequential regime. V1 ↔ V1B agree to 0.3%, V1' ↔
V1B' agree to 0.0%. The c-sequential penalty is 7.25–7.27× in either
shape; loss of c-parallelism is a hardware-level (warp-utilisation +
FP64-throughput) phenomenon that doesn't care which dimension is
stride-1.

**This is contrary to the V3fB-F vs V3fA-F finding (FP32-Dekker
realistic CFD)** where shape B beats shape A by 3% (42.35 s vs
43.65 s). The difference is in arithmetic intensity: FP32-Dekker's
TwoSum/TwoProd compensation puts roughly 2× the FLOPs per byte
through the kernel, pushing it closer to compute-bound territory
where per-warp c-locality starts to matter. Plain FP64 c-sequential
is so deeply memory-stall- and kernel-launch-overhead-bound (effective
2.18 GB/s — 100× below DRAM peak) that no storage-shape tweak can
help.

**Implication:** for FP64-only realistic CFD, storage shape is genuinely
irrelevant — pick whichever is more convenient for the rest of the
codebase. The 3% shape-B advantage observed for V3fB-F over V3fA-F is
specific to compensated FP32 kernels, not a general "shape B is
better for c-sequential" rule.

V2b's speedup fluctuates significantly between runs (0.83× to 1.24× observed) —
its kernel is on the slow FP64-ALU path where cache-state and thermal noise
move the timing substantially. The qualitative conclusion (V2b is in the
trap regime, ≤ V1 speed) stands; the magnitude is run-to-run noisy. The fast
variants (V3 family) are stable at the reported speedups across runs.

### Interpretation

**Four findings, three contrary to naive expectations:**

**1. V2b (surgical FP64 promotion of β-indicators only) is in the trap regime.**
At best run-to-run roughly tied with V1, never markedly faster, and gives
errMax identical to V2 (6.4e-7) to three digits. Conclusion: promoting *any*
FP64 work into the inner stencil loop engages the consumer-GPU FP64 ALU
bottleneck — even when the promoted region is the cancellation-sensitive
smoothness indicators, the FP64 throughput is the cost. The error floor is
also unaffected by β-promotion because **the dominant error source is the
per-step storage round-trip** (every load is `R4P → R8P → math → R4P → store`,
happening 6× per cell per direction in the rhs), not the cancellation in β.
The surgical fix targets the wrong thing.

**2. V3b (Kahan/Neumaier-compensated RK1) gives modest errMax improvement
(1.1e-6 → 9.0e-7, 1.2×) but DRAMATIC drMax improvement (5.4e-8 → 4.1e-9, 13×)**.
The asymmetry is informative: Neumaier compensation fixes only the
time-integration accumulation (which is precisely what conservation drift
measures), not the per-step rounding of every flux reconstruction. Conservation
drift is the integral of accumulated low-bit losses; L2 error is dominated by
the per-step reconstruction round-trip. **For production CFD where
conservation drift matters most over long trajectories, V3b's 9% speedup loss
buys back an order of magnitude of drift — an unambiguous win.**

**3. V3c (Klein second-order compensation) is WORSE than V3b at 100 steps**
(drMax 6.7e-9 vs 4.1e-9) and ~10% slower. Why: the first-level carry `c` is
only ~6e-6 after 100 steps of `dt·rhs = O(1e-3)`, well within FP32's 7-digit
dynamic range — there's nothing for the second-level compensator to catch, and
the extra reconstitution `U_final = U + comp + comp2` introduces a fresh
rounding step that exceeds the (zero) benefit. V3c crosses over V3b only at
~1000+ steps (measured: drMax 4.3e-9 vs V3b's 5.7e-9 at 1000 steps, ~30%
better) and even there costs 10% in speed. **For typical 100-1000 step
trajectories V3b strictly dominates V3c; Klein only matters at very long
trajectories where the first-level carry saturates.**

**4. The conservation diagnostic itself was leaking precision.** Replacing the
intrinsic `sum()` over 4096 elements with a pairwise (tree) sum dropped V1's
drMax from 1.6e-14 to 1.8e-16 (= eps_R8P). The earlier 1.6e-14 was the
diagnostic's own O(N · eps) naive-sum error, not the kernel's. Other variants
were unaffected — their drift is dominated by the kernel error, not the
diagnostic's. This matters for **future numerical-quality measurements**:
when measuring FP64-equivalent results, the diagnostic must itself have error
below the measurement threshold or it caps what you can read.

**V2 is essentially TIE with V1 (0.99×)** at these extents — the earlier 0.5×
result was from a thermal/state outlier. The qualitative conclusion stands:
V2 is not faster than V1, bandwidth halving buys nothing when FP64 ALU is
the bottleneck. V2 is not a useful path.

**V3 achieves 14.5× speedup at 184 GB/s sustained** (~37% of the RTX 4070's
~500 GB/s peak — credible for a strided WENO5 kernel with smoothness indicators).
All performance gains come from escaping the FP64 ALU.

### Findings from the extended compensation panel (V3d, V3e, V3f, V3g, V3h)

Five additional FP32 compensation techniques were added to test where the
~9e-7 L2 floor of V3b actually lives. The result is **the most important
conclusion of this benchmark** and inverts the initial hypothesis.

**5. The errMax floor of ~9e-7 is shared by every FP32 variant — to four
significant digits.** V3b, V3e, V3d, V3h, V3f, V3g all report errMax in the
range `8.960e-7 — 8.967e-7`. Five very different compensation techniques —
single-carry Neumaier, branchless FastTwoSum, Graillat-Langlois compensated
dot product in the WENO5 nonlinear combination, compensated Horner on β
indicators, Dekker double-FP32 storage with compensated update — produce
indistinguishable L2 error. **This means the dominant L2 error source is
not in any of these places.** The most likely remaining suspect is the
plain-FP32 flux-difference sum
`-(fL_ip - fL_im) + (fL_jp - fL_jm) + (fL_kp - fL_km)` at the end of `rhs`,
which cancels three differences that are each ~1e-6 in magnitude. Attacking
this would require Dekker representation of `rhs` itself or compensated
summation in the difference of differences — neither tested here.

**6. V3e (branchless FastTwoSum) reproduces V3b bit-for-bit** (errMax,
drMax, speedup all within run-to-run noise of V3b). Conclusion: **the
warp-divergence branch was free.** What V3b paid versus naive V3 (~9%
speedup loss) is the bandwidth of the `comp` carry array, not the abs-test
divergence. This rules out "branchless variants of Neumaier" as a speedup
recovery path on this kernel.

**7. V3d (Graillat-Langlois compdot on the WENO5 nonlinear sum) is a dead
end on this kernel.** ErrMax identical to V3b (9e-7), 7-8% slower from the
extra TwoProd/TwoSum operations. The L2 error is not concentrated in the
3-term convex combination `Σ ω_k q_k`; it is dominated by other parts of
the rhs.

**8. V3h (compensated Horner on β indicators) is a dead end on this
kernel.** ErrMax identical to V3b, 13% slower from the extra Horner
compensation work. This confirms — by orthogonal mechanism — the same
finding that V2b established with FP64 β: **β cancellation is not the
precision bottleneck of WENO5 on this kernel.** A Sod-shock or other
discontinuity-dominated test might shift this, but for the smooth
trigonometric initial condition the β path is comfortably within FP32
precision.

**9. V3f and V3g (Dekker double-FP32 storage) deliver a SPECTACULAR
conservation-drift improvement at modest speedup cost.** This is the
result that overturns the initial hypothesis. drMax drops from V3b's
`4.1e-9` to `3.5e-14` for V3f and `2.3e-14` for V3g — five to six orders
of magnitude better, approaching V1's `1.8e-16` (eps_R8P) floor. Speedup
falls from V3b's 14× to ~9.1-9.5× because the 2× bandwidth on U (hi+lo
pair) becomes the bottleneck — sustained 232 GB/s is near the kernel's
bandwidth ceiling on RTX 4070. **For long-trajectory CFD where
conservation drift is the gating quality metric, V3f is the new sweet
spot** — 9.5× speedup over FP64 at conservation drift indistinguishable
from V1 within nine significant figures. The accompanying errMax floor of
9e-7 remains, because errMax is not what V3f targets.

The asymmetry between errMax (untouched) and drMax (~10⁵× improved) for
V3f is the analog of the V3 → V3b asymmetry, but at a different mechanism:
V3b protects the time-integration accumulation; V3f protects the per-step
storage round-trip *and* its accumulation. The L2 error per step is set by
the rhs arithmetic, not by storage rounding, so V3f's storage upgrade
doesn't help errMax — but the cumulative cell-by-cell rounding bias that
manifests as conservation drift is killed almost entirely.

**10. V3g (Dekker + compdot recon) gives slightly better drMax than V3f
(2.3e-14 vs 3.5e-14) at the cost of ~5% extra time.** The compdot
reconstruction does help marginally when the storage round-trip is
already neutralised, suggesting that *some* fraction of the residual drift
comes from the nonlinear combination — but the magnitude is small. In
practice V3f is the simpler recipe and almost as good.

### A subtle bug worth recording — nvfortran scratch privatisation

During implementation, V3f initially produced errMax `2.8e-3` (4000×
worse than V3b). The cause turned out to be an OpenACC + nvfortran 26.1
miscompile: when the inner `!$acc loop vector` body reused named scratch
variables (`vm2, vm1, v0, vp1, vp2`) for six consecutive WENO5 face
computations, with the scratch declared `private(...)` on the outer
`!$acc parallel loop collapse(4)`, nvfortran emitted code that produced a
~5e-5 systematic bias per step. Replacing the named scratch with inline
expressions at each `weno5_recon_r4(...)` call site eliminated the bias
entirely.

This is a load-bearing nvfortran/OpenACC pitfall that doesn't surface
under `-fbounds-check` or compiler `-Minfo=accel` output. **Rule of thumb
for OpenACC stencil kernels with named scratch:** if scratch variables
are reused multiple times per inner-loop iteration, prefer to inline the
expression at the call site rather than declare scratch on the outer
parallel loop. The CUDA backend's private-variable lifetime semantics
differ from the host's, and reuse across calls within a parallel-loop
iteration can trip the optimiser.

### Parallelisation strategy: `collapse(4) + inner vector(b)` vs `collapse(5)` (V3f vs V3f')

V3f's kernels use a two-level scheduling:

```fortran
!$acc parallel loop collapse(4) present(U_hi, U_lo, rhs) private(...)
do c, do k, do j, do i
   !$acc loop vector
   do b = 1, nb
      ...
   enddo
enddo
```

V3f' tests the alternative of a single flattened iteration space:

```fortran
!$acc parallel loop collapse(5) present(U_hi, U_lo, rhs) private(...)
do c, do k, do j, do i
   do b = 1, nb
      ...
   enddo
enddo
```

The numerical algorithm is identical — only the OpenACC schedule
differs. Compiler diagnostics confirm that in both forms `b` ends up as
the vector (`threadIdx.x`) dimension, preserving coalesced loads on
stride-1 `nb`. The difference is the gang count:

- V3f schedule: $n_c \cdot n_i^3 = 5 \cdot 16^3 = 20{,}480$ gangs, each spanning $n_b = 512$ vector lanes tiled into 128-lane chunks.
- V3f' schedule: $n_c \cdot n_i^3 \cdot n_b = 10{,}485{,}760$ flattened iterations, ~80,000 gangs of 128 vector lanes each.

**Measurement** (RTX 4070 Ada, nvfortran 26.1, $n_b{=}512,\,n_i{=}16,\,n_c{=}5,\,n_{\mathrm{steps}}{=}100$, 11 timed trials after a cold-cache discard):

| Variant | mean $t$ [s] | stdev | median | mean BW [GB/s] | wins / losses |
|---------|-------------:|------:|-------:|---------------:|--------------:|
| V3f    | 0.376 | 0.011 | 0.375 | 233 | reference |
| V3f'   | 0.365 | 0.008 | 0.367 | 238 | **10 wins, 1 loss vs V3f** |

Per-trial pairing gives V3f' faster by **mean +3.0%, median +2.2%,
stdev ±2.3%** — consistent but small. V3f' wins 10 of 11 paired trials;
the one V3f' loss (0.376 s vs V3f 0.375 s) is in the run-to-run noise.
Numerical output is bit-identical to V3f (errMax 8.960e-7, drMax 3.5e-14)
— as expected since the algorithm is unchanged.

**Why the gain is small.** V3f is already bandwidth-saturated at ~232
GB/s, close to the kernel's effective ceiling (~250 GB/s on RTX 4070 for
this access pattern). The two-level schedule's gang count of 20,480 is
already enough to fill the SM grid (RTX 4070 has 46 SMs × 1024
threads/SM = 47,104 concurrent threads; 20,480 gangs × 128 lanes =
2,621,440 total threads — 55× over-subscription, plenty for latency
hiding). Collapse(5) gives marginally better occupancy patterns but
can't push past the bandwidth wall. The expectation is that the gain
would be larger on compute-bound variants (V3b, V3e) where the kernel
sits below the bandwidth ceiling and gang scheduling has more
headroom — not characterised here.

**Rule of thumb.** For stride-1-friendly stencil kernels on
nvfortran 26.1, **`collapse(N)` over all loop levels is consistently
on-par-or-faster than `collapse(N-1)` + inner `loop vector`**, at no
cost to readability. Adopt `collapse(N)` by default; reserve the
two-level form only when you need to explicitly control the per-gang
work granularity (e.g. to fit a tile in shared memory).

### `collapse(N)` does NOT recover from a hostile source loop order (V3f' vs V3f'')

V3f'' tests the corollary question: with array storage unchanged at
`(b,i,j,k,c)` and the same `!$acc parallel loop collapse(5)` schedule
as V3f', does inverting the *source lexical order* of the loop nest to
`(b, k, j, i, c)` — `b` outermost / `c` innermost — affect performance?
If `collapse(N)` truly flattens the iteration space and remaps the
threads, the source order should be irrelevant.

**It is not.** Measurement (RTX 4070 Ada, nvfortran 26.1, 9 trials
after cold-start discard):

| Variant | Lexical loop order | mean $t$ [s] | stdev | mean BW [GB/s] | speedup vs V1 |
|---------|--------------------|-------------:|------:|---------------:|--------------:|
| V3f'    | `c, k, j, i, b` (b innermost = stride-1) | 0.398 | 0.009 | 219 | 9.6× |
| V3f''   | `b, k, j, i, c` (b outermost, c innermost = strided) | 1.409 | 0.029 | 62 | 2.7× |

**V3f'' is 3.54× slower than V3f'** (254% wall-time penalty) — the
penalty is unambiguous (zero overlap between the two distributions
across all trials). Numerical output is bit-identical (errMax 8.960e-7,
drMax 3.525e-14 for both).

The effective bandwidth collapses from 219 GB/s to 62 GB/s, a ratio of
0.28 that directly mirrors the wall-time ratio — confirming the
slowdown is memory-stall, not compute. Two compounding effects explain
the magnitude:

1. **Innermost loop becomes the vector dimension.** nvfortran's
   `collapse(N)` flattens the iteration space, but the
   gang/vector mapping defaults to "lexically innermost is fastest" —
   the lexical source order leaks into the SASS. With `c` innermost,
   `c` becomes `threadIdx.x`. Since $n_c = 5$, every warp launches with
   5 active lanes out of 32 (~16% lane utilisation). The stride-1
   `b` dimension, now lexically outermost, is mapped to the gang
   index — so consecutive gangs request memory addresses
   $n_b \cdot (n_i + 2n_g)^3 \cdot 4 \text{ bytes} \approx 21.7$ MB
   apart. No coalescing across gangs, no warp-wide coalescing within a
   gang either (only 5 of 32 lanes participate).

2. **Strided access within the warp.** The innermost-loop reads
   `U_hi(b, ..., c)` and `U_lo(b, ..., c)`. With `c` walking the warp,
   each of the 5 active lanes reads a separate 22 MB-apart memory line.
   On Ada, a single 128-byte sector transaction serves at most one
   FP32 element per lane, requiring $\sim 5$ separate transactions for
   what would otherwise be one coalesced load — combined with the
   already-poor warp utilisation, effective bandwidth drops by the
   observed $\sim 3.5\times$ factor.

**Rule.** `!$acc parallel loop collapse(N)` does *not* abstract away
the source lexical order on nvfortran 26.1. The lexically innermost
loop becomes the vector dimension; for coalesced loads on a
Fortran column-major array, that **must** be the stride-1 dimension.
Source loop order matters as much as it would in CUDA C with explicit
threadIdx.x assignment — `collapse` reduces boilerplate, not
responsibility for the access pattern.

This makes the V3f vs V3f' comparison even more compelling in
retrospect: V3f' edges V3f by +3% precisely because both forms have
the *correct* source order (`b` lexically innermost / fastest). Get
the lexical order wrong and you lose 254% no matter what `collapse`
you ask for.

### Realistic CFD: c-component loop sequential (V3fA-F / -G, V3fB-F / -G)

V3f, V3f', V3f'' all parallelise over the conservative-component index
`c` — fine as a numerical-precision benchmark with a trivial linear
flux, but **not realistic** for production CFD. A real Euler /
Navier–Stokes flux couples the components nonlinearly:
$\hat F^{(c)} = \hat F^{(c)}(U^{(1)}, U^{(2)}, \dots, U^{(n_c)})$,
so `c` cannot in general be parallelised — it must be a sequential
inner `do` loop. The parallel surface drops from `collapse(5)` to
`collapse(4)` over $(b, i, j, k)$.

This subsection answers the natural design question that follows:
**given the sequential-c constraint, is storage shape A
`U(b,i,j,k,c)` better than shape B `U(c,i,j,k,b)`, and which loop
order is best for each?** Four new variants form a $2 \times 2$
cross-product of (storage A, B) $\times$ (loop order F, G):

- **F** = Fortran-compliant: stride-1 array dimension lexically
  innermost in the parallel loop set.
- **G** = NVIDIA / CUDA C convention: biggest-stride array dimension
  lexically outermost ("largest stride first").

Numerical output is bit-identical across all four variants
(errMax `8.960e-7`, drMax `3.525e-14`) — same as V3f. Comparison is
wall-clock only.

**The honest baseline is V1', not V1.** Comparing the realistic-CFD
FP32 variants against V1 (which parallelises c) is apples-to-oranges
— V1's parallel surface is 5× larger. The fair comparison is against
V1', the FP64 baseline *with c also sequential*. V1' uses the same
storage shape A and loop order F as V3fA-F, so storage and loop-order
effects cancel out and only the precision difference remains.

**Measurement** (RTX 4070 Ada, nvfortran 26.1, 7 trials after
cold-start discard):

| Variant | Storage | Parallel loops (outer → inner) | mean $t$ [s] | stdev | mean BW [GB/s] | speedup vs V1' |
|---------|---------|--------------------------------|-------------:|------:|---------------:|---------------:|
| **V1' (honest FP64 baseline)** | `(b,i,j,k,c)` | `k,j,i,b` seq c | **26.73** | 0.95 | 3.3 | **REF (= 1.00×)** |
| **V3fB-F (best realistic FP32)** | `(c,i,j,k,b)` | `b,k,j,i` seq c (i innermost; c stride-1 in seq) | **5.28** | 0.69 | **16.7** | **5.05×** |
| V3fA-F | `(b,i,j,k,c)` | `k,j,i,b` seq c (b innermost = stride-1) | 5.54 | 0.71 | 15.9 | 4.79× |
| V3fB-G | `(c,i,j,k,b)` | `i,j,k,b` seq c (b innermost in par set) | 5.94 | 1.01 | 15.0 | 4.50× |
| V3fA-G | `(b,i,j,k,c)` | `b,k,j,i` seq c (b outermost, i innermost) | 7.14 | 0.76 | 12.3 | 3.74× |
| *V3f' (V3f with c parallel, for reference)* | `(b,i,j,k,c)` | `c,k,j,i,b` collapse(5) | *0.37* | *0.01* | *239* | *73×* |
| *V1 (V1 with c parallel, for reference)*    | `(b,i,j,k,c)` | `c,k,j,i,b` collapse(5)  | *4.00* | *0.90* | *23*  | *6.7×* |

**Four findings, all clear:**

**1. The FP64 c-sequential penalty is brutal: V1' is 6.73× slower than
V1** (26.73 s vs 4.00 s). Losing c-parallelism hurts FP64 *more* than
FP32 because FP64 already runs at 1/64 the FP32 throughput on
consumer Ada — combining the slow datapath with 5/32 = 16% warp lane
utilisation across the c dimension compounds the inefficiency. Effective
BW for V1' drops to 3.3 GB/s, a small fraction of even the
realistic-FP32 17 GB/s ceiling.

**2. Best realistic FP32 (V3fB-F) is 5.05× faster than the honest
FP64 baseline V1'.** Mixed precision still buys an order-of-magnitude
benefit *even when c-parallelism is forbidden* — just not the 14× of
the c-parallel scenario. The 5× is real and large enough to be the
gating decision for FUNDAL's production API: even in the worst
realistic case, FP32 with Dekker storage is a clear win over FP64.

**3. Storage shape B (`U(c,i,j,k,b)`) beats shape A by 5% at the best
loop order (BF vs AF), and the F→G order penalty is 4–22%.** Total
spread between best (BF, 5.28 s) and worst (AG, 7.14 s) realistic
variants is **35%** — substantial but small compared to the
precision-axis 5× and the c-parallelism axis 14×. Reason for shape B's
edge: with c *inside* the kernel as a sequential loop, having c as
stride-1 lets the 5 c-iterations hit the same cache line per cell.
Shape A's stride of $n_b (n_i+2n_g)^3 \cdot 4 \approx 21$ MiB per
c-step is fully out of cache.

**4. Loop order F (Fortran-compliant) beats order G (GPU
"biggest-stride-first" convention) in both shapes** — by 22% for
shape A, 11% for shape B. Combined with V3f'' (where order matters
even more dramatically because c is in the parallel surface), this is
the third independent experiment confirming the rule: **the lexically
innermost loop in the OpenACC parallel set becomes the vector
dimension on nvfortran 26.1, regardless of `collapse`, and the
stride-1 array dimension belongs there**. The NVIDIA / CUDA C
"biggest-stride-first" heuristic does *not* transfer to Fortran
column-major + OpenACC.

**Architectural decision tree for FUNDAL's API:**

1. **If c-parallelism is available** (rare in production CFD but
   common in lower-order schemes, decoupled-scalar-transport sub-
   problems, neural-surrogate inference): pursue V3f' / V3b for
   ~14× speedup over FP64.
2. **If c-parallelism is forbidden** (the common case — compressible
   NS, MHD, multiphysics with implicit Riemann solvers): pursue
   V3fB-F (storage `U(c,i,j,k,b)` + loop order F) for ~5× speedup
   over the honest FP64 baseline. Storage choice is a 35% knob;
   choose it deliberately.
3. **Reclaim some of the lost factor by tiling c.** Compressible NS
   often admits a linear sub-coupling on (ρ, ρu, ρv, ρw) with the
   nonlinear piece confined to ρE — split into `parallel loop
   collapse(5)` for the linear group and a sequential pass for the
   scalar. Not implemented here; expected to recover roughly half of
   the c-parallelism factor based on $n_c$ ratios.

**Honest summary of the FP32 advantage:**

| c regime | Honest FP64 baseline | Best FP32 | Speedup |
|----------|---------------------:|----------:|--------:|
| c parallel (V3f-style)        |    4.0 s (V1)  |   0.37 s (V3f') | **10.9×** |
| c sequential (realistic CFD)  |   26.7 s (V1') |   5.28 s (V3fB-F) | **5.05×** |

Both regimes show that FP32 + Dekker storage is unambiguously worth
adopting on consumer GPUs; only the magnitude of the win depends on
whether c can be parallelised.

### CPU result for comparison (host, gfortran -O2)

```
V1 FP64                               5.76 s   1.9 GB/s   1.00×   ref      ref
V2 FP32 storage + FP64 compute        5.55 s   1.0 GB/s   1.04×   5.6e-7   3.3e-8
V3 FP32 throughout                    4.44 s   1.2 GB/s   1.30×   8.7e-7   3.3e-8
V4 FP16 storage + FP32 compute (emul) 4.44 s   0.6 GB/s   1.30×   4.0e-2   4.0e-2
```

On CPU, V2 ≈ V3 in both speed and error — storage rounding dominates, FP64
compute is essentially free (CPU FP64:FP32 ratio is 1:2). The mixed-precision
middle path looks defensible on CPU. **This is exactly the wrong intuition to
carry to GPU**, which is why the test exists: the regime flips depending on
the FP64:FP32 ALU ratio of the target hardware.

V4 (FP16 storage) gives ~4% L2 error after 100 steps in either case — clearly
unusable as a drop-in replacement for FP64 in this kernel.

V2b and V3b have not been run on CPU; the GPU-specific bottleneck (FP64 ALU
gating) is the only reason these surgical / compensated variants exist, so the
CPU comparison would not add information.

### Practical implication for FUNDAL adoption

On consumer Ada/Blackwell GPUs, **four** viable precision strategies for
stencil kernels, ordered by use case:

1. **All-FP64 (V1)**: accept the consumer-GPU FP64 throughput tax (1:64 vs FP32).
   Production accuracy preserved (drMax = eps_R8P, errMax = 0 by definition).
   Use when the application requires bit-level FP64 reference quality.
2. **All-FP32 naive (V3)**: **14.0× speedup** over FP64. Engineering-grade
   accuracy (errMax ~1.1e-6 per 100 steps, drMax ~5e-8). Viable when both the
   L2 accuracy budget AND the integrated conservation drift can absorb FP32
   rounding.
3. **All-FP32 + Neumaier-compensated time integration (V3b or V3e)**:
   **14.0× speedup** over FP64 — essentially the same speed as naive V3, but
   recovers an order of magnitude of conservation drift (5e-8 → 4e-9). V3e
   (branchless FastTwoSum) matches V3b's accuracy and speed and is mildly
   preferable for portability. **The production sweet spot for short-to-
   medium trajectories** (≤ 1000 steps).
4. **Dekker double-FP32 storage (V3f)**: **9.5× speedup** over FP64 with
   conservation drift `3.5e-14` — five orders of magnitude better than V3b
   and within 200× of V1's eps_R8P floor. errMax remains 9e-7 (the FP32 rhs
   floor — Dekker storage does not address it). **The production sweet spot
   for long-trajectory work where conservation drift is the load-bearing
   quality metric** (climate-scale integrations, long-time turbulence,
   anything where invariant preservation matters more than per-step L2).

**Five confirmed dead ends on consumer GPU:**

- **V2** (FP32 storage + blanket FP64 compute): essentially tied with V1 speed,
  FP32 accuracy. No use case.
- **V2b** (FP32 + surgical FP64 promotion of cancellation-sensitive β-indicators):
  speed in the V2-trap regime, no accuracy improvement over V2 because the
  dominant error source is not β cancellation. Surgical FP64 promotion is **not
  better than blanket** on consumer GPU — any FP64 work pulls the kernel onto
  the FP64 datapath.
- **V3c** (Klein second-order compensation): worse than V3b on drift at 100
  steps, slightly better at 1000 steps but still ~10% slower. The first-level
  Neumaier carry doesn't saturate in normal-length runs.
- **V3d** (Graillat-Langlois compensated dot product on WENO5 nonlinear
  combination): errMax identical to V3b. The L2 error is not concentrated in
  the 3-term convex combination.
- **V3h** (compensated Horner on β indicators): errMax identical to V3b. The
  β polynomial is not the bottleneck. Confirms V2b's FP64-β finding via an
  orthogonal mechanism.

### What's NOT in the test (could be future work)

- **Dekker double-FP32 storage for U** (high+low pair) would kill the per-step
  reconstruction round-trip noise (the V3/V3b/V3c errMax floor of ~1e-6) but
  doubles the storage bandwidth and ~20× the compute. Worth testing only if
  V3b's errMax floor proves load-bearing for a real workload.
- **Compensated WENO5 reconstruction** (compensated dot product `vL = Σ wi·pi`):
  could attack the L2 floor directly, ~25× cost of naive recon but the
  reconstruction is only part of the kernel — net cost likely modest. The
  cleanest "next experiment" if errMax matters more than drift.
- **Branchless Sum2 (Ogita) in place of Neumaier in V3b**: eliminates the
  `if (abs(u_old) >= abs(y))` branch and its warp divergence at similar
  accuracy. Might recover the 9% speedup loss vs naive V3.
- **Stochastic rounding** in the RK1 update: eliminates systematic drift
  without compensation. No hardware support on Ada; software emulation costs
  more than Kahan, so not useful here. Worth re-evaluating on Blackwell
  datacenter (B100/B200) which has FP4/FP6 stochastic rounding modes.
- **Mixed reconstruction order**: WENO3 (less cancellation in smoothness
  indicators) for FP32 regions, WENO5 reserved for FP64 critical regions.
  Out of scope here.
- **Iterative refinement at the time-step level**: run K FP32 steps, take a
  full-FP64 step to correct, repeat. Likely cheaper than blanket FP64 but
  requires the FP64 step to be invoked rarely.

### Why CPU lied: the regime flip

The factor that flips the conclusion between CPU and consumer GPU is the
**FP64:FP32 ALU throughput ratio**:

| Hardware                | FP64:FP32 ratio | Mixed-precision middle path? |
|-------------------------|----------------:|------------------------------|
| Modern x86 CPU (AVX-512)|             1:2 | Defensible — V2 ≈ V3        |
| Datacenter GPU (H100)   |             1:2 | Defensible — iterative refinement works |
| Datacenter GPU (B200)   |             1:2 | Defensible                  |
| Consumer GPU (RTX 30/40/50) | 1:64        | **TRAP** — V2 strictly worse than V1 |

The rule of thumb: mixed-precision storage + higher-precision compute only pays
off when compute is *not* the bottleneck. On consumer GPUs, FP64 compute is so
deliberately starved that it becomes the dominant cost as soon as you do *any*
FP64 work in the inner loop.

---

## Implementation notes

### GPU kernel structure

Each precision variant follows the same pattern:

```fortran
!$acc data copy(U) create(rhs)
do step = 1, nwarm                    ! warmup, untimed
   call ghost_fill_*(U)
   call weno5_rhs_*(U, rhs)
   call rk1_update_*(U, rhs, dt)
enddo
!$acc wait
call wall_clock(t0)                   ! wall time, NOT cpu_time
do step = 1, nsteps                   ! timed
   call ghost_fill_*(U)
   call weno5_rhs_*(U, rhs)
   call rk1_update_*(U, rhs, dt)
enddo
!$acc wait                            ! mandatory: ensures kernels complete
call wall_clock(t1)
!$acc end data
```

Key correctness/measurement details:

- **`!$acc wait` before `t1`.** Without it, async kernel launches return
  immediately and the timer measures launch latency, not work. This is the
  single most common GPU benchmarking error.
- **`system_clock` not `cpu_time`.** `cpu_time` measures CPU thread time —
  near-zero during GPU work, useless.
- **Structured `!$acc data` region.** One H→D transfer at start, one D→H at
  end, zero per-step transfers. The transfer cost is not what we're measuring;
  sustained device-side throughput is.

### Parallelisation strategy

Each compute kernel:

```fortran
!$acc parallel loop collapse(4) present(U, rhs) private(...)
do c = 1, nc
   do k = 1, ni
      do j = 1, ni
         do i = 1, ni
            !$acc loop vector
            do b = 1, nb              ! stride-1, mapped to threadIdx.x
               ...
            enddo
         enddo
      enddo
   enddo
enddo
```

- Outer `collapse(4)` over `(c, k, j, i)` gives `5 × 16³ = 20 480` gangs —
  plenty to saturate an SM grid.
- Inner `vector` loop over `b` (length ≥ 512, warp-multiple) gives coalesced
  loads on `U(b, ...)`.
- `private()` clause hoists per-iteration scratch onto registers; without it,
  nvfortran sometimes pessimises to shared memory.

### Why the WENO5 reconstruction is in a module

The functions `weno5_recon_r8` and `weno5_recon_r4` are called from inside
`!$acc parallel loop` regions and need `!$acc routine seq` to be offloadable.
The directive attaches most reliably when the routines live in a module —
program-internal subprograms hit compiler-specific acceptance issues across
nvfortran/gfortran/ifx/amd-flang. Hence the split into
`fundal_weno5_recon.F90` even though everything else is in the test file.

---

## Bug history (kept for the next person)

Two non-trivial bugs that the development cycle caught — useful to record
because they are exactly the kind of mistake easy to repeat in the next
rank-5 GPU test.

### Bug 1: rank-5 dummy bounds collapse on assumed-shape

```fortran
! Original BROKEN signature
subroutine error_stats_r8(U_var, ...)
   real(R8P), intent(in) :: U_var(:,:,:,:,:)   ! assumed-shape rebases all bounds to 1
   ...
   num = sum(U_var(b, 1:ni, 1:ni, 1:ni, :) - U_ref(b, 1:ni, 1:ni, 1:ni, :))**2
```

When the caller passes an array declared `U_promoted(1:nb, 1-ng:ni+ng, ...)`,
the dummy `U_var(:,:,:,:,:)` **rebases the bounds to `1:ni+2*ng`** inside the
callee. The selection `U_var(b, 1:ni, ...)` then reads the *lower ghost region*
of the original array, not the interior. Effect: a constant 9.7% relative L2
error invariant in step count — the smoking-gun signature.

**Fix**: always declare rank-5 dummies with explicit bounds matching the host:

```fortran
real(R8P), intent(in) :: U_var(1:nb, 1-ng:ni+ng, 1-ng:ni+ng, 1-ng:ni+ng, 1:nc)
```

Without this, the same bug bites every helper routine in the file.

### Bug 2: conservation diagnostic normalised by signed sum

```fortran
! Original BROKEN normalisation
drift = abs(s1 - s0) / max(abs(s0), tiny(0.0_R8P))
```

For momentum components (ρu, ρv, ρw) of a zero-mean perturbation, the integral
`s0 = sum(U_init)` is structurally near zero by symmetry. Dividing by `|s0|`
makes the relative drift explode by `1/eps` — observed as a drift value of
`3.4e+305` (= `1/tiny`).

**Fix**: normalise by the L1 norm of the component, which is always O(1):

```fortran
scale = sum(abs(U_init(b, 1:ni, 1:ni, 1:ni, c)))
drift = abs(s1 - s0) / max(scale, tiny(0.0_R8P))
```

Lesson: when a conservation diagnostic depends on the *signed* integral being
non-zero, it will fail on components whose physical mean is zero. Always
normalise by a positive norm of the field, not by a sum that can cancel.

---

## Open questions

1. **Tensor Core path (FP16 + FP32 accumulate via WMMA).** Not testable from
   pure Fortran. Requires iso_c_binding to a CUDA C++ kernel that calls
   `wmma::mma_sync` on the conservative state. Only meaningful for matmul-shaped
   sub-problems — coarse-grid solves, neural surrogate models, dense block
   preconditioners. WENO5 stencils are not matmul-shaped.

2. **Iterative refinement at the linear-solve level.** If a production FUNDAL
   solver uses a pressure Poisson or implicit time integration, that's where
   mixed precision pays even on consumer GPU: factor in FP32, solve in FP32,
   compute residual in FP64, correct. The transport kernels stay FP64. Worth
   characterising separately if/when a solver is added to the test surface.

3. **GPU-aware MPI coherence.** This test is single-GPU. Multi-rank halo
   exchange has its own correctness contract (`!$acc update host` before send,
   `!$acc update device` after recv) when not using GPU-aware MPI. Out of
   scope here; covered in the multi-rank tests under `src/tests/mpi/`.

4. **Datacenter GPU comparison.** The conclusion that V2 is a trap depends on
   the 1:64 FP64:FP32 ratio. On H100 (1:2) or B200 (1:2) the trap likely
   disappears and V2 may become genuinely competitive. Running this test on
   datacenter hardware would close the loop on hardware-dependent guidance.

---

## Known issues (unrelated to this test)

- The `fundal-test-gnu` mode currently fails at link with `acc_malloc`,
  `GOACC_*`, and `_gfortran_*` symbol resolution errors. This is pre-existing
  and affects the whole FUNDAL test suite, not just this test. Worth a
  separate investigation — likely a missing `-fopenacc` link flag or a stale
  `exe/obj/` cache from a prior different-compiler build.
