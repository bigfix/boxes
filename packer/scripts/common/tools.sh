#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
	VBOX_VERSION=$(cat .vbox_version)
	mount -o loop /tmp/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
	sh /mnt/VBoxLinuxAdditions.run --nox11
	umount /mnt
	rm -f /tmp/VBoxGuestAdditions_$VBOX_VERSION.iso
fi

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
	if [[ -f /etc/redhat-release ]]; then
		if grep -q -i "release 6" /etc/redhat-release ; then
			yum erase -y fuse
		fi
	elif [[ -f /etc/lsb-release ]]; then
		if grep -q -i "Ubuntu" /etc/lsb-release; then
			apt-get update
			apt-get install -y open-vm-tools
			exit $?
		fi
	fi

	if [[ -f /tmp/linux.iso ]]; then
		tools=/tmp/linux.iso
	else
		tools=/dev/cdrom
	fi

	mkdir -p /mnt/cdrom
	mount -o loop $tools /mnt/cdrom
	tar zxf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/
	/tmp/vmware-tools-distrib/vmware-install.pl --default
	rm -f /tmp/linux.iso
	umount /mnt/cdrom
	rmdir /mnt/cdrom
fi
