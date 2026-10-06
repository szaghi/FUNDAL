# FUNDAL CMake build: the static library, the unit tests (CTest) and an installable package (find_package(FUNDAL)).
# FoBiS (fobos) remains the primary build system; this file mirrors its compiler templates, as the makefile does.
#
# Usage:
#   cmake -B build                                              # compile-time CPU mode (no device backend)
#   cmake -B build -DFUNDAL_BACKEND=oac                         # OpenACC (gfortran or nvfortran)
#   cmake -B build -DCMAKE_Fortran_COMPILER=nvfortran -DFUNDAL_BACKEND=oac -DFUNDAL_GPU=cc89
#   cmake -B build -DCMAKE_Fortran_COMPILER=ifx -DFUNDAL_BACKEND=omp            # OpenMP offload (spir64)
#   cmake -B build -DCMAKE_Fortran_COMPILER=amdflang -DFUNDAL_BACKEND=omp -DFUNDAL_GPU=gfx90a
#   cmake -B build -DFUNDAL_MPI=ON                              # also build fundal_mpih_object (find_package(MPI))
#   cmake --build build && ctest --test-dir build && cmake --install build --prefix <prefix>
#
# Consumers link FUNDAL::fundal, which carries the backend macros, the offload flags and the include directory of
# fundal.H: their own kernels (DEVICEVAR, DEVICEPTR, OMPLOOP) are compiled with the same backend as the library.

cmake_minimum_required(VERSION 3.18)

file(STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/VERSION" FUNDAL_VERSION LIMIT_COUNT 1)
string(REGEX REPLACE "^v" "" FUNDAL_VERSION "${FUNDAL_VERSION}")
project(FUNDAL VERSION ${FUNDAL_VERSION} LANGUAGES Fortran)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

set(FUNDAL_BACKEND "none" CACHE STRING "Device backend: none (compile-time CPU mode), oac (OpenACC), omp (OpenMP)")
set_property(CACHE FUNDAL_BACKEND PROPERTY STRINGS none oac omp)
set(FUNDAL_GPU "" CACHE STRING "GPU target: nvfortran compute capability (default cc89), amdflang arch (default gfx90a)")
option(FUNDAL_MPI "Build the MPI handler fundal_mpih_object" OFF)
if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
  set(FUNDAL_TOP_LEVEL ON)
else()
  set(FUNDAL_TOP_LEVEL OFF)
endif()
option(FUNDAL_BUILD_TESTS "Build the unit tests of src/tests" ${FUNDAL_TOP_LEVEL})

if(NOT FUNDAL_BACKEND MATCHES "^(none|oac|omp)$")
  message(FATAL_ERROR "unknown FUNDAL_BACKEND=${FUNDAL_BACKEND}: use none, oac or omp")
endif()

# compiler templates (keep in sync with the fobos [template-*] sections and the makefile)
set(FUNDAL_DEFS)
set(FUNDAL_OFFLOAD)
set(FUNDAL_LIBS)
set(fc_id "${CMAKE_Fortran_COMPILER_ID}")
if(fc_id STREQUAL "GNU")
  list(APPEND FUNDAL_DEFS COMPILER_GNU)
  if(FUNDAL_BACKEND STREQUAL "oac")
    list(APPEND FUNDAL_DEFS DEV_OAC)
    list(APPEND FUNDAL_OFFLOAD -fopenacc)
  endif()
elseif(fc_id MATCHES "^(NVHPC|PGI)$")
  list(APPEND FUNDAL_DEFS COMPILER_NVF)
  if(FUNDAL_BACKEND STREQUAL "oac")
    if(NOT FUNDAL_GPU)
      set(FUNDAL_GPU cc89)
    endif()
    list(APPEND FUNDAL_DEFS DEV_OAC)
    list(APPEND FUNDAL_OFFLOAD -acc -gpu=${FUNDAL_GPU})
  endif()
elseif(fc_id STREQUAL "IntelLLVM")
  list(APPEND FUNDAL_OFFLOAD -fiopenmp)
  if(FUNDAL_BACKEND STREQUAL "omp")
    list(APPEND FUNDAL_DEFS DEV_OMP)
    list(APPEND FUNDAL_OFFLOAD -fopenmp-targets=spir64)
  endif()
elseif(fc_id MATCHES "^(LLVMFlang|Flang)$")
  list(APPEND FUNDAL_OFFLOAD -fopenmp)
  if(FUNDAL_BACKEND STREQUAL "omp")
    if(NOT FUNDAL_GPU)
      set(FUNDAL_GPU gfx90a)
    endif()
    list(APPEND FUNDAL_DEFS DEV_OMP DEV_HIP)
    list(APPEND FUNDAL_OFFLOAD --offload-arch=${FUNDAL_GPU})
    list(APPEND FUNDAL_LIBS amdhip64)
  endif()
elseif(NOT FUNDAL_BACKEND STREQUAL "none")
  message(FATAL_ERROR "FUNDAL_BACKEND=${FUNDAL_BACKEND} is not supported with the ${fc_id} compiler")
endif()
if(FUNDAL_BACKEND STREQUAL "oac" AND NOT "DEV_OAC" IN_LIST FUNDAL_DEFS)
  message(FATAL_ERROR "FUNDAL_BACKEND=oac needs gfortran or nvfortran (compiler: ${fc_id})")
endif()
if(FUNDAL_BACKEND STREQUAL "omp" AND NOT "DEV_OMP" IN_LIST FUNDAL_DEFS)
  message(FATAL_ERROR "FUNDAL_BACKEND=omp needs ifx or amdflang (compiler: ${fc_id})")
endif()
message(STATUS "FUNDAL ${PROJECT_VERSION}: compiler ${fc_id}, backend ${FUNDAL_BACKEND}, macros ${FUNDAL_DEFS}, "
               "flags ${FUNDAL_OFFLOAD}, MPI ${FUNDAL_MPI}")

# library
set(FUNDAL_SOURCES
  fundal_env.F90 fundal_utilities.F90 fundal_registry.F90 fundal_transpose_array.F90 fundal_dev_handling.F90
  fundal_dev_alloc.F90 fundal_dev_free.F90 fundal_dev_alloc_replace.F90 fundal_dev_alloc_unstructured.F90
  fundal_dev_free_unstructured.F90 fundal_dev_memcpy.F90 fundal_dev_memcpy_unstructured.F90 fundal_dev_assign.F90
  fundal.F90)
if(FUNDAL_MPI)
  find_package(MPI REQUIRED COMPONENTS Fortran)
  list(APPEND FUNDAL_SOURCES fundal_mpih_object.F90)
endif()
list(TRANSFORM FUNDAL_SOURCES PREPEND "${PROJECT_SOURCE_DIR}/src/lib/")

include(GNUInstallDirs)
set(FUNDAL_MOD_DIR "${PROJECT_BINARY_DIR}/mod")
set(FUNDAL_INSTALL_INCLUDEDIR "${CMAKE_INSTALL_INCLUDEDIR}/fundal")

add_library(fundal ${FUNDAL_SOURCES})
add_library(FUNDAL::fundal ALIAS fundal)
set_target_properties(fundal PROPERTIES
  Fortran_PREPROCESS ON
  Fortran_MODULE_DIRECTORY "${FUNDAL_MOD_DIR}"
  VERSION ${PROJECT_VERSION})
target_compile_definitions(fundal PUBLIC ${FUNDAL_DEFS})
target_compile_options(fundal PUBLIC ${FUNDAL_OFFLOAD})
target_link_options(fundal PUBLIC ${FUNDAL_OFFLOAD})
target_include_directories(fundal PUBLIC
  $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src/lib>
  $<BUILD_INTERFACE:${FUNDAL_MOD_DIR}>
  $<INSTALL_INTERFACE:${FUNDAL_INSTALL_INCLUDEDIR}>)
target_link_libraries(fundal PUBLIC ${FUNDAL_LIBS})
if(FUNDAL_MPI)
  target_link_libraries(fundal PUBLIC MPI::MPI_Fortran)
endif()

# tests: every top-level program of src/tests (the agnostic .INC files live next to them); "_xfail_" ones must fail
if(FUNDAL_BUILD_TESTS)
  enable_testing()
  file(GLOB FUNDAL_TESTS CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/src/tests/fundal_*_test.F90")
  if(FUNDAL_MPI)
    list(APPEND FUNDAL_TESTS "${PROJECT_SOURCE_DIR}/src/tests/mpi/fundal_mpi_dev_alloc_test.F90")
  endif()
  foreach(src IN LISTS FUNDAL_TESTS)
    get_filename_component(name "${src}" NAME_WE)
    add_executable(${name} "${src}")
    set_target_properties(${name} PROPERTIES
      Fortran_PREPROCESS ON
      Fortran_MODULE_DIRECTORY "${PROJECT_BINARY_DIR}/tests/mod/${name}"
      RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/tests")
    target_include_directories(${name} PRIVATE "${PROJECT_SOURCE_DIR}/src/tests")
    target_link_libraries(${name} PRIVATE FUNDAL::fundal)
    if(name MATCHES "mpi")
      add_test(NAME ${name} COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:${name}>)
    else()
      add_test(NAME ${name} COMMAND ${name})
    endif()
    if(name MATCHES "_xfail_")
      set_tests_properties(${name} PROPERTIES WILL_FAIL TRUE)
    endif()
  endforeach()
endif()

# install: library, modules and fundal.H (needed by consumers' kernels), package config FUNDALConfig.cmake
include(CMakePackageConfigHelpers)
set(FUNDAL_CMAKE_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/FUNDAL")
install(TARGETS fundal EXPORT FUNDALTargets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(DIRECTORY "${FUNDAL_MOD_DIR}/" DESTINATION ${FUNDAL_INSTALL_INCLUDEDIR})
install(FILES "${PROJECT_SOURCE_DIR}/src/lib/fundal.H" DESTINATION ${FUNDAL_INSTALL_INCLUDEDIR})
install(EXPORT FUNDALTargets NAMESPACE FUNDAL:: DESTINATION ${FUNDAL_CMAKE_DIR})
export(EXPORT FUNDALTargets NAMESPACE FUNDAL:: FILE "${PROJECT_BINARY_DIR}/FUNDALTargets.cmake")
configure_package_config_file("${PROJECT_SOURCE_DIR}/cmake/FUNDALConfig.cmake.in"
  "${PROJECT_BINARY_DIR}/FUNDALConfig.cmake" INSTALL_DESTINATION ${FUNDAL_CMAKE_DIR})
write_basic_package_version_file("${PROJECT_BINARY_DIR}/FUNDALConfigVersion.cmake" COMPATIBILITY SameMajorVersion)
install(FILES "${PROJECT_BINARY_DIR}/FUNDALConfig.cmake" "${PROJECT_BINARY_DIR}/FUNDALConfigVersion.cmake"
  DESTINATION ${FUNDAL_CMAKE_DIR})
