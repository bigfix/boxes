#!/bin/bash -eux
# Usage: relay.sh VERSION

. <(curl -s https://raw.githubusercontent.com/bigfix/boxes/master/bigfix/common/util.source.sh)

function _get {
	local version="$1"

	local package=""

	if [[ -f /etc/redhat-release ]]; then
		package="BESRelay-$version-rhe5.x86_64.rpm"
	fi

	echo $package
}

function _install {
	local relay="$1"

	if [[ -f /etc/redhat-release ]]; then
		if ! command -v perl 2>&1 >/dev/null; then
			yum install -y perl
		fi

		rpm -i $relay
	fi
}

version=${1:-$BIGFIX_VERSION}
relay=$(_get $version)
download $version $relay >/dev/null

_install $relay
service besrelay start
