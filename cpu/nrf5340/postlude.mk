# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

$(ELF_APP_application): $(LINKER_SCRIPT_application) $(LINKER_SCRIPT_common)
$(ELF_APP_network): $(LINKER_SCRIPT_network) $(LINKER_SCRIPT_common)