# Changelog

All notable changes to this project are documented here.
Versions follow [Semantic Versioning](https://semver.org/).
Format follows [Keep a Changelog](https://keepachangelog.com/).

## [2.1.1] — 2026-10-05
### Fixed
- **dev_handling**: Make host fallback explicit and fix dev_init crash


## [2.1.0] — 2026-10-05
### Added
- **dev_memcpy**: Add transposed device-to-host copy with lower-bound support

- **dev_handling**: Implement OpenMP device queries via HIP runtime

- **dev**: Publish total device memory alongside free

- **dev**: Add free-safe dev_alloc_replace and allocation accounting


### Documentation
- **precision**: Add LaTeX/PDF benchmark report with measured data

- **api**: Regenerate API reference

- **lib**: Explain direct C bindings to the OpenACC runtime


### Fixed
- **fobos**: Correct gcov-analyzer flag syntax in makecoverage-analysis rule

- **scripts**: Remove leading blank line before shebang in run_tests.sh

- **dev_memcpy**: Correct transpose_array argument order in device memcpy routines

- Correct dev_alloc standard violation and derived-type memcpy test under -fast

- **tests**: Move cpp directives to column 1 in derived-type memcpy test

- **dev_handling**: Initialize device state in dev_init

- **docs**: Untrack package-lock and pin esbuild for lock-free vite build

- **mpih**: Exit with nonzero status on error_stop

- **tests**: Use DEVICEVAR macro in laplace_dev_routine second loop


## [2.0.0] — 2026-03-05
### Added
- **dev_assign**: Add general transposed device-to-host assign variants


## [1.0.6] — 2026-03-02
### Added
- Add coverage analysis, install script, and project polish


## [1.0.5] — 2026-02-20
### Documentation
- Update Giacomo Rossi's email to AMD address


## [1.0.1] — 2026-02-20
### Added
- **devmemory**: Add device memory get info method

- **assign**: Add assign procedures, change memcpy API, add I2P support

- **assign-transposed**: Support transposed assign

- **assign-transposed**: Support transposed assign

- Add routine to save device memory status

- Add makefile to build static library (with only NVF)

- Add CI pipelines, VitePress docs site, and release tooling


### Changed
- **mpih**: Refactor mpi handler object for adam


### Documentation
- **README**: Refactor README documentation, complete API description


### Fixed
- Correct bug in device initialization

- Bug fix in dev_init


## [1.0.0-alpha] — 2024-09-12
### Documentation
- **README**: Improve README documentation



