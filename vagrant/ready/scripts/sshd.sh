#!/bin/bash -eux

echo "UseDNS no" >> /etc/ssh/sshd_config
service ssh restart
