define make-target
$(1): $(shell grep -oE '[^"]+\.sh' $(1)) $(join http,$(shell grep -oE '[^"\{}]+\.cfg' $(1) | uniq))
	$$(eval v = $$(shell dev/bump.sh $$(basename $$@)))
	@packer build -only=virtualbox-iso -force $$@
endef

TEMPLATES := $(wildcard *.json)

check-provider = $(shell packer inspect -machine-readable $(t) | \
		 awk -F ',' '{ if ($$3 == "template-builder" && $$4 == $(1)) print "$(t)" }')
VBOXTEMPLATES := $(foreach t, $(TEMPLATES), $(call check-provider,"virtualbox-iso"))
$(foreach t, $(VBOXTEMPLATES), $(eval $(call make-target,$(t))))

.PHONY: all packer virtualbox
all: $(VBOXTEMPLATES)

packer:
	dev/upgrade.sh packer

virtualbox:
	dev/upgrade.sh virtualbox