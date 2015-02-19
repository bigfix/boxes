#!/bin/bash

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $dir/util.source.sh

target=$1

expected_version=$(get $target)

if [[ "$target" = "virtualbox" ]]; then
	actual_version=$(vboxmanage --version)

	major_version=$(sed -rn 's/^virtualbox\t([0-9]*\.[0-9]*)\..*$/\1/p' $dir/VERSIONS)

	sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/virtualbox.sources.list" \
		-o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
	sudo apt-get install --only-upgrade virtualbox-$(version)

	if [[ "$actual_version" -ne "$expected_version" ]]; then
		bump virtualbox $actual_version
	fi
elif [[ "$target" = "packer" ]]; then
	actual_version=""
	if command -v packer 2>&1 >/dev/null; then
		action_version=$(packer version | grep -oE '[0-9\.]*')
	fi

	latest_version=$(curl -sS https://packer.io/downloads.html | \
		sed -nr 's#^.*Latest version: ([0-9\.]*).*$#\1#p')

	if [[ -z $actual_version || "$latest_version" != "$expected_version" ]]; then
		rm -f /opt/packer/*
		sudo rm -f /usr/local/bin/packer*

		sudo mkdir -p /opt/packer
		sudo chown -R vagrant:vagrant /opt/packer

		(cd /opt/packer && \
		curl -L https://dl.bintray.com/mitchellh/packer/packer_${latest_version}_linux_amd64.zip -o packer.zip && \
		unzip packer.zip && \
		rm packer.zip)

		sudo ln -s /opt/packer/packer* /usr/local/bin/

		bump packer $latest_version
	fi
fi