#!/bin/bash -eux

interface=$(netstat -ie | grep -B1 "172." | head -n 1 | awk -F '[: ]' '{ print $1 }')

sed -i 's/^#\(domain-name\)\s*.*$/\1=test/' /etc/avahi/avahi-daemon.conf
sed -i 's/^\(browse-domains\s*.*\)$/#\1/' /etc/avahi/avahi-daemon.conf
sed -i 's,^#\(allow-interfaces\)\s*.*$,\1='"$interface"',' /etc/avahi/avahi-daemon.conf

cat > /etc/mdns.allow << OHANA_MEANS_FAMILY
.test.
.test
OHANA_MEANS_FAMILY

sed -i 's/^\(hosts:.*\)$/\1 mdns/' /etc/nsswitch.conf
sed -i 's/^\(hosts:.*\)mdns[46]_minimal \(.*\)$/\1\2/' /etc/nsswitch.conf

service avahi-daemon restart
