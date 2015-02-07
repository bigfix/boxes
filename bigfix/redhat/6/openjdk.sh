#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
	rpm -qa | grep -q java-1.8.0-openjdk || yum install -y java-1.8.0-openjdk
fi