# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

DFLAGS += -mcpu=cortex-m4 -mthumb 
DIRS += $(CPUS)/stm32
ARCHETYPE = single-core

include $(CPUS)/arm/include.mk

.PHONY: flash
flash: $(BIN_APP)
	st-flash write $< 0x08000000