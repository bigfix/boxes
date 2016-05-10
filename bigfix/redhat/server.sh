#!/bin/bash -eux
# Usage: server.sh VERSION

. <(curl -s https://raw.githubusercontent.com/bigfix/boxes/master/bigfix/common/util.source.sh)

function fix_wr {
	/opt/BESWebReportsServer/bin/WebReportsInitDB.sh "BESREPOR" "db2inst1" "bigfix" "localhost" "50000"
	/opt/BESServer/bin/BESAdmin.sh -initializewebreportsuser -dbname:"BESREPOR" -dbUsername:"db2inst1" -dbPassword:"bigfix" -dbPort:"50000" -username:"bigfix" -password:"bigfix" -roleID:1
	return 0
}

rm -f ServerInstaller_*-rhe6.x86_64.tgz

custom=$(if [ -d /vagrant ]; then find /vagrant -maxdepth 1 -type f -name 'ServerInstaller_*-rhe6.x86_64.tgz' -print -quit; fi)
wr_port="80"
if [[ -n $custom ]]; then
	cp $custom .
	[[ $custom =~ ServerInstaller_42\.1\.*-rhe6\.x86_64\.tgz ]] && wr_port="8080"
else
	version=${1:-$BIGFIX_VERSION}
	major_version=$(download $version "ServerInstaller_$version-rhe6.x86_64.tgz")
	[[ $major_version == "WebConsole" ]] && wr_port="8080"
fi

tar -xzf ServerInstaller_*-rhe6.x86_64.tgz
rm -f ServerInstaller_*-rhe6.x86_64.tgz

rpm -qa | grep -q fontconfig || yum install -y fontconfig.x86_64
rpm -qa | grep -q libXext || yum install -y libXext.x86_64
rpm -qa | grep -q libXrender || yum install -y libXrender.x86_64

curl -s http://builds.sfolab.ibm.com/devtools/webui/license.pvk -o /home/vagrant/license.pvk
curl -s http://builds.sfolab.ibm.com/devtools/webui/license.crt -o /home/vagrant/license.crt

cat > /home/vagrant/iem.rsp << OHANA_MEANS_FAMILY
BES_PREREQ_INSTALL="install"
LA_ACCEPT="true"
IS_EVALUATION="false"
USE_PROXY="false"
COMPONENT_SRV="true"
COMPONENT_WR="true"
SINGLE_DATABASE="true"
LOCAL_DATABASE="true"
BES_WWW_FOLDER="/var/opt/BESServer"
WR_WWW_FOLDER="/var/opt/BESWebReportsServer"
WR_WWW_PORT="80"
DB2_ADMIN_USER="db2inst1"
DB2_ADMIN_PWD="bigfix"
DB2_INSTANCE_NAME="db2inst1"
DB2INST_CONFIGURE="yes"
TEM_USER_NAME="bigfix"
TEM_USER_PWD="bigfix"
CONF_FIREWALL="no"
BES_SETUP_TYPE="prodlic"
BES_CERT_FILE="/home/vagrant/license.crt"
BES_LICENSE_PVK="/home/vagrant/license.pvk"
BES_LICENSE_PVK_PWD="bigfix"
ADV_MASTHEAD_DEFAULT="true"
BES_LIC_FOLDER="./license"
DB2_PORT="50000"
WEBUI_PORT="443"
WEBUI_REDIRECT="true"
WEBUI_REDIRECT_PORT="80"
OHANA_MEANS_FAMILY

sh ServerInstaller_*-rhe6.x86_64/install.sh -f /home/vagrant/iem.rsp || true

is_ok "https://localhost:52311/api/help" true || exit 1
is_ok "http://localhost:${wr_port}/webreports" || fix_wr || exit 1

rm -rf ServerInstaller_*-rhe6.x86_64
