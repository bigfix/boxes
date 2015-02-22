define make-target
builds/virtualbox/$$(basename $(1)).box: packer/$(1) \
		$(addprefix packer/,$(shell grep -oE '[^"]+\.sh' packer/$(1))) \
		$(addprefix packer/,$(join http,$(shell grep -oE '[^"\{}]+\.cfg' packer/$(1) | uniq)))
	$$(eval v = $$(shell dev/bump.sh $$(basename $(1))))
	@cd packer && packer build -only=virtualbox-iso -force $(1)
endef

TEMPLATES := $(notdir $(wildcard packer/*.json))

check-provider = $(shell packer inspect -machine-readable packer/$(t) | \
		 awk -F ',' '{ if ($$3 == "template-builder" && $$4 == $(1)) print "$(t)" }')
VBOXTEMPLATES := $(foreach t,$(TEMPLATES),$(call check-provider,"virtualbox-iso"))
ESXTEMPLATES := $(foreach t,$(TEMPLATES),$(call check-provider,"vmware-iso"))

$(foreach t,$(VBOXTEMPLATES),$(eval $(call make-target,$(t))))

.PHONY: all validate packer virtualbox
all: $(VBOXTEMPLATES)

validate:
	@$(foreach t,$(VBOXTEMPLATES),echo $(t): $(shell cd packer && packer validate -only=virtualbox-iso $(t));) 
	@$(foreach t,$(ESXTEMPLATES),echo $(t): $(shell cd packer && packer validate -syntax-only -only=vmware-iso $(t));)

packer:
	dev/upgrade.sh packer

virtualbox:
	dev/upgrade.sh virtualbox
