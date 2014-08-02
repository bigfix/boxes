#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
	VBOX_VERSION=$(cat .vbox_version)
	mount -o loop /tmp/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
	sh /mnt/VBoxLinuxAdditions.run --nox11
	umount /mnt
	rm -f /tmp/VBoxGuestAdditions_$VBOX_VERSION.iso
fi
