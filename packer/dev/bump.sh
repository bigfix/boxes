#!/bin/bash

dir="$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )")"

target=$1
if grep -q '$target' $dir/VERSIONS; then
	sed -i -r 's/^('"$target"'\t)([0-9]*)[\.]([0-9]*)[\.]([0-9]*)$/echo "\1\2.\3.$((\4+1))"/eg' $dir/VERSIONS
else
	if [[ -n $ATLAS_ACCESS_TOKEN ]]; then
		echo "'$ATLAS_ACCESS_TOKEN'"
		status=$(curl -s -o /dev/null -w "%{http_code}" https://atlas.hashicorp.com/api/v1/boxes \
			-X POST \
			-d box[name]="$target" \
			-d access_token="$ATLAS_ACCESS_TOKEN")
		if [[ $status -ne 200 ]]; then
			echo "Failed to create box: $target"
			exit 1
		else
			echo -e "$target\t1.0.0" >> $dir/VERSIONS
		fi
	else
		echo 'ATLAS_ACCESS_TOKEN is not set'
		exit 1
	fi
fi

echo "$(grep '^packer' $dir/VERSIONS; \
	grep '^virtualbox' $dir/VERSIONS; \
	grep -v '^packer' $dir/VERSIONS | grep -v '^virtualbox' | sort)" > $dir/VERSIONS
awk -v t=$target -F '\t' '{ if ($1 == t) print $2 }' $dir/VERSIONS
