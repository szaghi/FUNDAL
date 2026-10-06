#!/usr/bin/make
# FUNDAL makefile: build the static library (and, optionally, the tests) without FoBiS.
# FoBiS (fobos) remains the primary build system; this makefile mirrors its compiler templates.
#
# Usage:
#   make                                      # gfortran, compile-time CPU mode (no device backend)
#   make COMPILER=gnu BACKEND=oac             # gfortran + OpenACC
#   make COMPILER=nvf BACKEND=oac GPU=cc89    # nvfortran + OpenACC (GPU: compute capability, e.g. cc80, cc90)
#   make COMPILER=ifx BACKEND=omp             # Intel ifx + OpenMP offload (spir64)
#   make COMPILER=amd BACKEND=omp GPU=gfx90a  # AMD flang + OpenMP offload (needs a ROCm environment)
#   make ... MPI=1                            # also build fundal_mpih_object with the MPI wrapper ($(MPIFC))
#   make ... tests                            # build the unit tests of src/tests (not laplace/, precision/, mpi/)
#   make ... clean                            # remove the build directory of the selected configuration
#
# Output: build/<COMPILER>-<BACKEND>/{libfundal.a, mod/, obj/, tests/}. Users compile against mod/ and link libfundal.a,
# with the same -DDEV_* / -DCOMPILER_* macros and -I<path to src/lib> (for fundal.H) used here.

COMPILER ?= gnu
BACKEND  ?= none
MPI      ?= 0

# compiler templates (keep in sync with the fobos [template-*] sections)
ifeq ($(COMPILER),gnu)
   FC_DEF   = gfortran
   MPIFC   ?= mpif90
   MODFLAG  = -J
   CPPFLAGS = -cpp -DCOMPILER_GNU
   FFLAGS  ?= -O2
   ifeq ($(BACKEND),oac)
      CPPFLAGS += -DDEV_OAC
      OFFLOAD   = -fopenacc
   endif
else ifeq ($(COMPILER),nvf)
   FC_DEF   = nvfortran
   MPIFC   ?= mpif90
   MODFLAG  = -module
   CPPFLAGS = -cpp -DCOMPILER_NVF
   FFLAGS  ?= -fast
   GPU     ?= cc89
   ifeq ($(BACKEND),oac)
      CPPFLAGS += -DDEV_OAC
      OFFLOAD   = -acc -gpu=$(GPU)
   endif
else ifeq ($(COMPILER),ifx)
   FC_DEF   = ifx
   MPIFC   ?= mpiifx
   MODFLAG  = -module
   CPPFLAGS = -fpp
   FFLAGS  ?= -O2
   OFFLOAD  = -fiopenmp
   ifeq ($(BACKEND),omp)
      CPPFLAGS += -DDEV_OMP
      OFFLOAD  += -fopenmp-targets=spir64
   endif
else ifeq ($(COMPILER),amd)
   FC_DEF   = amdflang
   MPIFC   ?= mpif90
   MODFLAG  = -J
   CPPFLAGS = -cpp
   FFLAGS  ?= -O2
   GPU     ?= gfx90a
   OFFLOAD  = -fopenmp
   ifeq ($(BACKEND),omp)
      CPPFLAGS += -DDEV_OMP -DDEV_HIP
      OFFLOAD  += --offload-arch=$(GPU)
      LIBS     += -lamdhip64
   endif
else
   $(error unknown COMPILER=$(COMPILER): use gnu, nvf, ifx or amd)
endif
# make predefines FC=f77: use the template compiler unless FC is given on the command line or in the environment
ifeq ($(filter $(origin FC),default undefined),$(origin FC))
   FC = $(FC_DEF)
endif
ifeq ($(filter $(BACKEND),none oac omp),)
   $(error unknown BACKEND=$(BACKEND): use none, oac or omp)
endif
ifeq ($(MPI),1)
   FC := $(MPIFC)
endif

BUILD = build/$(COMPILER)-$(BACKEND)
DOBJ  = $(BUILD)/obj
DMOD  = $(BUILD)/mod
DTST  = $(BUILD)/tests
LIB   = $(BUILD)/libfundal.a
COMPILE = $(FC) $(CPPFLAGS) $(FFLAGS) $(OFFLOAD) -Isrc/lib $(MODFLAG) $(DMOD) -c

# library modules in dependency order, with their module dependencies (the .INC files and fundal.H are common deps)
LIBMODS = fundal_env fundal_utilities fundal_registry fundal_transpose_array fundal_dev_handling \
          fundal_dev_alloc fundal_dev_free fundal_dev_alloc_replace fundal_dev_alloc_unstructured \
          fundal_dev_free_unstructured fundal_dev_memcpy fundal_dev_memcpy_unstructured fundal_dev_assign fundal
ifeq ($(MPI),1)
   LIBMODS += fundal_mpih_object
endif
LIBOBJS = $(addprefix $(DOBJ)/,$(addsuffix .o,$(LIBMODS)))
COMMON  = src/lib/fundal.H $(wildcard src/lib/*.INC)

$(DOBJ)/fundal_registry.o:          $(DOBJ)/fundal_env.o
$(DOBJ)/fundal_dev_handling.o:      $(DOBJ)/fundal_env.o
$(DOBJ)/fundal_dev_alloc.o:         $(DOBJ)/fundal_env.o $(DOBJ)/fundal_registry.o $(DOBJ)/fundal_utilities.o
$(DOBJ)/fundal_dev_free.o:          $(DOBJ)/fundal_env.o $(DOBJ)/fundal_registry.o
$(DOBJ)/fundal_dev_alloc_replace.o: $(DOBJ)/fundal_dev_alloc.o $(DOBJ)/fundal_dev_free.o $(DOBJ)/fundal_registry.o
$(DOBJ)/fundal_dev_memcpy.o:        $(DOBJ)/fundal_env.o $(DOBJ)/fundal_registry.o $(DOBJ)/fundal_transpose_array.o \
                                    $(DOBJ)/fundal_utilities.o
$(DOBJ)/fundal_dev_assign.o:        $(DOBJ)/fundal_dev_alloc.o $(DOBJ)/fundal_dev_alloc_replace.o $(DOBJ)/fundal_dev_free.o \
                                    $(DOBJ)/fundal_dev_memcpy.o $(DOBJ)/fundal_transpose_array.o
$(DOBJ)/fundal.o:                   $(filter-out $(DOBJ)/fundal.o $(DOBJ)/fundal_mpih_object.o,$(LIBOBJS))
$(DOBJ)/fundal_mpih_object.o:       $(DOBJ)/fundal.o

# tests: every top-level program of src/tests (the agnostic .INC files live next to them)
TESTSRC = $(wildcard src/tests/fundal_*_test.F90)
TESTS   = $(addprefix $(DTST)/,$(notdir $(TESTSRC:.F90=)))

.PHONY: all lib tests clean
all: lib
lib: $(LIB)
tests: $(TESTS)

$(LIB): $(LIBOBJS)
	ar -rcs $@ $^

$(DOBJ)/%.o: src/lib/%.F90 $(COMMON) | $(DOBJ) $(DMOD)
	$(COMPILE) $< -o $@

$(DTST)/%: src/tests/%.F90 $(LIB) | $(DTST)
	$(FC) $(CPPFLAGS) $(FFLAGS) $(OFFLOAD) -Isrc/lib -Isrc/tests -I$(DMOD) $(MODFLAG) $(DTST) $< $(LIB) $(LIBS) -o $@

$(DOBJ) $(DMOD) $(DTST):
	mkdir -p $@

clean:
	rm -rf $(BUILD)
