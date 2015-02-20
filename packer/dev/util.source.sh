#!/bin/bash

dir="$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"

function bump {
	local target=$1
	local version=$2

	if grep -q $target $dir/VERSIONS; then
		if [[ -n $version ]]; then
			sed -i -r 's/^('"$target"'\t).*$/\1'"$version"'/g' $dir/VERSIONS
		else
			sed -i -r 's/^('"$target"'\t)([0-9]*)\.([0-9]*)\.([0-9]*)$/echo "\1\2.\3.$((\4+1))"/eg' $dir/VERSIONS
		fi
	else
		if [[ -n $ATLAS_ACCESS_TOKEN ]]; then
			echo "'$ATLAS_ACCESS_TOKEN'"
			status=$(curl -s -o /dev/null -w "%{http_code}" https://atlas.hashicorp.com/api/v1/boxes \
				-X POST \
				-d box[name]="$target" \
				-d access_token="$ATLAS_ACCESS_TOKEN")
			if [[ $status -ne 200 ]]; then
				echo "Failed to create box: $target"
				return 1
			else
				echo -e "$target\t1.0.0" >> $dir/VERSIONS
			fi
		else
			echo 'ATLAS_ACCESS_TOKEN is not set'
			return 1
		fi
	fi
	return 0
}

function get {
	local target=$1

	echo $(awk -v t=$target -F '\t' '{ if ($1 == t) print $2 }' $dir/VERSIONS)
}