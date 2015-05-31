#!/bin/bash -eux

echo -e "\nUseDNS no" >> /etc/ssh/sshd_config
sed -i 's/^#\(GSSAPIAuthentication\)\s*.*$/\1/' /etc/ssh/ssh_config
