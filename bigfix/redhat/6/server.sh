#!/bin/bash -eux

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

function fix_wr {
	/opt/BESWebReportsServer/bin/WebReportsInitDB.sh "BESREPOR" "db2inst1" "bigfix" "localhost" "50000"
	/opt/BESServer/bin/BESAdmin.sh -initializewebreportsuser -dbname:"BESREPOR" -dbUsername:"db2inst1" -dbPassword:"bigfix" -dbPort:"50000" -username:"bigfix" -password:"bigfix" -roleID:1
	return 0
}

version=${1:-$BIGFIX_VERSION}
major_version=`echo "$version" | sed -r -n 's/([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)/\1\.\2/p'`

is_ok "http://builds.sfolab.ibm.com/$major_version/$version/" || exit 1

curl -O "http://builds.sfolab.ibm.com/$major_version/$version/Unix/ServerInstaller_$version-rhe6.x86_64.tgz"
tar -xzf ServerInstaller_$version-rhe6.x86_64.tgz
rm -f ServerInstaller_$version-rhe6.x86_64.tgz
yum install -y fontconfig.x86_64 libXext.x86_64 libXrender.x86_64 

curl http://platdev.sfolab.ibm.com/devtools/webui/license.pvk -o /home/vagrant/license.pvk
curl http://platdev.sfolab.ibm.com/devtools/webui/license.crt -o /home/vagrant/license.crt

echo "Creating response file for server installer"
cat > /home/vagrant/iem.rsp << OHANA_MEANS_FAMILY
BES_PREREQ_INSTALL="install"
LA_ACCEPT="true"
IS_EVALUATION="false"
COMPONENT_SRV="true"
COMPONENT_WR="true"
SINGLE_DATABASE="true"
LOCAL_DATABASE="true"
BES_WWW_FOLDER="/var/opt/BESServer"
WR_WWW_FOLDER="/var/opt/BESWebReportsServer"
WR_WWW_PORT="80"
DB2_ADMIN_USER="db2inst1"
DB2_ADMIN_PWD="{obf}YmlnZml4"
DB2INST_CONFIGURE="yes"
TEM_USER_NAME="bigfix"
TEM_USER_PWD="{obf}YmlnZml4"
CONF_FIREWALL="no"
BES_SETUP_TYPE="prodlic"
BES_CERT_FILE="/home/vagrant/license.crt"
BES_LICENSE_PVK="/home/vagrant/license.pvk"
BES_LICENSE_PVK_PWD="{obf}YmlnZml4"
ADV_MASTHEAD_DEFAULT="true"
BES_LIC_FOLDER="./license"
DB2_PORT="50000"
OHANA_MEANS_FAMILY

sh ServerInstaller_$version-rhe6.x86_64/install.sh -f /home/vagrant/iem.rsp || true

is_ok "https://localhost:52311/api/help" true || exit 1
is_ok "http://localhost/webreports" || fix_wr || exit 1

rm -rf ServerInstaller_$version-rhe6.x86_64
