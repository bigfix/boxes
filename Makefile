.PHONY: clean test

BUILDERS = $(dir $(wildcard builds/*/))
clean: 
	-for builder in $(BUILDERS); do (cd $$builder; rm -f *.box); done
	cd packer; rm -rf packer_cache

test: 
	nosetests test --verbose
