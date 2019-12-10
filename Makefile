SOURCEDIR := api
ROOT_SPEC := $(SOURCEDIR)/zone-update.yml
SOURCES := $(shell find $(SOURCEDIR) -name '*.yml')

dist/zone-update.yml: $(SOURCES)
	speccy resolve -j --internal-refs -o $@ $(ROOT_SPEC)

.PHONY: lint
lint:
	speccy lint $(ROOT_SPEC)

.PHONY: validate
validate:
	openapi-generator validate -i $(ROOT_SPEC)
