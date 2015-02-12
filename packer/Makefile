TEMPLATES := $(wildcard *.json)

CHECK_VBOX = $(shell packer inspect -machine-readable $(t) | \
	     awk -F ',' '{ if ($$3 == "template-builder" && $$4 == "virtualbox-iso") print "$(t)" }')

virtualbox-iso: $(foreach t, $(TEMPLATES), $(CHECK_VBOX))
	@$(foreach t, $^, packer build -only=$@ -force $(t);)
