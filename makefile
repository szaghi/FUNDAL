#!/usr/bin/make

#main building variables
MAKELIB = ar -rcs $(DEXE)libfundal.a $(DOBJ)*.o ; ranlib $(DEXE)libfundal.a
RULE    = FUNDAL
DSRC    = src
DOBJ    = exe/obj/
DMOD    = exe/mod/
DEXE    = exe/
LIBS    =
FC      = mpif90
OPTSC   = -cpp -c -acc -gpu=cc86 -fast -Minfo=all -DDEV_OAC -DCOMPILER_NVF -module exe/mod
OPTSL   = -acc -gpu=cc86 -fast -Minfo=all -module exe/mod
VPATH   = $(DSRC) $(DOBJ) $(DMOD)
MKDIRS  = $(DOBJ) $(DMOD) $(DEXE)
LCEXES  = $(shell echo $(EXES) | tr '[:upper:]' '[:lower:]')
EXESPO  = $(addsuffix .o,$(LCEXES))
EXESOBJ = $(addprefix $(DOBJ),$(EXESPO))

#auxiliary variables
COTEXT  = "Compiling $(<F)"
LITEXT  = "Assembling $@"

firsrule: $(RULE)

#building rules
$(DEXE)FUNDAL_TASTE: $(MKDIRS) $(DOBJ)fundal_taste.o
	@rm -f $(filter-out $(DOBJ)fundal_taste.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_TASTE
$(DEXE)FUNDAL_EXTERNAL_ROUTINE_TEST: $(MKDIRS) $(DOBJ)fundal_external_routine_test.o
	@rm -f $(filter-out $(DOBJ)fundal_external_routine_test.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_EXTERNAL_ROUTINE_TEST
$(DEXE)FUNDAL_DERIVED_TYPE_MEMCPY_TEST: $(MKDIRS) $(DOBJ)fundal_derived_type_memcpy_test.o
	@rm -f $(filter-out $(DOBJ)fundal_derived_type_memcpy_test.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_DERIVED_TYPE_MEMCPY_TEST
$(DEXE)FUNDAL_ALLOC_FREE_TEST: $(MKDIRS) $(DOBJ)fundal_alloc_free_test.o
	@rm -f $(filter-out $(DOBJ)fundal_alloc_free_test.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_ALLOC_FREE_TEST
$(DEXE)FUNDAL_USE_TEST: $(MKDIRS) $(DOBJ)fundal_use_test.o
	@rm -f $(filter-out $(DOBJ)fundal_use_test.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_USE_TEST
$(DEXE)FUNDAL_DEVICE_HANDLING_TEST: $(MKDIRS) $(DOBJ)fundal_device_handling_test.o
	@rm -f $(filter-out $(DOBJ)fundal_device_handling_test.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_DEVICE_HANDLING_TEST
$(DEXE)FUNDAL_SAVE_MEMORY_STATUS_TEST: $(MKDIRS) $(DOBJ)fundal_save_memory_status_test.o
	@rm -f $(filter-out $(DOBJ)fundal_save_memory_status_test.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_SAVE_MEMORY_STATUS_TEST
$(DEXE)FUNDAL_ARRAY_ACCESS_TEST: $(MKDIRS) $(DOBJ)fundal_array_access_test.o
	@rm -f $(filter-out $(DOBJ)fundal_array_access_test.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_ARRAY_ACCESS_TEST
$(DEXE)FUNDAL_ASSIGN_TEST: $(MKDIRS) $(DOBJ)fundal_assign_test.o
	@rm -f $(filter-out $(DOBJ)fundal_assign_test.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_ASSIGN_TEST
$(DEXE)FUNDAL_MEMCPY_TEST: $(MKDIRS) $(DOBJ)fundal_memcpy_test.o
	@rm -f $(filter-out $(DOBJ)fundal_memcpy_test.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_MEMCPY_TEST
$(DEXE)FUNDAL_MPI_DEV_ALLOC_TEST: $(MKDIRS) $(DOBJ)fundal_mpi_dev_alloc_test.o
	@rm -f $(filter-out $(DOBJ)fundal_mpi_dev_alloc_test.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_MPI_DEV_ALLOC_TEST
$(DEXE)FUNDAL_LAPLACE_DEV_INLINE: $(MKDIRS) $(DOBJ)fundal_laplace_dev_inline.o
	@rm -f $(filter-out $(DOBJ)fundal_laplace_dev_inline.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_LAPLACE_DEV_INLINE
$(DEXE)FUNDAL_LAPLACE_BASELINE: $(MKDIRS) $(DOBJ)fundal_laplace_baseline.o
	@rm -f $(filter-out $(DOBJ)fundal_laplace_baseline.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_LAPLACE_BASELINE
$(DEXE)FUNDAL_LAPLACE_DEV_ROUTINE: $(MKDIRS) $(DOBJ)fundal_laplace_dev_routine.o
	@rm -f $(filter-out $(DOBJ)fundal_laplace_dev_routine.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FUNDAL_LAPLACE_DEV_ROUTINE

FUNDAL: $(MKDIRS) $(DOBJ)fundal.o
	@echo $(LITEXT)
	@$(MAKELIB)

#compiling rules
$(DOBJ)fundal_taste.o: src/examples/fundal_taste.F90 \
	$(DOBJ)fundal.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_external_routine_test.o: src/tests/fundal_external_routine_test.F90 src/lib/fundal.H \
	$(DOBJ)fundal.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_derived_type_memcpy_test.o: src/tests/fundal_derived_type_memcpy_test.F90 src/lib/fundal.H \
	$(DOBJ)fundal.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_alloc_free_test.o: src/tests/fundal_alloc_free_test.F90 \
	$(DOBJ)fundal.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_use_test.o: src/tests/fundal_use_test.F90 \
	$(DOBJ)fundal.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_device_handling_test.o: src/tests/fundal_device_handling_test.F90 \
	$(DOBJ)fundal.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_save_memory_status_test.o: src/tests/fundal_save_memory_status_test.F90 src/lib/fundal.H \
	$(DOBJ)fundal.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_array_access_test.o: src/tests/fundal_array_access_test.F90 src/lib/fundal.H \
	$(DOBJ)fundal.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_assign_test.o: src/tests/fundal_assign_test.F90 src/lib/fundal.H \
	$(DOBJ)fundal.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_memcpy_test.o: src/tests/fundal_memcpy_test.F90 src/lib/fundal.H \
	$(DOBJ)fundal.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_mpi_dev_alloc_test.o: src/tests/mpi/fundal_mpi_dev_alloc_test.F90 src/lib/fundal.H \
	$(DOBJ)fundal.o \
	$(DOBJ)fundal_mpih_object.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_laplace_dev_inline.o: src/tests/laplace/fundal_laplace_dev_inline.F90 src/lib/fundal.H \
	$(DOBJ)fundal.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_laplace_baseline.o: src/tests/laplace/fundal_laplace_baseline.F90
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_laplace_dev_routine.o: src/tests/laplace/fundal_laplace_dev_routine.F90 src/lib/fundal.H \
	$(DOBJ)fundal.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_dev_assign.o: src/lib/fundal_dev_assign.F90 src/lib/fundal.H \
	$(DOBJ)fundal_dev_alloc.o \
	$(DOBJ)fundal_dev_free.o \
	$(DOBJ)fundal_dev_memcpy.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_dev_handling.o: src/lib/fundal_dev_handling.F90 src/lib/fundal.H \
	$(DOBJ)fundal_env.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_utilities.o: src/lib/fundal_utilities.F90
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_dev_free_unstructured.o: src/lib/fundal_dev_free_unstructured.F90 src/lib/fundal.H
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_dev_memcpy_unstructured.o: src/lib/fundal_dev_memcpy_unstructured.F90 src/lib/fundal.H
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal.o: src/lib/fundal.F90 \
	$(DOBJ)fundal_dev_alloc_unstructered.o \
	$(DOBJ)fundal_dev_alloc.o \
	$(DOBJ)fundal_dev_free_unstructured.o \
	$(DOBJ)fundal_dev_free.o \
	$(DOBJ)fundal_dev_memcpy_unstructured.o \
	$(DOBJ)fundal_dev_memcpy.o \
	$(DOBJ)fundal_dev_assign.o \
	$(DOBJ)fundal_dev_handling.o \
	$(DOBJ)fundal_env.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_mpih_object.o: src/lib/fundal_mpih_object.F90 src/lib/fundal.H \
	$(DOBJ)fundal.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_env.o: src/lib/fundal_env.F90
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_dev_free.o: src/lib/fundal_dev_free.F90 src/lib/fundal.H \
	$(DOBJ)fundal_env.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_dev_memcpy.o: src/lib/fundal_dev_memcpy.F90 src/lib/fundal.H \
	$(DOBJ)fundal_env.o \
	$(DOBJ)fundal_utilities.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_dev_alloc.o: src/lib/fundal_dev_alloc.F90 src/lib/fundal.H \
	$(DOBJ)fundal_env.o \
	$(DOBJ)fundal_utilities.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)fundal_dev_alloc_unstructered.o: src/lib/fundal_dev_alloc_unstructered.F90 src/lib/fundal.H
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

#phony auxiliary rules
.PHONY : $(MKDIRS)
$(MKDIRS):
	@mkdir -p $@
.PHONY : cleanobj
cleanobj:
	@echo deleting objects
	@rm -fr $(DOBJ)
.PHONY : cleanmod
cleanmod:
	@echo deleting mods
	@rm -fr $(DMOD)
.PHONY : cleanexe
cleanexe:
	@echo deleting exes
	@rm -f $(addprefix $(DEXE),$(EXES))
.PHONY : clean
clean: cleanobj cleanmod
.PHONY : cleanall
cleanall: clean cleanexe
