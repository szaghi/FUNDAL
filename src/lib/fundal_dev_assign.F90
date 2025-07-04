!< FUNDAL, memory assignment routines module.

#include "fundal.H"

module fundal_dev_assign
!< FUNDAL, memory assignment routines module.
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I2P=>int16, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64
use            :: fundal_dev_alloc
use            :: fundal_dev_free
use            :: fundal_dev_memcpy

implicit none
private
public :: dev_assign_from_device
public :: dev_assign_to_device

interface dev_assign_from_device
   !< Allocate device memory.
   !< @NOTE Destination variable (device) is re-allocated before assignment.
   module procedure dev_assign_from_device_R8P_1D,&
                    dev_assign_from_device_R8P_2D,&
                    dev_assign_from_device_R8P_3D,&
                    dev_assign_from_device_R8P_4D,&
                    dev_assign_from_device_R8P_5D,&
                    dev_assign_from_device_R8P_6D,&
                    dev_assign_from_device_R8P_7D,&
                    dev_assign_from_device_R4P_1D,&
                    dev_assign_from_device_R4P_2D,&
                    dev_assign_from_device_R4P_3D,&
                    dev_assign_from_device_R4P_4D,&
                    dev_assign_from_device_R4P_5D,&
                    dev_assign_from_device_R4P_6D,&
                    dev_assign_from_device_R4P_7D,&
                    dev_assign_from_device_I8P_1D,&
                    dev_assign_from_device_I8P_2D,&
                    dev_assign_from_device_I8P_3D,&
                    dev_assign_from_device_I8P_4D,&
                    dev_assign_from_device_I8P_5D,&
                    dev_assign_from_device_I8P_6D,&
                    dev_assign_from_device_I8P_7D,&
                    dev_assign_from_device_I4P_1D,&
                    dev_assign_from_device_I4P_2D,&
                    dev_assign_from_device_I4P_3D,&
                    dev_assign_from_device_I4P_4D,&
                    dev_assign_from_device_I4P_5D,&
                    dev_assign_from_device_I4P_6D,&
                    dev_assign_from_device_I4P_7D,&
                    dev_assign_from_device_I2P_1D,&
                    dev_assign_from_device_I2P_2D,&
                    dev_assign_from_device_I2P_3D,&
                    dev_assign_from_device_I2P_4D,&
                    dev_assign_from_device_I2P_5D,&
                    dev_assign_from_device_I2P_6D,&
                    dev_assign_from_device_I2P_7D,&
                    dev_assign_from_device_I1P_1D,&
                    dev_assign_from_device_I1P_2D,&
                    dev_assign_from_device_I1P_3D,&
                    dev_assign_from_device_I1P_4D,&
                    dev_assign_from_device_I1P_5D,&
                    dev_assign_from_device_I1P_6D,&
                    dev_assign_from_device_I1P_7D
endinterface dev_assign_from_device

interface dev_assign_to_device
   !< Allocate device memory.
   !< @NOTE Destination variable (device) is re-allocated before assignment.
   module procedure dev_assign_to_device_R8P_1D,&
                    dev_assign_to_device_R8P_2D,&
                    dev_assign_to_device_R8P_3D,&
                    dev_assign_to_device_R8P_4D,&
                    dev_assign_to_device_R8P_5D,&
                    dev_assign_to_device_R8P_6D,&
                    dev_assign_to_device_R8P_7D,&
                    dev_assign_to_device_R4P_1D,&
                    dev_assign_to_device_R4P_2D,&
                    dev_assign_to_device_R4P_3D,&
                    dev_assign_to_device_R4P_4D,&
                    dev_assign_to_device_R4P_5D,&
                    dev_assign_to_device_R4P_6D,&
                    dev_assign_to_device_R4P_7D,&
                    dev_assign_to_device_I8P_1D,&
                    dev_assign_to_device_I8P_2D,&
                    dev_assign_to_device_I8P_3D,&
                    dev_assign_to_device_I8P_4D,&
                    dev_assign_to_device_I8P_5D,&
                    dev_assign_to_device_I8P_6D,&
                    dev_assign_to_device_I8P_7D,&
                    dev_assign_to_device_I4P_1D,&
                    dev_assign_to_device_I4P_2D,&
                    dev_assign_to_device_I4P_3D,&
                    dev_assign_to_device_I4P_4D,&
                    dev_assign_to_device_I4P_5D,&
                    dev_assign_to_device_I4P_6D,&
                    dev_assign_to_device_I4P_7D,&
                    dev_assign_to_device_I2P_1D,&
                    dev_assign_to_device_I2P_2D,&
                    dev_assign_to_device_I2P_3D,&
                    dev_assign_to_device_I2P_4D,&
                    dev_assign_to_device_I2P_5D,&
                    dev_assign_to_device_I2P_6D,&
                    dev_assign_to_device_I2P_7D,&
                    dev_assign_to_device_I1P_1D,&
                    dev_assign_to_device_I1P_2D,&
                    dev_assign_to_device_I1P_3D,&
                    dev_assign_to_device_I1P_4D,&
                    dev_assign_to_device_I1P_5D,&
                    dev_assign_to_device_I1P_6D,&
                    dev_assign_to_device_I1P_7D
endinterface dev_assign_to_device

interface transpose_array
   !< Transpose array.
   module procedure transpose_array_R8P_2D, &
                    transpose_array_R8P_3D, &
                    transpose_array_R8P_4D, &
                    transpose_array_R8P_5D, &
                    transpose_array_R8P_6D, &
                    transpose_array_R8P_7D, &
                    transpose_array_R4P_2D, &
                    transpose_array_R4P_3D, &
                    transpose_array_R4P_4D, &
                    transpose_array_R4P_5D, &
                    transpose_array_R4P_6D, &
                    transpose_array_R4P_7D, &
                    transpose_array_I8P_2D, &
                    transpose_array_I8P_3D, &
                    transpose_array_I8P_4D, &
                    transpose_array_I8P_5D, &
                    transpose_array_I8P_6D, &
                    transpose_array_I8P_7D, &
                    transpose_array_I4P_2D, &
                    transpose_array_I4P_3D, &
                    transpose_array_I4P_4D, &
                    transpose_array_I4P_5D, &
                    transpose_array_I4P_6D, &
                    transpose_array_I4P_7D, &
                    transpose_array_I2P_2D, &
                    transpose_array_I2P_3D, &
                    transpose_array_I2P_4D, &
                    transpose_array_I2P_5D, &
                    transpose_array_I2P_6D, &
                    transpose_array_I2P_7D, &
                    transpose_array_I1P_2D, &
                    transpose_array_I1P_3D, &
                    transpose_array_I1P_4D, &
                    transpose_array_I1P_5D, &
                    transpose_array_I1P_6D, &
                    transpose_array_I1P_7D
endinterface transpose_array

contains
#define KKP R8P
#define VARTYPE real
#define DEV_ASSIGN_FROM_DEVICE_KKP_1D dev_assign_from_device_R8P_1D
#define DEV_ASSIGN_FROM_DEVICE_KKP_2D dev_assign_from_device_R8P_2D
#define DEV_ASSIGN_FROM_DEVICE_KKP_3D dev_assign_from_device_R8P_3D
#define DEV_ASSIGN_FROM_DEVICE_KKP_4D dev_assign_from_device_R8P_4D
#define DEV_ASSIGN_FROM_DEVICE_KKP_5D dev_assign_from_device_R8P_5D
#define DEV_ASSIGN_FROM_DEVICE_KKP_6D dev_assign_from_device_R8P_6D
#define DEV_ASSIGN_FROM_DEVICE_KKP_7D dev_assign_from_device_R8P_7D
#define DEV_ASSIGN_TO_DEVICE_KKP_1D dev_assign_to_device_R8P_1D
#define DEV_ASSIGN_TO_DEVICE_KKP_2D dev_assign_to_device_R8P_2D
#define DEV_ASSIGN_TO_DEVICE_KKP_3D dev_assign_to_device_R8P_3D
#define DEV_ASSIGN_TO_DEVICE_KKP_4D dev_assign_to_device_R8P_4D
#define DEV_ASSIGN_TO_DEVICE_KKP_5D dev_assign_to_device_R8P_5D
#define DEV_ASSIGN_TO_DEVICE_KKP_6D dev_assign_to_device_R8P_6D
#define DEV_ASSIGN_TO_DEVICE_KKP_7D dev_assign_to_device_R8P_7D
#include "fundal_dev_assign_agnostic.INC"

#define KKP R4P
#define VARTYPE real
#define DEV_ASSIGN_FROM_DEVICE_KKP_1D dev_assign_from_device_R4P_1D
#define DEV_ASSIGN_FROM_DEVICE_KKP_2D dev_assign_from_device_R4P_2D
#define DEV_ASSIGN_FROM_DEVICE_KKP_3D dev_assign_from_device_R4P_3D
#define DEV_ASSIGN_FROM_DEVICE_KKP_4D dev_assign_from_device_R4P_4D
#define DEV_ASSIGN_FROM_DEVICE_KKP_5D dev_assign_from_device_R4P_5D
#define DEV_ASSIGN_FROM_DEVICE_KKP_6D dev_assign_from_device_R4P_6D
#define DEV_ASSIGN_FROM_DEVICE_KKP_7D dev_assign_from_device_R4P_7D
#define DEV_ASSIGN_TO_DEVICE_KKP_1D dev_assign_to_device_R4P_1D
#define DEV_ASSIGN_TO_DEVICE_KKP_2D dev_assign_to_device_R4P_2D
#define DEV_ASSIGN_TO_DEVICE_KKP_3D dev_assign_to_device_R4P_3D
#define DEV_ASSIGN_TO_DEVICE_KKP_4D dev_assign_to_device_R4P_4D
#define DEV_ASSIGN_TO_DEVICE_KKP_5D dev_assign_to_device_R4P_5D
#define DEV_ASSIGN_TO_DEVICE_KKP_6D dev_assign_to_device_R4P_6D
#define DEV_ASSIGN_TO_DEVICE_KKP_7D dev_assign_to_device_R4P_7D
#include "fundal_dev_assign_agnostic.INC"

#define KKP I8P
#define VARTYPE integer
#define DEV_ASSIGN_FROM_DEVICE_KKP_1D dev_assign_from_device_I8P_1D
#define DEV_ASSIGN_FROM_DEVICE_KKP_2D dev_assign_from_device_I8P_2D
#define DEV_ASSIGN_FROM_DEVICE_KKP_3D dev_assign_from_device_I8P_3D
#define DEV_ASSIGN_FROM_DEVICE_KKP_4D dev_assign_from_device_I8P_4D
#define DEV_ASSIGN_FROM_DEVICE_KKP_5D dev_assign_from_device_I8P_5D
#define DEV_ASSIGN_FROM_DEVICE_KKP_6D dev_assign_from_device_I8P_6D
#define DEV_ASSIGN_FROM_DEVICE_KKP_7D dev_assign_from_device_I8P_7D
#define DEV_ASSIGN_TO_DEVICE_KKP_1D dev_assign_to_device_I8P_1D
#define DEV_ASSIGN_TO_DEVICE_KKP_2D dev_assign_to_device_I8P_2D
#define DEV_ASSIGN_TO_DEVICE_KKP_3D dev_assign_to_device_I8P_3D
#define DEV_ASSIGN_TO_DEVICE_KKP_4D dev_assign_to_device_I8P_4D
#define DEV_ASSIGN_TO_DEVICE_KKP_5D dev_assign_to_device_I8P_5D
#define DEV_ASSIGN_TO_DEVICE_KKP_6D dev_assign_to_device_I8P_6D
#define DEV_ASSIGN_TO_DEVICE_KKP_7D dev_assign_to_device_I8P_7D
#include "fundal_dev_assign_agnostic.INC"

#define KKP I4P
#define VARTYPE integer
#define DEV_ASSIGN_FROM_DEVICE_KKP_1D dev_assign_from_device_I4P_1D
#define DEV_ASSIGN_FROM_DEVICE_KKP_2D dev_assign_from_device_I4P_2D
#define DEV_ASSIGN_FROM_DEVICE_KKP_3D dev_assign_from_device_I4P_3D
#define DEV_ASSIGN_FROM_DEVICE_KKP_4D dev_assign_from_device_I4P_4D
#define DEV_ASSIGN_FROM_DEVICE_KKP_5D dev_assign_from_device_I4P_5D
#define DEV_ASSIGN_FROM_DEVICE_KKP_6D dev_assign_from_device_I4P_6D
#define DEV_ASSIGN_FROM_DEVICE_KKP_7D dev_assign_from_device_I4P_7D
#define DEV_ASSIGN_TO_DEVICE_KKP_1D dev_assign_to_device_I4P_1D
#define DEV_ASSIGN_TO_DEVICE_KKP_2D dev_assign_to_device_I4P_2D
#define DEV_ASSIGN_TO_DEVICE_KKP_3D dev_assign_to_device_I4P_3D
#define DEV_ASSIGN_TO_DEVICE_KKP_4D dev_assign_to_device_I4P_4D
#define DEV_ASSIGN_TO_DEVICE_KKP_5D dev_assign_to_device_I4P_5D
#define DEV_ASSIGN_TO_DEVICE_KKP_6D dev_assign_to_device_I4P_6D
#define DEV_ASSIGN_TO_DEVICE_KKP_7D dev_assign_to_device_I4P_7D
#include "fundal_dev_assign_agnostic.INC"

#define KKP I2P
#define VARTYPE integer
#define DEV_ASSIGN_FROM_DEVICE_KKP_1D dev_assign_from_device_I2P_1D
#define DEV_ASSIGN_FROM_DEVICE_KKP_2D dev_assign_from_device_I2P_2D
#define DEV_ASSIGN_FROM_DEVICE_KKP_3D dev_assign_from_device_I2P_3D
#define DEV_ASSIGN_FROM_DEVICE_KKP_4D dev_assign_from_device_I2P_4D
#define DEV_ASSIGN_FROM_DEVICE_KKP_5D dev_assign_from_device_I2P_5D
#define DEV_ASSIGN_FROM_DEVICE_KKP_6D dev_assign_from_device_I2P_6D
#define DEV_ASSIGN_FROM_DEVICE_KKP_7D dev_assign_from_device_I2P_7D
#define DEV_ASSIGN_TO_DEVICE_KKP_1D dev_assign_to_device_I2P_1D
#define DEV_ASSIGN_TO_DEVICE_KKP_2D dev_assign_to_device_I2P_2D
#define DEV_ASSIGN_TO_DEVICE_KKP_3D dev_assign_to_device_I2P_3D
#define DEV_ASSIGN_TO_DEVICE_KKP_4D dev_assign_to_device_I2P_4D
#define DEV_ASSIGN_TO_DEVICE_KKP_5D dev_assign_to_device_I2P_5D
#define DEV_ASSIGN_TO_DEVICE_KKP_6D dev_assign_to_device_I2P_6D
#define DEV_ASSIGN_TO_DEVICE_KKP_7D dev_assign_to_device_I2P_7D
#include "fundal_dev_assign_agnostic.INC"

#define KKP I1P
#define VARTYPE integer
#define DEV_ASSIGN_FROM_DEVICE_KKP_1D dev_assign_from_device_I1P_1D
#define DEV_ASSIGN_FROM_DEVICE_KKP_2D dev_assign_from_device_I1P_2D
#define DEV_ASSIGN_FROM_DEVICE_KKP_3D dev_assign_from_device_I1P_3D
#define DEV_ASSIGN_FROM_DEVICE_KKP_4D dev_assign_from_device_I1P_4D
#define DEV_ASSIGN_FROM_DEVICE_KKP_5D dev_assign_from_device_I1P_5D
#define DEV_ASSIGN_FROM_DEVICE_KKP_6D dev_assign_from_device_I1P_6D
#define DEV_ASSIGN_FROM_DEVICE_KKP_7D dev_assign_from_device_I1P_7D
#define DEV_ASSIGN_TO_DEVICE_KKP_1D dev_assign_to_device_I1P_1D
#define DEV_ASSIGN_TO_DEVICE_KKP_2D dev_assign_to_device_I1P_2D
#define DEV_ASSIGN_TO_DEVICE_KKP_3D dev_assign_to_device_I1P_3D
#define DEV_ASSIGN_TO_DEVICE_KKP_4D dev_assign_to_device_I1P_4D
#define DEV_ASSIGN_TO_DEVICE_KKP_5D dev_assign_to_device_I1P_5D
#define DEV_ASSIGN_TO_DEVICE_KKP_6D dev_assign_to_device_I1P_6D
#define DEV_ASSIGN_TO_DEVICE_KKP_7D dev_assign_to_device_I1P_7D
#include "fundal_dev_assign_agnostic.INC"

   ! private procedures
#define KKP R8P
#define VARTYPE real
#define TRANSPOSE_ARRAY_KKP_2D transpose_array_R8P_2D
#define TRANSPOSE_ARRAY_KKP_3D transpose_array_R8P_3D
#define TRANSPOSE_ARRAY_KKP_4D transpose_array_R8P_4D
#define TRANSPOSE_ARRAY_KKP_5D transpose_array_R8P_5D
#define TRANSPOSE_ARRAY_KKP_6D transpose_array_R8P_6D
#define TRANSPOSE_ARRAY_KKP_7D transpose_array_R8P_7D
#include "fundal_transpose_array_agnostic.INC"

#define KKP R4P
#define VARTYPE real
#define TRANSPOSE_ARRAY_KKP_2D transpose_array_R4P_2D
#define TRANSPOSE_ARRAY_KKP_3D transpose_array_R4P_3D
#define TRANSPOSE_ARRAY_KKP_4D transpose_array_R4P_4D
#define TRANSPOSE_ARRAY_KKP_5D transpose_array_R4P_5D
#define TRANSPOSE_ARRAY_KKP_6D transpose_array_R4P_6D
#define TRANSPOSE_ARRAY_KKP_7D transpose_array_R4P_7D
#include "fundal_transpose_array_agnostic.INC"

#define KKP I8P
#define VARTYPE integer
#define TRANSPOSE_ARRAY_KKP_2D transpose_array_I8P_2D
#define TRANSPOSE_ARRAY_KKP_3D transpose_array_I8P_3D
#define TRANSPOSE_ARRAY_KKP_4D transpose_array_I8P_4D
#define TRANSPOSE_ARRAY_KKP_5D transpose_array_I8P_5D
#define TRANSPOSE_ARRAY_KKP_6D transpose_array_I8P_6D
#define TRANSPOSE_ARRAY_KKP_7D transpose_array_I8P_7D
#include "fundal_transpose_array_agnostic.INC"

#define KKP I4P
#define VARTYPE integer
#define TRANSPOSE_ARRAY_KKP_2D transpose_array_I4P_2D
#define TRANSPOSE_ARRAY_KKP_3D transpose_array_I4P_3D
#define TRANSPOSE_ARRAY_KKP_4D transpose_array_I4P_4D
#define TRANSPOSE_ARRAY_KKP_5D transpose_array_I4P_5D
#define TRANSPOSE_ARRAY_KKP_6D transpose_array_I4P_6D
#define TRANSPOSE_ARRAY_KKP_7D transpose_array_I4P_7D
#include "fundal_transpose_array_agnostic.INC"

#define KKP I2P
#define VARTYPE integer
#define TRANSPOSE_ARRAY_KKP_2D transpose_array_I2P_2D
#define TRANSPOSE_ARRAY_KKP_3D transpose_array_I2P_3D
#define TRANSPOSE_ARRAY_KKP_4D transpose_array_I2P_4D
#define TRANSPOSE_ARRAY_KKP_5D transpose_array_I2P_5D
#define TRANSPOSE_ARRAY_KKP_6D transpose_array_I2P_6D
#define TRANSPOSE_ARRAY_KKP_7D transpose_array_I2P_7D
#include "fundal_transpose_array_agnostic.INC"

#define KKP I1P
#define VARTYPE integer
#define TRANSPOSE_ARRAY_KKP_2D transpose_array_I1P_2D
#define TRANSPOSE_ARRAY_KKP_3D transpose_array_I1P_3D
#define TRANSPOSE_ARRAY_KKP_4D transpose_array_I1P_4D
#define TRANSPOSE_ARRAY_KKP_5D transpose_array_I1P_5D
#define TRANSPOSE_ARRAY_KKP_6D transpose_array_I1P_6D
#define TRANSPOSE_ARRAY_KKP_7D transpose_array_I1P_7D
#include "fundal_transpose_array_agnostic.INC"
endmodule fundal_dev_assign
