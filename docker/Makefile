DOCKERFILES = $(wildcard */Dockerfile)
IMAGES = $(DOCKERFILES:%/Dockerfile=%)
IMAGES := $(filter-out base,$(IMAGES))
DATE := $(shell date +%Y-%m-%d)

$(info Dockerfiles: $(DOCKERFILES))
$(info Images: $(IMAGES))

all: $(addsuffix /built,$(IMAGES))

base/built: base/Dockerfile
	docker build base -t seeseemelk/mcud:base-$(DATE) --network=host
	touch base/built

define build_image =
.PHONY: build_$1
build_$1: $1/built

$1/built: $1/Dockerfile base/built
	docker build $1 -t seeseemelk/mcud:$1-$(DATE)
	touch $1/built
endef

$(foreach image,$(IMAGES),$(eval $(call build_image,$(image))))
