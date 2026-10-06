---
title: Contributing
---

# Contributing

FUNDAL is free software: anyone interested in using, developing or contributing to it is welcome. The project follows
the KISS principle (keep it simple and stupid).

## Reporting issues

Open an issue on [GitHub](https://github.com/szaghi/FUNDAL/issues) with the compiler and its version, the backend
(`DEV_OAC`, `DEV_OMP`, CPU mode), the device, and the smallest program that shows the problem.

## Pull requests

1. Fork the repository and create a topic branch from `main`:
   ```bash
   git checkout -b fix/short-description main
   ```
2. Build and run the tests with the toolchain you have:
   ```bash
   fobis build --mode fundal-test-oac-gnu   # or another mode: fobis build --lmodes
   bash scripts/run_tests.sh
   ```
   or with make (no FoBiS): `make COMPILER=gnu BACKEND=oac tests`, then run the programs of `build/gnu-oac/tests/`.
   `exe/` is shared by every FoBiS mode: `fobis clean` before switching compiler or backend.
3. If the change touches the documented behaviour, update the pages and the [examples](#documentation-examples).
4. Check whitespace with `git diff --check`, and open the pull request against `main`.

## Tests

The tests are the programs of `src/tests` (see its
[README](https://github.com/szaghi/FUNDAL/blob/main/src/tests/README.md)). `scripts/run_tests.sh` runs every program
of `exe/` (those with `mpi` in the name under `mpirun -np 2`): a test passes when it exits with status 0 (and, if a
`<name>.result` file exists, prints its content). A test whose name contains `_xfail_` must exit with a non-zero
status. A new test should end with `error stop` on any failure, so that the exit status tells.

## Documentation examples

Every code sample and output of the documentation comes from a program of `docs/examples/src`, built and run by
`scripts/docs_examples.sh` (gfortran through the MPI wrapper `mpif90`, OpenACC backend, runs on the host). To add or
change an example:

1. Write or edit the program in `docs/examples/src/<name>.F90`: `implicit none`, kinds imported from `iso_fortran_env`,
   pointers declared `=>null()`, `ierr` checked, every device array freed, explicit print formats. Print only values
   that do not depend on the machine (no device names, memory sizes, timings, addresses) and make every kernel result
   checked by the printed output. An MPI program prints from rank 0 only.
2. Mark the parts shown in the pages with `!region NAME` ... `!endregion NAME`, and the runs with `!run ID COMMAND`
   (`!run -s ID COMMAND` also shows the exit status). MPI runs are `mpirun --oversubscribe -np 2 <name>`.
3. Run `bash scripts/docs_examples.sh` (with `MPIFC=/path/to/mpif90` if `mpif90` is not on `PATH`) and include the
   results in the pages: `<<< @/examples/snippets/<name>-<region>.F90{fortran}` and
   `<<< @/examples/output/<ID>.txt{text}`.
4. Commit the program and the regenerated `docs/examples/snippets` and `docs/examples/output`.

To preview the site: `cd docs && npm install && npx vitepress dev` (the API pages need `formal`, see
`fobis rule --ex makedoc`).

## Coding style

- Clarity over brevity; single-letter names only for loop counters; named constants.
- `implicit none` everywhere; an `intent` for every dummy argument; a `!<` comment for every entity.
- Indent with 3 spaces, no tabs, no trailing whitespace; `>`, `<`, `==` instead of `.gt.`, `.lt.`, `.eq.`.
- New generic procedures cover every kind and rank through the `*_agnostic.INC` templates of `src/lib`.

## Commit messages

[Conventional Commits](https://www.conventionalcommits.org/): `CHANGELOG.md` is generated from them by
[git-cliff](https://git-cliff.org/).

| Prefix | Purpose | Changelog section |
|---|---|---|
| `feat:` | new feature | Added |
| `fix:` | bug fix | Fixed |
| `perf:` | performance | Performance |
| `refactor:` | restructuring | Changed |
| `docs:` | documentation | Documentation |
| `test:`, `build:`, `ci:`, `chore:`, `style:` | tests, build system, workflows, maintenance | not listed |

Append `!` for breaking changes (`feat!:`); reference issues with `#N`. For example:

```text
feat(dev): add an optional stream argument to dev_memcpy_to_device
fix(dev_free): nullify the pointer when the registry policy is off
docs(tutorial): explain the halo exchange of chapter 6
```

## Workflows

| Workflow | When | What |
|---|---|---|
| `ci.yml` | every push and pull request | builds the tests with gfortran and OpenACC (`fundal-test-oac-gnu`, coverage) and runs them, on the host |
| `docs-examples.yml` | pushes to `main`, pull requests | runs `scripts/docs_examples.sh` and fails if `docs/examples` changes |
| `docs.yml` | pushes to `main` | coverage, API pages (formal), VitePress build, deployment to GitHub Pages |
| `release.yml` | tags `vX.Y.Z` | release tarball and GitHub release with the changelog section and `install.sh`; it runs no tests |
| `install.yml` | published releases | tries `install.sh` with make, CMake and fpm |

## Releases

```bash
scripts/release.sh --patch   # X.Y.Z -> X.Y.Z+1 (--minor, --major, or an explicit vX.Y.Z)
```

From an up-to-date, clean `main`, it regenerates `CHANGELOG.md` with git-cliff, updates `VERSION`, commits
`chore(release): vX.Y.Z`, creates the annotated tag and pushes both; the tag triggers `release.yml`. Document the
user-visible changes in [Upgrading](/project/upgrading) before releasing.
