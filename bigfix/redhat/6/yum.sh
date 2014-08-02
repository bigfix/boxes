#!/bin/bash -eux

function is_ok {
	local url="$1"
	local status=`curl $url -L -s -o /dev/null -w "%{http_code}"`
	local retry=0
	while [[ "$status" -ne 200 && "$retry" -lt 3 ]]; do
		sleep 15
		((retry++))
		status=`curl $url -L -s -o /dev/null -w "%{http_code}"`
	done

	if [[ "$status" -ne 200 ]]; then
		return 1
	else
		return 0
	fi
}

repo="http://oxygen.sfolab.ibm.com/rpms/RHEL60_X86_64_SERVER"
is_ok "$repo" || exit

echo -e "
[oxygen]
name=oxygen
baseurl=$repo
enabled=1
gpgcheck=0
" > /etc/yum.repos.d/oxygen.repo
