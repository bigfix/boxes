TEMPLATES = $(notdir $(wildcard packer/*.json))
all: clean test
	cd packer; for template in $(TEMPLATES); do (packer build $$template); done

BUILDERS = $(dir $(wildcard builds/*/))
clean: 
	-for builder in $(BUILDERS); do (cd $$builder; rm -f *.box); done
	cd packer; rm -rf packer_cache

.PHONY: test
test: 
	nosetests test --verbose
