#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
	if grep -q -i "release 6" /etc/redhat-release ; then
		rm /etc/udev/rules.d/70-persistent-net.rules
		mkdir /etc/udev/rules.d/70-persistent-net.rules
		rm /lib/udev/rules.d/75-persistent-net-generator.rules
	fi
	rm -rf /dev/.udev/
	if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ] ; then
		sed -i "/^HWADDR/d" /etc/sysconfig/network-scripts/ifcfg-eth0
		sed -i "/^UUID/d" /etc/sysconfig/network-scripts/ifcfg-eth0
	fi
fi

yum -y clean all

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync

cat /dev/null > ~/.bash_history && history -c
