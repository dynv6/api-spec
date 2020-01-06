SOURCEDIR := api
ROOT_SPEC := $(SOURCEDIR)/openapi.yml
SOURCES := $(shell find $(SOURCEDIR) -name '*.yml')

SPECCY_VERSION      = 0.11.0
OPENAPI_GEN_VERSION = 4.2.2

dist/zone-update.yml: $(SOURCES)
	docker run --rm -v $(PWD):/project \
		wework/speccy:$(SPECCY_VERSION) speccy resolve \
			--json-schema \
			--internal-refs \
			--output $@ \
			$(ROOT_SPEC)

.PHONY: lint
lint:
	docker run --rm -v $(PWD):/project \
		wework/speccy:$(SPECCY_VERSION) lint \
			/project/$(ROOT_SPEC)

.PHONY: validate
validate:
	docker run --rm -v $(PWD):/local \
		openapitools/openapi-generator-cli:v$(OPENAPI_GEN_VERSION) validate \
			-i /local/$(ROOT_SPEC)

.PHONY: docs
docs: docs/openapi.json docs/index.html

docs/openapi.json: $(SOURCES)
	docker run --rm -v $(PWD):/local \
		openapitools/openapi-generator-cli:v$(OPENAPI_GEN_VERSION) generate \
			-g openapi \
			-o /local/docs \
			-i /local/$(ROOT_SPEC)

docs/index.html: $(SOURCES)
	docker run --rm -v $(PWD):/local \
		openapitools/openapi-generator-cli:v$(OPENAPI_GEN_VERSION) generate \
			-g html \
			-o /local/docs \
			-i /local/$(ROOT_SPEC)
