#!/bin/bash -eux

echo -e "\nUseDNS no" >> /etc/ssh/sshd_config
service ssh restart
