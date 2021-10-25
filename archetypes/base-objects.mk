# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# This archetype defines targets which will built some '.o' objects for a 
# single-core SoC.

$(OBJ_APP): $(SOURCES_APP)
	@mkdir -p $(dir $@)
	$(RUN) $(DC) $(DFLAGS) -c -o $@ $(call convert_path,$^)

$(OBJ_PHOBOS): $(SOURCES_LIBPHOBOS)
	@mkdir -p $(dir $@)
	$(RUN) $(DC) $(DFLAGS) -c -o $@ $(call convert_path,$^)

$(OBJ_DRUNTIME): $(SOURCES_DRUNTIME)
	@mkdir -p $(dir $@)
	$(RUN) $(DC) $(DFLAGS) -c -o $@ $(call convert_path,$^)
