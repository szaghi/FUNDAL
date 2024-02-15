<a name="top"></a>

# OAFML

> OpenACC Fortran Memory Library

### Authors

+ Francesco Salvadore, [f.salvadore@cineca.it](mailto:f.salvadore@cineca.it)
+ Andrea di Mascio, [andrea.dimascio@univaq.it](andrea.dimascio@univaq.it)
+ Giacomo Rossi, [giacomo.rossi@intel.com](giacomo.rossi@intel.com)
+ Stefano Zaghi, [stefano.zaghi@cnr.it](stefano.zaghi@cnr.it)

### Features

+ KISS, keep it simple and stupid;
+ easy handling OpenACC memory offloading on devices (GPU);
+ Fortran 2003+ with OpenACC directives standard compliant ;
+ Free, Open Source Project.

#### Issues

[![GitHub issues](https://img.shields.io/github/issues/szaghi/OAFML.svg)]()

#### Compiler Support

[![Compiler](https://img.shields.io/badge/NVidia-SDK-24.1.svg)]()

---

| [What is OAFML?](#what-is-oafml) | [Status](#status) | [Copyrights](#copyrights) | [A taste of OAFML](#a-taste-of-oafml) | [Documentation](#documentation) | [Install](#install) |

---

## What is OAFML?

OpenACC allows to manage device memory by means of runtime rutines, e.g. allocate and copy to/from device. These routines,
in general, handles C's pointers: OAFML provides a convenient fortran API to use OpenACC runtime routines handling C's data
in background simplifying end-user experience.

Go to [Top](#top)

## Status

Status of implemented API:

+ [x] acc_malloc
+ [x] acc_memcpy_to_device
+ [x] acc_memcpy_from_device
+ [x] acc_free
+ [ ] acc_device

Go to [Top](#top)

## Copyrights

OAFML is an open source project, it is distributed under a multi-licensing system:

+ for FOSS projects:
  - [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html);
+ for closed source/commercial projects:
  - [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause);
  - [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause);
  - [MIT](http://opensource.org/licenses/MIT).

Anyone is interest to use, to develop or to contribute is welcome, feel free to select the license that best matches your soul!

More details can be found on [wiki](https://github.com/szaghi/OAFML/wiki/Copyrights).

Go to [Top](#top)

## A taste of OAFML

To be written.

Go to [Top](#top)

## Documentation

To be written.

Go to [Top](#top)

## Install

To be written.

Go to [Top](#top)
