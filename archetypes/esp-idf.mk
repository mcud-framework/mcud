# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# This archetype defines a target which builds the firmware using the ESP-IDF
# SDK.

# === BUILD TARGETS ===
DOCKER_NEEDS_NETWORK = yes
IDF_PROJECT = $(MCUD)/dist/esp-idf-project
ELF_APP = $(IDF_PROJECT)/build/mcud_application.elf

ESP_IDF_OBJ = $(OBJ_APP) $(OBJ_PHOBOS) $(OBJ_DRUNTIME)

ESP_IDF_JOBS = $(filter -j%,$(MAKEFLAGS))

$(ELF_APP): $(ESP_IDF_OBJ) get-esp-idf
	rm -f $(ELF_APP)
	$(call RUN_ARGS, \
		-e IDF_PATH=$(call convert_path,$(MCUD)/dist/esp-idf) \
		-e MCUD_OBJECTS="$(call convert_path,$(ESP_IDF_OBJ))" \
	) \
	make -f $(call convert_path,$(IDF_PROJECT)/Makefile) BATCH_BUILD=1 $(ESP_IDF_JOBS) all

include $(ARCHETYPES)/base-objects.mk

get-esp-idf:
	cd $(MCUD) && git submodule update --init --recursive dist/esp-idf
# === END OF BUILD TARGETS ===

# === BUILD CACHE TARGETS ===
BUILDCACHE_ARCHIVE = 2021-12-23.tar.xz
BUILDCACHE_DIR = $(MCUD)/dist/buildcache
BUILDCACHE_PATH = $(BUILDCACHE_DIR)/$(BUILDCACHE_ARCHIVE)
download_buildcache: $(BUILDCACHE_PATH)
	tar -x -f $(BUILDCACHE_PATH) -C $(IDF_PROJECT)

$(BUILDCACHE_PATH):
	mkdir -p $(BUILDCACHE_DIR)
	curl -o $(BUILDCACHE_PATH).download https://raw.githubusercontent.com/mcud-framework/buildcache-esp-idf/main/$(BUILDCACHE_ARCHIVE)
	mv $(BUILDCACHE_PATH).download $(BUILDCACHE_PATH)
# === END OF BUILD CACHE TARGETS ===

# === GENERAL TARGETS ===
all: $(ELF_APP)

flash: $(ELF_APP)
	IDF_PATH=$(MCUD)/dist/esp-idf MCUD_OBJECTS="$^" $(MAKE) -f $(IDF_PROJECT)/Makefile BATCH_BUILD=1 flash
# === END OF GENERAL TARGETS ===