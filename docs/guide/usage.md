---
title: Usage
---

# Usage

All examples use `use :: fundal` and assume `implicit none`.

## Initialisation

Always start by calling `dev_init`, which sets the global environment variables `myhos`, `devtype`, `mydev`, `devs_number`, and `dev_memory_avail` in one call:

```fortran
use :: fundal
call dev_init
```

For more control — or when the device ID is determined by MPI rank — initialise manually:

```fortran
use :: fundal
myhos   = dev_get_host_num()
devtype = dev_get_device_type()
call dev_set_device_num(0)     ! or: rank mod devs_number
mydev   = dev_get_device_num()
```

::: tip
After `dev_init`, inspect the device with `dev_get_property_string` before allocating large arrays to verify available memory.
:::

---

## Structured memory model

In the **structured** model, memory lives exclusively on the device and is referenced through a Fortran `pointer`. The host never sees the data unless you explicitly copy it.

```fortran
use, intrinsic :: iso_fortran_env, only : I4P=>int32, R8P=>real64
use            :: fundal

real(R8P), pointer     :: a_dev(:,:,:)=>null()   ! device memory
real(R8P), allocatable :: b_hos(:,:,:)            ! host   memory
integer(I4P)           :: ierr, i, j, k

call dev_init

! allocate on device with non-default lower bounds
call dev_alloc(fptr_dev=a_dev, lbounds=[-1,-2,-3], ubounds=[1,2,3], &
               init_value=0._R8P, ierr=ierr, dev_id=mydev)
if (ierr /= 0) error stop 'a_dev: allocation failed'

allocate(b_hos(-1:1,-2:2,-3:3))
b_hos = -3._R8P

call dev_memcpy_to_device(dst=a_dev, src=b_hos)

!$acc parallel loop independent deviceptr(a_dev) collapse(3)
!$omp target teams distribute parallel do collapse(3) has_device_addr(a_dev)
do k=-3,3; do j=-2,2; do i=-1,1
  a_dev(i,j,k) = a_dev(i,j,k) / 2._R8P
enddo; enddo; enddo

call dev_memcpy_from_device(dst=b_hos, src=a_dev)
call dev_free(a_dev)
```

::: warning
Device memory **must** be declared as `pointer`, never `allocatable`. Use `allocatable` for host-side arrays.
:::

---

## Unstructured memory model

In the **unstructured** model, a host `allocatable` array is *mapped* onto the device. The same variable name is valid in both host code and device kernels.

```fortran
use :: fundal
real(R8P), allocatable :: a(:,:,:)

call dev_init
allocate(a(-1:1,-2:2,-3:3))
a = -3._R8P

call dev_alloc_unstr(fptr_dev=a, init_value=0._R8P)  ! map to device

!$acc parallel loop collapse(3) present(a)
!$omp target teams distribute parallel do collapse(3)
do k=-3,3; do j=-2,2; do i=-1,1
  a(i,j,k) = a(i,j,k) / 2._R8P
enddo; enddo; enddo

call dev_memcpy_from_device_unstr(a)  ! copy back to host
call dev_free_unstr(a)
deallocate(a)
```

::: tip
Prefer the **unstructured model** when the array needs to remain valid on the host between kernel launches, or when integrating with existing host code that already manages the array lifetime.
:::

---

## Device arrays in derived types

Both device pointers and host allocatables can coexist as components of a derived type:

```fortran
type :: solver_data
   integer(I4P)           :: n = 1000
   real(R8P), pointer     :: a_dev(:)=>null()   ! device
   real(R8P), pointer     :: b_dev(:)=>null()   ! device
   real(R8P), allocatable :: a(:)               ! host
   real(R8P), allocatable :: b(:)               ! host
endtype solver_data

type(solver_data) :: s
integer(I4P)      :: ierr, i

call dev_init

allocate(s%a(s%n), s%b(s%n))
s%a = [(real(i, R8P), i=1, s%n)]

call dev_alloc(fptr_dev=s%a_dev, ubounds=[s%n], ierr=ierr)
call dev_alloc(fptr_dev=s%b_dev, ubounds=[s%n], ierr=ierr)

call dev_memcpy_to_device(src=s%a, dst=s%a_dev)

!$acc parallel loop deviceptr(s%a_dev, s%b_dev)
!$omp target teams distribute parallel do has_device_addr(s%a_dev, s%b_dev)
do i = 1, s%n
  s%b_dev(i) = s%a_dev(i) + 10._R8P
enddo

call dev_memcpy_from_device(src=s%b_dev, dst=s%b)
```

::: info
When passing device pointers that are derived-type components to OpenMP kernels, you may need `#ifdef DEV_OMP` to guard the `has_device_addr` clause, as some compilers handle it differently for component references.
:::

---

## External routines with device arrays

### Pointer (structured) approach

Declare the dummy argument as `target` with the same rank, and use `DEVICEVAR` / `has_device_addr`:

```fortran
subroutine compute_ptr(n, a)
  integer(I4P), intent(in)            :: n
  real(R8P),    intent(inout), target :: a(0:, 0:)   ! target is required

  !$acc parallel loop collapse(2) deviceptr(a)
  !$omp target teams distribute parallel do collapse(2) has_device_addr(a)
  do j = 0, n; do i = 0, n
    a(i,j) = real(i**3 - j**2, R8P)
  enddo; enddo
endsubroutine compute_ptr
```

Call site:

```fortran
real(R8P), pointer :: a_dev(:,:)
call dev_alloc(fptr_dev=a_dev, lbounds=[0,0], ubounds=[n,n], ierr=ierr)
call compute_ptr(n, a_dev)
```

### Unstructured approach

With host-mapped arrays, use `present` (OpenACC) or omit the clause (OpenMP):

```fortran
subroutine compute_unstr(n, a)
  integer(I4P), intent(in)            :: n
  real(R8P),    intent(inout), target :: a(0:, 0:)

  !$acc parallel loop collapse(2) present(a)
  !$omp target teams distribute parallel do collapse(2)
  do j = 0, n; do i = 0, n
    a(i,j) = real(i**3 - j**2, R8P)
  enddo; enddo
endsubroutine compute_unstr
```

::: warning
Do **not** pass non-contiguous array sections to device subroutines — this can cause illegal memory accesses. Copy to a contiguous local buffer first, or restructure the subroutine to accept scalar indices and the full array.
:::

---

## Reductions

Convergence loops that require a `max` or `sum` across threads work identically for both backends:

```fortran
real(R8P), pointer :: A(:,:), Anew(:,:)
real(R8P)          :: error = 1._R8P, tol = 1e-6_R8P

call dev_alloc(fptr_dev=A,    lbounds=[0,0], ubounds=[n-1,m-1], init_value=0._R8P, ierr=ierr)
call dev_alloc(fptr_dev=Anew, lbounds=[0,0], ubounds=[n-1,m-1], init_value=0._R8P, ierr=ierr)

do while (error > tol)
  error = 0._R8P

  !$acc parallel loop reduction(max:error) deviceptr(A, Anew)
  !$omp target teams distribute parallel do reduction(max:error) has_device_addr(A, Anew)
  do j = 1, m-2; do i = 1, n-2
    Anew(i,j) = 0.25_R8P * (A(i+1,j) + A(i-1,j) + A(i,j-1) + A(i,j+1))
    error = max(error, abs(Anew(i,j) - A(i,j)))
  enddo; enddo
enddo
```

::: tip
Reductions are available inside external subroutines too. Pass `error` with `intent(inout)` and declare it in the reduction clause.
:::

---

## Device enumeration

Iterate over all available devices to inspect them before assigning one per MPI rank:

```fortran
use :: fundal

integer(I4P)   :: i
character(999) :: prop

devtype     = dev_get_device_type()
myhos       = dev_get_host_num()
devs_number = dev_get_num_devices()
print '("host ID =",i3,",  devices available =",i3)', myhos, devs_number

do i = 0, devs_number - 1
  call dev_set_device_num(i)
  mydev = dev_get_device_num()
  call dev_get_property_string(dev_num=mydev, string=prop, prefix='  ')
  print '("  device",i2," :",A)', mydev, new_line('a')//trim(prop)
enddo
```

---

## MPI multi-device

Use `mpih_object` for MPI-enabled applications. It automatically binds each rank to a device and exposes global FUNDAL variables as pointers:

```fortran
use :: fundal
use :: fundal_mpih_object
use :: mpi

type(mpih_object) :: mpih
real(R8P), pointer :: a(:,:,:)=>null()

call mpih%initialize(do_mpi_init=.true., do_device_init=.true., verbose=.true.)

! rank-local allocation
call dev_alloc(fptr_dev=a, ubounds=[10,10,10], ierr=mpih%error, init_value=0._R8P)

call mpih%barrier

if (mpih%myrank == 0) then
  ! process 0 receives from process 1 into host buffer, then copies to device
  real(R8P), allocatable :: buf(:,:,:)
  allocate(buf(10,10,10))
  call MPI_RECV(buf, 1000, MPI_REAL8, 1, 100, MPI_COMM_WORLD, MPI_STATUS_IGNORE, mpih%error)
  call dev_memcpy_to_device(dst=a, src=buf)
endif

call mpih%finalize
```

::: tip
For direct GPU-to-GPU MPI transfers (without staging through host memory), wrap the `MPI_SEND`/`MPI_RECV` calls inside an `!$omp target data use_device_ptr(...)` region. Ensure your MPI library supports CUDA-aware or OpenMP-device-aware transfers before relying on this.
:::

---

## Memory status logging

`save_memory_status` records the current state of device memory to a log file — useful for tracking allocations across a time loop:

```fortran
use :: fundal

integer(I4P), pointer :: a(:,:,:)
integer(I4P)          :: ierr

call dev_init
call save_memory_status(file_name='mem.log', tag='before alloc :')
call dev_alloc(fptr_dev=a, ubounds=[100,100,100], ierr=ierr)
call save_memory_status(file_name='mem.log', tag='after  alloc :')
call dev_free(a)
call save_memory_status(file_name='mem.log', tag='after  free  :')
```

---

## HPC tips and warnings

### Loop ordering and memory coalescing

Fortran stores arrays in **column-major order** — the leftmost index is contiguous in memory. For CPU kernels, the innermost loop should vary the leftmost index:

```fortran
! GOOD for CPU: stride-1 access
do k = 1, nk; do j = 1, nj; do i = 1, ni
  arr(i, j, k) = ...
enddo; enddo; enddo
```

For GPU kernels with `collapse`, adjacent threads should access adjacent memory locations (same rule applies — the leftmost index should be in the innermost, fastest-varying loop position):

```fortran
!$acc parallel loop collapse(3) gang vector deviceptr(arr)
!$omp target teams distribute parallel do collapse(3) has_device_addr(arr)
do k = 1, nk; do j = 1, nj; do i = 1, ni
  arr(i, j, k) = ...        ! thread i accesses arr(i,...) — coalesced
enddo; enddo; enddo
```

::: warning
The `fundal_array_access_test` benchmark shows that loop ordering can have a measurable effect on GPU throughput. Profile with different `collapse` depths and loop orderings on your target hardware.
:::

### Minimise host-device data transfers

Each `dev_memcpy_to_device` / `dev_memcpy_from_device` call crosses the PCIe/NVLink bus. Structure your code so that data is allocated once, then operated on by multiple kernels before copying back:

```fortran
! GOOD: allocate once, run N kernels, copy back once
call dev_alloc(fptr_dev=a_dev, ..., ierr=ierr)
call dev_memcpy_to_device(dst=a_dev, src=a_hos)
do iter = 1, n_iter
  call kernel_1(a_dev)
  call kernel_2(a_dev)
enddo
call dev_memcpy_from_device(dst=a_hos, src=a_dev)
call dev_free(a_dev)
```

### Module-level variables in OpenACC

Scalar `parameter` constants are inlined at compile time and need no device handling. But module-level arrays — whether `parameter` or `allocatable` — must be explicitly declared for the device:

```fortran
module coefficients
  implicit none
  real(R8P), parameter :: FD1(5,5) = reshape([...], [5,5])
  !$acc declare copyin(FD1)       ! array parameter: needs copyin
end module

module state
  implicit none
  real(R8P), allocatable :: work(:,:)
  !$acc declare create(work)      ! allocatable: reserve device slot

contains
  subroutine init(n)
    integer, intent(in) :: n
    allocate(work(n,n))
    !$acc update device(work)     ! push data after host allocation
  end subroutine
  subroutine cleanup()
    !$acc exit data delete(work)
    deallocate(work)
  end subroutine
end module
```

::: warning
**FUNDAL device pointers are not the same as OpenACC managed arrays.** Variables allocated with `dev_alloc` live exclusively on the device and must be referenced via `deviceptr` (not `present` or `create`). Do not mix the two patterns for the same array.
:::

### Private clause for local variables in GPU kernels

Local variables (declared inside a subroutine) can be made `private` on the device, giving each thread its own copy:

```fortran
!$acc parallel loop collapse(3) private(stencil) deviceptr(q)
do k = 1, n; do j = 1, n; do i = 1, n
  stencil(:) = q(i-s:i+s, j, k)   ! local stencil buffer, one per thread
  q(i, j, k) = sum(stencil)
enddo; enddo; enddo
```

Module-level variables **cannot** be made `private` in OpenACC — the compiler will report *"No device symbol for address reference"*. Move such variables to local scope or use `dev_alloc` if they need to live on the device.

### Stale data pitfall

When using the unstructured model, any host modification after `dev_alloc_unstr` leaves the device copy stale. Update explicitly:

```fortran
call dev_alloc_unstr(fptr_dev=arr)
arr(:) = new_values              ! modifies host copy only
!$acc update device(arr)         ! synchronise device copy
!$acc parallel loop present(arr)
```

With FUNDAL's structured model (`dev_alloc` + `dev_memcpy_*`) this is explicit by construction — you always call the copy routine yourself.

### Debugging OpenACC on GPU

| Environment variable | Effect |
|----------------------|--------|
| `ACC_SYNCHRONOUS=1` | Forces synchronous kernel execution — errors surface immediately instead of asynchronously |
| `NV_ACC_DEBUG=1` | Verbose runtime output from the OpenACC runtime |

For memory errors, use `compute-sanitizer ./executable` (replaces `cuda-memcheck`). To verify that a host array is currently resident on the device, use `acc_is_present(arr, sizeof(arr))`.

::: tip
Enable compiler feedback to see which loops were actually parallelised:
- NVIDIA nvfortran: `-Minfo=accel`
- Intel IFX: `-qopt-report`

Avoid `!$acc kernels` without explicit `loop` directives — the compiler may not parallelise the loop optimally.
:::

### OpenMP debugging

| Technique | Command |
|-----------|---------|
| Bounds checking (GNU) | `-fbounds-check` or `-fcheck=all` |
| Bounds checking (Intel) | `-check bounds` |
| FP exceptions | `-ffpe-trap=invalid,zero,overflow` (GNU) |
| Stack size | `ulimit -s unlimited` (needed for deep recursion) |
| MPI + GPU deadlock | Reduce to 2 ranks; check for unmatched Send/Recv pairs |
