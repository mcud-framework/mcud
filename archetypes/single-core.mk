# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# This archetype defines targets which will built a simple '.elf' and '.bin'
# for a single-core SoC.

.PHONY: all
all: $(ELF_APP)
	$(RUN) $(TARGET)size $(ELF_APP)

$(BIN_APP): $(ELF_APP)
	$(RUN) $(OBJCOPY) -O binary $< $@

$(ELF_APP):  $(OBJ_APP) $(OBJ_PHOBOS) $(OBJ_DRUNTIME) $(LINKER_SCRIPT)
	@mkdir -p $(dir $@)
	$(RUN) $(LD) $(LDFLAGS) -o $@ $(call convert_path,$(OBJ_APP) $(OBJ_PHOBOS) $(OBJ_DRUNTIME))

$(OBJ_APP): $(SOURCES_APP)
	@mkdir -p $(dir $@)
	$(RUN) $(DC) $(DFLAGS) -c -o $@ $(call convert_path,$^)

$(OBJ_PHOBOS): $(SOURCES_LIBPHOBOS)
	@mkdir -p $(dir $@)
	$(RUN) $(DC) $(DFLAGS) -c -o $@ $(call convert_path,$^)

$(OBJ_DRUNTIME): $(SOURCES_DRUNTIME)
	@mkdir -p $(dir $@)
	$(RUN) $(DC) $(DFLAGS) -c -o $@ $(call convert_path,$^)