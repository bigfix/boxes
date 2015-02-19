#!/bin/bash

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $dir/bump.sh

major_version=$(sed -rn 's/^virtualbox\t([0-9]*\.[0-9]*)\..*$/\1/p' $dir/VERSIONS)

sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/virtualbox.sources.list" \
	-o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
sudo apt-get install --only-upgrade virtualbox-$(version)

actual_version=$(vboxmanage --version)
expected_version=$(get virtualbox)

if [[ "$actual_version" -ne "$expected_version" ]]; then
	bump virtualbox $actual_version
fi