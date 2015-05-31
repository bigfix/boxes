#!/bin/bash -eux
# Usage: agent.sh VERSION ROOT

. <(curl -s https://raw.githubusercontent.com/bigfix/boxes/master/bigfix/common/util.source.sh)

version=${1:-$BIGFIX_VERSION}
download $version "BESAgent-$version-ubuntu10.amd64.deb" >/dev/null

root_server=${2:-$BIGFIX_ROOT}

mkdir /etc/opt/BESClient
curl -s "http://${root_server}/masthead" -o /etc/opt/BESClient/actionsite.afxm

dpkg -i BESAgent-*-ubuntu10.amd64.deb
service besclient start
