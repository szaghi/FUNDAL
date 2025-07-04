!< FUNDAL, memory free routines module.

#include "fundal.H"

#if defined DEV_OAC
#   define DEVFREE(p, d) call acc_free_f(p)
#elif defined DEV_OMP
#   define DEVFREE(p, d) call omp_target_free(p, d)
#else
#   define DEVFREE(p, d) call free_f(p)
#endif

module fundal_dev_free
!< FUNDAL, memory free routines module.
use, intrinsic :: iso_c_binding
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I2P=>int16, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: DEVMODULE
use            :: fundal_env,      only : mydev

implicit none
private
public :: dev_free

interface dev_free
   !< Free device memory OpenACC backend.
   module procedure dev_free_R8P_1D,&
                    dev_free_R8P_2D,&
                    dev_free_R8P_3D,&
                    dev_free_R8P_4D,&
                    dev_free_R8P_5D,&
                    dev_free_R8P_6D,&
                    dev_free_R8P_7D,&
                    dev_free_R4P_1D,&
                    dev_free_R4P_2D,&
                    dev_free_R4P_3D,&
                    dev_free_R4P_4D,&
                    dev_free_R4P_5D,&
                    dev_free_R4P_6D,&
                    dev_free_R4P_7D,&
                    dev_free_I8P_1D,&
                    dev_free_I8P_2D,&
                    dev_free_I8P_3D,&
                    dev_free_I8P_4D,&
                    dev_free_I8P_5D,&
                    dev_free_I8P_6D,&
                    dev_free_I8P_7D,&
                    dev_free_I4P_1D,&
                    dev_free_I4P_2D,&
                    dev_free_I4P_3D,&
                    dev_free_I4P_4D,&
                    dev_free_I4P_5D,&
                    dev_free_I4P_6D,&
                    dev_free_I4P_7D,&
                    dev_free_I2P_1D,&
                    dev_free_I2P_2D,&
                    dev_free_I2P_3D,&
                    dev_free_I2P_4D,&
                    dev_free_I2P_5D,&
                    dev_free_I2P_6D,&
                    dev_free_I2P_7D,&
                    dev_free_I1P_1D,&
                    dev_free_I1P_2D,&
                    dev_free_I1P_3D,&
                    dev_free_I1P_4D,&
                    dev_free_I1P_5D,&
                    dev_free_I1P_6D,&
                    dev_free_I1P_7D
endinterface dev_free

#ifdef DEV_OAC
interface
   ! interface to C runtime routines
   subroutine acc_free_f(dev_ptr) bind(c, name="acc_free")
   use iso_c_binding, only : c_ptr
   implicit none
   type(c_ptr), value :: dev_ptr
   endsubroutine acc_free_f
endinterface
#else
interface
   ! interface to C runtime routines
   subroutine free_f(dev_ptr) bind(c, name="free")
   use iso_c_binding, only : c_ptr
   implicit none
   type(c_ptr), value :: dev_ptr
   endsubroutine free_f
endinterface
#endif

contains
#define KKP R8P
#define VARTYPE real
#define DEV_FREE_KKP_1D dev_free_R8P_1D
#define DEV_FREE_KKP_2D dev_free_R8P_2D
#define DEV_FREE_KKP_3D dev_free_R8P_3D
#define DEV_FREE_KKP_4D dev_free_R8P_4D
#define DEV_FREE_KKP_5D dev_free_R8P_5D
#define DEV_FREE_KKP_6D dev_free_R8P_6D
#define DEV_FREE_KKP_7D dev_free_R8P_7D
#include "fundal_dev_free_agnostic.INC"

#define KKP R4P
#define VARTYPE real
#define DEV_FREE_KKP_1D dev_free_R4P_1D
#define DEV_FREE_KKP_2D dev_free_R4P_2D
#define DEV_FREE_KKP_3D dev_free_R4P_3D
#define DEV_FREE_KKP_4D dev_free_R4P_4D
#define DEV_FREE_KKP_5D dev_free_R4P_5D
#define DEV_FREE_KKP_6D dev_free_R4P_6D
#define DEV_FREE_KKP_7D dev_free_R4P_7D
#include "fundal_dev_free_agnostic.INC"

#define KKP I8P
#define VARTYPE integer
#define DEV_FREE_KKP_1D dev_free_I8P_1D
#define DEV_FREE_KKP_2D dev_free_I8P_2D
#define DEV_FREE_KKP_3D dev_free_I8P_3D
#define DEV_FREE_KKP_4D dev_free_I8P_4D
#define DEV_FREE_KKP_5D dev_free_I8P_5D
#define DEV_FREE_KKP_6D dev_free_I8P_6D
#define DEV_FREE_KKP_7D dev_free_I8P_7D
#include "fundal_dev_free_agnostic.INC"

#define KKP I4P
#define VARTYPE integer
#define DEV_FREE_KKP_1D dev_free_I4P_1D
#define DEV_FREE_KKP_2D dev_free_I4P_2D
#define DEV_FREE_KKP_3D dev_free_I4P_3D
#define DEV_FREE_KKP_4D dev_free_I4P_4D
#define DEV_FREE_KKP_5D dev_free_I4P_5D
#define DEV_FREE_KKP_6D dev_free_I4P_6D
#define DEV_FREE_KKP_7D dev_free_I4P_7D
#include "fundal_dev_free_agnostic.INC"

#define KKP I2P
#define VARTYPE integer
#define DEV_FREE_KKP_1D dev_free_I2P_1D
#define DEV_FREE_KKP_2D dev_free_I2P_2D
#define DEV_FREE_KKP_3D dev_free_I2P_3D
#define DEV_FREE_KKP_4D dev_free_I2P_4D
#define DEV_FREE_KKP_5D dev_free_I2P_5D
#define DEV_FREE_KKP_6D dev_free_I2P_6D
#define DEV_FREE_KKP_7D dev_free_I2P_7D
#include "fundal_dev_free_agnostic.INC"

#define KKP I1P
#define VARTYPE integer
#define DEV_FREE_KKP_1D dev_free_I1P_1D
#define DEV_FREE_KKP_2D dev_free_I1P_2D
#define DEV_FREE_KKP_3D dev_free_I1P_3D
#define DEV_FREE_KKP_4D dev_free_I1P_4D
#define DEV_FREE_KKP_5D dev_free_I1P_5D
#define DEV_FREE_KKP_6D dev_free_I1P_6D
#define DEV_FREE_KKP_7D dev_free_I1P_7D
#include "fundal_dev_free_agnostic.INC"
endmodule fundal_dev_free
