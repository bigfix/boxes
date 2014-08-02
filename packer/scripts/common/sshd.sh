#!/bin/bash -eux

echo "UseDNS no" >> /etc/ssh/sshd_config
sed -i 's/^#\(GSSAPIAuthentication\)\s*.*$/\1/' /etc/ssh/ssh_config
