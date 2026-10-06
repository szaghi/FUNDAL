---
title: Global variables
---

# Global variables

Module variables of `fundal_env`, exported by `fundal`. They describe the device of the process; [`dev_init`](./devices#dev-init)
sets them. Read them; change them only if you know why (FUNDAL uses `mydev`, `myhos` and `devtype` in its calls).

| Variable | Type | Set by | Description |
|---|---|---|---|
| `mydev` | `integer(I4P)` | `dev_init` | Device of this process: default device for `dev_alloc` and copies on OpenMP, the device made current on OpenACC |
| `myhos` | `integer(I4P)` | `dev_init` | Host device number (`omp_get_initial_device()`, `acc_get_device_num(acc_device_host)`) |
| `devtype` | `integer(IDK)` | `dev_init`, OpenACC only | OpenACC device type of the queries; default `acc_device_default`. 0 and unused on OpenMP and in the CPU mode |
| `IDK` | `integer, parameter` | | Kind of `devtype`: `acc_device_kind` on OpenACC, `I4P` otherwise |
| `devs_number` | `integer(I4P)` | `dev_init` | Number of devices (`acc_get_num_devices(devtype)`, `omp_get_num_devices()`); stays 0 in the CPU mode |
| `dev_memory_avail` | `integer(I8P)` | `dev_init` | Device memory **free** when `dev_init` ran [bytes]: for diagnostics |
| `dev_memory_total` | `integer(I8P)` | `dev_init` | Device memory **total** [bytes]: a property of the device, reproducible, for sizing problems |
| `local_comm` | `integer(I4P)` | `mpih_object%initialize(do_device_init=.true.)` | MPI communicator of the ranks of this node; 0 otherwise |

All start at 0 (`devtype` at `acc_device_default` on OpenACC). The CPU-mode `dev_init` sets none of them. Both memory
values are 0 where [`dev_get_device_memory_info`](./devices#dev-get-device-memory-info) returns 0 (OpenMP without
`DEV_HIP`, CPU mode): guard against a zero budget.

`mpih_object` points its components `mydev`, `myhos`, `devtype`, `devs_number`, `dev_memory_avail`, `dev_memory_total`
and `local_comm` to these variables (see [MPI handler](./mpi#components)).
