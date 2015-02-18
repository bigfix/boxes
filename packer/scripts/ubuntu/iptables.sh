#!/bin/bash -eux

cat > /home/vagrant/iptables.sh << OHANA_MEANS_FAMILY
jenkins=\$(dig +short jenkins.sfolab.ibm.com)
iptables -F

iptables -A INPUT -p tcp -s \$jenkins --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP

sudo debconf-set-selections <<< 'iptables-persistent iptables-persistent/autosave_v6 boolean true'
sudo debconf-set-selections <<< 'iptables-persistent iptables-persistent/autosave_v4 boolean true'

apt-get update
apt-get install -y iptables-persistent
OHANA_MEANS_FAMILY
chmod 744 /home/vagrant/iptables.sh