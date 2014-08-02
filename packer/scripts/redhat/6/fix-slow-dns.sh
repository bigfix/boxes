#!/bin/bash -eux

# https://access.redhat.com/solutions/58625
if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
	echo 'RES_OPTIONS="single-request-reopen"' >> /etc/sysconfig/network
  service network restart
fi
