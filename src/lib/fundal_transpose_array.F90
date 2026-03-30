!< FUNDAL, transpose array library.
module fundal_transpose_array
!< FUNDAL, transpose array library.
use, intrinsic :: iso_fortran_env, only : I1P=>int8, I2P=>int16, I4P=>int32, I8P=>int64, R4P=>real32, R8P=>real64

implicit none
private
public :: transpose_array_alloc
public :: transpose_array

interface transpose_array_alloc
   !< Transpose array.
   module procedure transpose_array_alloc_R8P_2D, &
                    transpose_array_alloc_R8P_3D, &
                    transpose_array_alloc_R8P_4D, &
                    transpose_array_alloc_R8P_5D, &
                    transpose_array_alloc_R8P_6D, &
                    transpose_array_alloc_R8P_7D, &
                    transpose_array_alloc_R4P_2D, &
                    transpose_array_alloc_R4P_3D, &
                    transpose_array_alloc_R4P_4D, &
                    transpose_array_alloc_R4P_5D, &
                    transpose_array_alloc_R4P_6D, &
                    transpose_array_alloc_R4P_7D, &
                    transpose_array_alloc_I8P_2D, &
                    transpose_array_alloc_I8P_3D, &
                    transpose_array_alloc_I8P_4D, &
                    transpose_array_alloc_I8P_5D, &
                    transpose_array_alloc_I8P_6D, &
                    transpose_array_alloc_I8P_7D, &
                    transpose_array_alloc_I4P_2D, &
                    transpose_array_alloc_I4P_3D, &
                    transpose_array_alloc_I4P_4D, &
                    transpose_array_alloc_I4P_5D, &
                    transpose_array_alloc_I4P_6D, &
                    transpose_array_alloc_I4P_7D, &
                    transpose_array_alloc_I2P_2D, &
                    transpose_array_alloc_I2P_3D, &
                    transpose_array_alloc_I2P_4D, &
                    transpose_array_alloc_I2P_5D, &
                    transpose_array_alloc_I2P_6D, &
                    transpose_array_alloc_I2P_7D, &
                    transpose_array_alloc_I1P_2D, &
                    transpose_array_alloc_I1P_3D, &
                    transpose_array_alloc_I1P_4D, &
                    transpose_array_alloc_I1P_5D, &
                    transpose_array_alloc_I1P_6D, &
                    transpose_array_alloc_I1P_7D
endinterface transpose_array_alloc

interface transpose_array
   !< Transpose array (no allocation, caller supplies pre-allocated output).
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
#define TRANSPOSE_ARRAY_ALLOC_KKP_2D transpose_array_alloc_R8P_2D
#define TRANSPOSE_ARRAY_ALLOC_KKP_3D transpose_array_alloc_R8P_3D
#define TRANSPOSE_ARRAY_ALLOC_KKP_4D transpose_array_alloc_R8P_4D
#define TRANSPOSE_ARRAY_ALLOC_KKP_5D transpose_array_alloc_R8P_5D
#define TRANSPOSE_ARRAY_ALLOC_KKP_6D transpose_array_alloc_R8P_6D
#define TRANSPOSE_ARRAY_ALLOC_KKP_7D transpose_array_alloc_R8P_7D
#define TRANSPOSE_ARRAY_KKP_2D transpose_array_R8P_2D
#define TRANSPOSE_ARRAY_KKP_3D transpose_array_R8P_3D
#define TRANSPOSE_ARRAY_KKP_4D transpose_array_R8P_4D
#define TRANSPOSE_ARRAY_KKP_5D transpose_array_R8P_5D
#define TRANSPOSE_ARRAY_KKP_6D transpose_array_R8P_6D
#define TRANSPOSE_ARRAY_KKP_7D transpose_array_R8P_7D
#include "fundal_transpose_array_agnostic.INC"

#define KKP R4P
#define VARTYPE real
#define TRANSPOSE_ARRAY_ALLOC_KKP_2D transpose_array_alloc_R4P_2D
#define TRANSPOSE_ARRAY_ALLOC_KKP_3D transpose_array_alloc_R4P_3D
#define TRANSPOSE_ARRAY_ALLOC_KKP_4D transpose_array_alloc_R4P_4D
#define TRANSPOSE_ARRAY_ALLOC_KKP_5D transpose_array_alloc_R4P_5D
#define TRANSPOSE_ARRAY_ALLOC_KKP_6D transpose_array_alloc_R4P_6D
#define TRANSPOSE_ARRAY_ALLOC_KKP_7D transpose_array_alloc_R4P_7D
#define TRANSPOSE_ARRAY_KKP_2D transpose_array_R4P_2D
#define TRANSPOSE_ARRAY_KKP_3D transpose_array_R4P_3D
#define TRANSPOSE_ARRAY_KKP_4D transpose_array_R4P_4D
#define TRANSPOSE_ARRAY_KKP_5D transpose_array_R4P_5D
#define TRANSPOSE_ARRAY_KKP_6D transpose_array_R4P_6D
#define TRANSPOSE_ARRAY_KKP_7D transpose_array_R4P_7D
#include "fundal_transpose_array_agnostic.INC"

#define KKP I8P
#define VARTYPE integer
#define TRANSPOSE_ARRAY_ALLOC_KKP_2D transpose_array_alloc_I8P_2D
#define TRANSPOSE_ARRAY_ALLOC_KKP_3D transpose_array_alloc_I8P_3D
#define TRANSPOSE_ARRAY_ALLOC_KKP_4D transpose_array_alloc_I8P_4D
#define TRANSPOSE_ARRAY_ALLOC_KKP_5D transpose_array_alloc_I8P_5D
#define TRANSPOSE_ARRAY_ALLOC_KKP_6D transpose_array_alloc_I8P_6D
#define TRANSPOSE_ARRAY_ALLOC_KKP_7D transpose_array_alloc_I8P_7D
#define TRANSPOSE_ARRAY_KKP_2D transpose_array_I8P_2D
#define TRANSPOSE_ARRAY_KKP_3D transpose_array_I8P_3D
#define TRANSPOSE_ARRAY_KKP_4D transpose_array_I8P_4D
#define TRANSPOSE_ARRAY_KKP_5D transpose_array_I8P_5D
#define TRANSPOSE_ARRAY_KKP_6D transpose_array_I8P_6D
#define TRANSPOSE_ARRAY_KKP_7D transpose_array_I8P_7D
#include "fundal_transpose_array_agnostic.INC"

#define KKP I4P
#define VARTYPE integer
#define TRANSPOSE_ARRAY_ALLOC_KKP_2D transpose_array_alloc_I4P_2D
#define TRANSPOSE_ARRAY_ALLOC_KKP_3D transpose_array_alloc_I4P_3D
#define TRANSPOSE_ARRAY_ALLOC_KKP_4D transpose_array_alloc_I4P_4D
#define TRANSPOSE_ARRAY_ALLOC_KKP_5D transpose_array_alloc_I4P_5D
#define TRANSPOSE_ARRAY_ALLOC_KKP_6D transpose_array_alloc_I4P_6D
#define TRANSPOSE_ARRAY_ALLOC_KKP_7D transpose_array_alloc_I4P_7D
#define TRANSPOSE_ARRAY_KKP_2D transpose_array_I4P_2D
#define TRANSPOSE_ARRAY_KKP_3D transpose_array_I4P_3D
#define TRANSPOSE_ARRAY_KKP_4D transpose_array_I4P_4D
#define TRANSPOSE_ARRAY_KKP_5D transpose_array_I4P_5D
#define TRANSPOSE_ARRAY_KKP_6D transpose_array_I4P_6D
#define TRANSPOSE_ARRAY_KKP_7D transpose_array_I4P_7D
#include "fundal_transpose_array_agnostic.INC"

#define KKP I2P
#define VARTYPE integer
#define TRANSPOSE_ARRAY_ALLOC_KKP_2D transpose_array_alloc_I2P_2D
#define TRANSPOSE_ARRAY_ALLOC_KKP_3D transpose_array_alloc_I2P_3D
#define TRANSPOSE_ARRAY_ALLOC_KKP_4D transpose_array_alloc_I2P_4D
#define TRANSPOSE_ARRAY_ALLOC_KKP_5D transpose_array_alloc_I2P_5D
#define TRANSPOSE_ARRAY_ALLOC_KKP_6D transpose_array_alloc_I2P_6D
#define TRANSPOSE_ARRAY_ALLOC_KKP_7D transpose_array_alloc_I2P_7D
#define TRANSPOSE_ARRAY_KKP_2D transpose_array_I2P_2D
#define TRANSPOSE_ARRAY_KKP_3D transpose_array_I2P_3D
#define TRANSPOSE_ARRAY_KKP_4D transpose_array_I2P_4D
#define TRANSPOSE_ARRAY_KKP_5D transpose_array_I2P_5D
#define TRANSPOSE_ARRAY_KKP_6D transpose_array_I2P_6D
#define TRANSPOSE_ARRAY_KKP_7D transpose_array_I2P_7D
#include "fundal_transpose_array_agnostic.INC"

#define KKP I1P
#define VARTYPE integer
#define TRANSPOSE_ARRAY_ALLOC_KKP_2D transpose_array_alloc_I1P_2D
#define TRANSPOSE_ARRAY_ALLOC_KKP_3D transpose_array_alloc_I1P_3D
#define TRANSPOSE_ARRAY_ALLOC_KKP_4D transpose_array_alloc_I1P_4D
#define TRANSPOSE_ARRAY_ALLOC_KKP_5D transpose_array_alloc_I1P_5D
#define TRANSPOSE_ARRAY_ALLOC_KKP_6D transpose_array_alloc_I1P_6D
#define TRANSPOSE_ARRAY_ALLOC_KKP_7D transpose_array_alloc_I1P_7D
#define TRANSPOSE_ARRAY_KKP_2D transpose_array_I1P_2D
#define TRANSPOSE_ARRAY_KKP_3D transpose_array_I1P_3D
#define TRANSPOSE_ARRAY_KKP_4D transpose_array_I1P_4D
#define TRANSPOSE_ARRAY_KKP_5D transpose_array_I1P_5D
#define TRANSPOSE_ARRAY_KKP_6D transpose_array_I1P_6D
#define TRANSPOSE_ARRAY_KKP_7D transpose_array_I1P_7D
#include "fundal_transpose_array_agnostic.INC"
endmodule fundal_transpose_array
