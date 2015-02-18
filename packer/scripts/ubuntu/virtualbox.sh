#!/bin/bash -eux

wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
cat > /etc/apt/sources.list.d/virtualbox.sources.list << OHANA_MEANS_FAMILY
deb http://download.virtualbox.org/virtualbox/debian trusty contrib
OHANA_MEANS_FAMILY

apt-get update
apt-get install -y virtualbox-4.3 dkms