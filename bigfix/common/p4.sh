#!/bin/bash -eux

curl -O "http://builds.sfolab.ibm.com/devtools/perforce/Linux-2.6-x64/p4"
mv p4 /usr/bin/p4
chmod 755 /usr/bin/p4