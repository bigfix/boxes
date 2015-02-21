define make-target
../builds/virtualbox/$$(basename $(1)).box: $(1) \
		$(shell grep -oE '[^"]+\.sh' $(1)) \
		$(join http,$(shell grep -oE '[^"\{}]+\.cfg' $(1) | uniq))
	$$(eval v = $$(shell dev/bump.sh $$(basename $(1))))
	@packer build -only=virtualbox-iso -force $$@
endef

TEMPLATES := $(wildcard *.json)

check-provider = $(shell packer inspect -machine-readable $(t) | \
		 awk -F ',' '{ if ($$3 == "template-builder" && $$4 == $(1)) print "$(t)" }')
VBOXTEMPLATES := $(foreach t, $(TEMPLATES), $(call check-provider,"virtualbox-iso"))
ESXTEMPLATES := $(foreach t, $(TEMPLATES), $(call check-provider,"vmware-iso"))

$(foreach t, $(VBOXTEMPLATES), $(eval $(call make-target,$(t))))

.PHONY: all validate packer virtualbox
all: $(VBOXTEMPLATES)

validate:
	@$(foreach t, $(VBOXTEMPLATES), echo $(t): $(shell packer validate -only=virtualbox-iso $(t));) 
	@$(foreach t, $(ESXTEMPLATES), echo $(t): $(shell packer validate -syntax-only -only=vmware-iso $(t));)

packer:
	dev/upgrade.sh packer

virtualbox:
	dev/upgrade.sh virtualbox
