# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

TARGET = arm-none-eabi-
DOCKER = seeseemelk/mcud:arm-none-eabi-2021-10-19
DIRS += $(CPUS)/arm
LIBS += -lc_nano
