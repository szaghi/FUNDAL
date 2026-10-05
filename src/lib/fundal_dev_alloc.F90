!< FUNDAL, memory allocation routines module.

#include "fundal.H"

#if defined DEV_OAC
#   define DEVALLOC(b, d) acc_malloc_f(b)
#elif defined DEV_OMP
#   define DEVALLOC(b, d) omp_target_alloc(b, d)
#else
#   define DEVALLOC(b, d) malloc_f(b)
#endif

module fundal_dev_alloc
!< FUNDAL, memory allocation routines module.
use, intrinsic :: iso_c_binding,   only : c_size_t, c_int, c_ptr, c_associated, c_f_pointer
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I2P=>int16, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: DEVMODULE
use            :: fundal_env
use            :: fundal_utilities

implicit none
private
public :: dev_alloc
public :: FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED

integer(I4P), parameter :: FUNDAL_ERR_FPTR_DEV_NOT_ALLOCATED=101 !< Error flag, not allocated device memory.

interface dev_alloc
   !< Allocate device memory.
   module procedure dev_alloc_R8P_1D,&
                    dev_alloc_R8P_2D,&
                    dev_alloc_R8P_3D,&
                    dev_alloc_R8P_4D,&
                    dev_alloc_R8P_5D,&
                    dev_alloc_R8P_6D,&
                    dev_alloc_R8P_7D,&
                    dev_alloc_R4P_1D,&
                    dev_alloc_R4P_2D,&
                    dev_alloc_R4P_3D,&
                    dev_alloc_R4P_4D,&
                    dev_alloc_R4P_5D,&
                    dev_alloc_R4P_6D,&
                    dev_alloc_R4P_7D,&
                    dev_alloc_I8P_1D,&
                    dev_alloc_I8P_2D,&
                    dev_alloc_I8P_3D,&
                    dev_alloc_I8P_4D,&
                    dev_alloc_I8P_5D,&
                    dev_alloc_I8P_6D,&
                    dev_alloc_I8P_7D,&
                    dev_alloc_I4P_1D,&
                    dev_alloc_I4P_2D,&
                    dev_alloc_I4P_3D,&
                    dev_alloc_I4P_4D,&
                    dev_alloc_I4P_5D,&
                    dev_alloc_I4P_6D,&
                    dev_alloc_I4P_7D,&
                    dev_alloc_I2P_1D,&
                    dev_alloc_I2P_2D,&
                    dev_alloc_I2P_3D,&
                    dev_alloc_I2P_4D,&
                    dev_alloc_I2P_5D,&
                    dev_alloc_I2P_6D,&
                    dev_alloc_I2P_7D,&
                    dev_alloc_I1P_1D,&
                    dev_alloc_I1P_2D,&
                    dev_alloc_I1P_3D,&
                    dev_alloc_I1P_4D,&
                    dev_alloc_I1P_5D,&
                    dev_alloc_I1P_6D,&
                    dev_alloc_I1P_7D
endinterface dev_alloc

#ifdef DEV_OAC
! OpenACC runtime routines are bound directly to their C API (void*, size_t) on purpose, instead of being taken from the
! vendor `openacc` module, whose Fortran interfaces are not portable (verified on nvhpc 26.1 and gfortran 16, see #2):
! - nvfortran declares acc_malloc/acc_free/acc_memcpy_* with the NVIDIA-only type(c_devptr), not type(c_ptr);
! - gfortran declares the host side of acc_memcpy_* as type(*), dimension(*): passing c_loc(x) compiles, but copies the
!   bytes of the temporary c_ptr instead of the data.
! The C symbols are defined by the OpenACC specification and exported by every implementation. The `_f` suffix avoids
! clashing with the names exported by the vendor module (used via DEVMODULE).
interface
   ! interface to C runtime routines
   function acc_malloc_f(total_byte_dim) bind(c, name="acc_malloc")
   use iso_c_binding, only : c_ptr, c_size_t
   implicit none
   type(c_ptr)                          :: acc_malloc_f
   integer(c_size_t), value, intent(in) :: total_byte_dim
   endfunction acc_malloc_f
endinterface
#else
interface
   ! interface to C runtime routines
   function malloc_f(total_byte_dim) bind(c, name="malloc")
   use iso_c_binding, only : c_ptr, c_size_t
   implicit none
   type(c_ptr)                          :: malloc_f
   integer(c_size_t), value, intent(in) :: total_byte_dim
   endfunction malloc_f
endinterface
#endif

contains
#define KKP R8P
#define VARTYPE real
#define DEV_ALLOC_KKP_1D dev_alloc_R8P_1D
#define DEV_ALLOC_KKP_2D dev_alloc_R8P_2D
#define DEV_ALLOC_KKP_3D dev_alloc_R8P_3D
#define DEV_ALLOC_KKP_4D dev_alloc_R8P_4D
#define DEV_ALLOC_KKP_5D dev_alloc_R8P_5D
#define DEV_ALLOC_KKP_6D dev_alloc_R8P_6D
#define DEV_ALLOC_KKP_7D dev_alloc_R8P_7D
#include "fundal_dev_alloc_agnostic.INC"

#define KKP R4P
#define VARTYPE real
#define DEV_ALLOC_KKP_1D dev_alloc_R4P_1D
#define DEV_ALLOC_KKP_2D dev_alloc_R4P_2D
#define DEV_ALLOC_KKP_3D dev_alloc_R4P_3D
#define DEV_ALLOC_KKP_4D dev_alloc_R4P_4D
#define DEV_ALLOC_KKP_5D dev_alloc_R4P_5D
#define DEV_ALLOC_KKP_6D dev_alloc_R4P_6D
#define DEV_ALLOC_KKP_7D dev_alloc_R4P_7D
#include "fundal_dev_alloc_agnostic.INC"

#define KKP I8P
#define VARTYPE integer
#define DEV_ALLOC_KKP_1D dev_alloc_I8P_1D
#define DEV_ALLOC_KKP_2D dev_alloc_I8P_2D
#define DEV_ALLOC_KKP_3D dev_alloc_I8P_3D
#define DEV_ALLOC_KKP_4D dev_alloc_I8P_4D
#define DEV_ALLOC_KKP_5D dev_alloc_I8P_5D
#define DEV_ALLOC_KKP_6D dev_alloc_I8P_6D
#define DEV_ALLOC_KKP_7D dev_alloc_I8P_7D
#include "fundal_dev_alloc_agnostic.INC"

#define KKP I4P
#define VARTYPE integer
#define DEV_ALLOC_KKP_1D dev_alloc_I4P_1D
#define DEV_ALLOC_KKP_2D dev_alloc_I4P_2D
#define DEV_ALLOC_KKP_3D dev_alloc_I4P_3D
#define DEV_ALLOC_KKP_4D dev_alloc_I4P_4D
#define DEV_ALLOC_KKP_5D dev_alloc_I4P_5D
#define DEV_ALLOC_KKP_6D dev_alloc_I4P_6D
#define DEV_ALLOC_KKP_7D dev_alloc_I4P_7D
#include "fundal_dev_alloc_agnostic.INC"

#define KKP I2P
#define VARTYPE integer
#define DEV_ALLOC_KKP_1D dev_alloc_I2P_1D
#define DEV_ALLOC_KKP_2D dev_alloc_I2P_2D
#define DEV_ALLOC_KKP_3D dev_alloc_I2P_3D
#define DEV_ALLOC_KKP_4D dev_alloc_I2P_4D
#define DEV_ALLOC_KKP_5D dev_alloc_I2P_5D
#define DEV_ALLOC_KKP_6D dev_alloc_I2P_6D
#define DEV_ALLOC_KKP_7D dev_alloc_I2P_7D
#include "fundal_dev_alloc_agnostic.INC"

#define KKP I1P
#define VARTYPE integer
#define DEV_ALLOC_KKP_1D dev_alloc_I1P_1D
#define DEV_ALLOC_KKP_2D dev_alloc_I1P_2D
#define DEV_ALLOC_KKP_3D dev_alloc_I1P_3D
#define DEV_ALLOC_KKP_4D dev_alloc_I1P_4D
#define DEV_ALLOC_KKP_5D dev_alloc_I1P_5D
#define DEV_ALLOC_KKP_6D dev_alloc_I1P_6D
#define DEV_ALLOC_KKP_7D dev_alloc_I1P_7D
#include "fundal_dev_alloc_agnostic.INC"
endmodule fundal_dev_alloc
