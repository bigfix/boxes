#!/bin/bash -eux

default=""
case "`rpm -qf /etc/redhat-release --qf '%{VERSION}' 2>/dev/null`" in
	6*) default="10.5fp2";;
	7*) default="10.5fp3";;
esac

version=${DB2_VERSION:-$default}
install_dir=`echo "$version" | grep -Po '([0-9\.]+)' | head -1`

curl -O "http://builds.sfolab.ibm.com/devtools/db2/v${version}_linuxx64_server_r.tar.gz"

cat > /home/vagrant/db2.rsp << NO_ONE_GETS_LEFT_BEHIND
LIC_AGREEMENT=ACCEPT
PROD=DB2_SERVER_EDITION
FILE=/opt/ibm/db2/V$install_dir
INSTALL_TYPE=TYPICAL
DAS_CONTACT_LIST=LOCAL
DAS_USERNAME=dasusr1
DAS_GROUP_NAME=dasadm1
DAS_HOME_DIRECTORY=/home/dasusr1
DAS_PASSWORD=bigfix
INSTANCE=inst1
inst1.TYPE=ese
inst1.NAME=db2inst1
inst1.GROUP_NAME=db2iadm1
inst1.HOME_DIRECTORY=/home/db2inst1
inst1.PASSWORD=bigfix
inst1.AUTOSTART=YES
inst1.SVCENAME=db2c_db2inst1
inst1.PORT_NUMBER=50000
inst1.FCM_PORT_NUMBER=60000
inst1.MAX_LOGICAL_NODES=4
inst1.CONFIGURE_TEXT_SEARCH=NO
inst1.FENCED_USERNAME=db2fenc1
inst1.FENCED_GROUP_NAME=db2fadm1
inst1.FENCED_HOME_DIRECTORY=/home/db2fenc1
inst1.FENCED_PASSWORD=bigfix
LANG=EN
NO_ONE_GETS_LEFT_BEHIND

tar -xf "v${version}_linuxx64_server_r.tar.gz"
rm -f "v${version}_linuxx64_server_r.tar.gz"
./server_r/db2setup -r db2.rsp -l /var/log/db2setup.log
rm -rf ./server_r
rm -f db2.rsp
/opt/ibm/db2/V$install_dir/bin/db2iauto -on db2inst1

cat > /etc/rc.d/init.d/db2 << NO_ONE_GETS_FORGOTTEN
#!/bin/sh
# chkconfig: 2345 99 99

export SYSTEMCTL_SKIP_REDIRECT=1

PROG="DB2"
DBINST="db2inst1"

start() {
	/bin/echo -n $"Starting $PROG: "
	su - $DBINST -c "db2start"
	/bin/echo " done."
	exit 0
}

case "$1" in
	start) start ;;
	*)
		/bin/echo "Usage: service db2 {start}"
		exit 1
		;;
esac
NO_ONE_GETS_FORGOTTEN
chmod 755 /etc/rc.d/init.d/db2
chkconfig --add db2
