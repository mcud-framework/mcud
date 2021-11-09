# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# This archetype defines a target which builds the firmware using the ESP-IDF
# SDK.


IDF_PROJECT = $(MCUD)/dist/esp-idf-project
ELF_APP = $(IDF_PROJECT)/build/mcud_application.elf

ESP_IDF_OBJ = $(OBJ_APP) $(OBJ_PHOBOS) $(OBJ_DRUNTIME)

$(ELF_APP): $(ESP_IDF_OBJ) get-esp-idf
	rm -f $(ELF_APP)
	IDF_PATH=$(MCUD)/dist/esp-idf MCUD_OBJECTS="$(ESP_IDF_OBJ)" $(MAKE) -f $(IDF_PROJECT)/Makefile BATCH_BUILD=1 all

include $(ARCHETYPES)/base-objects.mk

get-esp-idf:
	git submodule update --init $(MCUD)/dist/esp-idf

all: $(ELF_APP)

flash: $(ELF_APP)
	IDF_PATH=$(MCUD)/dist/esp-idf MCUD_OBJECTS="$^" $(MAKE) -f $(IDF_PROJECT)/Makefile BATCH_BUILD=1 flash