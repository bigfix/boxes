#!/bin/bash -eux
# Usage: agent.sh VERSION ROOT

function is_ok {
	local url="$1"
	local auth=${2:-false}
	local auth_opt=""
	if $auth; then
		auth_opt="--user bigfix:bigfix"
	fi

	local status=`curl --insecure $auth_opt $url -s -o /dev/null -w "%{http_code}"`
	local retry=0
	while [[ "$status" -ne 200 && "$retry" -lt 3 ]]; do
		sleep 15
		((retry++))
		status=`curl --insecure $auth_opt $url -s -o /dev/null -w "%{http_code}"`
	done

	if [[ "$status" -ne 200 ]]; then
		return 1
	else
		return 0
	fi
}

version=${1:-$BIGFIX_VERSION}
major_version=`echo "$version" | sed -r -n 's/([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)/\1\.\2/p'`
[[ $major_version == "42.1" ]] && major_version="WebConsole"

is_ok "http://builds.sfolab.ibm.com/$major_version/$version/" || exit 1

curl -O "http://builds.sfolab.ibm.com/$major_version/$version/Unix/BESAgent-$version-ubuntu10.amd64.deb"

root_server=${2:-$BIGFIX_ROOT}

mkdir /etc/opt/BESClient
curl -s "http://${root_server}/masthead" -o /etc/opt/BESClient/actionsite.afxm

dpkg -i BESAgent-*-ubuntu10.amd64.deb
service besclient start
