#!/bin/bash -eux
# Usage: agent.sh VERSION ROOT

. <(curl -s https://raw.githubusercontent.com/bigfix/boxes/master/bigfix/common/util.source.sh)

version=${1:-$BIGFIX_VERSION}
agent=$(get_agent $version)
download $version $agent >/dev/null

root_server=${2:-$BIGFIX_ROOT}

mkdir /etc/opt/BESClient
curl -s "http://${root_server}/masthead" -o /etc/opt/BESClient/actionsite.afxm

dpkg -i $agent
service besclient start
