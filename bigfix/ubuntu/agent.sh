#!/bin/bash -eux
# Usage: agent.sh VERSION ROOT

. <(curl -s https://raw.githubusercontent.com/bigfix/boxes/master/bigfix/common/util.source.sh)

version=${1:-$BIGFIX_VERSION}
major_version=`echo "$version" | sed -r -n 's/([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)/\1\.\2/p'`
[[ $major_version == "42.1" ]] && major_version="WebConsole"

is_ok "http://builds.sfolab.ibm.com/$major_version/$version/" || exit 1

curl -sO "http://builds.sfolab.ibm.com/$major_version/$version/Unix/BESAgent-$version-ubuntu10.amd64.deb"

root_server=${2:-$BIGFIX_ROOT}

mkdir /etc/opt/BESClient
curl -s "http://${root_server}/masthead" -o /etc/opt/BESClient/actionsite.afxm

dpkg -i BESAgent-*-ubuntu10.amd64.deb
service besclient start
