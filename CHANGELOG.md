# Changelog
## [v1.0.4](https://github.com/szaghi/FLAP/tree/v1.0.4) (2026-02-20)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.0.3...v1.0.4)
### CI/CD
- Switch to official github pages actions deployment ([`8442804`](https://github.com/szaghi/FLAP/commit/8442804c3db11722dd214d5304b4fb0c11ccadd5))

## [v1.0.3](https://github.com/szaghi/FLAP/tree/v1.0.3) (2026-02-20)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.0.2...v1.0.3)
### CI/CD
- Fix broken docs deployment workflow ([`0fd44ca`](https://github.com/szaghi/FLAP/commit/0fd44ca1b14a0b1aaca35d9006e85c71404b1d21))

## [v1.0.2](https://github.com/szaghi/FLAP/tree/v1.0.2) (2026-02-20)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.0.1...v1.0.2)
### CI/CD
- Remove coverage analysis workflow and simplify CI pipeline ([`61f1d18`](https://github.com/szaghi/FLAP/commit/61f1d181c13218475e7ab49ecd09e5b6230534a7))

## [v1.0.1](https://github.com/szaghi/FLAP/tree/v1.0.1) (2026-02-20)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.0.0-alpha...v1.0.1)
### Bug fixes
- Correct bug in device initialization ([`1b9e302`](https://github.com/szaghi/FLAP/commit/1b9e302a0ad4829eadeca3954efde0a485f06d4a))
- Bug fix in dev_init ([`87124a8`](https://github.com/szaghi/FLAP/commit/87124a8429723c04128ee95b541514769dda539b))

### Documentation
- Refactor README documentation, complete API description ([`1bccb22`](https://github.com/szaghi/FLAP/commit/1bccb22e1338cd6746b1bbf496432a9f9e908671))

### Miscellaneous
- Update nvidia cc version for ADM ([`0556bb0`](https://github.com/szaghi/FLAP/commit/0556bb0282452f16ac2f9546c5b9979a799f79f1))
- Add c_int ([`4ee7dd9`](https://github.com/szaghi/FLAP/commit/4ee7dd973e218d64d26e1110ae285cfd828b6f2f))
- Remove unnecessary macro definitions ([`61cf3c1`](https://github.com/szaghi/FLAP/commit/61cf3c1261c69b24cd57d618fdfaff51e07e262a))
- Add AMD compiler temporary workaround for has_device_add ([`41a2e90`](https://github.com/szaghi/FLAP/commit/41a2e90a36f6c8a65decaad19df61818456bc4a9))
- Add AMD Flang compiler and remove IFX compiler preprocessing macro ([`6b46a9a`](https://github.com/szaghi/FLAP/commit/6b46a9a0942a3d537b0cd43f42e64ce18a0c1b57))
- Remove workaround for has_device_addr clause not supported by AMD compiler ([`ae3c980`](https://github.com/szaghi/FLAP/commit/ae3c9803bb22f0626f0568dcc281b793e2de87aa))
- Introduced map for mapped variable, has_device_addr for device pointers only ([`d82a3b3`](https://github.com/szaghi/FLAP/commit/d82a3b37b5ad031ddac20bb4a064d9863a1b0f71))
- Remove DEVICEVAR clause from OpenMP loops: ifx and gfortran preprocessors cannot expand VA_ARGS macro ([`f997a23`](https://github.com/szaghi/FLAP/commit/f997a23f516f185570a5a7501d1c263364f8018e))
- Add some compilers proofs tests ([`4830b2b`](https://github.com/szaghi/FLAP/commit/4830b2b407000da88d1c967a3624d3062b6c82cc))
- Support transposed assign for all ranks ([`525d93f`](https://github.com/szaghi/FLAP/commit/525d93fe1c72aa504d7f7880893261cb268d9d3b))
- Exploit cpp preprocessor to reduce code verbosity ([`d99e29f`](https://github.com/szaghi/FLAP/commit/d99e29f4eb8dceef07912fe09261f0c9bb8a4129))

### New features
- Add device memory get info method ([`0c12b07`](https://github.com/szaghi/FLAP/commit/0c12b0754744e6413cc3a688d05f808428dc3f9e))
- Add assign procedures, change memcpy API, add I2P support ([`f6be6ec`](https://github.com/szaghi/FLAP/commit/f6be6ec541ebfacbc5ae4c8645da8c89d28a62da))
- Support transposed assign ([`b7b31ad`](https://github.com/szaghi/FLAP/commit/b7b31ad5182d42780691bfc5503ee32ddf484650))
- Support transposed assign ([`bf7d7f3`](https://github.com/szaghi/FLAP/commit/bf7d7f351a8a5decfaac40a7336ba2b8e29b2c4b))
- Add routine to save device memory status ([`c857163`](https://github.com/szaghi/FLAP/commit/c85716394743165fd407a423c1b60fe11be04361))
- Add makefile to build static library (with only NVF) ([`32ea531`](https://github.com/szaghi/FLAP/commit/32ea5314433960e2f5e070ad9ff3f98e690f7de3))
- Add CI pipelines, VitePress docs site, and release tooling ([`eb42cf9`](https://github.com/szaghi/FLAP/commit/eb42cf922f8ccbf4d34f6caae82161d717212dd8))

### Refactoring
- Refactor mpi handler object for adam ([`5a6c0d9`](https://github.com/szaghi/FLAP/commit/5a6c0d93aee7e7c251b6283c710129c7ddd30c0e))

## [v1.0.0-alpha](https://github.com/szaghi/FLAP/tree/v1.0.0-alpha) (2024-09-12)
### Documentation
- Improve README documentation ([`0889028`](https://github.com/szaghi/FLAP/commit/08890282df8941bd0713bdf1cc3e08e95d299251))

### Miscellaneous
- Start ([`fba31c2`](https://github.com/szaghi/FLAP/commit/fba31c2f98e9b5ae49e7be4f1f0524099d37e727))
- Update readme ([`2d35af2`](https://github.com/szaghi/FLAP/commit/2d35af2505d1b2c3976c53c5d048dd57a5ecba5d))
- Clean memcpy test ([`4b50d7d`](https://github.com/szaghi/FLAP/commit/4b50d7d95c69a5834a2c15f79b75c0533c08fc85))
- Clean memcpy test comments ([`eb74517`](https://github.com/szaghi/FLAP/commit/eb74517efd82e5b6a017bb637fcbbecf1ee25f7c))
- Add memcpy test for derived type memory

Add memcpy test for derived type memory ([`86dee45`](https://github.com/szaghi/FLAP/commit/86dee456f4b75cb51d38eeb26807651ecce3ef3f))
- Use fptr_dev in alloc routine as storage_size argument ([`69ec34e`](https://github.com/szaghi/FLAP/commit/69ec34ecfbaf5ad19da79d8b1f0fdb699adc4762))
- Fix variable name ([`11f7326`](https://github.com/szaghi/FLAP/commit/11f7326d0d987b426780b2b459ff4dccb768f05c))
- Add openacc specifications doc ([`2a65b9a`](https://github.com/szaghi/FLAP/commit/2a65b9a7095d1357067b0b1f1c62ceb17d005aa7))
- Add all rank alloc for R8P and R4P

Add all rank alloc for R8P and R4P: add procedures for all ranks (up to
7) for R8P and R4P kinds, tested only alloc, memcpy to be tested. ([`ca573c2`](https://github.com/szaghi/FLAP/commit/ca573c2137e256b0e699ac18584591ef803ee03e))
- Complete memcpy for all real kinds and ranks

Complete memcpy for all real kinds and ranks ([`3708a5c`](https://github.com/szaghi/FLAP/commit/3708a5ca71f2372a50dee41e4b8758f29fda6796))
- Complete alloc/memcpy for reals and integers

Complete alloc/memcpy for reals and integers: complete implementation
and test of acc_malloc/acc_memcpy_from_device/acc_memcpy_to_device
wrappers for R8P, R4P, I8P, I4P, I1P of all rank (up to rank 7). ([`cc0c05e`](https://github.com/szaghi/FLAP/commit/cc0c05e8061ac7eecaaa5de6bfd1948dc3d35e19))
- Update readme ([`8be29a0`](https://github.com/szaghi/FLAP/commit/8be29a00437f0d396f48a5bfe3c9e3902781c819))
- Complete free routines ([`52a4dbc`](https://github.com/szaghi/FLAP/commit/52a4dbc0cac7df5da3433198d5669b79caeb86bb))
- Update readme ([`2330b8e`](https://github.com/szaghi/FLAP/commit/2330b8ed204ff08812df40abfed0448f8bf26b56))
- Add some runtime routines for multi devices

Add some runtime routines for multi devices

Side effects: the acc_get_num_devices seems to not work on my laptop ([`b872b57`](https://github.com/szaghi/FLAP/commit/b872b57ed53135227aeda5edf91e8988f473b1b1))
- Rename library before integrate OpenMP offloading

Rename library before integrate OpenMP offloading ([`cc767fc`](https://github.com/szaghi/FLAP/commit/cc767fc0dc64476dbd3c0819ae2878f6613e40ba))
- Refactor library in modules

Refactor library in modules: split library in modules and exploit
pre-processor to switch between OpenACC/OpenMP. ([`3c369a5`](https://github.com/szaghi/FLAP/commit/3c369a585eec73d88ddc8b447ebe38e07518be7c))
- Adopt dst-src convention for memcpy

Adopt dst-src convention for memcpy: even if passing out-dummy before
in-dummy sounds odd to me I have changed the memcpy API convention
passing dst pointer (out) before src pointer (in). ([`dc98bd1`](https://github.com/szaghi/FLAP/commit/dc98bd1d730f88266bb85a81f28bde432a08470e))
- OpenMP backend improvement

OpenMP backend improvement: add many runtime routines of the OpenMP
backend.

Seamless Unified API improvement:

+ dev_alloc unified API
+ dev_free  unified API
+ dev_memcpy NOT yet unified
+ device handling NOT yet unified

OpenMP backend has currently only one test (aside the trivial use test),
the alloc_free test. ([`bc6af93`](https://github.com/szaghi/FLAP/commit/bc6af93cf7026754bcddacb9abddbb1ec67abc9c))
- Unified API almost complete (for the basic aims)

Unified API almost complete (for the basic aims): device handling,
memory allocation and copy are now unified, the seamless integration of
OpenACC and OpenMP backends is near to be completed.

A taste examples has been added and reported into the README (also
improved with some documentation).

All the tests can now be compiled with both backends, but only OpenACC
are also been executed and checked, the OpenMP compiled tests are not
yet executed on Intel GPUs. ([`d1a5326`](https://github.com/szaghi/FLAP/commit/d1a5326d797bef4e71f246ad20f4035d2fee78f9))
- Fix bugs in openmp backend

Fix bugs in openmp backend and add script and FoBiS rules to
automatically run tests. ([`7b66e60`](https://github.com/szaghi/FLAP/commit/7b66e6027443d34214fa7737b78784219f1c4d92))
- Update readme ([`8f29a1c`](https://github.com/szaghi/FLAP/commit/8f29a1cc13a462fed552723a6ad4e48c282c4fc7))
- Partially support GNU gfortran and improve documentation

Partially support GNU gfortran and improve documentation ([`7ee2b2f`](https://github.com/szaghi/FLAP/commit/7ee2b2f6984c87ecc273dd0dc8e6184981c0f706))
- Improve fobos, doc and laplace case study

Improve fobos, doc and laplace case study ([`983056e`](https://github.com/szaghi/FLAP/commit/983056e7aa458d2b355046bb8c142197527e7616))
- Add host fallback backend

Add host fallback backend: refactor library sources, all backends
defined in single files without splitting for backends exploiting few
cpp macros; added *host fallback* backend wichi allocate/deallocate/copy
memory on host instead of device (with some support for OpenMP multi
thread parallelization on host).

Many of the *magic things* happens including fundal.H macros definition. ([`2ead60c`](https://github.com/szaghi/FLAP/commit/2ead60c60e0fe447ae4f148dcc19e8d47326246a))
- Add MPI test

Add MPI test: compile, but do not work as expected (at least
completely). ([`4f8f02a`](https://github.com/szaghi/FLAP/commit/4f8f02abf3e9548014336a11313907ad3b15beb8))
- Change tags mpi test ([`243d939`](https://github.com/szaghi/FLAP/commit/243d9395285851cb70d75e4e3aa2dec79a400200))
- Implement unstructured memory approach suggested by Mat Colgrove (NVIDIA DEV Mod)

Add unstructured memory approach as suggested by Mat: FUNDAL API
expanded to enable the "unstructured memory approach" exploiting "acc
data enter/exit/update" pragmas encapsulated in runtime routines
equivalent to the "pointer memory approach".

Why:

Overcoming NVIDIA SDK bugs on MPI comm  with pointer memory approach

Side effects:

Unified API incomplete: the equivalent OpenMP unstructured memory still
missing. ([`0f343f3`](https://github.com/szaghi/FLAP/commit/0f343f31108f40bca572393e65ddd91206e0e964))
- Add OpenMP directives to unstructured routines ([`9e854bb`](https://github.com/szaghi/FLAP/commit/9e854bb2bf5364a8c01932ccb5255731fbb04cd2))
- Fix variable names in some OpenMP pragmas ([`9bd16e9`](https://github.com/szaghi/FLAP/commit/9bd16e9dbb7aa3009a458089620399641fe0e650))
- Add fobos oac-mpi-nvf-debug rules ([`3ed3408`](https://github.com/szaghi/FLAP/commit/3ed34080b6197703c97678dfde820b988462c37b))
- Add deviceptr multi GPU MPI test

Add deviceptr multi GPU MPI test.

Note: for RTX 4070 GPUs the following envinronment setting is necessary

export UCX_MEMTYPE_CACHE=n

See https://forums.developer.nvidia.com/t/mpi-send-openacc-acc-malloc-fail-with-nvfortran-but-work-with-c/305839/1 ([`4509d93`](https://github.com/szaghi/FLAP/commit/4509d93476b86416630e5490eb0e588caec075b9))
- Add dev_init method in device handling

Add dev_init method in device handling ([`305bbf7`](https://github.com/szaghi/FLAP/commit/305bbf79890b8dba8d30bb0aaf2d44b1adabe0df))
- Add MPI handler object ([`3d35ad1`](https://github.com/szaghi/FLAP/commit/3d35ad102601095ab3b0d8469678a0c7d12cdee5))


