# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

DIRS += $(CPUS)/stm32l496
LINKER_SCRIPT = $(CPUS)/stm32l496/linker_$(LINKER_VARIANT).ld

include $(CPUS)/stm32/include.mk
