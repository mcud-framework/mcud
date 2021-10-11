# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# This archetype defines targets which will built multiple '.elf' files for a
# multi-core SoC.

ifeq (,$(CPU_LIST))
$(error CPU_LIST was set)
endif

ALL_BINS :=
ALL_ELFS :=

define targets_for_cpu
$(eval VERSIONS_$1 ?= CORE_$1)
$(eval DFLAGS_$1 ?= $(DFLAGS) $(VERSIONS_$1:%=-fversion=%))
$(eval LDFLAGS_$1 ?= $(filter-out -T $(LINKER_SCRIPT),$(LDFLAGS)) -T $(LINKER_SCRIPT_$1))

$(eval BIN_APP_$1 = $(BIN_APP:%.bin=%_$1.bin))
$(eval ELF_APP_$1 = $(ELF_APP:%.elf=%_$1.elf))
$(eval OBJ_APP_$1 = $(OBJ_APP:%.o=%_$1.o))
$(eval OBJ_PHOBOS_$1 = $(OBJ_PHOBOS:%.o=%_$1.o))
$(eval OBJ_DRUNTIME_$1 = $(OBJ_DRUNTIME:%.o=%_$1.o))

ALL_BINS += $(BIN_APP_$1)
ALL_ELFS += $(ELF_APP_$1)
VARIANTS += $1

$(BIN_APP_$1): $(ELF_APP_$1)
	$(RUN) $(OBJCOPY) -O binary $$< $$@

$(ELF_APP_$1): $(OBJ_APP_$1) $(OBJ_PHOBOS_$1) $(OBJ_DRUNTIME_$1) $(LINKER_SCRIPT_$1)
	@mkdir -p $$(dir $$@)
	$(RUN) $(LD) -MD -MP -MF $$(@:%.elf=%.elf.dep) \
		$$(call convert_path,$$(LDFLAGS_$1)) \
		-o $$@ $$(call convert_path,$(OBJ_APP_$1) \
		$(OBJ_PHOBOS_$1) $(OBJ_DRUNTIME_$1)) -lc_nano

$(OBJ_APP_$1): $(SOURCES_APP)
	@mkdir -p $$(dir $$@)
	$(RUN) $(DC) $(DFLAGS_$1) -c -o $$@ $$(call convert_path,$$^)

$(OBJ_PHOBOS_$1): $(SOURCES_LIBPHOBOS)
	@mkdir -p $$(dir $$@)
	$(RUN) $(DC) $(DFLAGS_$1) -c -o $$@ $$(call convert_path,$$^)

$(OBJ_DRUNTIME_$1): $(SOURCES_DRUNTIME)
	@mkdir -p $$(dir $$@)
	$(RUN) $(DC) $(DFLAGS_$1) -c -o $$@ $$(call convert_path,$$^)
endef

$(foreach cpu,$(CPU_LIST),$(eval $(call targets_for_cpu,$(cpu))))
.PHONY: all
all: $(ALL_ELFS) $(ALL_BINS)
	$(RUN) $(TARGET)size $(ALL_ELFS)