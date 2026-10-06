---
title: MPI handler
---

# MPI handler

```fortran
use fundal_mpih_object, only : mpih_object
```

`mpih_object` wraps the MPI calls of a multi-device code: initialization of MPI and of the device of each rank,
barriers with timing, aborts. The module uses the `mpi` module: it is built only with MPI (`make MPI=1`, the `mpi` FoBiS
modes) and compiled by the MPI wrapper. It uses `MPI_COMM_WORLD`.

[[toc]]

## Components

| Component | Type | Description |
|---|---|---|
| `error` | `integer(I4P)` | Error code of the last MPI call made by a method |
| `myrank` | `integer(I4P)` | Rank in `MPI_COMM_WORLD` |
| `procs_number` | `integer(I4P)` | Number of ranks |
| `hos_memory_avail` | `integer(I8P)` | Free host memory of the node (`MemFree` of `/proc/meminfo`, kB) divided by `procs_number`; meaningless without `/proc/meminfo` (Linux only) |
| `timing(1:2)` | `real(R8P)` | Times of the last tic and toc [s] |
| `tictoc` | `integer(I4P)` | Which of `timing` the next timed `barrier` sets |
| `req_send_recv(:)` | `integer(I4P), allocatable` | Request handles, `0:2*procs_number-1`, for the caller's non-blocking calls |
| `devs_number` | `integer(I4P), pointer` | Points to the global [`devs_number`](./globals) |
| `dev_memory_avail` | `integer(I8P), pointer` | Points to the global `dev_memory_avail` (free at `dev_init`) |
| `dev_memory_total` | `integer(I8P), pointer` | Points to the global `dev_memory_total` |
| `mydev` | `integer(I4P), pointer` | Points to the global `mydev` |
| `local_comm` | `integer(I4P), pointer` | Points to the global `local_comm` |
| `myhos` | `integer(I4P), pointer` | Points to the global `myhos` |
| `devtype` | `integer(IDK), pointer` | Points to the global `devtype` |
| `myrankstr` | `character(:), allocatable` | Rank tag for messages, `[mpi-00000]` |

The pointer components are associated by `initialize`.

## initialize {#initialize}

```fortran
subroutine initialize(self, do_mpi_init, do_device_init, myrankstr_char_length, verbose, require_device)
class(mpih_object), intent(out)          :: self
logical,            intent(in), optional :: do_mpi_init
logical,            intent(in), optional :: do_device_init
integer(I4P),       intent(in), optional :: myrankstr_char_length
logical,            intent(in), optional :: verbose
logical,            intent(in), optional :: require_device
```

| Argument | Intent | Description |
|---|---|---|
| `self` | out | The handler (reset to its default values) |
| `do_mpi_init` | in, optional | `.true.`: call `MPI_Init` (default: MPI already initialized by the caller) |
| `do_device_init` | in, optional | `.true.`: split `MPI_COMM_WORLD` by node (`MPI_COMM_TYPE_SHARED`) into `local_comm`, then `dev_init(local_rank=<rank in local_comm>, require_device=require_device)` |
| `myrankstr_char_length` | in, optional | Digits of the rank in `myrankstr` (default 5) |
| `verbose` | in, optional | `.true.`: print start/finish messages and `description()` |
| `require_device` | in, optional | Passed to `dev_init`: `.true.` stops the rank (error stop) if it has no device |

`local_comm` is set only with `do_device_init=.true.`. Without `do_device_init`, call
[`dev_init`](./devices#dev-init) yourself.

<<< @/examples/snippets/heat_6-init.F90{fortran}

## finalize {#finalize}

```fortran
subroutine finalize(self)
class(mpih_object), intent(inout) :: self
```

Calls `MPI_Finalize`.

## barrier {#barrier}

```fortran
subroutine barrier(self, tictoc, timing, single)
class(mpih_object), intent(inout)         :: self
logical,            intent(in),  optional :: tictoc
real(R8P),          intent(out), optional :: timing
logical,            intent(in),  optional :: single
```

| Argument | Intent | Description |
|---|---|---|
| `tictoc` | in, optional | `.true.`: after the barrier, store `MPI_Wtime()` in `timing(self%tictoc)` and alternate `self%tictoc` between 1 and 2 |
| `timing` | out, optional | The time stored (with `tictoc`) |
| `single` | in, optional | `.true.`: do not alternate `self%tictoc` |

Two timed barriers bracket a region; `tictoc_timing()` then returns its duration.

## tic, toc, tictoc_timing {#tic-toc}

```fortran
subroutine tic(self)
class(mpih_object), intent(inout) :: self

function toc(self) result(timing)
class(mpih_object), intent(inout) :: self
real(R8P)                         :: timing

function tictoc_timing(self) result(timing)
class(mpih_object), intent(in) :: self
real(R8P)                      :: timing
```

`tic` stores `MPI_Wtime()` in `timing(1)`, `toc` in `timing(2)` and returns `timing(2) - timing(1)`, which
`tictoc_timing` also returns. No barrier is involved.

## abort {#abort}

```fortran
subroutine abort(self, error_code, msg)
class(mpih_object), intent(inout)        :: self
integer(I4P),       intent(in), optional :: error_code
character(*),       intent(in), optional :: msg
```

| Argument | Intent | Description |
|---|---|---|
| `error_code` | in, optional | Code passed to `MPI_Abort` (default -101) |
| `msg` | in, optional | Written on standard error, after `myrankstr` and `abort` |

Calls `MPI_Abort(MPI_COMM_WORLD, ...)`: every rank stops.

## error_stop {#error-stop}

```fortran
subroutine error_stop(self, msg)
class(mpih_object), intent(inout)        :: self
character(*),       intent(in), optional :: msg
```

Writes `msg` on standard error, calls `MPI_Finalize` and stops with exit status 1. Only the calling rank stops:
`MPI_Finalize` is collective, so the other ranks must reach it too.

## print_message {#print-message}

```fortran
subroutine print_message(self, msg)
class(mpih_object), intent(in) :: self
character(*),       intent(in) :: msg
```

Prints `msg` on standard output, prefixed by `myrankstr`.

## description {#description}

```fortran
pure function description(self) result(desc)
class(mpih_object), intent(in) :: self
character(len=:), allocatable  :: desc
```

A multi-line summary of the handler, every line prefixed by `myrankstr`: rank, number of ranks, host memory [GB],
device memory free and total [GB], `local_comm`, `myhos`, `devtype`, `devs_number`, `mydev`. Call it after
`initialize`, which associates the pointer components; the device values are meaningful after `dev_init`.
