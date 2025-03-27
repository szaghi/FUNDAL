/* cpp macros to setup backends */
#if defined DEV_OAC
#   define DEVMODULE openacc
#   if defined COMPILER_NVF
#      define DEVICEVAR deviceptr
#   elif defined COMPILER_GNU
#      define DEVICEVAR present
#   endif
#elif defined DEV_OMP
#   define DEVMODULE omp_lib
#   define DEVICEPTR(...) has_device_addr(__VA_ARGS__)
#   define DEVICEVAR(...) map(present,alloc:__VA_ARGS__)
#   define OMPLOOP target teams distribute parallel do
#else
#   define DEVMODULE omp_lib
#   define DEVICEVAR shared
#   define OMPLOOP parallel do
#endif
