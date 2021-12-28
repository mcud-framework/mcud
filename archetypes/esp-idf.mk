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
ESP_IDF_DEP = $(MCUD)/dist/esp-idf/README.md

ESP_IDF_JOBS = $(filter -j%,$(MAKEFLAGS))

$(ELF_APP): $(ESP_IDF_OBJ) $(ESP_IDF_DEP)
	rm -f $(ELF_APP)
	$(call RUN_ARGS, \
		-e IDF_PATH=$(call convert_path,$(MCUD)/dist/esp-idf) \
		-e MCUD_OBJECTS="$(call convert_path,$(ESP_IDF_OBJ))" \
	) \
	make -f $(call convert_path,$(IDF_PROJECT)/Makefile) BATCH_BUILD=1 $(ESP_IDF_JOBS) all

include $(ARCHETYPES)/base-objects.mk

$(ESP_IDF_DEP):
	cd $(MCUD) && git submodule update --init --recursive dist/esp-idf
	find $(MCUD)/dist/esp-idf -type f -exec touch -t 202112220000 {} \;
# === END OF BUILD TARGETS ===

# === BUILD CACHE TARGETS ===
BUILDCACHE_ARCHIVE = esp-idf-2021-12-23.tar.xz
BUILDCACHE_DIR = $(MCUD)/dist/buildcache
BUILDCACHE_PATH = $(BUILDCACHE_DIR)/$(BUILDCACHE_ARCHIVE)
.PHONY: download_buildcache_esp_idf
download_buildcache_esp_idf: $(BUILDCACHE_PATH) $(ESP_IDF_DEP)
	tar -x -f $(BUILDCACHE_PATH) -C $(IDF_PROJECT)
download_buildcache: download_buildcache_esp_idf

$(BUILDCACHE_PATH):
	mkdir -p $(BUILDCACHE_DIR)
	curl -o $(BUILDCACHE_PATH).download https://raw.githubusercontent.com/mcud-framework/buildcache/main/$(BUILDCACHE_ARCHIVE)
	mv $(BUILDCACHE_PATH).download $(BUILDCACHE_PATH)
# === END OF BUILD CACHE TARGETS ===

# === GENERAL TARGETS ===
all: $(ELF_APP)

flash: $(ELF_APP)
	IDF_PATH=$(MCUD)/dist/esp-idf MCUD_OBJECTS="$^" $(MAKE) -f $(IDF_PROJECT)/Makefile BATCH_BUILD=1 flash
# === END OF GENERAL TARGETS ===
