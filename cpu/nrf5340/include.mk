# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

DFLAGS += -mcpu=cortex-m33 -mthumb 
LDFLAGS += -mcpu=cortex-m33 -mthumb

CPU_LIST = application network
LINKER_SCRIPT_common = $(CPUS)/nrf5340/linker.ld
LINKER_SCRIPT_application = $(CPUS)/nrf5340/linker_application.ld
LINKER_SCRIPT_network = $(CPUS)/nrf5340/linker_network.ld

ARCHETYPE = multi-core

include $(CPUS)/arm/include.mk