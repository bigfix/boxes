#!/bin/bash -eux

yum install -y avahi nss-mdns

service messagebus restart
service avahi-daemon restart
