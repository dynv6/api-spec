SOURCEDIR := api
ROOT_SPEC := $(SOURCEDIR)/openapi.yml
SOURCES := $(shell find $(SOURCEDIR) -name '*.yml')

SPECCY_VERSION      = 0.11.0
OPENAPI_GEN_VERSION = 4.3.1

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
docs: docs/index.html

docs/index.html: publisher/.have-image $(SOURCES)
	docker run --rm -v $(PWD):/local \
		-u $(shell id -u):$(shell id -g) \
		dynv6/publisher:latest \
		npx redoc-cli bundle -o /local/$@ /local/api/openapi.yml

publisher/.have-image: publisher/Dockerfile publisher/package.json
	cd publisher && docker build --pull --tag dynv6/publisher:latest .
	touch $@
