#!/bin/bash -eux

cat > /home/vagrant/hostname.sh << OHANA_MEANS_FAMILY
number=\$1

sed -i "s/^\(HOSTNAME=\)\s*.*$/\1${BOXNAME}-\${number}/" /etc/sysconfig/network
service network restart

sed -i "s/^\(127\.0\.0\.1\s*\)\(.*\)$/\1${BOXNAME}-\${number} \2/" /etc/hosts
sed -i "s/^\(::1\s*\)\(.*\)$/\1${BOXNAME}-\${number} \2/" /etc/hosts
OHANA_MEANS_FAMILY
chmod 744 /home/vagrant/hostname.sh