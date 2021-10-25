# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# This archetype defines a target which builds the firmware using the ESP-IDF
# SDK.


IDF_PROJECT = $(MCUD)/dist/esp-idf-project
ELF_APP = $(IDF_PROJECT)/build/mcud_application.elf

$(ELF_APP):  $(OBJ_APP) $(OBJ_PHOBOS) $(OBJ_DRUNTIME)
	rm -f $(ELF_APP)
	IDF_PATH=$(MCUD)/dist/esp-idf MCUD_OBJECTS="$^" $(MAKE) -f $(IDF_PROJECT)/Makefile BATCH_BUILD=1 all

include $(ARCHETYPES)/base-objects.mk

all: $(ELF_APP)

flash: $(ELF_APP)
	IDF_PATH=$(MCUD)/dist/esp-idf MCUD_OBJECTS="$^" $(MAKE) -f $(IDF_PROJECT)/Makefile BATCH_BUILD=1 flash