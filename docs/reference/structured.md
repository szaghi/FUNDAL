---
title: Structured memory
---

# Structured memory

Device memory referenced by Fortran pointers. Every procedure is generic over the kinds `R8P`, `R4P`, `I8P`, `I4P`,
`I2P`, `I1P` and the ranks 1 to 7; the signatures below show rank 1 of a `real(R8P)` array, written `VARTYPE(KKP)` where
the kind varies. The bound arrays (`ubounds`, `lbounds`, `bb`, `tb`) have one element (or column) per dimension.

[[toc]]

## dev_alloc {#dev-alloc}

```fortran
subroutine dev_alloc(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value, label)
VARTYPE(KKP), intent(out), pointer :: fptr_dev(:)
integer(I4P), intent(in)           :: ubounds(1)
integer(I4P), intent(out)          :: ierr
integer(I4P), intent(in), optional :: dev_id
integer(I4P), intent(in), optional :: lbounds(1)
VARTYPE(KKP), intent(in), optional :: init_value
character(*), intent(in), optional :: label
```

| Argument | Intent | Description |
|---|---|---|
| `fptr_dev` | out, pointer | Associated with the new device array, bounds `lbounds:ubounds`; null on failure |
| `ubounds` | in | Upper bounds |
| `ierr` | out | 0, or `FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED` (101) if the runtime returned no memory |
| `dev_id` | in, optional | OpenMP: device to allocate on (default `mydev`). OpenACC: not used, the buffer is allocated on the current device; a different `dev_id` is reported by a warning (unless the registry policy is `off`) |
| `lbounds` | in, optional | Lower bounds (default 1) |
| `init_value` | in, optional | Value given to every element, by a kernel on the device |
| `label` | in, optional | Name of the allocation in [`dev_alloc_report`](./registry#dev-alloc-report), up to 32 characters |

- `acc_malloc` (OpenACC), `omp_target_alloc` (OpenMP) or `malloc` (CPU mode); the size in bytes is computed from the
  kind and the bounds. Every allocation is recorded in the [registry](./registry) with its size, device and label.
- **Pointer-`allocate` semantics**: `fptr_dev` is `intent(out)`, so `dev_alloc` cannot see a buffer the pointer already
  holds; calling it on an associated pointer leaks that buffer. Free it first, or use
  [`dev_alloc_replace`](#dev-alloc-replace).
- Without `init_value` the contents are undefined.

<<< @/examples/snippets/memory-bounds.F90{fortran}

## dev_alloc_replace {#dev-alloc-replace}

```fortran
subroutine dev_alloc_replace(fptr_dev, ubounds, ierr, dev_id, lbounds, init_value, label)
VARTYPE(KKP), intent(inout), pointer :: fptr_dev(:)
integer(I4P), intent(in)             :: ubounds(1)
integer(I4P), intent(out)            :: ierr
integer(I4P), intent(in), optional   :: dev_id
integer(I4P), intent(in), optional   :: lbounds(1)
VARTYPE(KKP), intent(in), optional   :: init_value
character(*), intent(in), optional   :: label
```

The arguments of [`dev_alloc`](#dev-alloc); `fptr_dev` is `intent(inout)`. If `fptr_dev` is associated, its buffer is
freed first, on the device where the registry recorded it, then a new buffer is allocated.

- The actual argument must have a **defined association status**: declared `=>null()`, nullified, or allocated.
- The contents are **not preserved** (it is not `realloc`): undefined unless `init_value` is passed.
- `dev_id` is the device of the *new* buffer: a buffer can be moved to another device. It is not checked against the
  device of the old one.
- With the registry policy `error`, freeing a pointer the registry does not know fails: `ierr` is
  `FUNDAL_ERR_NOT_REGISTERED` (103) and nothing is allocated. With `warn` the old pointer is freed with a warning, with
  `off` without checks.

<<< @/examples/snippets/memory-replace.F90{fortran}

## dev_free {#dev-free}

```fortran
subroutine dev_free(fptr, dev_id, ierr)
VARTYPE(KKP), intent(inout), pointer :: fptr(:)
integer(I4P), intent(in),  optional  :: dev_id
integer(I4P), intent(out), optional  :: ierr
```

| Argument | Intent | Description |
|---|---|---|
| `fptr` | inout, pointer | Pointer from `dev_alloc`/`dev_alloc_replace`/`dev_assign_to_device`; nullified when freed. A null pointer is a no-op |
| `dev_id` | in, optional | Device the caller believes the buffer lives on: only checked against the registry |
| `ierr` | out, optional | 0, `FUNDAL_ERR_NOT_REGISTERED` (103) or `FUNDAL_ERR_DEV_ID_MISMATCH` (104); on error nothing is freed and `fptr` is unchanged |

The buffer is freed on the device where it was allocated, as recorded by the registry, whatever the current device
(OpenACC switches to it and back). What happens on a misuse depends on `ierr` and on the [registry policy](./registry#policy):

| Case | with `ierr`, policy `warn` or `error` | without `ierr`, policy `warn` (default) | without `ierr`, policy `error` | policy `off` |
|---|---|---|---|---|
| pointer not recorded (double free, alias, section, foreign pointer) | 103, nothing freed | warning, then freed anyway: OpenMP on `dev_id` (default `mydev`), OpenACC on the current device | `error stop` | freed without checks, `ierr` 0 |
| `dev_id` differs from the recorded device | 104, nothing freed | warning, freed on the recorded device | `error stop` | freed without checks: OpenMP on `dev_id`, OpenACC on the current device |

With policy `off` there are no checks: `ierr`, if present, is 0. Pass a pointer with a defined association status.

<<< @/examples/snippets/debugging-double-free.F90{fortran}

## Copies {#copies}

### dev_memcpy_to_device {#dev-memcpy-to-device}

```fortran
subroutine dev_memcpy_to_device(dst, src, ierr)
VARTYPE(KKP), intent(out), target             :: dst(:)
VARTYPE(KKP), intent(in),  target, contiguous :: src(:)
integer(I4P), intent(out), optional           :: ierr
```

| Argument | Intent | Description |
|---|---|---|
| `dst` | out, target | Device array: a FUNDAL buffer or a contiguous section of it |
| `src` | in, target, contiguous | Host array |
| `ierr` | out, optional | Error status: 0, `FUNDAL_ERR_NOT_CONTIGUOUS`, `FUNDAL_ERR_NOT_REGISTERED` or `FUNDAL_ERR_MEMCPY_FAILED`; nothing is copied on error |

### dev_memcpy_from_device {#dev-memcpy-from-device}

```fortran
subroutine dev_memcpy_from_device(dst, src, ierr)
VARTYPE(KKP), intent(out), target, contiguous :: dst(:)
VARTYPE(KKP), intent(in),  target             :: src(:)
integer(I4P), intent(out), optional           :: ierr
```

| Argument | Intent | Description |
|---|---|---|
| `dst` | out, target, contiguous | Host array |
| `src` | in, target | Device array: a FUNDAL buffer or a contiguous section of it |
| `ierr` | out, optional | As for `dev_memcpy_to_device` |

Rules of both copies:

- The number of bytes copied is that of the **source**; the size of the destination is not checked. Arrays of the same
  size, please.
- **The copy happens on the device where the buffer lives**, found in the [allocation registry](./registry): the whole
  buffer or a contiguous section of it (`a(i:j)`, `b(:,j)`). OpenACC makes that device current for the copy and
  restores the previous one; OpenMP passes it to `omp_target_memcpy`. Device memory the registry does not know (not
  allocated by FUNDAL), and every copy under policy `off`, is copied as before: on `mydev` (OpenMP), on the current
  device (OpenACC).
- **The device argument must be contiguous.** A strided section (`a(1:n:2)`) returns `FUNDAL_ERR_NOT_CONTIGUOUS` (105)
  with `ierr`; without `ierr` it is a registry misuse: a warning and the copy as before under policy `warn`, a stop
  under policy `error`. With nvfortran the routine never sees a strided argument: the compiler passes it through a
  contiguous host temporary, which reads device memory on the host. Do not pass strided device sections.
- A device range that ends beyond its allocation (pointer remapping) returns `FUNDAL_ERR_NOT_REGISTERED` (103); so does
  device memory not allocated by FUNDAL under policy `error`.
- The **host argument** may be any section: it is declared `contiguous`, so a strided host section is copied through a
  temporary made by the compiler.
- A copy the OpenMP runtime reports as failed returns `FUNDAL_ERR_MEMCPY_FAILED` (106), or stops without `ierr`
  (except under policy `off`, where it is ignored as before). OpenACC copies report no status.
- The CPU mode assigns the arrays.

<<< @/examples/snippets/heat_1-copy.F90{fortran}

### Transposed copies {#transposed-copies}

The copies also exist with a transposition, through a host buffer `buf` (contiguous), for ranks 2 to 7. They take the
same optional `ierr`, last, and follow the same rules; `buf` is the host side of the copy.

```fortran
! rank 2
subroutine dev_memcpy_from_device(bb, tb, dst, src, buf)
integer(I4P), intent(in)            :: bb(2,2)
integer(I4P), intent(in)            :: tb(2,2)
VARTYPE(KKP), intent(inout), target :: dst(tb(1,1):,tb(1,2):)
VARTYPE(KKP), intent(in),    target :: src(bb(1,1):,bb(1,2):)
VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,bb(1,2):)

subroutine dev_memcpy_to_device(bb, tb, dst, src, buf)
integer(I4P), intent(in)            :: bb(2,2)
integer(I4P), intent(in)            :: tb(2,2)
VARTYPE(KKP), intent(inout), target :: dst(bb(1,1):,bb(1,2):)
VARTYPE(KKP), intent(in),    target :: src(tb(1,1):,tb(1,2):)
VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,bb(1,2):)

! ranks 3 to 7 (rank 3 shown)
subroutine dev_memcpy_from_device(bb, ij, tb, dst, src, buf)
integer(I4P), intent(in)            :: bb(2,3)
integer(I4P), intent(in)            :: ij(2)
integer(I4P), intent(in)            :: tb(2,3)
VARTYPE(KKP), intent(inout), target :: dst(tb(1,1):,tb(1,2):,tb(1,3):)
VARTYPE(KKP), intent(in),    target :: src(bb(1,1):,bb(1,2):,bb(1,3):)
VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,bb(1,2):,bb(1,3):)

subroutine dev_memcpy_to_device(bb, ij, tb, dst, src, buf)
integer(I4P), intent(in)            :: bb(2,3)
integer(I4P), intent(in)            :: ij(2)
integer(I4P), intent(in)            :: tb(2,3)
VARTYPE(KKP), intent(inout), target :: dst(bb(1,1):,bb(1,2):,bb(1,3):)
VARTYPE(KKP), intent(in),    target :: src(tb(1,1):,tb(1,2):,tb(1,3):)
VARTYPE(KKP), intent(inout), target :: buf(bb(1,1):,bb(1,2):,bb(1,3):)
```

| Argument | Intent | Description |
|---|---|---|
| `bb` | in | Bounds of the device array: `bb(1,:)` lower, `bb(2,:)` upper |
| `ij` | in | Ranks 3 to 7: the two dimensions to swap (1-based) |
| `tb` | in | Bounds of the transposed host array (those of the device array with the dimensions `ij` swapped) |
| `dst` | inout, target | From device: the transposed host array. To device: the device array |
| `src` | in, target | From device: the device array. To device: the transposed host array |
| `buf` | inout, target | Host buffer with the shape of the device array |

`from_device` copies `src` into `buf`, then transposes `buf` into `dst`; `to_device` transposes `src` into `buf`, then
copies `buf` into `dst`. Rank 2 always swaps the two dimensions.

## Allocate and copy {#allocate-and-copy}

### dev_assign_to_device {#dev-assign-to-device}

```fortran
subroutine dev_assign_to_device(dst, src, ierr)
VARTYPE(KKP), intent(inout), pointer :: dst(:)
VARTYPE(KKP), intent(in)             :: src(:)
integer(I4P), intent(out), optional  :: ierr

subroutine dev_assign_to_device(lbounds, dst, src, ierr)   ! keeps the lower bounds
integer(I4P), intent(in)             :: lbounds            ! rank 1: a scalar; rank N: lbounds(N)
VARTYPE(KKP), intent(inout), pointer :: dst(:)
VARTYPE(KKP), intent(in)             :: src(lbounds:)
integer(I4P), intent(out), optional  :: ierr

subroutine dev_assign_to_device(dst, src, ij, ierr)        ! ranks 2 to 7: transposed
VARTYPE(KKP), intent(inout), pointer :: dst(:,:)
VARTYPE(KKP), intent(in)             :: src(:,:)
integer(I4P), intent(in)             :: ij(2)
integer(I4P), intent(out), optional  :: ierr
```

| Argument | Intent | Description |
|---|---|---|
| `lbounds` | in | Lower bounds of `src`, given to `dst` |
| `dst` | inout, pointer | Device array: (re)allocated by [`dev_alloc_replace`](#dev-alloc-replace) with the shape of `src`, then filled |
| `src` | in | Host array |
| `ij` | in | The two dimensions of `src` to swap; rank 2 always swaps the two |
| `ierr` | out, optional | 0, or the error of `dev_alloc_replace`; without `ierr` an error is an `error stop` |

- `dst` is **always** reallocated, even when the shape is unchanged; it must have a defined association status.
- Without `lbounds`, `src` is assumed-shape: `dst` gets **lower bounds 1**, whatever the bounds of the actual argument.
- The transposed form allocates `dst` with the shape of `src` with the dimensions `ij` swapped, lower bounds 1, and
  copies `src` transposed into it.
- The allocation has no label.

### dev_assign_from_device {#dev-assign-from-device}

```fortran
subroutine dev_assign_from_device(dst, src)
VARTYPE(KKP), intent(inout), allocatable :: dst(:)
VARTYPE(KKP), intent(in)                 :: src(:)

subroutine dev_assign_from_device(lbounds, dst, src)       ! keeps the lower bounds
integer(I4P), intent(in)                 :: lbounds        ! rank 1: a scalar; rank N: lbounds(N)
VARTYPE(KKP), intent(inout), allocatable :: dst(:)
VARTYPE(KKP), intent(in)                 :: src(lbounds:)

subroutine dev_assign_from_device(dst, src, ij)            ! ranks 2 to 7: transposed
VARTYPE(KKP), intent(inout), allocatable :: dst(:,:)
VARTYPE(KKP), intent(in)                 :: src(:,:)
integer(I4P), intent(in)                 :: ij(2)
```

| Argument | Intent | Description |
|---|---|---|
| `lbounds` | in | Lower bounds of `src`, given to `dst` |
| `dst` | inout, allocatable | Host array: deallocated if allocated, allocated with the shape of `src`, filled |
| `src` | in | Device array |
| `ij` | in | The two dimensions of `src` to swap; rank 2 always swaps the two |

The same bounds rule as `dev_assign_to_device`: without `lbounds`, `dst` has lower bounds 1.

<<< @/examples/snippets/heat_2-assign.F90{fortran}

<<< @/examples/output/heat_2.txt{text}

## Ownership contract {#ownership-contract}

| Routine | Pointer intent | On an associated pointer | The caller ensures |
|---|---|---|---|
| `dev_alloc` | out | **leaks** the buffer, like pointer `allocate` | the pointer holds no buffer |
| `dev_alloc_replace` | inout | frees (on the recorded device), then allocates | defined association status |
| `dev_assign_to_device` | inout | frees, allocates, copies | defined association status |
| `dev_free` | inout | frees on the recorded device, nullifies; no-op on a null pointer | defined association status; a buffer of FUNDAL |

`dev_alloc` keeps `intent(out)` on purpose: testing the association of an `intent(inout)` pointer would read an undefined
status for local pointers declared without `=>null()` (an initializer implies `save`, so it is often omitted).
