#!/bin/bash -eux

rpm -qa | grep -q java-1.8.0-openjdk || yum install -y java-1.8.0-openjdk