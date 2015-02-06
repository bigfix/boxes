#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
	VBOX_VERSION=$(cat .vbox_version)
	mount -o loop /tmp/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
	sh /mnt/VBoxLinuxAdditions.run --nox11
	umount /mnt
	rm -f /tmp/VBoxGuestAdditions_$VBOX_VERSION.iso
fi

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
	if grep -q -i "release 6" /etc/redhat-release ; then
		yum erase -y fuse
	fi

	cd /tmp
	mkdir -p /mnt/cdrom
	mount -o loop /tmp/linux.iso /mnt/cdrom
	tar zxf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/
	/tmp/vmware-tools-distrib/vmware-install.pl --default
	rm -f /tmp/linux.iso
	umount /mnt/cdrom
	rmdir /mnt/cdrom
fi
