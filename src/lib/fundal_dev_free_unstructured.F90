!< FUNDAL, memory free routines module, unstructured model.

#include "fundal.H"

module fundal_dev_free_unstructured
!< FUNDAL, memory free routines module, unstructured model.
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I2P=>int16, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64

implicit none
private
public :: dev_free_unstr

interface dev_free_unstr
   !< Free device memory, unstructured model.
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
endinterface dev_free_unstr

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
#include "fundal_dev_free_unstructured_agnostic.INC"

#define KKP R4P
#define VARTYPE real
#define DEV_FREE_KKP_1D dev_free_R4P_1D
#define DEV_FREE_KKP_2D dev_free_R4P_2D
#define DEV_FREE_KKP_3D dev_free_R4P_3D
#define DEV_FREE_KKP_4D dev_free_R4P_4D
#define DEV_FREE_KKP_5D dev_free_R4P_5D
#define DEV_FREE_KKP_6D dev_free_R4P_6D
#define DEV_FREE_KKP_7D dev_free_R4P_7D
#include "fundal_dev_free_unstructured_agnostic.INC"

#define KKP I8P
#define VARTYPE integer
#define DEV_FREE_KKP_1D dev_free_I8P_1D
#define DEV_FREE_KKP_2D dev_free_I8P_2D
#define DEV_FREE_KKP_3D dev_free_I8P_3D
#define DEV_FREE_KKP_4D dev_free_I8P_4D
#define DEV_FREE_KKP_5D dev_free_I8P_5D
#define DEV_FREE_KKP_6D dev_free_I8P_6D
#define DEV_FREE_KKP_7D dev_free_I8P_7D
#include "fundal_dev_free_unstructured_agnostic.INC"

#define KKP I4P
#define VARTYPE integer
#define DEV_FREE_KKP_1D dev_free_I4P_1D
#define DEV_FREE_KKP_2D dev_free_I4P_2D
#define DEV_FREE_KKP_3D dev_free_I4P_3D
#define DEV_FREE_KKP_4D dev_free_I4P_4D
#define DEV_FREE_KKP_5D dev_free_I4P_5D
#define DEV_FREE_KKP_6D dev_free_I4P_6D
#define DEV_FREE_KKP_7D dev_free_I4P_7D
#include "fundal_dev_free_unstructured_agnostic.INC"

#define KKP I2P
#define VARTYPE integer
#define DEV_FREE_KKP_1D dev_free_I2P_1D
#define DEV_FREE_KKP_2D dev_free_I2P_2D
#define DEV_FREE_KKP_3D dev_free_I2P_3D
#define DEV_FREE_KKP_4D dev_free_I2P_4D
#define DEV_FREE_KKP_5D dev_free_I2P_5D
#define DEV_FREE_KKP_6D dev_free_I2P_6D
#define DEV_FREE_KKP_7D dev_free_I2P_7D
#include "fundal_dev_free_unstructured_agnostic.INC"

#define KKP I1P
#define VARTYPE integer
#define DEV_FREE_KKP_1D dev_free_I1P_1D
#define DEV_FREE_KKP_2D dev_free_I1P_2D
#define DEV_FREE_KKP_3D dev_free_I1P_3D
#define DEV_FREE_KKP_4D dev_free_I1P_4D
#define DEV_FREE_KKP_5D dev_free_I1P_5D
#define DEV_FREE_KKP_6D dev_free_I1P_6D
#define DEV_FREE_KKP_7D dev_free_I1P_7D
#include "fundal_dev_free_unstructured_agnostic.INC"
endmodule fundal_dev_free_unstructured
