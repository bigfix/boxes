#!/bin/bash

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $dir/util.source.sh

if [[ -n $1 ]]; then
	target=$1
	version=$2
	bump $target $version || exit 1

	echo "$(grep '^packer' $dir/VERSIONS; \
		grep '^virtualbox' $dir/VERSIONS; \
		grep -v '^packer' $dir/VERSIONS | grep -v '^virtualbox' | sort)" > $dir/VERSIONS
	get $target
fi