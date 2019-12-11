SOURCEDIR := api
ROOT_SPEC := $(SOURCEDIR)/zone-update.yml
SOURCES := $(shell find $(SOURCEDIR) -name '*.yml')

dist/zone-update.yml: $(SOURCES)
	speccy resolve -j --internal-refs -o $@ $(ROOT_SPEC)

.PHONY: lint
lint:
	docker run --rm \
		-v ${PWD}:/project wework/speccy:0.11.0 \
		lint /project/$(ROOT_SPEC)

.PHONY: validate
validate:
	docker run --rm \
		-v ${PWD}:/local openapitools/openapi-generator-cli:v4.2.2 validate \
		-i /local/$(ROOT_SPEC)

.PHONY: docs
docs:
	docker run --rm \
		-v ${PWD}:/local openapitools/openapi-generator-cli:v4.2.2 generate \
		-g html \
		-o /local/docs \
		-i /local/$(ROOT_SPEC)
