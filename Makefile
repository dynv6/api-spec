SOURCEDIR := api
SOURCES := $(shell find $(SOURCEDIR) -name '*.yml')

dist/zone-update.yml: $(SOURCES)
	speccy resolve -j --internal-refs -o $@ api/zone-update.yml

.PHONY: lint
lint:
	speccy lint api/zone-update.yml
