#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
	cat > /home/vagrant/iptables.sh << OHANA_MEANS_FAMILY
jenkins=$(dig +short jenkins.sfolab.ibm.com)
service iptables stop
iptables -F

iptables -I INPUT -p tcp -s $jenkins --dport 22 -j ACCEPT
iptables -I INPUT -p tcp -s 0.0.0.0/0 --dport 22 -j DROP

service iptables save
chkconfig iptables on
service iptables start
OHANA_MEANS_FAMILY
	chmod 744 /home/vagrant/iptables.sh
fi
