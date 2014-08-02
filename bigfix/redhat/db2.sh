#!/bin/bash -eux

curl -O http://platdev.sfolab.ibm.com/devtools/db2/v10.5fp2_linuxx64_server_r.tar.gz
curl -O http://platdev.sfolab.ibm.com/devtools/db2/db2-10.5.rsp

tar -xf v10.5fp2_linuxx64_server_r.tar.gz
rm -f v10.5fp2_linuxx64_server_r.tar.gz
./server_r/db2setup -r db2-10.5.rsp -l /var/log/db2setup.log
rm -rf ./server_r
rm -f db2-10.5.rsp
/opt/ibm/db2/V10.5/bin/db2iauto -on db2inst1
