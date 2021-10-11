# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

DOCKERFILES = $(wildcard */Dockerfile)
IMAGES = $(DOCKERFILES:%/Dockerfile=%)
IMAGES := $(filter-out base,$(IMAGES))
DATE := $(shell date +%Y-%m-%d)

$(info Dockerfiles: $(DOCKERFILES))
$(info Images: $(IMAGES))

all: $(addsuffix /built,$(IMAGES))

define build_image =
.PHONY: build_$1
build_$1: $1/built

$1/built: $1/Dockerfile
	docker build $1 -t seeseemelk/mcud:$1-$(DATE)
	touch $1/built
endef

$(foreach image,$(IMAGES),$(eval $(call build_image,$(image))))
