# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

EXAMPLES = $(patsubst examples/%,%,$(wildcard examples/*))
$(info Examples: $(EXAMPLES))

.PHONY: all build_examples

all: build_examples

define built_example =
.PHONY: build_$1
build_$1:
	$(MAKE) -C examples/$1

build_examples: build_$1
endef

$(foreach EXAMPLE,$(EXAMPLES),$(eval $(call built_example,$(EXAMPLE))))
