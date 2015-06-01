#!/bin/bash -eux
# Usage: agent.sh VERSION ROOT

. <(curl -s https://raw.githubusercontent.com/bigfix/boxes/master/bigfix/common/util.source.sh)

function _get {
	local version="$1"

	local package=""

	if [[ -f /etc/redhat-release ]]; then
		package="BESAgent-$version-rhe5.x86_64.rpm"
	elif [[ -f /etc/lsb-release ]]; then
		if grep -q -i "Ubuntu" /etc/lsb-release; then
			package="BESAgent-$version-ubuntu10.amd64.deb"
		fi
	fi

	echo $package
}

function _install {
	local agent="$1"

	if [[ -f /etc/redhat-release ]]; then
		rpm -i $agent
	elif [[ -f /etc/lsb-release ]]; then
		if grep -q -i "Ubuntu" /etc/lsb-release; then
			dpkg -i $agent
		fi
	fi
}

version=${1:-$BIGFIX_VERSION}
agent=$(_get $version)
download $version $agent >/dev/null

root_server=${2:-$BIGFIX_ROOT}

mkdir /etc/opt/BESClient
curl -s "http://${root_server}/masthead" -o /etc/opt/BESClient/actionsite.afxm

_install $agent
service besclient start
