#!/bin/bash -eux

yum -y clean all

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync

cat /dev/null > ~/.bash_history && history -c
