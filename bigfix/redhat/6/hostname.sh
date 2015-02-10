#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
	cat > /home/vagrant/hostname.sh << OHANA_MEANS_FAMILY
number=\$1
sed -i "s/^\(HOSTNAME=\)\s*.*$/\1redhat65x64-build-\${number}/" /etc/sysconfig/network
service network restart

sed -i "s/^\(127\.0\.0\.1\s*\)\(.*\)$/\1redhat65x64-build-\${number} \2/" /etc/hosts
sed -i "s/^\(::1\s*\)\(.*\)$/\1redhat65x64-build-\${number} \2/" /etc/hosts
OHANA_MEANS_FAMILY
	chmod 744 /home/vagrant/hostname.sh
fi
