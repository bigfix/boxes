#!/bin/bash -eux

rpm --import http://packages.atrpms.net/RPM-GPG-KEY.atrpms
rpm -i http://dl.atrpms.net/all/atrpms-repo-6-7.el6.x86_64.rpm

sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/atrpms.repo
