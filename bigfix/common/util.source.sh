#!/bin/bash

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
