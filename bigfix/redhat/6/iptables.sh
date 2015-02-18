#!/bin/bash -eux

cat > /home/vagrant/iptables.sh << OHANA_MEANS_FAMILY
jenkins=\$(dig +short jenkins.sfolab.ibm.com)
service iptables stop
iptables -F

iptables -A INPUT -p tcp -s \$jenkins --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP

service iptables save
chkconfig iptables on
service iptables start
OHANA_MEANS_FAMILY
chmod 744 /home/vagrant/iptables.sh