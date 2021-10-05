# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# The location of the MCUd directory.
_MCUD := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
MCUD ?= $(_MCUD)

# The directory containing the application sources.
APP_SRC ?= source

# The directory which will containg compiled binaries.
BIN_DIR ?= bin/$(BOARD)

# The directory which will contain distribution files.
DIST ?= $(MCUD)/dist

# The source directory of MCUd.
MCUD_SRC = $(MCUD)/source

# The directory containing the default boards
BOARDS = $(MCUD)/boards

# The directory containing the sources for the D runtime.
DIR_DRUNTIME = $(MCUD)/libd

# The directory containing the sources for libphobos.
DIR_LIBPHOBOS = $(MCUD)/libphobos

# The directory containing CPU sources.
CPUS = $(MCUD)/cpu

# The output ELF file.
ELF_APP = $(BIN_DIR)/application.elf

# The output ELF file for unit testing.
ELF_TEST_FILE = $(BIN_DIR)/test.elf

# The output BIN file.
BIN_APP = $(ELF_APP:%.elf=%.bin)

# The output object file.
OBJ_APP = $(BIN_DIR)/application.o

# The object file for the D runtime
OBJ_DRUNTIME = $(BIN_DIR)/druntime.o

# The object file for the Phobos standard library
OBJ_PHOBOS = $(BIN_DIR)/phobos.o

# The linker script to use.
LINKER_SCRIPT = $(CPUS)/$(CPU)/linker.ld

# Use docker if docker hasn't been explicitly disabled
USE_DOCKER ?= yes

# Set of variants, used by the dub generator to generate configurations.
VARIANTS :=

ifeq (,$(BOARD))
$(error No board was set)
endif

ifneq (,$(wildcard $(BOARD)))
BOARD_DIR = $(BOARD)
else
BOARD_DIR = $(wildcard $(BOARDS)/$(BOARD))
endif
include $(BOARD_DIR)/include.mk

ifeq (,$(CPU))
$(error No CPU was set. Make sure your board definition sets CPU)
endif

.DEFAULT_GOAL := all

# Include CPU targets
include $(CPUS)/$(CPU)/include.mk

$(info Docker: $(DOCKER))
ifeq (yes,$(USE_DOCKER))
convert_path = $(subst $(MCUD),/mcud,$1)
RUN := docker run -t --rm --network none \
	-v $(CURDIR):/src \
	-v $(abspath $(MCUD)):/mcud \
	-w /src \
	-u $(shell id -u):$(shell id -g) \
	$(DOCKER)
else
convert_path = $1
RUN :=
endif

# Find all the sources to build.
# Common sources
COMMONSOURCES += $(shell find $(APP_SRC) -type f -iname "*.d")

# Test-only sources
TESTSOURCES += $(shell find $(MCUD_SRC) -type f -iname "*.d")
TESTSOURCES := $(COMMONSOURCES) $(TESTSOURCES)

# Build-only sources
DIRS += $(wildcard $(MCUD_SRC))
DIRS += $(CPUS)/$(CPU)
DIRS += $(BOARD_DIR)
DIRS := $(DIRS)
SOURCES_APP += $(shell find $(DIRS) -type f -iname "*.d" )
SOURCES_APP := $(COMMONSOURCES) $(SOURCES_APP)
SOURCES_DRUNTIME += $(shell find $(DIR_DRUNTIME) -type f -iname "*.d")
SOURCES_LIBPHOBOS += $(shell find $(DIR_LIBPHOBOS) -type f -iname "*.d")

OBJECTS_APP = $(SOURCES:%.d=$(BIN_DIR)/%.d.o)
OBJECTS_DRUNTIME = $(SOURCES_DRUNTIME:%.d=$(BIN_DIR)/%.d.o)
OBJECTS_LIBPHOBOS = $(SOURCES_LIBPHOBOS:%.d=$(BIN_DIR)/%.d.o)

# The host D compiler to use.
HOSTDC = gdc
# The D compiler to use.
DC := $(TARGET)gdc
# The linker to use.
LD := $(TARGET)gcc
# Flags to pass to the D compiler.
DFLAGS += -nostdlib -Os -ggdb -flto \
	-ffunction-sections \
	-fdata-sections \
	-fno-moduleinfo \
	-fno-exceptions \
	-fno-switch-errors \
	-I$(DIR_DRUNTIME) \
	-I$(DIR_LIBPHOBOS) \
	-I$(MCUD_SRC)
DFLAGS += $(VERSIONS:%=-fversion=%)
DFLAGS := $(call convert_path,$(DFLAGS))
# Flags to pass to the compiler when building tests.
HOSTDFLAGS = -funittest -fmain -ggdb
LDFLAGS += -Wl,-gc-sections -Os -flto -nostdlib
ifneq (,$(LINKER_SCRIPT))
LDFLAGS += -L $(CPUS)/$(CPU) -T $(LINKER_SCRIPT)
endif
# The tool to strip binaries with.
STRIP = $(TARGET)strip
# The tool to copy object files with.
OBJCOPY = $(TARGET)objcopy

.PHONY: test
test: $(ELF_TEST_FILE)
	@echo "Running tests..."
	@$(ELF_TEST_FILE)
	@echo "Tests succeeded!"

.PHONY: info
info:
	@echo "Sources: $(SOURCES)"
	@echo "App sources: $(APP_SRC)"
	@echo "D4MCU sources: $(MCUD_SRC)"
	@echo "Binaries directory: $(BIN_DIR)"
	@echo "Firmware binary: $(BIN_APP)"

.PHONY: clean
clean:
	rm -rf $(BIN_DIR)

.PHONY: distclean
distclean: clean
	rm -rf $(DIST)

$(ELF_TEST_FILE): $(TESTSOURCES) $(MCUD)/include.mk
	mkdir -p $(dir $@)
	$(RUN) $(HOSTDC) $(HOSTDFLAGS) -o $@ $(TESTSOURCES)

.PHONY: dub
dub:
	$(MCUD)/tools/generate_dub.d "$(MCUD)" $(SUPPORTED_BOARDS) > dub.sdl

define VARIANT_INFO
	@echo "VERSION_$V=$(VERSIONS_$V)"
	
endef

.PHONY: describe
describe:
	@echo "MCUD=$(MCUD)"
	@echo "BOARD=$(BOARD)"
	@echo "BOARD_DIR=$(BOARD_DIR)"
	@echo "VARIANTS=$(VARIANTS)"
	@echo "CPU=$(CPU)"
	@echo "DIRS=$(DIRS)"
	$(foreach V,$(VARIANTS),$(call VARIANT_INFO,$V))

ifeq (,$(ARCHETYPE))
$(error CPU did not set an archetype)
else
include $(MCUD)/archetypes/$(ARCHETYPE).mk
endif

ifneq (,$(wildcard $(CPUS)/$(CPU)/postlude.mk))
include $(CPUS)/$(CPU)/postlude.mk
endif
