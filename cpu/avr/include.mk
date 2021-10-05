# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

TARGET = avr-
DFLAGS +=  -B /usr/lib/gcc/avr/11.2.0/
DOCKER ?= seeseemelk/mcud:avr-2021-07-30
DIRS += $(CPUS)/avr
ARCHETYPE = single-core

.PHONY: flash
flash: $(BIN_APP)
